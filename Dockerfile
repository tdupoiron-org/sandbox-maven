# Multi-stage Dockerfile with old base images for Dependabot testing

# Stage 1: Build stage with old nginx
FROM nginx:1.19.0 AS webserver
COPY ./html /usr/share/nginx/html

# Stage 2: Redis old version
FROM redis:6.0.0 AS cache
EXPOSE 6379

# Stage 3: PostgreSQL old version
FROM postgres:18.1 AS database
ENV POSTGRES_DB=testdb
ENV POSTGRES_USER=testuser
ENV POSTGRES_PASSWORD=testpass
EXPOSE 5432

# Stage 4: Final application stage
FROM python:3.8.0
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY sandbox-maven/src /app/src

# Expose application port
EXPOSE 8080

CMD ["python", "-m", "http.server", "8080"]
