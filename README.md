# README.md

## How to Build Time-Stamp Application

1. Clone the repository
   ```sh
   git clone https://github.com/sojipariola/my-flask-app.git
   cd my-flask-app

We'll create a simple HTTP service that returns the current timestamp and the We'll use Python with Flask to build the service, package it into a Docker image, and then write the necessary Kubernetes manifests for deployment, service, and ingress. We'll also provide detailed instructions for building and deploying the application, as well as configuration files for bootstrapping the testing environment.

Here’s a step-by-step guide to accomplishing this:

### Step 1: Build the Service

#### a. Create the Flask Application

Create a directory for your project and initialize a Flask application.

*Directory Structure:*

my-app/
├── app.py
├── Dockerfile
├── requirements.txt
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── prometheus/
│   ├── prometheus-deployment.yaml
│   └── prometheus-service.yaml
└── README.md


*app.py:*
python
from flask import Flask, jsonify
import socket
import datetime

app = Flask(__name__)

@app.route('/')
def index():
    hostname = socket.gethostname()
    timestamp = datetime.datetime.now().isoformat()
    return jsonify({
        'timestamp': timestamp,
        'hostname':

python
        'hostname': hostname
    })

if _name_ == '_main_':
    app.run(host='0.0.0.0', port=5000)


**requirements.txt:**

Flask==2.1.1


### Step 2: Package the Application into a Docker Image

**Dockerfile:**
dockerfile
# Use a minimal base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY app.py .

# Expose the port the app runs on
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]


### Step 3: Write the Kubernetes Deployment Files

**k8s/deployment.yaml:**
yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        ports:
        - containerPort: 5000


**kubernetes/service.yaml:**
yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer


**kubernetes/ingress.yaml:**
yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80


### Step 4: Provide a Git Repository

1. **Initialize a Git Repository:**
   sh
   git init
   

2. **Add Files and Commit:**
   sh
   git add .
   git commit -m "Initial commit"
   

3. **Push to a Remote Repository:**
   Create a repository on a platform like GitHub and push your local repository to the remote repository.
   sh
   git remote add origin <REMOTE_URL>
   git push -u origin main
   OR
   git remote set-url origin <REMOTE_URL>
   git remote -v

   https://github.com/sojipariola/new-repo.git
   https://github.com/acepeakgl/new-repo.git
   https://github.com/blessedspring/new-repo.git

FOR REMOTE
git config --global --list 
git config --global user.name "Olusoji"
git config --global user.email "ex@mail.com"


git config --list
git config user.name "Your Name"
git config user.email "your_email@example.com"


### Step 5: Detailed Instructions

**README.md:**
markdown
# My App

## Description
A simple HTTP service that returns the current timestamp and the hostname.

## Build the Application

1. *Build the Docker image:*
   sh
   docker build -t my-app:latest .
   

2. *Run the Docker container:*
   sh
   docker run -p 5000:5000 my-app:latest
   

## Deploy the Application

1. *Setup Kubernetes (using Minikube as an example):*
   sh
   minikube start
   

2. *Deploy the application:*
   sh
   kubectl apply -f kubernetes/deployment.yaml
   kubectl apply -f kubernetes/service.yaml
   kubectl apply -f kubernetes/ingress.yaml
   

3. **Add the ingress host to /etc/hosts:**
   sh
   echo "$(minikube ip) myapp.local" | sudo tee -a /etc/hosts
   

4. *Access the application:*
   Open a browser and navigate to http://myapp.local.

## Configuration for Testing Environment

Include Minikube or Kind configurations if necessary.

### Stretch Goals

*a. Monitoring/Metrics:*
Integrate Prometheus and Grafana.

*b. Make the Image Small:*
Use python:3.9-alpine as the base image.

*Monitoring Example:*
1. Add Prometheus client to requirements.txt:
   
   prometheus_client==0.14.1
   
   
2. Modify app.py to include metrics:
   python
   from prometheus_client import start_http_server, Counter

   REQUEST_COUNT = Counter('request_count', 'Total number of requests')

   @app.route('/')
   def index():
       REQUEST_COUNT.inc()
       hostname = socket.gethostname()
       timestamp = datetime.datetime.now().isoformat()
       return jsonify({
           'timestamp': timestamp,
           'hostname': hostname
       })

   if __name__ == '__main__':
       start_http_server(8000)
       app.run(host='0.0.0.0', port=5000)
   

### Conclusion
This guide provides the steps needed to build, package, and deploy a simple HTTP service in Kubernetes. The additional configuration files and instructions ensure that anyone can set up and test the environment easily. 

The stretch goals offer a way to further enhance the service with monitoring and optimizations.


