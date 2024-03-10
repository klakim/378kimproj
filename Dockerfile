# Chat GPT helped Use the official Python base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Install Quarto
RUN wget -qO- "https://github.com/quarto-dev/quarto-cli/releases/download/v0.9.534/quarto-0.9.534-linux-amd64.deb" > quarto.deb && \
    dpkg -i quarto.deb && \
    rm quarto.deb

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run your FastAPI application using Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
