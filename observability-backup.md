# Observability, Backup, and Disaster Recovery

## Observability Components

The diagram includes:
- Prometheus for metrics
- Grafana for dashboards
- Alertmanager for alert routing
- Loki for log aggregation
- Promtail for log shipping (verify current support and consider supported alternatives)
- Tempo for distributed tracing
- OpenTelemetry Collector for telemetry ingestion
- metrics-server for Kubernetes CPU/memory metrics

Track service-level indicators such as request rate, error rate, latency percentiles, CPU, memory, saturation, and dependency health.

## Backup

- Velero for Kubernetes resources and persistent-volume backups
- Amazon S3 for backup storage
- Proposed daily schedule and 30-day retention, subject to cost and compliance review
- Restore testing is required, not optional

## Stateful Data

Define separate backup and recovery procedures for PostgreSQL, Redis, and Kafka. Establish RPO/RTO, encryption, retention, access controls, and restore validation before production use.
