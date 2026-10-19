# CI/CD and GitOps Design

## Continuous Integration

The source diagram uses GitHub Actions for CI:
1. Build and test Go services in parallel.
2. Scan images with Trivy.
3. Publish images.
4. Update Helm values/manifests with an immutable image tag or digest.
5. Commit the deployment change to the GitOps repository.

## Registry Decision

Use **Docker Hub** for application images. The ECR labels in the source diagram are superseded by this project decision. Do not provision ECR repositories or implement ECR login for application images.

## Continuous Delivery

- Store Helm charts and environment values in the GitOps repository.
- Argo CD watches the repository and reconciles desired state into EKS.
- Use an app-of-apps or another documented application layout.
- Do not run `helm upgrade` from CI for applications managed by Argo CD.
- Store Docker Hub tokens and other credentials in secure secret storage, not in Git.

## CI Tool Decision

The diagram names GitHub Actions, while the wider project plan has also discussed Jenkins. Before implementation, decide whether to use GitHub Actions, Jenkins, or a clearly separated combination. Avoid maintaining two pipelines that duplicate the same work without a reason.
