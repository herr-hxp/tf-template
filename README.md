# tf template
A terraform template for Elastx OpenStack to modify after your needs.

_Note: This terraform demo currently uses a local terraform state_

## Usage
1. Clone the repo
2. Download and soure your RC file from OpenStack. If you're not using an RC file, you'll have to manually set the ENV variables listed in `main.tf` or edit the file and set the credential variables yourself (row 5-10)
3. Make sure you have your public SSH key uploaded to OpenStack or generate a new one using either Horizon or the OpenStack cli
4. Edit the `variables.tf` file after your needs
5. Run `terraform init`
6. Run `terraform apply`
