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

/* how to make terraform code dry using terragrunt

  steps: you need to follow module structure, first you need to create terraform files push it to github and publish it in terraform registry as a modules.
         now you can use the same terraform code again & again.
   
  step1: now use that module in the source parameter in the terraform block.

  step2: now write the generate block to create provider.tf file.
 
  step3: here comes the interesting part of how to make terraform code dry using terragrunt, if you want to use the same terraform block & generate block in child directory
         terragrunt.hcl file you can use it with below commands.
   
         child directory terragrunt.hcl file
    
         include "root" {
            path = find_in_parent_folders()
         }
         inputs = {
            cidr = "10.10.0.0/16"
         }
         
         in the child directory terragrunt.hcl file we can specify module specific input variables.
  Note:  by using the above concept we can reduce the complexity of terragrunt.hcl file in child directory.

  Note:  the above terraform block and generate block terragrunt.hcl file must be in root directory.

  Note:  |
         |------prod
         |       |
         |       |----- terragrunt.hcl file
         |       |
         |       |----- app
         |       |       |
         |       |       |
         |       |       |---- terragrunt.hcl file
         |       |       |
         |       |       |
         |       |       |
         |       |
         |       |
         |       |

   NOte:  in the root directory we need to write terragrunt.hcl file, to include that in app/terragrunt.hcl file.

   Note: instead of copying everything from root terragrunt.hcl file into app/terragrunt.hcl file, we can write specific block in root terragrunt.hcl file and copy that 
         into app/terragrunt.hcl file and you can write your rest of the code ie terraform block, input block etc...

   reference link: https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/


