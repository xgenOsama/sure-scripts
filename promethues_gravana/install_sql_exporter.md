# Install SQL Exporter

## Prerequisites
- SQL database installed and running

## Steps

1. Download the SQL Exporter:
    ```bash
    wget https://github.com/free/sql_exporter/releases/download/v0.5.0/sql_exporter-v0.5.0.linux-amd64.tar.gz
    ```

2. Extract the downloaded file:
    ```bash
    tar -xzf sql_exporter-v0.5.0.linux-amd64.tar.gz
    ```

3. Move the binary to `/usr/local/bin`:
    ```bash
    sudo mv sql_exporter /usr/local/bin/
    ```

4. Create a systemd service file for SQL Exporter:
    ```bash
    sudo nano /etc/systemd/system/sql_exporter.service
    ```

    Add the following content:
    ```ini
    [Unit]
    Description=SQL Exporter
    After=network.target

    [Service]
    User=nobody
    ExecStart=/usr/local/bin/sql_exporter

    [Install]
    WantedBy=default.target
    ```

5. Reload systemd and start the SQL Exporter service:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl start sql_exporter
    sudo systemctl enable sql_exporter
    ```

6. Verify that the SQL Exporter is running:
    ```bash
    sudo systemctl status sql_exporter
    ```

7. Access the SQL Exporter metrics at `http://localhost:9399/metrics`.

## README

This guide provides steps to install and configure the SQL Exporter for Prometheus monitoring. Follow the steps to download, extract, and set up the exporter as a systemd service.
