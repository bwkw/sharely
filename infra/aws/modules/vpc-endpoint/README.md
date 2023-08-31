<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., 'stg', 'prod') | `string` | `"stg"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to be associated with the VPC endpoint | `list(string)` | n/a | yes |
| <a name="input_subnet_pri2_1a_id"></a> [subnet\_pri2\_1a\_id](#input\_subnet\_pri2\_1a\_id) | ID of the second created private subnet in AZ 1a | `string` | n/a | yes |
| <a name="input_subnet_pri2_1c_id"></a> [subnet\_pri2\_1c\_id](#input\_subnet\_pri2\_1c\_id) | ID of the second created private subnet in AZ 1c | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_vpc_endpoint_id"></a> [aurora\_vpc\_endpoint\_id](#output\_aurora\_vpc\_endpoint\_id) | The ID of the VPC Endpoint for Aurora |
<!-- END_TF_DOCS -->
