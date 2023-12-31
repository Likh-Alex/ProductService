# Create a Route53 zone for the product service
resource "aws_route53_zone" "product_service_route53_zone" {
  name = var.domain_name
}

# Create a Route53 record for the product service
resource "aws_route53_record" "product_service_environment" {
  zone_id = aws_route53_zone.product_service_route53_zone.zone_id
  name    = var.domain_name
  type    = "NS"
  ttl     = 300
  records = [
    aws_route53_zone.product_service_route53_zone.name_servers[0],
    aws_route53_zone.product_service_route53_zone.name_servers[1],
    aws_route53_zone.product_service_route53_zone.name_servers[2],
    aws_route53_zone.product_service_route53_zone.name_servers[3],
  ]
}

resource "aws_route53_record" "product_service_route53_record" {
  name    = "${var.environment}.${var.domain_name}"
  type    = "A"
  zone_id = aws_route53_zone.product_service_route53_zone.id

  alias {
    name                   = aws_cloudfront_distribution.default_cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.default_cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}