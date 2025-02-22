# Install and Configure Node Exporter

```shell
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-*.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin
rm -r node_exporter-1.5.0.linux-amd64*
node_exporter
sudo useradd -rs /bin/false node_exporter
sudo vi /etc/systemd/system/node_exporter.service
```

Put this content into the file:

```ini
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

```shell
sudo systemctl enable node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter
```

Configure Prometheus to monitor client nodes:

```shell
sudo vi /etc/prometheus/prometheus.yml
```

Add the client to monitor:

```yaml
- job_name: "remote_collector"
  scrape_interval: 10s
  static_configs:
    - targets: ["remote_addr:9100"]
```
