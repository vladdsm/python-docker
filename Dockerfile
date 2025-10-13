FROM jupyter/base-notebook:latest

# Set working directory
WORKDIR /home/jovyan

# Copy and install Python packages
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install system packages
USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
USER jovyan

EXPOSE 8888