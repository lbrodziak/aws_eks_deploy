# Use a lightweight Python base image
FROM python:3.11-slim-buster

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt requirements.txt

# Install dependencies
RUN pip install -r requirements.txt

# Copy the app files
COPY . .

# Expose the port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
