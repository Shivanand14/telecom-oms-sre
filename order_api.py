import time
import random
from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# SRE Custom Metrics
ORDER_COUNT = Counter('telecom_orders_received_total', 'Total number of porting orders received', ['status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP request latency', ['endpoint'])

@app.route('/api/v1/order', methods=['POST'])
def create_order():
    start_time = time.time()
    data = request.json or {}
    phone_number = data.get('phone_number', 'unknown')
    
    # Simulate a small percentage of automated bad requests (400s) or gateway drops (500s)
    fail_chance = random.random()
    
    if fail_chance < 0.05:  # 5% intentional intermittent internal server failures
        ORDER_COUNT.labels(status='500').inc()
        REQUEST_LATENCY.labels(endpoint='/order').observe(time.time() - start_time)
        return jsonify({"error": "Internal Telecom Gateway Timeout"}), 500
        
    # Simulate processing time
    time.sleep(random.uniform(0.05, 0.2))
    
    ORDER_COUNT.labels(status='202').inc()
    REQUEST_LATENCY.labels(endpoint='/order').observe(time.time() - start_time)
    return jsonify({"status": "Accepted", "tn": phone_number, "workflow": "LNP_NPAC_Submit"}), 202

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
