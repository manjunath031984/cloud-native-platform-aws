# Cloud Native Platform on AWS --- Project Skill Guide

## 1. Project Overview

Build a production-oriented cloud-native platform on AWS using modular
Terraform. Implement the project incrementally, validate each phase,
document decisions, and obtain approval before moving to the next phase.

**GitHub repository:** `cloud-native-platform-aws`\
**Default branch:** `main`\
**Default AWS region:** `us-east-1` (configurable per environment)

## 2. Target Technology Stack

-   **Infrastructure as Code:** Terraform
-   **Cloud provider:** AWS
-   **Kubernetes:** Amazon EKS
-   **Secrets management:** HashiCorp Vault
-   **CI:** Jenkins
-   **Container registry:** Docker Hub --- do not use Amazon ECR for
    application images
-   **Packaging:** Helm
-   **CD/GitOps:** Argo CD
-   **Networking and ingress:** AWS Network Load Balancer (NLB),
    Traefik, Route 53, and TLS
-   **Platform services (later phases):** PostgreSQL, Redis, and Kafka
-   **Observability (later phases):** Prometheus, Grafana, Loki, Tempo,
    and OpenTelemetry
-   **Backup and recovery (later phases):** Amazon S3 and Velero, where
    appropriate

Do not deploy Jenkins, Argo CD, application workloads, databases,
observability services, or other platform services during the initial
infrastructure phases.

## 3. Core Engineering Rules

1.  Inspect the existing repository and Git status before changing
    files.
2.  Reuse and improve existing implementation; do not duplicate,
    overwrite, or delete existing work without a clear reason and
    approval.
3.  Use reusable, focused Terraform modules with clear inputs, outputs,
    and documentation.
4.  Keep environment-specific configuration separate from reusable
    modules.
5.  Pin and document compatible Terraform and AWS provider versions. Use
    currently supported versions and verify provider arguments against
    official documentation.
6.  Never commit Terraform state, credentials, private keys, Vault
    tokens, passwords, or other secrets.
7.  Do not place secret values in Terraform outputs, source control,
    Helm values, or pipeline logs.
8.  Treat Terraform state as sensitive. Use a protected S3 backend with
    versioning, encryption, restrictive access, and native S3 state
    locking supported by the selected Terraform version.
9.  Do not use `terraform apply -auto-approve` or run
    `terraform destroy` automatically.
10. Never apply infrastructure changes without showing the plan and
    receiving explicit approval.
11. Identify destructive changes, replacements, security implications,
    and estimated cost impacts before requesting approval.
12. Do not claim a command or validation passed unless it was actually
    executed and its result inspected.
13. Prefer least-privilege IAM, private networking, secure defaults, and
    explicit configuration over broad permissions.
14. Keep documentation synchronized with implementation and decisions.

## 4. HashiCorp Vault and Encryption

Use HashiCorp Vault as the centralized secrets-management platform for
application secrets, credentials, tokens, and supported dynamic secrets.

Vault is not a universal replacement for AWS KMS. Retain AWS-managed
encryption or AWS KMS where required or appropriate for AWS services,
Terraform state, EKS secrets encryption, S3, and other infrastructure
components. Do not create a dedicated KMS module solely for application
secret storage.

Before implementing Vault, document and review:

-   Self-hosted Vault versus HashiCorp-managed Vault
-   Supported storage backend, durability, and high availability
-   Initialization and unsealing strategy
-   Authentication and least-privilege policies
-   AWS IAM authentication and Kubernetes authentication, where
    appropriate
-   Jenkins integration and EKS workload access
-   Backup, restore, recovery, rotation, and revocation procedures
-   Bootstrap dependencies, operational risks, and estimated costs

Avoid passing secret values through Terraform when applications or
pipelines can retrieve them securely at runtime.

## 5. Suggested Repository Structure

Adapt this structure after inspecting the repository; do not create
unnecessary files just to match it.

``` text
cloud-native-platform-aws/
├── Skill.md
├── README.md
├── .gitignore
├── versions.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   ├── iam/
│   ├── eks/
│   ├── eks-addons/
│   ├── vault/
│   ├── route53/
│   ├── acm/
│   └── backup/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── bootstrap/
│   └── terraform-state/
└── docs/
    ├── architecture.md
    ├── networking.md
    ├── security.md
    ├── deployment-guide.md
    ├── cost-estimation.md
    ├── troubleshooting.md
    └── phase-tracker.md
```

Keep only the modules and files that are appropriate to the agreed
design. A bootstrap layer may be required to create the remote state
bucket before other Terraform layers can use it.

## 6. Infrastructure Design Guidelines

### Networking

-   Use a configurable VPC CIDR; proposed default: `10.0.0.0/16`.
-   Plan for three Availability Zones, with public and private subnets
    in each AZ where supported by the selected region.
-   Place EKS worker nodes in private subnets.
-   Configure Internet Gateway, route tables, and NAT according to the
    approved design.
-   Make NAT topology configurable: a single NAT gateway can reduce
    development costs; NAT per AZ can improve availability at higher
    cost.
-   Evaluate VPC endpoints where they reduce exposure or operating cost.
-   Avoid exposing private services directly to the public internet.

### Amazon EKS

-   Use managed node groups in private subnets unless a reviewed
    requirement calls for another approach.
-   Prefer a private EKS API endpoint. If public access is enabled,
    require an explicit CIDR allowlist; never default to unrestricted
    public API access.
-   Use current, supported EKS and add-on versions compatible with the
    chosen region.
-   Review EKS access entries, control-plane logging, encryption,
    network policies, node sizing, and autoscaling.
-   Plan required add-ons, such as VPC CNI, CoreDNS, kube-proxy, EBS
    CSI, and metrics support, according to the selected architecture.
-   Validate capacity for the expected workloads and document
    assumptions.

### DNS and TLS

-   The domain is registered with GoDaddy. Do not assume its DNS is
    already delegated to Route 53.
-   Document the proposed DNS hosting and delegation approach before
    making DNS changes.
-   Explain the chosen TLS termination design, certificate ownership,
    renewal, and traffic path.
-   Install Traefik and configure application ingress only in a later
    platform phase.

### Images and GitOps

-   Use Docker Hub for application images, not Amazon ECR.
-   Use secure Jenkins credentials and Docker Hub access tokens; never
    hardcode them.
-   Use immutable image tags or digests in deployment configuration.
-   Jenkins builds, tests, scans, and publishes images, then updates the
    GitOps configuration as appropriate.
-   Argo CD reconciles GitOps configuration into EKS.
-   Do not have Jenkins run `helm upgrade` for applications managed by
    Argo CD; avoid competing deployment controllers.
-   Keep application source and GitOps configuration logically organized
    and document the chosen repository strategy.

## 7. Phased Implementation Workflow

### Phase 0 --- Repository and Architecture Review

-   Inspect repository contents, Git status, branches, and existing
    implementation.
-   Review the target architecture and identify missing decisions.
-   Produce an architecture inventory, dependency map, network/security
    plan, state strategy, cost considerations, and phase roadmap.
-   Record assumptions and open questions.
-   Do not provision AWS resources.
-   Wait for approval before implementing Phase 1.

### Phase 1 --- Terraform Foundation

-   Establish Terraform conventions, version constraints, providers,
    variables, outputs, formatting, validation, and `.gitignore`.
-   Create documentation and a phase tracker.
-   Do not provision production infrastructure.

### Phase 2 --- Remote State

-   Create the remote state bootstrap layer.
-   Configure a protected S3 state bucket with versioning, encryption,
    public-access blocking, and least-privilege access.
-   Configure native S3 state locking supported by the selected
    Terraform version.
-   Document state migration, recovery, and access controls.
-   Avoid circular dependencies between the bootstrap layer and
    environment states.

### Phase 3 --- VPC and Networking

-   Implement VPC, subnets across the approved AZs, routing, Internet
    Gateway, configurable NAT, and appropriate endpoints.
-   Add network security rules using least privilege.
-   Validate subnet layout and routing before approval.

### Phase 4 --- IAM and Security Foundations

-   Create only the IAM roles and policies required by the approved
    design.
-   Configure encryption and security controls required by AWS services.
-   Keep application secrets in Vault where appropriate.
-   Avoid unnecessary permissions and broad wildcard policies.

### Phase 5 --- Amazon EKS

-   Provision the EKS control plane, managed node groups, access
    configuration, logging, and required network integrations.
-   Keep worker nodes in private subnets.
-   Review endpoint exposure, node sizing, capacity, availability, and
    cost.

### Phase 6 --- EKS Add-ons and Vault Integration

-   Add and validate the approved EKS add-ons.
-   Design and deploy Vault only after its bootstrap, storage,
    authentication, recovery, and access controls are reviewed.
-   Integrate Vault with AWS and EKS using supported authentication
    methods.
-   Test secret access without exposing secret values.

### Phase 7 --- DNS, TLS, and Load-Balancer Prerequisites

-   Finalize Route 53/GoDaddy DNS delegation decisions.
-   Configure certificate and TLS prerequisites.
-   Prepare the network path for NLB and later Traefik deployment.
-   Do not change public DNS without explicit approval.

### Later Phases

After infrastructure is reviewed and approved, implement the CI/CD and
platform layers in separately reviewed phases:

-   Jenkins CI and Docker Hub integration
-   Helm chart conventions
-   Argo CD and GitOps
-   PostgreSQL, Redis, and Kafka deployment choices
-   Observability with Prometheus, Grafana, Loki, Tempo, and
    OpenTelemetry
-   Backup, restore, disaster recovery, security hardening, load
    testing, and operational runbooks

For stateful services, decide between managed and self-managed options
before implementing them. Do not deploy both alternatives by default.

## 8. Required Validation

Run relevant checks for the files and modules being changed:

``` bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Also use TFLint, Checkov, and Terraform tests where appropriate and
available.

-   Run commands in the correct Terraform root directory.
-   Initialize and validate against the intended backend configuration
    when practical.
-   Do not treat `terraform init -backend=false` as proof that the real
    backend works.
-   Review the complete plan, including resource replacements and
    deletions.
-   If a command cannot be run because credentials, network access, or
    prerequisites are missing, state that clearly.
-   Never apply a plan without explicit approval.

## 9. Required Report at the End of Each Phase

At the end of each phase, report:

1.  Phase completed and scope
2.  Files created or modified
3.  Modules and AWS resources included
4.  Commands actually run and their results
5.  Security, availability, and cost considerations
6.  Outstanding issues and assumptions
7.  Acceptance checklist
8.  Documentation and `docs/phase-tracker.md` updates
9.  The exact next phase proposed

Stop after each phase and wait for explicit approval before continuing.

## 10. Definition of Done

A phase is complete only when:

-   The implementation matches the approved design.
-   Terraform code is formatted and validated where execution is
    possible.
-   Inputs, outputs, dependencies, and security choices are documented.
-   No credentials or secret values are committed.
-   The plan has been reviewed for destructive changes and unexpected
    cost.
-   The phase tracker and relevant documentation are updated.
-   Known limitations and unexecuted checks are clearly reported.
-   Approval is requested before proceeding to the next phase.
