output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "application_security_group_id" {
  description = "ID of the application security group."
  value       = aws_security_group.application.id
}

output "postgres_security_group_id" {
  description = "ID of the PostgreSQL security group."
  value       = aws_security_group.postgres.id
}

output "redis_security_group_id" {
  description = "ID of the Redis security group."
  value       = aws_security_group.redis.id
}

output "security_group_ids" {
  description = "Map of security group names to IDs."
  value = {
    alb         = aws_security_group.alb.id
    application = aws_security_group.application.id
    postgres    = aws_security_group.postgres.id
    redis       = aws_security_group.redis.id
  }
}
