# ChatGPT helped, as my website runs off of a FastAPI, not from vertiver
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
# This includes your FastAPI app, requirements file, and model file
COPY . /app

# Install any needed packages specified in requirements.txt
# Ensure this file includes fastapi, uvicorn, joblib, pandas, pydantic, etc.
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run your FastAPI application using Uvicorn
# Change 'app:app' based on your Python file and FastAPI instance names
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
