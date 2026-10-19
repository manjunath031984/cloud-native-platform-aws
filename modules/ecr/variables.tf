variable "repository_names" {
  description = "Names of private ECR repositories to create."
  type        = set(string)

  validation {
    condition = (
      length(var.repository_names) > 0 &&
      alltrue([
        for name in var.repository_names :
        can(regex("^[a-z0-9]+([._/-][a-z0-9]+)*$", name)) &&
        length(name) <= 256
      ])
    )
    error_message = "Provide at least one valid ECR repository name using lowercase letters, numbers, hyphens, underscores, periods, or slashes."
  }
}

variable "image_tag_mutability" {
  description = "Whether existing image tags can be overwritten."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable ECR image scanning when images are pushed."
  type        = bool
  default     = true
}

variable "max_tagged_images" {
  description = "Maximum number of tagged images to retain in each repository."
  type        = number
  default     = 30

  validation {
    condition     = var.max_tagged_images >= 1
    error_message = "max_tagged_images must be at least 1."
  }
}

variable "tags" {
  description = "Common tags applied to ECR resources."
  type        = map(string)
  default     = {}
}