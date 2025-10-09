# Use a lightweight official Python 3.13 image
FROM python:3.13-slim

# Set working directory inside container
WORKDIR /app

# Copy only requirements first (for caching)
COPY requirements.txt .

# Install system dependencies required for numpy/scikit-learn/pandas
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    gfortran \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the application files
COPY . .

# Expose port (Render uses $PORT automatically)
EXPOSE 10000

# Command to start the app using Gunicorn
CMD gunicorn --workers=4 --threads=2 --bind 0.0.0.0:$PORT app:app