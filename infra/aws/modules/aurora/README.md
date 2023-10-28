<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | n/a | yes |
| <a name="input_az"></a> [az](#input\_az) | The availability zones for the subnets. | <pre>object({<br>    a = string<br>    c = string<br>  })</pre> | n/a | yes |
| <a name="input_database"></a> [database](#input\_database) | Database configuration | <pre>object({<br>    instance_class = string<br>    db_username    = string<br>    db_password    = string<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., 'stg', 'prod') | `string` | n/a | yes |
| <a name="input_pri2_sub_ids"></a> [pri2\_sub\_ids](#input\_pri2\_sub\_ids) | List of primary subnet IDs | `list(string)` | n/a | yes |
| <a name="input_sg_ids"></a> [sg\_ids](#input\_sg\_ids) | List of security group IDs to associate with Aurora | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_cluster_arn"></a> [aurora\_cluster\_arn](#output\_aurora\_cluster\_arn) | ARN of the Aurora Cluster |
| <a name="output_aurora_cluster_endpoint"></a> [aurora\_cluster\_endpoint](#output\_aurora\_cluster\_endpoint) | Writer endpoint for the Aurora Cluster |
| <a name="output_aurora_cluster_reader_endpoint"></a> [aurora\_cluster\_reader\_endpoint](#output\_aurora\_cluster\_reader\_endpoint) | Reader endpoint for the Aurora Cluster |
<!-- END_TF_DOCS -->