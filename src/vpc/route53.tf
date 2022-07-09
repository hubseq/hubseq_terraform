module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  #zones = {
  #  "ngspipelines.com" = {
  #    name = "main"
  #    comment = "ngspipelines.com"
  #    tags = merge(local.common_tags, { Name = "${local.name_prefix}-route53-zone-main" })
  #  }
  #}

  tags = {
    ManagedBy = "Terraform"
  }
}

/* hosted zone for HubSeq */
resource "aws_route53_zone" "main_hubseq" {
  name = "hubseq.com"
}

/* certificates for HubSeq */
resource "aws_acm_certificate" "cert_hubseq" {
  domain_name       = "hubseq.com"
  validation_method = "DNS"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-acm-cert-1" })

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_route53_zone.main_hubseq]
}

resource "aws_acm_certificate" "cert2_hubseq" {
  domain_name       = "data.hubseq.com"
  validation_method = "DNS"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-acm-cert-2" })

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_route53_zone.main_hubseq]
}

resource "aws_acm_certificate" "cert3_hubseq" {
  domain_name       = "demo.hubseq.com"
  validation_method = "DNS"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-acm-cert-3" })

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_route53_zone.main_hubseq]
}

/*
resource "aws_route53_zone" "main" {
  name = "ngspipelines.com"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "ngspipelines.com"
  validation_method = "DNS"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-acm-cert-1" })

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_route53_zone.main]
}

resource "aws_acm_certificate" "cert2" {
  domain_name       = "data.ngspipelines.com"
  validation_method = "DNS"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-acm-cert-2" })

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_route53_zone.main]
}
*/
