// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package testimpl

import (
	"context"
	"net/http"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/dashboard/armdashboard"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestGrafanaWorkspace is the full functional post-deploy test. It verifies
// Terraform outputs, asserts both the Grafana and Azure Monitor Workspace
// resources via the Azure SDK, and exercises the Grafana data plane endpoint.
func TestGrafanaWorkspace(t *testing.T, ctx types.TestContext) {
	assertDeployment(t, ctx)
	exerciseGrafanaEndpoint(t, ctx)
}

// TestGrafanaWorkspaceReadonly is the read-only post-deploy test. It verifies
// Terraform outputs and asserts both resources via the Azure SDK without
// exercising the data plane or performing any write operations.
func TestGrafanaWorkspaceReadonly(t *testing.T, ctx types.TestContext) {
	assertDeployment(t, ctx)
}

func assertDeployment(t *testing.T, ctx types.TestContext) {
	t.Helper()

	opts := ctx.TerratestTerraformOptions()

	grafanaId := terraform.Output(t, opts, "grafana_id")
	grafanaName := terraform.Output(t, opts, "grafana_name")
	grafanaEndpoint := terraform.Output(t, opts, "grafana_endpoint")
	grafanaPrincipalId := terraform.Output(t, opts, "grafana_principal_id")
	monitorWorkspaceId := terraform.Output(t, opts, "monitor_workspace_id")
	monitorWorkspaceName := terraform.Output(t, opts, "monitor_workspace_name")
	resourceGroupName := terraform.Output(t, opts, "resource_group_name")

	require.NotEmpty(t, grafanaId, "grafana_id output must be non-empty")
	require.NotEmpty(t, grafanaName, "grafana_name output must be non-empty")
	require.NotEmpty(t, grafanaEndpoint, "grafana_endpoint output must be non-empty")
	require.NotEmpty(t, grafanaPrincipalId, "grafana_principal_id output must be non-empty")
	require.NotEmpty(t, monitorWorkspaceId, "monitor_workspace_id output must be non-empty")
	require.NotEmpty(t, monitorWorkspaceName, "monitor_workspace_name output must be non-empty")
	require.NotEmpty(t, resourceGroupName, "resource_group_name output must be non-empty")

	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	require.NotEmpty(t, subscriptionId, "ARM_SUBSCRIPTION_ID must be set")

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err, "failed to load Azure default credentials")

	assertGrafana(t, subscriptionId, cred, resourceGroupName, grafanaName, grafanaId, grafanaEndpoint, monitorWorkspaceId)
	assertMonitorWorkspace(t, subscriptionId, cred, resourceGroupName, monitorWorkspaceName, monitorWorkspaceId)
}

func assertGrafana(
	t *testing.T,
	subscriptionId string,
	cred *azidentity.DefaultAzureCredential,
	resourceGroupName, grafanaName, expectedId, expectedEndpoint, expectedMonitorWorkspaceId string,
) {
	t.Helper()

	client, err := armdashboard.NewGrafanaClient(subscriptionId, cred, nil)
	require.NoError(t, err, "failed to construct Grafana SDK client")

	sdkCtx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
	defer cancel()

	resp, err := client.Get(sdkCtx, resourceGroupName, grafanaName, nil)
	require.NoError(t, err, "Grafana Get call must succeed")

	require.NotNil(t, resp.ID, "API response must include resource ID")
	assert.Equal(t, expectedId, *resp.ID, "API resource ID should match grafana_id output")

	require.NotNil(t, resp.SKU, "SKU must be present on Grafana resource")
	require.NotNil(t, resp.SKU.Name, "SKU.Name must be present")
	assert.Equal(t, "Standard", *resp.SKU.Name, "default SKU should be Standard")

	require.NotNil(t, resp.Properties, "Properties must be present on Grafana resource")
	p := resp.Properties

	require.NotNil(t, p.GrafanaMajorVersion, "grafana_major_version must be set on the resource")
	assert.Equal(t, "12", *p.GrafanaMajorVersion, "default grafana_major_version should be 12")

	require.NotNil(t, p.PublicNetworkAccess, "public_network_access must be present")
	assert.Equal(t, "Enabled", string(*p.PublicNetworkAccess), "public_network_access should be Enabled by default")

	require.NotNil(t, p.ZoneRedundancy, "zone_redundancy must be present")
	assert.Equal(t, "Disabled", string(*p.ZoneRedundancy), "zone_redundancy should be Disabled by default")

	require.NotNil(t, p.DeterministicOutboundIP, "deterministic_outbound_ip must be present")
	assert.Equal(t, "Disabled", string(*p.DeterministicOutboundIP), "deterministic_outbound_ip should be Disabled by default")

	require.NotNil(t, p.Endpoint, "Properties.Endpoint must be present")
	assert.Equal(t, expectedEndpoint, *p.Endpoint, "endpoint from API should match grafana_endpoint output")

	require.NotNil(t, p.GrafanaIntegrations, "GrafanaIntegrations must be present")
	integrations := p.GrafanaIntegrations.AzureMonitorWorkspaceIntegrations
	require.Len(t, integrations, 1, "example wires exactly one Azure Monitor workspace integration")
	require.NotNil(t, integrations[0].AzureMonitorWorkspaceResourceID, "integration resource_id must be present")
	assert.Equal(t,
		strings.ToLower(expectedMonitorWorkspaceId),
		strings.ToLower(*integrations[0].AzureMonitorWorkspaceResourceID),
		"AMW integration resource_id should match monitor_workspace_id output",
	)
}

func assertMonitorWorkspace(
	t *testing.T,
	subscriptionId string,
	cred *azidentity.DefaultAzureCredential,
	resourceGroupName, workspaceName, expectedId string,
) {
	t.Helper()

	opts := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	factory, err := armmonitor.NewClientFactory(subscriptionId, cred, &opts)
	require.NoError(t, err, "failed to construct monitor client factory")

	mCtx, mCancel := context.WithTimeout(context.Background(), 2*time.Minute)
	defer mCancel()

	resp, err := factory.NewAzureMonitorWorkspacesClient().Get(mCtx, resourceGroupName, workspaceName, nil)
	require.NoError(t, err, "AzureMonitorWorkspaces Get call must succeed")

	require.NotNil(t, resp.ID, "monitor workspace ID must be present in API response")
	assert.Equal(t,
		strings.ToLower(expectedId),
		strings.ToLower(*resp.ID),
		"API resource ID should match monitor_workspace_id output",
	)
}

func exerciseGrafanaEndpoint(t *testing.T, ctx types.TestContext) {
	t.Helper()

	endpoint := terraform.Output(t, ctx.TerratestTerraformOptions(), "grafana_endpoint")
	require.NotEmpty(t, endpoint, "grafana_endpoint output must be present")

	// Do not follow redirects — Azure Managed Grafana redirects unauthenticated
	// requests to Azure AD. A redirect response is proof the endpoint is live.
	client := &http.Client{
		Timeout: 30 * time.Second,
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			return http.ErrUseLastResponse
		},
	}
	resp, err := client.Get(endpoint)
	require.NoError(t, err, "HTTP GET against Grafana endpoint must succeed")
	defer func() { _ = resp.Body.Close() }()

	assert.Truef(t,
		resp.StatusCode >= 200 && resp.StatusCode < 400,
		"Grafana endpoint should return non-error status, got %d", resp.StatusCode,
	)
}
