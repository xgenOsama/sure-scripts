# Install MySQL Exporter

## Prerequisites
- MySQL server installed and running

## Steps

1. Download the MySQL Exporter:
    ```bash
    wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz
    ```

2. Extract the downloaded file:
    ```bash
    tar -xzf mysqld_exporter-0.12.1.linux-amd64.tar.gz
    ```

3. Move the binary to `/usr/local/bin`:
    ```bash
    sudo mv mysqld_exporter /usr/local/bin/
    ```

4. Create a systemd service file for MySQL Exporter:
    ```bash
    sudo nano /etc/systemd/system/mysqld_exporter.service
    ```

    Add the following content:
    ```ini
    [Unit]
    Description=MySQL Exporter
    After=network.target

    [Service]
    User=nobody
    ExecStart=/usr/local/bin/mysqld_exporter

    [Install]
    WantedBy=default.target
    ```

5. Reload systemd and start the MySQL Exporter service:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl start mysqld_exporter
    sudo systemctl enable mysqld_exporter
    ```

6. Verify that the MySQL Exporter is running:
    ```bash
    sudo systemctl status mysqld_exporter
    ```

7. Access the MySQL Exporter metrics at `http://localhost:9104/metrics`.

## README

This guide provides steps to install and configure the MySQL Exporter for Prometheus monitoring. Follow the steps to download, extract, and set up the exporter as a systemd service.
