# Use the official Apache Airflow image with Python 3.11
FROM apache/airflow:2.7.1-python3.11

USER root

# Install Git and other system dependencies
RUN apt-get update && \
    apt-get install -y git gcc python3-dev openjdk-11-jdk && \
    apt-get clean

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

USER airflow

# Install Apache Airflow and providers
RUN pip install apache-airflow apache-airflow-providers-apache-spark pyspark pandas

# Install additional Airflow dependencies
RUN pip install apache-airflow[gcp] google-cloud-storage psycopg2-binary pytz==2023.3

# Install Cloud SQL connector, pg8000, and configparser
#RUN pip install git+https://github.com/GoogleCloudPlatform/cloud-sql-python-connector pg8000 configparser

# Install a specific version of cryptography that is compatible
RUN pip install setuptools pyarrow

RUN pip install aiohttp==3.9.5 cryptography==42.0.8 Requests==2.32.3 google-auth==2.30.

RUN pip install "cloud-sql-python-connector[pymysql]" 
RUN pip install "cloud-sql-python-connector[pg8000]"
RUN pip install "cloud-sql-python-connector[asyncpg]"
RUN pip install "cloud-sql-python-connector[pytds]"

# Optionally install other dependencies like openpyxl and pyspark-excel if needed
# RUN pip install openpyxl pyspark-excel

# Copy DAGs to the container
COPY dags /opt/airflow/dags

# Copy the configuration file
COPY config.ini /opt/airflow/config.ini

# Copy Google Cloud credentials
COPY airflow-service-acc.json /opt/airflow/airflow-service-acc.json