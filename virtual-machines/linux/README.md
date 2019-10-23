# Create Linux VM using Terraform

References:

* <https://docs.microsoft.com/en-gb/azure/virtual-machines/linux/terraform-create-complete-vm>
* <https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html>
* <https://pleasereleaseme.net/create-an-azure-devops-services-self-hosted-agent-in-azure-using-terraform-cloud-init-and-azure-devops-pipelines/>

## Configuration

Get account details

```sh
az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
export TF_VAR_subscription_id=azure_subscription_id
export TF_VAR_tenant_id=azure_tenant_id
```

Set which subscription to use if multiple

```sh
az account set --subscription="${TF_VAR_subscription_id}"
```

Create service principle for use by Terraform

```sh
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${TF_VAR_subscription_id}"
```

Setting environment variables for Terraform

```sh
#!/bin/sh
echo "Setting environment variables for Terraform"
export TF_VAR_subscription_id=azure_subscription_id
export TF_VAR_client_id=azure_client_id
export TF_VAR_client_secret=azure_client_secret
export TF_VAR_tenant_id=azure_tenant_id
```

## Initialse the working directory

```sh
cd <working-directory>
terraform init
```

## Deploy the configuration

Run terraform plan to test the new Terraform configuration

```sh
terraform plan
```

Apply the configuration

```sh
terraform apply
```

## Clean up resources

```sh
terraform destroy -auto-approve
```
