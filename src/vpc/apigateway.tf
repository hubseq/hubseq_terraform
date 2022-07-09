
/*
resource "aws_api_gateway_rest_api" "apigw_rest_api_data" {
 name = "api-gateway-rest-api-data"
 description = "Proxy to handle requests to data.ngspipelines.com"
 endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "apigw_resource_data" {
  rest_api_id = aws_api_gateway_rest_api.apigw_rest_api_data.id
  parent_id   = aws_api_gateway_rest_api.apigw_rest_api_data.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "apigw_method_data" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw_rest_api_data.id}"
  resource_id   = "${aws_api_gateway_resource.apigw_resource_data.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "apigw_integration_data" {
  rest_api_id = aws_api_gateway_rest_api.apigw_rest_api_data.id
  resource_id = aws_api_gateway_resource.apigw_resource_data.id
  http_method = aws_api_gateway_method.apigw_method_data.http_method
  integration_http_method = "ANY"
  type = "HTTP_PROXY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_api_gateway_vpc_link.vpc_link_data.id
  uri                = format("%s//%s","http:","${aws_lb.data_front_end_nlb.dns_name}")
}

resource "aws_api_gateway_vpc_link" "vpc_link_data" {
  name               = "vpc_link_data"
  target_arns        = [aws_lb.data_front_end_nlb.arn]
}

resource "aws_api_gateway_deployment" "apigw_deployment_data" {
  rest_api_id = aws_api_gateway_rest_api.apigw_rest_api_data.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.apigw_resource_data.id,
      aws_api_gateway_method.apigw_method_data.id,
      aws_api_gateway_integration.apigw_integration_data.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw_stage_data" {
  deployment_id = aws_api_gateway_deployment.apigw_deployment_data.id
  rest_api_id   = aws_api_gateway_rest_api.apigw_rest_api_data.id
  stage_name    = "apigw_stage_data"
}


resource "aws_api_gateway_domain_name" "apigw_domain_name_data" {
  domain_name              = "data.ngspipelines.com"
  regional_certificate_arn = aws_acm_certificate.cert2.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "apigw_route53_record_data" {
  name    = aws_api_gateway_domain_name.apigw_domain_name_data.domain_name
  type    = "A"
  zone_id = aws_route53_zone.main.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.apigw_domain_name_data.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.apigw_domain_name_data.regional_zone_id
  }
}

# map the custom domain name data.ngspipelines.com to API gateway deployed stage
resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.apigw_rest_api_data.id
  stage_name  = aws_api_gateway_stage.apigw_stage_data.stage_name
  domain_name = aws_api_gateway_domain_name.apigw_domain_name_data.domain_name
}

# need for authentication on API Gateway
resource "aws_api_gateway_api_key" "apigw_api_key_data" {
  name = "apigw_api_key_data"
}

resource "aws_api_gateway_usage_plan" "apigw_usage_plan_data" {
  name = "usage_plan_data"

  api_stages {
    api_id = aws_api_gateway_rest_api.apigw_rest_api_data.id
    stage  = aws_api_gateway_stage.apigw_stage_data.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "apigw_usage_plan_key_data" {
  key_id        = aws_api_gateway_api_key.apigw_api_key_data.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.apigw_usage_plan_data.id
}
*/
