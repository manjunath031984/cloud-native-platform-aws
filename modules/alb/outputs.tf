# ---------------------------------------------------------
# ALB Outputs
# ---------------------------------------------------------

output "alb_id" {
  description = "ID of the Application Load Balancer."
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.this.arn
}

output "alb_name" {
  description = "Name of the Application Load Balancer."
  value       = aws_lb.this.name
}

output "alb_dns_name" {
  description = "DNS name assigned to the Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer, useful for Route 53 aliases."
  value       = aws_lb.this.zone_id
}

# ---------------------------------------------------------
# Target Group Outputs
# ---------------------------------------------------------

output "target_group_arn" {
  description = "ARN of the ALB target group."
  value       = aws_lb_target_group.this.arn
}

output "target_group_name" {
  description = "Name of the ALB target group."
  value       = aws_lb_target_group.this.name
}

# ---------------------------------------------------------
# Listener Outputs
# ---------------------------------------------------------

output "http_listener_arn" {
  description = "ARN of the HTTP listener."
  value       = aws_lb_listener.http.arn
}

output "http_url" {
  description = "HTTP URL for accessing the ALB directly."
  value       = "http://${aws_lb.this.dns_name}"
}