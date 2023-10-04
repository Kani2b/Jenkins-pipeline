FROM python:3.9-alpine

# Set the working directory in the container
WORKDIR /flask_app

# Copy the requirements file into the container at /flask_app
COPY requirements.txt .

# Install the required packages, including pytest and markupsafe
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install pytest \
    && pip install markupsafe==2.0.1

# Copy the application code into the container at /flask_app
COPY app .

# Expose the port that the app will run on
EXPOSE 5000

# Define the command to run the application
CMD ["python", "app.py"]

