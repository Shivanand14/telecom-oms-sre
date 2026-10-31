# Telecom Order Management System (OMS) - Cloud Native Telecom Showcase

A high-performance cloud-native microservices cluster recreating a **Local Number Portability (LNP)** order ingestion engine using an asynchronous orchestration workflow.

## 🛠️ Technology Vector
* **Orchestration:** Kubernetes (Docker Desktop Linux runtime environment)
* **Language Layer:** Python (Flask Engine running custom Prometheus hooks)
* **State Engines:** Redis High-Availability StatefulSet 
* **Chaos Framework:** Automated Linux Bash Injector utilizing Mock Traffic

## 📊 SRE Strategy & SLA Matrix
The system tracks reliability benchmarks against standard telecommunication performance rules:
* **Service Level Objective (SLO):** 99.5% of porting orders must respond with a `202 Accepted` status code.
* **Latency Objective:** P95 latency boundary must stay below `200ms` during high bulk activation periods.

## 🚀 Deployment Instructions

1. **Verify your local cluster configuration:**
   ```bash
   kubectl cluster-info
   ```
2. **Launch the entire environment & inject validation disruptions:**
   ```bash
   chmod +x telecom-chaos.sh
   ./telecom-chaos.sh
   ```
3. **Monitor Live Scrape Targets:**
   Access the metrics layer via `http://localhost:8080/metrics` to watch production counters increment as load models fire.


Commands used to execute this project in your local environment.
  545  ls -la
  546  cd telecom-oms-sre/
  547  ll
  548  cat README.md
  549  kubectl cluster-info
  550  chmod +x telecom-chaos.sh
  551  ./telecom-chaos.sh
  552  docker build -f Dockerfile.api -t telecom-order-api:latest .
  553  docker run -d -p 8080:8080 --name order-service telecom-order-api:latest
  554  ocker run -d -p 8080:8080 --name order-service telecom-order-api:latest
  555  docker run -d -p 8080:8080 --name order-service telecom-order-api:latest
  556  docker ps
  557  ./telecom-chaos.sh
  558  cat telecom-oms.yaml
  559  nano telecom-oms.yaml
  560  ./telecom-chaos.sh
  561  cat README.md
  562  kubectl get pods -n telecom-oms -w
  563  kubectl logs -n telecom-oms deployments/order-api --tail=50 -f
  564  kubectl port-forward svc/order-api-service 8081:80 -n telecom-oms
  565  cat order_api.py
  566  kubectl delete -f telecom-oms.yaml -f oms-servicemonitor.yaml -f oms-alerts.yaml
  567  docker stop order-service && docker rm order-service
  568  docker ps
  569  kubectl get pods -n telecom-oms
