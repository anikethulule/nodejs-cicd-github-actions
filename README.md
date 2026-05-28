# Node.js Static Website CI/CD with Terraform, Docker, Trivy and Kubernetes on AWS EC2

## 📌 Project Overview

This project demonstrates an end-to-end DevOps CI/CD workflow for deploying a Node.js static website on a Kubernetes cluster running on an AWS EC2 Ubuntu server.

The infrastructure is provisioned using Terraform. Kubernetes is installed on an EC2 instance using kubeadm. The application is containerized using Docker, scanned using Trivy, pushed to Docker Hub, and deployed to Kubernetes using GitHub Actions.

---

## 🏗️ Architecture Flow

```text
Developer
   ↓
Code Push to GitHub main branch
   ↓
GitHub Actions CI/CD Pipeline
   ↓
npm ci
   ↓
npm test
   ↓
npm run build
   ↓
Docker image build
   ↓
Trivy image scan
   ↓
Docker image push to Docker Hub
   ↓
Deploy to Kubernetes running on AWS EC2
   ↓
Access application using EC2 Public IP and NodePort
```

---

## ✅ What This Project Covers

- Node.js Express static website
- Unit testing using Jest and Supertest
- Multi-stage Docker build
- Docker Hub image push
- Trivy image vulnerability scanning
- Terraform Infrastructure as Code
- AWS VPC, Subnet, Security Group, EC2 provisioning
- Kubernetes installation on Ubuntu EC2 using kubeadm
- Kubernetes Deployment, Namespace and NodePort Service
- GitHub Actions CI/CD pipeline
- Automated deployment to Kubernetes

---

## 🧰 Tools and Technologies Used

| Tool | Purpose |
|---|---|
| Node.js | Application runtime |
| Express.js | Static website hosting and API endpoints |
| Jest | Unit testing |
| Supertest | API endpoint testing |
| Docker | Containerization |
| Docker Hub | Container image registry |
| Trivy | Container image vulnerability scanning |
| GitHub Actions | CI/CD automation |
| Terraform | Infrastructure provisioning |
| AWS EC2 | Kubernetes server |
| Ubuntu | EC2 operating system |
| Kubernetes | Container orchestration |
| kubeadm | Kubernetes cluster bootstrap |
| kubectl | Kubernetes CLI |
| Calico | Kubernetes CNI plugin |

---

## 📁 Project Structure

```text
nodejs-k8s-cicd-terraform/
├── app/
│   ├── public/
│   │   ├── index.html
│   │   ├── style.css
│   │   └── script.js
│   ├── src/
│   │   ├── app.js
│   │   └── server.js
│   ├── tests/
│   │   └── app.test.js
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── package.json
│   └── package-lock.json
│
├── k8s/
│   ├── namespace.yml
│   ├── deployment.yml
│   └── service-nodeport.yml
│
├── terraform/
│   ├── modules/
│   │   ├── networking/
│   │   ├── security-group/
│   │   └── ec2-k8s/
│   └── environments/
│       └── dev/
│           ├── versions.tf
│           ├── provider.tf
│           ├── data.tf
│           ├── locals.tf
│           ├── main.tf
│           ├── variables.tf
│           ├── terraform.tfvars
│           └── outputs.tf
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── .gitignore
└── README.md
```

---

## 🔐 Required Accounts

Before starting, create or prepare these accounts:

- AWS account
- GitHub account
- Docker Hub account

---

## 💻 Local System Prerequisites

Install the following tools on your local machine:

```bash
git --version
node -v
npm -v
docker --version
terraform version
aws --version
kubectl version --client
```

If any tool is missing, install it before continuing.

---

## 1️⃣ Clone or Create the Repository

```bash
git clone git@github.com:anikethulule/nodejs-cicd-github-actions.git
cd nodejs-cicd-github-actions
```

If you are creating from scratch:

```bash
mkdir nodejs-cicd-github-actions
cd nodejs-cicd-github-actions
git init
```

---

## 2️⃣ Node.js Application Setup

Go to the application directory:

```bash
cd app
```

Install dependencies:

```bash
npm install
```

Run tests:

```bash
npm test
```

Start the application locally:

```bash
npm start
```

Access locally:

```text
http://localhost:3000
http://localhost:3000/health
http://localhost:3000/api/info
```

---

## 3️⃣ Node.js Application Files

### `app/src/app.js`

```javascript
const express = require("express");
const path = require("path");

const app = express();

app.use(express.static(path.join(__dirname, "../public")));

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "UP",
    service: "nodejs-static-website-k8s",
    timestamp: new Date().toISOString()
  });
});

app.get("/api/info", (req, res) => {
  res.status(200).json({
    app: "Static Website using Node.js",
    environment: process.env.NODE_ENV || "development",
    version: process.env.APP_VERSION || "1.0.0",
    deployedOn: "Kubernetes",
    provisionedBy: "Terraform"
  });
});

module.exports = app;
```

### `app/src/server.js`

```javascript
const app = require("./app");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Static website server is running on port ${PORT}`);
});
```

---

## 4️⃣ Dockerfile

### `app/Dockerfile`

```dockerfile
# Multi-stage build for Node.js application
FROM node:22-alpine AS builder

WORKDIR /app

RUN npm install -g npm@latest

COPY package*.json ./

RUN npm ci --omit=dev

# Production stage
FROM node:22-alpine

WORKDIR /app

RUN apk update && apk upgrade --no-cache

RUN npm install -g npm@latest

COPY --from=builder /app/node_modules ./node_modules

COPY src ./src
COPY public ./public
COPY package*.json ./

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => { if (r.statusCode !== 200) process.exit(1); }).on('error', () => process.exit(1))"

CMD ["npm", "start"]
```

---

## 5️⃣ Build and Test Docker Image Locally

Replace `<dockerhub-username>` with your Docker Hub username.

```bash
cd app

docker build -t <dockerhub-username>/nodejs-k8s-cicd:latest .
```

Run the container:

```bash
docker run -d \
  --name nodejs-k8s-cicd \
  -p 3000:3000 \
  <dockerhub-username>/nodejs-k8s-cicd:latest
```

Test:

```bash
curl http://localhost:3000
curl http://localhost:3000/health
curl http://localhost:3000/api/info
```

Stop and remove container:

```bash
docker stop nodejs-k8s-cicd
docker rm nodejs-k8s-cicd
```

---

## 6️⃣ Docker Hub Setup

Login to Docker Hub:

```bash
docker login
```

Push image manually if needed:

```bash
docker push <dockerhub-username>/nodejs-k8s-cicd:latest
```

---

## 7️⃣ Terraform Infrastructure Setup

Terraform provisions the AWS infrastructure required for the Kubernetes EC2 server.

Terraform creates:

- VPC
- Public subnet
- Internet gateway
- Route table
- Security group
- EC2 key pair
- Ubuntu EC2 instance
- Kubernetes installation through user data

---

## 8️⃣ Configure AWS CLI

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region name
Default output format
```

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

---

## 9️⃣ Create SSH Key for EC2

```bash
ssh-keygen -t ed25519 -C "nodejs-k8s-key" -f ~/.ssh/nodejs-k8s-key
chmod 600 ~/.ssh/nodejs-k8s-key
```

Verify:

```bash
ls -l ~/.ssh/nodejs-k8s-key*
```

You should see:

```text
~/.ssh/nodejs-k8s-key
~/.ssh/nodejs-k8s-key.pub
```

---

## 🔟 Configure Terraform Variables

Go to Terraform dev environment:

```bash
cd terraform/environments/dev
```

Update `terraform.tfvars`:

```hcl
aws_region  = "ap-south-1"
project_name = "nodejs-k8s-cicd"
environment = "dev"
owner       = "aniket"

vpc_cidr           = "10.10.0.0/16"
public_subnet_cidr = "10.10.1.0/24"

instance_type    = "t3.medium"
root_volume_size = 30
root_volume_type = "gp3"

ubuntu_version = "22.04"
architecture   = "amd64"

key_name        = "nodejs-k8s-key"
public_key_path = "~/.ssh/nodejs-k8s-key.pub"

allowed_ssh_cidr = "0.0.0.0/0"
allowed_app_cidr = "0.0.0.0/0"

nodeport = 30080

kubernetes_version = "v1.31"
calico_version     = "v3.28.0"
```

`calico_version` is required in this project because the EC2 user-data script installs Calico as the Kubernetes CNI plugin. Without a CNI plugin, Kubernetes pods may not get proper networking and the node may not become fully ready.

> Warning: `0.0.0.0/0` opens SSH and Kubernetes API access to the internet. This is acceptable for temporary demo/testing, but for production you should restrict it to your trusted IP or use a self-hosted GitHub runner.

---

## 1️⃣1️⃣ Run Terraform

Initialize Terraform:

```bash
terraform init
```

Format code:

```bash
terraform fmt -recursive ../../
```

Validate:

```bash
terraform validate
```

Review plan:

```bash
terraform plan
```

Create infrastructure:

```bash
terraform apply
```

Type:

```text
yes
```

After completion, Terraform will show outputs such as:

```text
k8s_server_public_ip
k8s_server_public_dns
ssh_command
application_url
kubernetes_api_server
```

---

## 1️⃣2️⃣ Verify EC2 and Kubernetes Installation

SSH to EC2:

```bash
ssh -i ~/.ssh/nodejs-k8s-key ubuntu@<EC2_PUBLIC_IP>
```

Check Kubernetes installation logs:

```bash
sudo tail -f /var/log/k8s-user-data.log
```

Check Kubernetes node:

```bash
kubectl get nodes
```

Check all Kubernetes pods:

```bash
kubectl get pods -A
```

Expected:

```text
STATUS: Ready
```

---

## 1️⃣3️⃣ Kubernetes Manifests

### `k8s/namespace.yml`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: nodejs-cicd
```

### `k8s/deployment.yml`

Replace `<dockerhub-username>` with your Docker Hub username.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-k8s-cicd
  namespace: nodejs-cicd
  labels:
    app: nodejs-k8s-cicd
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-k8s-cicd
  template:
    metadata:
      labels:
        app: nodejs-k8s-cicd
    spec:
      containers:
        - name: nodejs-k8s-cicd
          image: <dockerhub-username>/nodejs-k8s-cicd:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              value: "staging"
            - name: APP_VERSION
              value: "1.0.0"
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 10
            timeoutSeconds: 2
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 15
            periodSeconds: 20
            timeoutSeconds: 2
            failureThreshold: 3
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "300m"
              memory: "256Mi"
```

### `k8s/service-nodeport.yml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodejs-k8s-cicd-service
  namespace: nodejs-cicd
spec:
  type: NodePort
  selector:
    app: nodejs-k8s-cicd
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
      nodePort: 30080
```

---

## 1️⃣4️⃣ Manual Kubernetes Deployment

Copy Kubernetes manifests to EC2:

```bash
scp -i ~/.ssh/nodejs-k8s-key -r k8s ubuntu@<EC2_PUBLIC_IP>:/home/ubuntu/
```

SSH to EC2:

```bash
ssh -i ~/.ssh/nodejs-k8s-key ubuntu@<EC2_PUBLIC_IP>
```

Apply manifests:

```bash
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service-nodeport.yml
```

Verify:

```bash
kubectl get all -n nodejs-cicd
kubectl get pods -n nodejs-cicd -o wide
kubectl logs -n nodejs-cicd -l app=nodejs-k8s-cicd
```

Access:

```text
http://<EC2_PUBLIC_IP>:30080
http://<EC2_PUBLIC_IP>:30080/health
http://<EC2_PUBLIC_IP>:30080/api/info
```

---

## 1️⃣5️⃣ GitHub Repository Secrets

Go to:

```text
GitHub Repository → Settings → Secrets and variables → Actions → New repository secret
```

Add these secrets:

| Secret Name | Description |
|---|---|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |
| `KUBE_CONFIG` | Kubernetes kubeconfig content |

---

## 1️⃣6️⃣ Prepare Kubeconfig for GitHub Actions

On EC2:

```bash
cat ~/.kube/config
```

Copy the full content.

If using GitHub-hosted runner, update the server line:

```yaml
server: https://<EC2_PUBLIC_IP>:6443
```

If you get a TLS certificate error like:

```text
x509: certificate is valid for 10.96.0.1, 10.10.x.x, not <EC2_PUBLIC_IP>
```

For temporary testing, update the cluster section like this:

```yaml
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://<EC2_PUBLIC_IP>:6443
  name: kubernetes
```

Remove this line if present:

```yaml
certificate-authority-data: XXXXX
```

Then save the full kubeconfig in GitHub secret:

```text
KUBE_CONFIG
```

---

## 1️⃣7️⃣ GitHub Actions Workflow

### `.github/workflows/ci-cd.yml`

```yaml
name: Node.js Kubernetes CI/CD with Terraform Infrastructure

on:
  push:
    branches:
      - main

env:
  IMAGE_NAME: nodejs-k8s-cicd
  K8S_NAMESPACE: nodejs-cicd
  K8S_DEPLOYMENT: nodejs-k8s-cicd
  K8S_CONTAINER: nodejs-k8s-cicd

jobs:
  build-test-scan-push-deploy:
    name: Build, Test, Scan, Push Image and Deploy to Kubernetes
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source code
        uses: actions/checkout@v4

      - name: Setup Node.js 22
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: app/package-lock.json

      - name: Install dependencies
        working-directory: app
        run: npm ci

      - name: Run test cases
        working-directory: app
        run: npm test

      - name: Build application
        working-directory: app
        run: npm run build

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build Docker image locally
        uses: docker/build-push-action@v5
        with:
          context: ./app
          file: ./app/Dockerfile
          push: false
          load: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:latest
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}

      - name: Scan Docker image with Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: table
          vuln-type: os,library
          severity: HIGH,CRITICAL
          ignore-unfixed: true
          exit-code: '0'

      - name: Push Docker image after scan
        run: |
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:latest
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}

      - name: Setup kubeconfig
        run: |
          mkdir -p $HOME/.kube
          echo "${{ secrets.KUBE_CONFIG }}" > $HOME/.kube/config
          chmod 600 $HOME/.kube/config

      - name: Verify Kubernetes connection
        run: |
          kubectl get nodes

      - name: Deploy Kubernetes manifests
        run: |
          kubectl apply -f k8s/namespace.yml
          kubectl apply -f k8s/deployment.yml
          kubectl apply -f k8s/service-nodeport.yml

      - name: Update Kubernetes image
        run: |
          kubectl set image deployment/${{ env.K8S_DEPLOYMENT }} \
            ${{ env.K8S_CONTAINER }}=${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n ${{ env.K8S_NAMESPACE }}

      - name: Verify rollout status
        run: |
          kubectl rollout status deployment/${{ env.K8S_DEPLOYMENT }} \
            -n ${{ env.K8S_NAMESPACE }}

      - name: Show Kubernetes resources
        run: |
          kubectl get all -n ${{ env.K8S_NAMESPACE }}
```

---

## 1️⃣8️⃣ Trivy Scan Behavior

Current setting:

```yaml
exit-code: '0'
```

This means:

```text
Trivy will scan the image.
Vulnerabilities will be shown in logs.
Pipeline will continue even if vulnerabilities are found.
```

Strict DevSecOps setting:

```yaml
exit-code: '1'
severity: HIGH,CRITICAL
```

This means:

```text
Pipeline fails if HIGH or CRITICAL vulnerabilities are found.
Deployment will not continue.
```

Practical learning-project setting:

```yaml
exit-code: '1'
severity: CRITICAL
```

This means:

```text
Pipeline fails only for CRITICAL vulnerabilities.
HIGH vulnerabilities are reported but do not block deployment.
```

---

## 1️⃣9️⃣ Push Code to GitHub

```bash
git add .
git commit -m "Add Node.js Kubernetes CI/CD project with Terraform and Trivy"
git branch -M main
git remote add origin https://github.com/<your-github-username>/<repo-name>.git
git push -u origin main
```

After pushing, go to:

```text
GitHub Repository → Actions
```

The pipeline should run automatically.

---

## 2️⃣0️⃣ Access Application

After successful deployment:

```text
http://<EC2_PUBLIC_IP>:30080
```

Health endpoint:

```text
http://<EC2_PUBLIC_IP>:30080/health
```

API info endpoint:

```text
http://<EC2_PUBLIC_IP>:30080/api/info
```

---

## 2️⃣1️⃣ Verification Commands

### Docker

```bash
docker images
docker ps
docker logs <container-id>
```

### Kubernetes

```bash
kubectl get nodes
kubectl get pods -A
kubectl get all -n nodejs-cicd
kubectl describe pod -n nodejs-cicd <pod-name>
kubectl logs -n nodejs-cicd -l app=nodejs-k8s-cicd
kubectl rollout status deployment/nodejs-k8s-cicd -n nodejs-cicd
```

### Application

```bash
curl http://<EC2_PUBLIC_IP>:30080
curl http://<EC2_PUBLIC_IP>:30080/health
curl http://<EC2_PUBLIC_IP>:30080/api/info
```

---

## 2️⃣2️⃣ Common Issues and Fixes

### Issue 1: GitHub Actions cannot connect to Kubernetes

Error:

```text
dial tcp <EC2_PUBLIC_IP>:6443: i/o timeout
```

Fix:

- Ensure security group allows port `6443`.
- For testing, use:

```hcl
allowed_ssh_cidr = "0.0.0.0/0"
```

- For secure setup, use a self-hosted GitHub runner on EC2.

---

### Issue 2: Kubernetes TLS certificate error

Error:

```text
x509: certificate is valid for 10.96.0.1, 10.10.x.x, not <EC2_PUBLIC_IP>
```

Temporary fix in kubeconfig:

```yaml
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://<EC2_PUBLIC_IP>:6443
```

Permanent fix:

Initialize kubeadm with:

```bash
kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --apiserver-cert-extra-sans=<EC2_PUBLIC_IP>
```

---

### Issue 3: Trivy fails the pipeline

Reason:

```text
Trivy found vulnerabilities and exit-code is set to 1.
```

Fix options:

```yaml
exit-code: '0'
```

or fail only for critical:

```yaml
severity: CRITICAL
exit-code: '1'
```

---

### Issue 4: ImagePullBackOff

Check image name:

```bash
kubectl describe pod -n nodejs-cicd <pod-name>
```

Verify image exists on Docker Hub:

```bash
docker pull <dockerhub-username>/nodejs-k8s-cicd:latest
```

---

### Issue 5: Website not accessible

Check service:

```bash
kubectl get svc -n nodejs-cicd
```

Check security group allows NodePort:

```text
Port: 30080
Source: 0.0.0.0/0 or your IP
```

Access:

```text
http://<EC2_PUBLIC_IP>:30080
```

---

## 2️⃣3️⃣ Destroy Infrastructure

To avoid AWS charges, destroy resources after testing:

```bash
cd terraform/environments/dev
terraform destroy
```

Type:

```text
yes
```

---


## 📌 Final URLs

```text
Application:
http://<EC2_PUBLIC_IP>:30080

Health Check:
http://<EC2_PUBLIC_IP>:30080/health

API Info:
http://<EC2_PUBLIC_IP>:30080/api/info
```

---

## 👤 Author

**Aniket Hulule**

DevOps | Automation | Terraform | Kubernetes | GitHub Actions | Docker | AWS
