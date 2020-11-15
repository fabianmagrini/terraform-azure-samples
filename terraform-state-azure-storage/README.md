# Store Terraform state in Azure Storage

Store Terraform state in Azure Storage

References:

* <https://www.terraform.io/docs/backends/types/azurerm.html>
* <https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage>
  
## Prerequisites

* Azure CLI
* az login

### Logging into the Azure CLI

If you have multiple subscriptions then set subscription after completing the login.

```sh
az login
az account list
az account set --subscription="SUBSCRIPTION_ID"
```

## Configure storage account

Run the setup script to configure storage account

```sh
chmod 775 *.sh
./setup.sh
```

Take note of the storage account name, container name, and storage access key. These values are needed when you configure the remote state.

## Configure state back end

```sh
export ARM_ACCESS_KEY=<storage access key>
```

Initialize the configuration by doing the following steps:

Run the terraform init command.

```sh
terraform init \
    -backend-config="storage_account_name=<storage account name>"
```

Run the terraform apply command.
You can now find the state file in the Azure Storage blob.

## Cleanup the storage account
