#!/bin/sh
set -e

ALIAS_NAME="aistor"
AISTOR_ENDPOINT="http://aistor-minio:9000"
AISTOR_USER="minio"
AISTOR_PASSWORD="minio123"
WAREHOUSE="${WAREHOUSE_NAME:-lakehouse}"

echo "Waiting for AIStor to be ready..."

until mc alias set ${ALIAS_NAME} ${AISTOR_ENDPOINT} ${AISTOR_USER} ${AISTOR_PASSWORD}; do
  echo "AIStor is not ready yet. Retrying in 3 seconds..."
  sleep 3
done

echo "AIStor is ready."
echo "Checking warehouse: ${WAREHOUSE}"

if mc table warehouse create ${ALIAS_NAME} ${WAREHOUSE} >/dev/null 2>&1; then
  echo "Warehouse created: ${WAREHOUSE}"
else
  echo "Warehouse already exists: ${WAREHOUSE}"
fi

echo "AIStor warehouse initialization finished."
echo "aistor-mc container will stay running."

tail -f /dev/null
