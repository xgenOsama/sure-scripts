# Install Blackbox Exporter

```shell
sudo apt update && sudo apt install -y wget
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
tar -xvzf blackbox_exporter-0.25.0.linux-amd64
cd blackbox_exporter-0.25.0.linux-amd64
sudo mv blackbox_exporter /usr/local/bin/
blackbox_exporter --version
```

Create a Blackbox Exporter Service:

```shell
sudo nano /etc/systemd/system/blackbox-exporter.service
```

Add this config:

```ini
[Unit]
Description=Blackbox Exporter
After=network.target

[Service]
User=nobody
ExecStart=/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox_exporter/config.yml
Restart=always

[Install]
WantedBy=multi-user.target
```

```shell
sudo mkdir -p /etc/blackbox_exporter
sudo nano /etc/blackbox_exporter/config.yml
```

Put this config:

```yaml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      method: GET
      valid_http_versions: [ "HTTP/1.1", "HTTP/2" ]
      valid_status_codes: []  # Defaults to 2xx
      fail_if_ssl: false
      fail_if_not_ssl: false
      tls_config:
        insecure_skip_verify: true
```

```shell
sudo systemctl daemon-reload
sudo systemctl enable blackbox-exporter
sudo systemctl start blackbox-exporter
sudo systemctl status blackbox-exporter
```

Edit Prometheus config (`/etc/prometheus/prometheus.yml`):

```yaml
- job_name: 'blackbox'
  metrics_path: /probe
  params:
    module: [http_2xx]
  static_configs:
    - targets:
      - https://your-website.com
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: localhost:9115
```

```shell
sudo systemctl restart prometheus
```
