FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

# Set the working directory
WORKDIR /app

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the source code into the container
COPY src/ ./src
COPY ultralytics/ ./ultralytics
COPY datasets/ ./datasets
COPY weights/ ./weights
COPY tempDir/ ./tempDir

# Command to run the application
CMD ["python3", "src/ui.py"]