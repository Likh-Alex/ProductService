# Creates a new ACM certificate in AWS for an ALB. The certificate will work for the domain "example.com" and all of its subdomains.
resource "aws_acm_certificate" "alb_certificate" {
  domain_name               = "example.com"
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

# Validates the ACM certificate using Route53 DNS records.
resource "aws_acm_certificate_validation" "alb_certificate_validation" {
  certificate_arn         = aws_acm_certificate.alb_certificate.arn
  validation_record_fqdns = [aws_route53_record.generic_certificate_validation.fqdn]
}

# Creates a new ACM certificate in AWS for CloudFront in the eu-central-1 region. The certificate will work for the domain specified in the `var.domain_name` variable and all of its subdomains.
resource "aws_acm_certificate" "cloudfront_certificate" {
  provider                  = aws.eu-central-1
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

# Validates the ACM certificate using Route53 DNS records.
resource "aws_acm_certificate_validation" "cloudfront_certificate_validation" {
  provider                = aws.eu-central-1
  certificate_arn         = aws_acm_certificate.cloudfront_certificate.arn
  validation_record_fqdns = [aws_route53_record.generic_certificate_validation.fqdn]
}

# Creates a Route53 DNS record for the domain validation of the ACM certificate.
resource "aws_route53_record" "generic_certificate_validation" {
  name    = tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_value]
  zone_id = aws_route53_zone.product_service_route53_zone.id
  ttl     = 300
}