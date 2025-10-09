# Use a lightweight official Python 3.13 image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy only requirements first (for caching)
COPY requirements.txt .

# Install minimal system dependencies required by numpy/pandas/scikit-learn
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy remaining project files
COPY . .

# Expose Render port
EXPOSE 10000

# Run app with Gunicorn (Render will set $PORT)
CMD gunicorn --workers=4 --threads=2 --bind 0.0.0.0:$PORT app:app