# Install Redis Exporter

## Prerequisites
- Redis server installed and running

## Steps

1. Download the Redis Exporter:
    ```bash
    wget https://github.com/oliver006/redis_exporter/releases/download/v1.29.0/redis_exporter-v1.29.0.linux-amd64.tar.gz
    ```

2. Extract the downloaded file:
    ```bash
    tar -xzf redis_exporter-v1.29.0.linux-amd64.tar.gz
    ```

3. Move the binary to `/usr/local/bin`:
    ```bash
    sudo mv redis_exporter /usr/local/bin/
    ```

4. Create a systemd service file for Redis Exporter:
    ```bash
    sudo nano /etc/systemd/system/redis_exporter.service
    ```

    Add the following content:
    ```ini
    [Unit]
    Description=Redis Exporter
    After=network.target

    [Service]
    User=nobody
    ExecStart=/usr/local/bin/redis_exporter

    [Install]
    WantedBy=default.target
    ```

5. Reload systemd and start the Redis Exporter service:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl start redis_exporter
    sudo systemctl enable redis_exporter
    ```

6. Verify that the Redis Exporter is running:
    ```bash
    sudo systemctl status redis_exporter
    ```

7. Access the Redis Exporter metrics at `http://localhost:9121/metrics`.
