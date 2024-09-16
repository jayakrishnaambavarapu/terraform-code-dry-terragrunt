terraform {
  source = "tfr://registry.terraform.io/jayakrishnaambavarapu/ambavarapu-vpcmodule/aws?version=4.0.0"

}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  profile = "jayakrishna-trusted-user"
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::976806633434:role/terragrunt-role" 

  }

}
EOF
}

#iam_role = "arn:aws:iam::976806633434:role/terragrunt-role"

inputs = {
  cidr = "10.50.0.0/16"
  
}

#note: in the provider block we have mentioned jayakrishna-trusted-user ( this is user is created in source account and have access to sts:assume role policy )
#note: assume_role ==> in assume role we have mentioned role that is created on destination account, in this role trust-relationship we haved added the above user to assume it. 

