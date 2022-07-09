resource "aws_lb" "data_front_end_nlb1" {
  name               = "nlb-front-end-data-public"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for s in aws_subnet.public_subnets : s.id]
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-data-frontend" })
}

/* target group for port 80 of the data server */
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

/* target group for port 8080 of the data server */
resource "aws_lb_target_group" "front_end_tg_data1b" {
  name     = "front-end-tg-data-1b"
  port     = 8080
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-data1b-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_data1b" {
  target_group_arn = aws_lb_target_group.front_end_tg_data1b.arn
  target_id        = var.data_instance_ip1
  port             = 8080
}

/* target group for port 8081 of the data server */
resource "aws_lb_target_group" "front_end_tg_data1c" {
  name     = "front-end-tg-data-1c"
  port     = 8081
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-data1c-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_data1c" {
  target_group_arn = aws_lb_target_group.front_end_tg_data1c.arn
  target_id        = var.data_instance_ip1
  port             = 8081
}

/* target group for port 8082 of the data server */
resource "aws_lb_target_group" "front_end_tg_data1d" {
  name     = "front-end-tg-data-1d"
  port     = 8082
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-data1d-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_data1d" {
  target_group_arn = aws_lb_target_group.front_end_tg_data1d.arn
  target_id        = var.data_instance_ip1
  port             = 8082
}

/* load balancer listener for port 80 on the front end (internet facing)*/
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

/* load balancer listener for port 8080 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_data1b" {
  load_balancer_arn = aws_lb.data_front_end_nlb1.arn
  port              = "8080"
  protocol          = "TCP"
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_data1b.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-data1b-frontend" })
}

/* load balancer listener for port 8081 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_data1c" {
  load_balancer_arn = aws_lb.data_front_end_nlb1.arn
  port              = "8081"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_data1c.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-data1c-frontend" })
}

/* load balancer listener for port 8082 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_data1d" {
  load_balancer_arn = aws_lb.data_front_end_nlb1.arn
  port              = "8082"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_data1d.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-data1d-frontend" })
}

resource "aws_route53_record" "data" {
  zone_id = aws_route53_zone.main_hubseq.zone_id
  name    = "data.${var.company_name}.com"
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
