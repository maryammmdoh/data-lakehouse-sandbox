#!/bin/bash
set -e

WAREHOUSE="$1"

if [ -z "$WAREHOUSE" ]; then
  echo "Usage: ./scripts/trino/switch-warehouse.sh <warehouse-name>"
  echo "Example: ./scripts/trino/switch-warehouse.sh api-lakehouse"
  echo "Example: ./scripts/trino/switch-warehouse.sh jar-lakehouse"
  exit 1
fi

CATALOG_FILE="config/trino-config/catalog/aistor.properties"

if [ ! -f "$CATALOG_FILE" ]; then
  echo "Catalog file not found: $CATALOG_FILE"
  exit 1
fi

echo "Switching Trino AIStor warehouse to: $WAREHOUSE"

sed -i "s/^iceberg.rest-catalog.warehouse=.*/iceberg.rest-catalog.warehouse=${WAREHOUSE}/" "$CATALOG_FILE"

echo "Updated catalog file:"
grep "iceberg.rest-catalog.warehouse" "$CATALOG_FILE"

echo "Recreating Trino..."
docker compose up -d --force-recreate trino

echo "Done. Trino now points to warehouse: $WAREHOUSE"
