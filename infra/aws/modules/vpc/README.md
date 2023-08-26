<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                   | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                              | resource |
| [aws_route_table.pub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                         | resource |
| [aws_route_table_association.pub_rt_associate_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.pub_rt_associate_1c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.pri1_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                               | resource |
| [aws_subnet.pri1_1c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                               | resource |
| [aws_subnet.pri2_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                               | resource |
| [aws_subnet.pri2_1c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                               | resource |
| [aws_subnet.pub_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                | resource |
| [aws_subnet.pub_1c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                        | resource |

## Inputs

| Name                                                                                       | Description                                       | Type           | Default | Required |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_allow_ip_list"></a> [allow_ip_list](#input_allow_ip_list)                   | List of allowed IPs for security group ingress    | `list(string)` | n/a     |   yes    |
| <a name="input_app_name"></a> [app_name](#input_app_name)                                  | Application name                                  | `string`       | n/a     |   yes    |
| <a name="input_availability_zone_a"></a> [availability_zone_a](#input_availability_zone_a) | Availability Zone for the 1a subnet               | `string`       | n/a     |   yes    |
| <a name="input_availability_zone_c"></a> [availability_zone_c](#input_availability_zone_c) | Availability Zone for the 1c subnet               | `string`       | n/a     |   yes    |
| <a name="input_environment"></a> [environment](#input_environment)                         | Environment name (e.g., 'stg', 'prod')            | `string`       | n/a     |   yes    |
| <a name="input_pri1_sub_1a_cidr"></a> [pri1_sub_1a_cidr](#input_pri1_sub_1a_cidr)          | CIDR block for the first private subnet in AZ 1a  | `string`       | n/a     |   yes    |
| <a name="input_pri1_sub_1c_cidr"></a> [pri1_sub_1c_cidr](#input_pri1_sub_1c_cidr)          | CIDR block for the first private subnet in AZ 1c  | `string`       | n/a     |   yes    |
| <a name="input_pri2_sub_1a_cidr"></a> [pri2_sub_1a_cidr](#input_pri2_sub_1a_cidr)          | CIDR block for the second private subnet in AZ 1a | `string`       | n/a     |   yes    |
| <a name="input_pri2_sub_1c_cidr"></a> [pri2_sub_1c_cidr](#input_pri2_sub_1c_cidr)          | CIDR block for the second private subnet in AZ 1c | `string`       | n/a     |   yes    |
| <a name="input_pub_sub_1a_cidr"></a> [pub_sub_1a_cidr](#input_pub_sub_1a_cidr)             | CIDR block for the public subnet in AZ 1a         | `string`       | n/a     |   yes    |
| <a name="input_pub_sub_1c_cidr"></a> [pub_sub_1c_cidr](#input_pub_sub_1c_cidr)             | CIDR block for the public subnet in AZ 1c         | `string`       | n/a     |   yes    |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr)                                  | CIDR block for the VPC                            | `string`       | n/a     |   yes    |

## Outputs

| Name                                                                                   | Description                                      |
| -------------------------------------------------------------------------------------- | ------------------------------------------------ |
| <a name="output_subnet_pri1_1a_id"></a> [subnet_pri1_1a_id](#output_subnet_pri1_1a_id) | ID of the first created private subnet in AZ 1a  |
| <a name="output_subnet_pri1_1c_id"></a> [subnet_pri1_1c_id](#output_subnet_pri1_1c_id) | ID of the first created private subnet in AZ 1c  |
| <a name="output_subnet_pri2_1a_id"></a> [subnet_pri2_1a_id](#output_subnet_pri2_1a_id) | ID of the second created private subnet in AZ 1a |
| <a name="output_subnet_pri2_1c_id"></a> [subnet_pri2_1c_id](#output_subnet_pri2_1c_id) | ID of the second created private subnet in AZ 1c |
| <a name="output_subnet_pub_1a_id"></a> [subnet_pub_1a_id](#output_subnet_pub_1a_id)    | ID of the first created public subnet in AZ 1a   |
| <a name="output_subnet_pub_1c_id"></a> [subnet_pub_1c_id](#output_subnet_pub_1c_id)    | ID of the first created public subnet in AZ 1c   |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)                                  | ID of the created VPC                            |

<!-- END_TF_DOCS -->
