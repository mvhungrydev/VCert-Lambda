variable "account_id" {
  type        = string
  description = "AWS account ID for ECR image"
}

variable "image_tag" {
  type        = string
  description = "Tag of the ECR image to deploy"
}
