# projext-x
    # 🚀 Azure VM Platform (Project X)

    [![Status: In Development](https://img.shields.io/badge/Status-In%20Development-orange?style=for-the-badge&logo=git)](https://github.com/harshspy14-
  su57/projext-x)
    [![Terraform](https://img.shields.io/badge/Terraform-1.0+-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
    [![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.
  com/)
    [![Ansible](https://img.shields.io/badge/Ansible-Ready-EE0000?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
    [![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

    An enterprise-ready Infrastructure as Code (IaC) repository for provisioning, configuring, and securing **Linux Virtual Machines on Microsoft Azure**
  using **Terraform** and **Ansible**.

    > ⚠️ **Project Status**: **Active Development / Prototype Stage**
    > The core Terraform modules and test environment integration have been developed and validated. Remote backend integration, environment promotion
  (Dev/Prod), CI/CD pipelines, and Ansible playbooks are actively being implemented.

    ---

    ## 📌 Project Overview

    This platform establishes a standardized, reusable, and modular approach to deploying Linux virtual machines in Azure:
    - **Modular Terraform Architecture**: Loosely coupled child modules for Resource Groups, Networking, Compute (Linux VMs), and Managed Disks.
    - **Enterprise Shared Networking**: Employs Terraform `data` sources to reference existing enterprise Hub-and-Spoke Virtual Networks and Subnets
  provisioned by network administrators, rather than recreating network boundaries.
    - **Multi-Disk Scaling**: Utilizes Terraform `for_each` mapping to dynamically attach 0 to *N* managed data disks with configurable LUNs, caching,
  and SKUs.
    - **Multi-Environment Promotion**: Structured environment layers (`test`, `dev`, `prod`) to ensure safe testing and release cycles.

    ---

    ## 📊 Current Development Status & Roadmap

    | Component | Status | Description |
    | :--- | :---: | :--- |
    | **Resource Group Module** | ✅ Completed | Automated creation with standard naming and tagging |
    | **Networking Module** | ✅ Completed | References shared VNets/Subnets via data sources + NSG binding |
    | **Linux VM Module** | ✅ Completed | Standardized VM deployment with SSH key authentication |
    | **Managed Disks Module** | ✅ Completed | Dynamic disk attachment using `for_each` loops |
    | **Test Environment** | ✅ Working | End-to-end integration verified in `Central India` region |
    | **Dev / Prod Environments** | 🚧 In Progress | Variable definitions & environment-specific values |
    | **Remote State Backend** | 🚧 In Progress | Migration from local state to Azure Blob Storage (`azurerm`) |
    | **Ansible OS Hardening & Config** | ⏳ Planned | Base OS setup, CIS benchmark hardening, and app deployments |
    | **Azure DevOps / GitHub CI/CD** | ⏳ Planned | Automated linting (`fmt`), validation, plan, and apply pipelines |

    ---

    ## 📂 Repository Directory Structure

    ```text
    terraform-vm-platform/
    ├── ansible/                           # Ansible configuration management
    │   └── playbooks/
    │       ├── base_os.yml                # Base operating system packages & users
    │       ├── hardening.yml              # Security baseline & OS hardening
    │       └── app_install.yml            # Application runtime installation
    ├── docs/                              # Project architecture & documentation
    │   └── architecture.md
    ├── environments/                      # Environment-specific root compositions
    │   ├── dev/                           # Development environment (WIP)
    │   ├── prod/                          # Production environment (WIP)
    │   └── test/                          # Active test & integration environment
    │       ├── main.tf                    # Module composition & resource wiring
    │       ├── variables.tf
    │       ├── outputs.tf
    │       └── terraform.tfvars
    ├── modules/                           # Reusable child modules
    │   ├── linux_vm/                      # Azure Linux Virtual Machine & NIC
    │   ├── managed-disks/                 # Dynamic managed disk provisioning & attachment
    │   ├── networking/                    # Shared VNet/Subnet data sources & NSG
    │   └── resource_group/                # Dedicated resource groups
    ├── pipelines/                         # CI/CD pipeline definitions
    │   ├── terraform-plan.yml             # Terraform plan & static analysis
    │   ├── terraform-apply.yml            # Automated/approved infrastructure deployment
    │   └── ansible-deploy.yml             # Post-provisioning configuration deployment
    ├── ssh-keys/                          # Deployment SSH keys (.gitignore protected)
    │   └── terraform-vm-platforssh-keys.pub
    ├── tests/                             # Validation scripts
    │   ├── terraform_fmt.sh
    │   └── terraform_validate.sh
    ├── backend.tf                         # Remote state backend configuration
    ├── providers.tf                       # Provider configurations (hashicorp/azurerm)
    ├── versions.tf                        # Required Terraform & provider versions
    └── README.md                          # Project documentation
  ──────
  ## 🏗️ Architectural Highlights & Design Patterns

  ### 1. Enterprise Shared Networking Pattern

  In enterprise Azure environments, virtual networks are managed centrally by the core networking team. The networking module uses data blocks to
  discover existing subnets:

    data "azurerm_virtual_network" "vnet" {
      name                = var.vnet_name
      resource_group_name = var.vnet_rg_name
    }

    data "azurerm_subnet" "subnet" {
      name                 = var.subnet_name
      virtual_network_name = data.azurerm_virtual_network.vnet.name
      resource_group_name  = var.vnet_rg_name
    }

  ### 2. Loose Coupling via Explicit Inputs & Outputs

  Modules never cross-reference each other directly. Instead:

    [Resource Group Module] ──(output: rg_name, location)──> [Root Environment] ──(input)──> [Networking & VM Modules]

  ### 3. Dynamic Managed Disks (for_each)

  Storage disks are provisioned dynamically without changing module code by passing an array of disk configurations:

    data_disks = [
      { size_gb = 50,  storage_account_type = "Standard_LRS", lun = 0 },
      { size_gb = 100, storage_account_type = "Premium_LRS",  lun = 1 }
    ]
  ──────
  ## 🛠️ Getting Started (Local Development)

  ### Prerequisites

  • Terraform https://developer.hashicorp.com/terraform/downloads >= 1.0
  • Azure CLI https://learn.microsoft.com/en-us/cli/azure/install-azure-cli (az login)
  • Active Azure Subscription with Contributor access
  • Generated SSH Key Pair for VM access

  ### Quick Test Deployment

  1. Clone the repository:
    git clone https://github.com/harshspy14-su57/projext-x.git
    cd projext-x/terraform-vm-platform/environments/test

  2. Authenticate with Azure:
    az login
    az account set --subscription "<YOUR_SUBSCRIPTION_ID>"

  3. Initialize Terraform:
    terraform init

  4. Review execution plan:
    terraform plan

  5. Deploy test infrastructure:
    terraform apply

  6. Teardown (when finished testing):
    terraform destroy

  ──────
  ## 🔒 Security Best Practices

  • No Passwords: Password authentication is disabled on VMs; authentication is strictly enforced via SSH key pairs.
  • Secrets Management: Private keys and sensitive files are excluded via .gitignore to prevent credential exposure in public repositories.
  • Isolated State: Production state files will be isolated in encrypted Azure Storage containers with state locking.
  ──────
  ## 🤝 Contributing & Feedback

  This project is actively maintained by @harshspy14-su57 https://github.com/harshspy14-su57.
  For suggestions, bug reports, or feature requests, feel free to open an Issue https://github.com/harshspy14-su57/projext-x/issues or submit a Pull
  Request.


    ---

    ### 💡 Key Details Reflected in This README:
    1. **Accurate Architecture**: Captures your exact modules (`linux_vm`, `managed-disks`, `networking`, `resource_group`) and your usage of `data
  "azurerm_virtual_network"` for shared enterprise networking.
    2. **Current Status Banner**: Highlights to visitors that the repository is in **active development/WIP**.
    3. **Status Matrix**: Clear visual table highlighting what is built (`test` environment, modules) vs what is upcoming (`dev`/`prod`, remote backend,
  Ansible, CI/CD).
    4. **Links**: Points to your GitHub repository `https://github.com/harshspy14-su57/projext-x`.
