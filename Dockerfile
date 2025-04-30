FROM python:3.11-slim

WORKDIR /app

# Install dependencies including git
RUN apt-get update && apt-get install -y libpq-dev gcc git && rm -rf /var/lib/apt/lists/*

# Clone the repository
ARG REPO_URL=https://github.com/Sanjibkarki/E-Commerce-Website.git
ARG BRANCH=master # Or specify a different branch/tag if needed
RUN git clone --branch ${BRANCH} --single-branch ${REPO_URL} .

# Install Python dependencies from the cloned repo
RUN pip install -r requirements.txt

# COPY . . # Removed, code is cloned now

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port gunicorn will run on
EXPOSE 8000

# Run the production server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "e_commerce.wsgi:application"]
