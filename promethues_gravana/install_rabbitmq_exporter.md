# Install RabbitMQ Exporter

## Prerequisites
- RabbitMQ server installed and running

## Steps

1. Download the RabbitMQ Exporter:
    ```bash
    wget https://github.com/kbudde/rabbitmq_exporter/releases/download/v0.29.0/rabbitmq_exporter-0.29.0.linux-amd64.tar.gz
    ```

2. Extract the downloaded file:
    ```bash
    tar -xzf rabbitmq_exporter-0.29.0.linux-amd64.tar.gz
    ```

3. Move the binary to `/usr/local/bin`:
    ```bash
    sudo mv rabbitmq_exporter /usr/local/bin/
    ```

4. Create a systemd service file for RabbitMQ Exporter:
    ```bash
    sudo nano /etc/systemd/system/rabbitmq_exporter.service
    ```

    Add the following content:
    ```ini
    [Unit]
    Description=RabbitMQ Exporter
    After=network.target

    [Service]
    User=nobody
    ExecStart=/usr/local/bin/rabbitmq_exporter

    [Install]
    WantedBy=default.target
    ```

5. Reload systemd and start the RabbitMQ Exporter service:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl start rabbitmq_exporter
    sudo systemctl enable rabbitmq_exporter
    ```

6. Verify that the RabbitMQ Exporter is running:
    ```bash
    sudo systemctl status rabbitmq_exporter
    ```

7. Access the RabbitMQ Exporter metrics at `http://localhost:9419/metrics`.

## README

This guide provides steps to install and configure the RabbitMQ Exporter for Prometheus monitoring. Follow the steps to download, extract, and set up the exporter as a systemd service.
