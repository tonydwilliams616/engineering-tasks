# =============================
# Stage 1: Build environment
# =============================

# Use the official Python image
FROM python:3.11-slim As builder

# Set the working directory
WORKDIR /app

# Copy dependency file
COPY  requirements.txt .

# Install dependencies into a temp directory
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt

# Copy app code
COPY . .

# =============================
# Stage 1: Runtime environment
# =============================
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy installed Python packages from the builder
COPY --from=builder /install /usr/local

# Copy application code
COPY --from=builder /app /app

# Expose the port Flask runs on
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]