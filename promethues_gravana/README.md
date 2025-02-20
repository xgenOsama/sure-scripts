```shell
# this demo is a clone of 
https://www.linode.com/docs/guides/how-to-install-prometheus-and-grafana-on-ubuntu/
# Use wget to download Prometheus to the monitoring server. 
wget https://github.com/prometheus/prometheus/releases/download/v2.37.6/prometheus-2.37.6.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
rm prometheus-*.tar.gz
sudo mkdir /etc/prometheus /var/lib/prometheus
cd prometheus-2.37.6.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mv consoles/ console_libraries/ /etc/prometheus/
prometheus --version

#  Configure Prometheus as a Service
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus
sudo vi /etc/systemd/system/prometheus.service
#### put this content into this file
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle \
    --log.level=info

[Install]
WantedBy=multi-user.target
###############################################

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus

# now open server at http://server_ip:9090


################ install gravana 
#  Install and Configure Node Exporter on the Client
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

tar xvfz node_exporter-*.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin
rm -r node_exporter-1.5.0.linux-amd64*
node_exporter
sudo useradd -rs /bin/false node_exporter
sudo vi /etc/systemd/system/node_exporter.service
# put this content into the file 

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
#####################################
sudo systemctl enable node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter

# Configure Prometheus to Monitor Client Nodes
sudo vi /etc/prometheus/prometheus.yml

################################ add client to monitor 
- job_name: "remote_collector"
  scrape_interval: 10s
  static_configs:
    - targets: ["remote_addr:9100"]
#####################################


#### add gravana  Install and Deploy the Grafana Serve
sudo apt-get install -y apt-transport-https software-properties-common
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server.service


# open dashboard at http://localhost:3000/login
user : admin password: admin

# install blackbox 
sudo apt update && sudo apt install -y wget
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
tar -xvzf blackbox_exporter-0.25.0.linux-amd64
cd blackbox_exporter-0.25.0.linux-amd64
sudo mv blackbox_exporter /usr/local/bin/
blackbox_exporter --version
Create a Blackbox Exporter Service
sudo nano /etc/systemd/system/blackbox-exporter.service
##################### add this config ####################
[Unit]
Description=Blackbox Exporter
After=network.target

[Service]
User=nobody
ExecStart=/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox_exporter/config.yml
Restart=always

[Install]
WantedBy=multi-user.target
#########################################################
sudo mkdir -p /etc/blackbox_exporter
sudo nano /etc/blackbox_exporter/config.yml
################### put this config #####################
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
###############################################################
sudo systemctl daemon-reload
sudo systemctl enable blackbox-exporter
sudo systemctl start blackbox-exporter
sudo systemctl status blackbox-exporter

# Edit Prometheus config (/etc/prometheus/prometheus.yml):
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

sudo systemctl restart prometheus



# install alert manager 
wget https://github.com/prometheus/alertmanager/releases/download/v0.28.0/alertmanager-0.28.0.linux-amd64.tar.gz
tar -xvzf alertmanager-*.tar.gz
sudo mv alertmanager-*/alertmanager /usr/local/bin/
sudo mv alertmanager-*/amtool /usr/local/bin/
alertmanager --version
sudo mkdir -p /etc/alertmanager
sudo nano /etc/alertmanager/alertmanager.yml
###############################################
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

# Optional: More configuration options for Slack, Opsgenie, etc.
#########################################################################
sudo chmod 644 /etc/alertmanager/alertmanager.yml
sudo nano /etc/systemd/system/alertmanager.service
##########################################################
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
############################################################

sudo useradd --no-create-home --shell /bin/false alertmanager
sudo mkdir -p /etc/alertmanager//data

sudo chown -R alertmanager:alertmanager /etc/alertmanager/
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

sudo nano /etc/prometheus/prometheus.yml
#######################################################################
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 'localhost:9093'  # Point to the Alertmanager instance

rule_files:
  - "alert.rules"  # Path to your alert rule file
#######################################################################
sudo systemctl restart prometheus

```