#!/bin/bash
set -e

NAMESPACE="telecom-oms"
API_URL="http://localhost:8080/api/v1/order" # Port-forwarded endpoint

echo "📡 [SRE] Starting Telecom OMS Resiliency Scenario..."

# 1. Compile docker image locally into cluster context
echo "📦 Building project microservice..."
docker build -f Dockerfile.api -t order-api:local .

# 2. Deploy to local K8s
echo "☸️  Applying K8s manifests..."
kubectl apply -f telecom-oms.yaml

echo "⏳ Waiting for pods to initialize..."
kubectl wait --for=condition=ready pod -l app=order-api -n $NAMESPACE --timeout=60s

# Background Port Forwarding for Testing
kubectl port-forward svc/order-api-service 8080:80 -n $NAMESPACE > /dev/null 2>&1 &
PF_PID=$!
trap "kill $PF_PID" EXIT

sleep 3

echo "📈 Simulating background traffic flow (LNP submissions)..."
for i in {1..50}; do
  curl -s -X POST $API_URL \
    -H "Content-Type: application/json" \
    -d "{\"phone_number\": \"+1-202-555-01${i}\"}" > /dev/null &
done

echo "💥 Injecting Telecom Chaos: Deleting State Database..."
# Delete the state container mapping out processing items
kubectl delete pod cache-db-0 -n $NAMESPACE --grace-period=0

echo "⏳ Simulating Network Saturation / Cascade Congestion..."
# Artificially modify api replicas scale down under continuous load
kubectl scale deployment order-api --replicas=1 -n $NAMESPACE

sleep 10
echo "📊 Scale restored. Checking self-healing capabilities..."
kubectl scale deployment order-api --replicas=2 -n $NAMESPACE

echo "✅ Chaos run complete. Evaluate your Grafana dashboard metrics."
