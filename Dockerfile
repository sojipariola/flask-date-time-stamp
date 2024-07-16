# Dockerfile
#FROM python:3.9-slim
#WORKDIR /app
#COPY requirements.txt requirements.txt
#RUN pip install -r requirements.txt
#COPY . .
#CMD ["python", "app.py"]

# Dockerfile
FROM python:3.9-alpine

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
