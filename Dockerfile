# Use official Python 3.13 base image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy project files into the container
COPY . /app

# Install system dependencies (if needed by pandas/numpy/scikit-learn)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install Python dependencies
RUN pip install flask pandas scikit-learn gunicorn

# Expose port 10000 (Render expects web services to listen on $PORT)
EXPOSE 10000

# Command to run the app with Gunicorn
# Render automatically sets the PORT environment variable
CMD gunicorn --bind 0.0.0.0:$PORT app:app