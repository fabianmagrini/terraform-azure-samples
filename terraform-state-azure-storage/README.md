# Store Terraform state in Azure Storage

Store Terraform state in Azure Storage

References:

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

## Cleanup the storage account
