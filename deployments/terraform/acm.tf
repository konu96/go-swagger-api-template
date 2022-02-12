# ====================
# ACM
# ====================
#resource "aws_acm_certificate" "atplace-acm" {
#  domain_name               = "atplace.com"
#  subject_alternative_names = ["*.atplace.com"]
#  validation_method         = "DNS"
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}