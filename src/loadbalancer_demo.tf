/*
  load balancer and target groups for demo instances
  demo.hubseq.com
*/
resource "aws_lb" "demo_front_end_nlb1" {
  name               = "nlb-front-end-demo-public"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for s in aws_subnet.public_subnets : s.id]
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-demo-frontend" })
}

/* target group for port 80 of the demo server */
resource "aws_lb_target_group" "front_end_tg_demo1" {
  name     = "front-end-tg-demo-1"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-demo-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_demo1" {
  target_group_arn = aws_lb_target_group.front_end_tg_demo1.arn
  target_id        = var.demo_instance_ip1
  port             = 80
}

/* target group for port 8080 of the demo server */
resource "aws_lb_target_group" "front_end_tg_demo1b" {
  name     = "front-end-tg-demo-1b"
  port     = 8080
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-demo1b-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_demo1b" {
  target_group_arn = aws_lb_target_group.front_end_tg_demo1b.arn
  target_id        = var.demo_instance_ip1
  port             = 8080
}

/* target group for port 8081 of the demo server */
resource "aws_lb_target_group" "front_end_tg_demo1c" {
  name     = "front-end-tg-demo-1c"
  port     = 8081
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-demo1c-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_demo1c" {
  target_group_arn = aws_lb_target_group.front_end_tg_demo1c.arn
  target_id        = var.demo_instance_ip1
  port             = 8081
}

/* target group for port 8082 of the demo server */
resource "aws_lb_target_group" "front_end_tg_demo1d" {
  name     = "front-end-tg-demo-1d"
  port     = 8082
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-demo1d-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_demo1d" {
  target_group_arn = aws_lb_target_group.front_end_tg_demo1d.arn
  target_id        = var.demo_instance_ip1
  port             = 8082
}

/* target group for port 8083 of the demo server */
resource "aws_lb_target_group" "front_end_tg_demo1e" {
  name     = "front-end-tg-demo-1e"
  port     = 8083
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-tg-demo1e-frontend" })
}

resource "aws_lb_target_group_attachment" "front_end_tg_attachment_demo1e" {
  target_group_arn = aws_lb_target_group.front_end_tg_demo1e.arn
  target_id        = var.demo_instance_ip1
  port             = 8083
}


/* load balancer listener for port 80 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_demo1" {
  load_balancer_arn = aws_lb.demo_front_end_nlb1.arn
  port              = "80"
  protocol          = "TCP"
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_demo1.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-demo-frontend" })
}

/* load balancer listener for port 8080 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_demo1b" {
  load_balancer_arn = aws_lb.demo_front_end_nlb1.arn
  port              = "8080"
  protocol          = "TCP"
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_demo1b.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-demo1b-frontend" })
}

/* load balancer listener for port 8081 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_demo1c" {
  load_balancer_arn = aws_lb.demo_front_end_nlb1.arn
  port              = "8081"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_demo1c.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-demo1c-frontend" })
}

/* load balancer listener for port 8082 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_demo1d" {
  load_balancer_arn = aws_lb.demo_front_end_nlb1.arn
  port              = "8082"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_demo1d.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-demo1d-frontend" })
}

/* load balancer listener for port 8083 on the front end (internet facing)*/
resource "aws_lb_listener" "front_end_nlb_listener_demo1e" {
  load_balancer_arn = aws_lb.demo_front_end_nlb1.arn
  port              = "8083"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_tg_demo1e.arn
  }
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nlb-listener-demo1e-frontend" })
}

/* route53 record for demo.hubseq.com - alias for demo load balancer */
resource "aws_route53_record" "demo" {
  zone_id = aws_route53_zone.main_hubseq.zone_id
  name    = "demo.${var.company_name}.com"
  type    = "A"

  alias {
    name                   = aws_lb.demo_front_end_nlb1.dns_name
    zone_id                = aws_lb.demo_front_end_nlb1.zone_id
    evaluate_target_health = true
  }
}
