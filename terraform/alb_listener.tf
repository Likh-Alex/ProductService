# Default HTTPS listener with fixed response that blocks all traffic
resource "aws_alb_listener" "alb_default_listener_https" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate.alb_certitificate.arn
  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No way Jose!"
      status_code  = "403"
    }

    depends_on = [
      aws_acm_certificate.alb_certificate
    ]
  }
}

resource "aws_alb_listener_rule" "https_listener_rule" {
  listener_arn = aws_alb_listener_rule.https_listener_rule.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.environment}.${var.domain_name}"]
    }
  }
  condition {
    http_header {
      http_header_name = "X-Custom-Header"
      values           = [var.custom_origin_host_header]
    }
  }
}