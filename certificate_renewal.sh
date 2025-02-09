#!/bin/bash

# Configurations
API_KEY="LiZbKiczW4Eu1HtD7Cxsu7y1ewZkT-Q0AU8JZu09"
EMAIL="your-email@example.com"
ZONE_ID="b220dd40f7f4fbcc43bbdbd717fbf6d2"
CERT_PATH="/etc/cloudflare/moovstore.org.pem"
EXPIRY_THRESHOLD=30  # Days before expiry to renew

# Function to check certificate expiry
check_certificate_expiry() {
    if [ ! -f "$CERT_PATH" ]; then
        echo "Certificate file not found. Renewal needed."
        return 1
    fi

    EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_PATH" | cut -d= -f2)
    EXPIRY_TIMESTAMP=$(date -d "$EXPIRY_DATE" +%s)
    CURRENT_TIMESTAMP=$(date +%s)
    DAYS_LEFT=$(( (EXPIRY_TIMESTAMP - CURRENT_TIMESTAMP) / 86400 ))

    echo "Certificate expires in $DAYS_LEFT days."

    if [ "$DAYS_LEFT" -le "$EXPIRY_THRESHOLD" ]; then
        echo "Certificate is about to expire. Renewal required."
        return 1
    else
        echo "Certificate is still valid. No renewal needed."
        return 0
    fi
}

# Function to renew certificate
renew_certificate() {
    echo "Renewing Cloudflare Origin CA Certificate..."

    CERT_RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/origin_ca/certificate" \
        -H "X-Auth-Email: ${EMAIL}" \
        -H "X-Auth-Key: ${API_KEY}" \
        -H "Content-Type: application/json" \
        --data '{
            "hostnames": ["moovstore.org", "*.moovstore.org"],
            "request_type": "origin-rsa",
            "key_type": "rsa",
            "validity_days": 365
        }')

    CERTIFICATE=$(echo "$CERT_RESPONSE" | jq -r '.result.certificate')
    PRIVATE_KEY=$(echo "$CERT_RESPONSE" | jq -r '.result.private_key')

    if [ -z "$CERTIFICATE" ] || [ -z "$PRIVATE_KEY" ]; then
        echo "Failed to obtain a new certificate."
        exit 1
    fi

    echo "$CERTIFICATE" > /etc/cloudflare/moovstore.org.pem
    echo "$PRIVATE_KEY" > /etc/cloudflare/moovstore.org.key

    echo "Certificate renewed successfully. Restarting Nginx..."
    systemctl reload nginx
}

# Main script execution
check_certificate_expiry || renew_certificate
