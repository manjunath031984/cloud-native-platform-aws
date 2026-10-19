# ------------------------------------------------------------
# Application Load Balancer Security Group
# ------------------------------------------------------------

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic to the application load balancer."
  vpc_id      = var.vpc_id

  ingress = []
  egress  = []

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-alb-sg"
      Tier = "public"
    }
  )
}

# Allow HTTP traffic on port 80
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  for_each = toset(var.alb_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from approved client CIDRs"
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Allow HTTPS traffic on port 443
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  for_each = toset(var.alb_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS from approved client CIDRs"
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# ------------------------------------------------------------
# Application Security Group
# ------------------------------------------------------------

resource "aws_security_group" "application" {
  name        = "${var.name}-application-sg"
  description = "Allow application traffic from the ALB security group."
  vpc_id      = var.vpc_id

  ingress = []
  egress  = []

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-application-sg"
      Tier = "application"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "application_from_alb" {
  security_group_id            = aws_security_group.application.id
  referenced_security_group_id = aws_security_group.alb.id
  description                  = "Allow application traffic from ALB"
  ip_protocol                  = "tcp"
  from_port                    = var.application_port
  to_port                      = var.application_port
}

# ------------------------------------------------------------
# PostgreSQL Security Group
# ------------------------------------------------------------

resource "aws_security_group" "postgres" {
  name        = "${var.name}-postgres-sg"
  description = "Allow PostgreSQL access from the application security group."
  vpc_id      = var.vpc_id

  ingress = []
  egress  = []

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-postgres-sg"
      Tier = "database"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_application" {
  security_group_id            = aws_security_group.postgres.id
  referenced_security_group_id = aws_security_group.application.id
  description                  = "Allow PostgreSQL from application workloads"
  ip_protocol                  = "tcp"
  from_port                    = var.postgres_port
  to_port                      = var.postgres_port
}

# ------------------------------------------------------------
# Redis Security Group
# ------------------------------------------------------------

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis-sg"
  description = "Allow Redis access from the application security group."
  vpc_id      = var.vpc_id

  ingress = []
  egress  = []

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-redis-sg"
      Tier = "cache"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_application" {
  security_group_id            = aws_security_group.redis.id
  referenced_security_group_id = aws_security_group.application.id
  description                  = "Allow Redis from application workloads"
  ip_protocol                  = "tcp"
  from_port                    = var.redis_port
  to_port                      = var.redis_port
}

# ------------------------------------------------------------
# Explicit Egress Rules
# ------------------------------------------------------------

# ALB can send traffic to the application port only.
resource "aws_vpc_security_group_egress_rule" "alb_to_application" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.application.id
  description                  = "Forward application traffic to application workloads"
  ip_protocol                  = "tcp"
  from_port                    = var.application_port
  to_port                      = var.application_port
}

# Application workloads can connect to PostgreSQL.
resource "aws_vpc_security_group_egress_rule" "application_to_postgres" {
  security_group_id            = aws_security_group.application.id
  referenced_security_group_id = aws_security_group.postgres.id
  description                  = "Allow application connections to PostgreSQL"
  ip_protocol                  = "tcp"
  from_port                    = var.postgres_port
  to_port                      = var.postgres_port
}

# Application workloads can connect to Redis.
resource "aws_vpc_security_group_egress_rule" "application_to_redis" {
  security_group_id            = aws_security_group.application.id
  referenced_security_group_id = aws_security_group.redis.id
  description                  = "Allow application connections to Redis"
  ip_protocol                  = "tcp"
  from_port                    = var.redis_port
  to_port                      = var.redis_port
}
