# Install Alert Manager

```shell
wget https://github.com/prometheus/alertmanager/releases/download/v0.28.0/alertmanager-0.28.0.linux-amd64.tar.gz
tar -xvzf alertmanager-*.tar.gz
sudo mv alertmanager-*/alertmanager /usr/local/bin/
sudo mv alertmanager-*/amtool /usr/local/bin/
alertmanager --version
sudo mkdir -p /etc/alertmanager
sudo nano /etc/alertmanager/alertmanager.yml
```

Add this config:

```yaml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  receiver: 'email_notifications'

receivers:
- name: 'email_notifications'
  email_configs:
  - to: 'your-email@example.com'
    send_resolved: true
```

```shell
sudo chmod 644 /etc/alertmanager/alertmanager.yml
sudo nano /etc/systemd/system/alertmanager.service
```

Add this config:

```ini
[Unit]
Description=Alertmanager
Documentation=https://prometheus.io/docs/alerting/latest/alertmanager/
After=network.target

[Service]
User=alertmanager
Group=alertmanager
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --storage.path=/etc/alertmanager/data
Restart=always
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

```shell
sudo useradd --no-create-home --shell /bin/false alertmanager
sudo mkdir -p /etc/alertmanager//data
sudo chown -R alertmanager:alertmanager /etc/alertmanager/
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager
```

Edit Prometheus config (`/etc/prometheus/prometheus.yml`):

```yaml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 'localhost:9093'  # Point to the Alertmanager instance

rule_files:
  - "alert.rules"  # Path to your alert rule file
```

```shell
sudo systemctl restart prometheus
```
