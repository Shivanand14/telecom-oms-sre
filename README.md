# Neustar Order Management System (OMS) - Cloud Native Telecom Showcase

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
