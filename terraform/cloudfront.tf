# module "cdn" {
#   source = "terraform-aws-modules/cloudfront/aws"

#   aliases = [local.domain[local.environment].domain_name]

#   comment             = "CloudFront WorldCup API"
#   enabled             = true
#   is_ipv6_enabled     = false
#   price_class         = "PriceClass_All"
#   retain_on_delete    = false
#   wait_for_deployment = false

#   create_origin_access_identity = false

#   origin = {
#     apigateway_wc = {
#       domain_name = local.apigateway_dns
#       custom_origin_config = {
#         http_port              = 80
#         https_port             = 443
#         origin_protocol_policy = "https-only"
#         origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
#       }
#     }
#   }

#   default_cache_behavior = {
#     target_origin_id       = "apigateway_wc"
#     viewer_protocol_policy = "allow-all"

#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods  = ["GET", "HEAD"]
#     compress        = true
#     query_string    = true
#   }

#   ordered_cache_behavior = [
#     {
#       path_pattern           = "/Prod/*"
#       target_origin_id       = "apigateway_wc"
#       viewer_protocol_policy = "redirect-to-https"

#       allowed_methods = ["GET", "HEAD", "OPTIONS"]
#       cached_methods  = ["GET", "HEAD"]
#       compress        = true
#       query_string    = true
#     }
#   ]

#   viewer_certificate = {
#     acm_certificate_arn = aws_acm_certificate.ga_cloud.id
#     ssl_support_method  = "sni-only"
#   }
# }

# resource "aws_acm_certificate" "ga_cloud" {
#   domain_name       = local.domain.name
#   validation_method = "DNS"

#   subject_alternative_names = [format("*.%s", local.domain.name)]

# }

# data "aws_route53_zone" "ga_cloud" {
#   name         = local.domain.name
#   private_zone = false
# }

# resource "aws_route53_record" "ga_cloud" {
#   for_each = {
#     for dvo in aws_acm_certificate.ga_cloud.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.ga_cloud.zone_id
# }

# resource "aws_acm_certificate_validation" "ga_cloud" {
#   certificate_arn         = aws_acm_certificate.ga_cloud.arn
#   validation_record_fqdns = [for record in aws_route53_record.ga_cloud : record.fqdn]
# }