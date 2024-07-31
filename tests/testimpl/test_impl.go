package testimpl

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestGrafanaWorkspace(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	grafanaId := terraform.Output(t, ctx.TerratestTerraformOptions(), "grafana_id")
	workspaceId := terraform.Output(t, ctx.TerratestTerraformOptions(), "monitor_workspace_id")

	t.Run("TfOutputsNotEmpty", func(t *testing.T) {
		assert.NotEmpty(t, grafanaId, "Grafana resource ID must not be empty")
		assert.NotEmpty(t, workspaceId, "Workspace ID must not be empty")
	})
}
