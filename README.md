# tf template
A terraform template for Elastx OpenStack to modify after your needs.

_Note: This terraform demo currently uses a local terraform state_

## Usage
1. Clone the repo
2. Download and soure your RC file from OpenStack. If you're not using an RC file, you'll have to manually set the ENV variables listed in `main.tf` or edit the file and set the credential variables yourself (row 5-10)
3. Edit the `variables.tf` file after your needs
4. Run `terraform init`
5. Run `terraform apply`
