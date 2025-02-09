```shell
# Install all the dependencies required for the build and compilation process with the following command:
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt update

sudo apt-get install bison build-essential ca-certificates curl dh-autoreconf doxygen \
  flex gawk git iputils-ping libcurl4-gnutls-dev libexpat1-dev libgeoip-dev liblmdb-dev \
  libpcre3-dev libpcre2-dev libssl-dev libtool libxml2 libxml2-dev libyajl-dev locales \
  lua5.3-dev pkg-config wget zlib1g-dev zlib1g-dev libxslt1-dev libgd-dev

# Ensure that git is installed:
sudo apt install git

# Clone the ModSecurity Github repository from the /opt directory:
cd /opt && sudo git clone https://github.com/SpiderLabs/ModSecurity
cd ModSecurity
# Run the following git commands to initialize and update the submodule:
sudo git submodule init
sudo git submodule update
# Run the build.sh script:
sudo ./build.sh
# Run the configure file, which is responsible for getting all the dependencies for the build process:
sudo ./configure
# Run the make command to build ModSecurity:
sudo make
# After the build process is complete, install ModSecurity by running the following command:
sudo make install
```
```shell
# Downloading ModSecurity-Nginx Connector
## Before compiling the ModSecurity module, clone the Nginx-connector from the /opt directory:
cd /opt && sudo git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
# Building the ModSecurity Module For Nginx
# Enumerate the version of Nginx you have installed:
nginx -v
nginx version: nginx/1.24.0 (Ubuntu)
# Download the exact version of Nginx running on your system into the /opt directory:
cd /opt && sudo wget http://nginx.org/download/nginx-1.24.0.tar.gz
# Extract the tarball:
sudo tar -xvzmf nginx-1.24.0.tar.gz
cd nginx-1.24.0
# Display the configure arguments used for your version of Nginx:
nginx -V
nginx version: nginx/1.24.0 (Ubuntu)
built with OpenSSL 3.0.13 30 Jan 2024
TLS SNI support enabled
configure arguments: --with-cc-opt='-g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/nginx-Vwk9BR/nginx-1.24.0=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -mbranch-protection=standard -fdebug-prefix-map=/build/nginx-Vwk9BR/nginx-1.24.0=/usr/src/nginx-1.24.0-2ubuntu7.1 -fPIC -Wdate-time -D_FORTIFY_SOURCE=3' --with-ld-opt='-Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=stderr --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-compat --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_sub_module --with-mail_ssl_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_perl_module=dynamic --with-http_xslt_module=dynamic --with-mail=dynamic --with-stream=dynamic --with-stream_geoip_module=dynamic
# To compile the Modsecurity module, copy all of the arguments following configure arguments: from your output of the above command and paste them in place of <Configure Arguments> in the following command:
sudo ./configure --add-dynamic-module=../ModSecurity-nginx  --with-cc-opt='-g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/nginx-Vwk9BR/nginx-1.24.0=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -mbranch-protection=standard -fdebug-prefix-map=/build/nginx-Vwk9BR/nginx-1.24.0=/usr/src/nginx-1.24.0-2ubuntu7.1 -fPIC -Wdate-time -D_FORTIFY_SOURCE=3' --with-ld-opt='-Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=stderr --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-compat --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_sub_module --with-mail_ssl_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_perl_module=dynamic --with-http_xslt_module=dynamic --with-mail=dynamic --with-stream=dynamic --with-stream_geoip_module=dynamic
# Build the modules with the following command:
sudo make modules
# Create a directory for the Modsecurity module in your system’s Nginx configuration folder:
sudo apt install libperl-dev
sudo mkdir /etc/nginx/modules
# Copy the compiled Modsecurity module into your Nginx configuration folder:
sudo cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
# Open the /etc/nginx/nginx.conf file with a text editor such a vim and add the following line:
load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;
```
```shell
# Setting Up OWASP-CRS
# The OWASP ModSecurity Core Rule Set (CRS) is a set of generic attack detection rules for use with ModSecurity
# or compatible web application firewalls. The CRS aims to protect web applications from a wide range of attacks,
# including the OWASP Top Ten, with a minimum of false alerts. The CRS provides protection against many common attack categories, including SQL Injection, Cross Site Scripting, and Local File Inclusion.

# First, delete the current rule set that comes prepackaged with ModSecurity by running the following command:
sudo rm -rf /usr/share/modsecurity-crs
# Clone the OWASP-CRS GitHub repository into the /usr/share/modsecurity-crs directory:
sudo git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs
# Rename the crs-setup.conf.example to crs-setup.conf
sudo mv /usr/local/modsecurity-crs/crs-setup.conf.example /usr/local/modsecurity-crs/crs-setup.conf
# Rename the default request exclusion rule file:
sudo mv /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
# Configuring Modsecurity
# Start by creating a ModSecurity directory in the /etc/nginx/ directory:
sudo mkdir -p /etc/nginx/modsec
# Copy over the unicode mapping file and the ModSecurity configuration file from your cloned ModSecurity GitHub repository:
sudo cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec
sudo cp /opt/ModSecurity/modsecurity.conf-recommended /etc/nginx/modsec
# Remove the -recommended extension from the ModSecurity configuration filename with the following command:
 sudo cp /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
# With a text editor such as vim, open /etc/nginx/modsec/modsecurity.conf and change the value for SecRuleEngine to On:
SecRuleEngine On
# Create a new configuration file called main.conf under the /etc/nginx/modsec directory:
sudo touch /etc/nginx/modsec/main.conf
# Open /etc/nginx/modsec/main.conf with a text editor such as vim and specify the rules and the Modsecurity configuration file for Nginx by inserting following lines:
Include /etc/nginx/modsec/modsecurity.conf
Include /usr/local/modsecurity-crs/crs-setup.conf
Include /usr/local/modsecurity-crs/rules/*.conf
# Configuring Nginx
# Open the /etc/nginx/sites-available/default with a text editor such as vim and insert the following lines in your server block:
modsecurity on;
modsecurity_rules_file /etc/nginx/modsec/main.conf;

```