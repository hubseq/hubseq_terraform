resource "aws_lb" "data_front_end_nlb1" {
  name               = "nlb-front-end-data-public"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for s in aws_subnet.public_subnets : s.id]
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-data-frontend" })
}

resource "aws_lb_target_group" "front_end_tg_data1" {
  name     = "front-end-tg-data-1"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-data-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_data1" {
  target_group_arn = aws_lb_target_group.front_end_tg_data1.arn
  target_id        = var.data_instance_ip1
  port             = 80
}

resource "aws_lb_listener" "front_end_nlb_listener_data1" {
  load_balancer_arn = aws_lb.data_front_end_nlb1.arn
  port              = "80"
  protocol          = "TCP"
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_data1.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-data-frontend" })
}

resource "aws_route53_record" "data" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "data.ngspipelines.com"
  type    = "A"

  alias {
    name                   = aws_lb.data_front_end_nlb1.dns_name
    zone_id                = aws_lb.data_front_end_nlb1.zone_id
    evaluate_target_health = true
  }
}

#resource "aws_lb_listener_certificate" "data_front_end_cert" {
#  listener_arn    = aws_lb_listener.data_front_end_alb_listener.arn
#  certificate_arn = aws_acm_certificate.cert2.arn
#}
