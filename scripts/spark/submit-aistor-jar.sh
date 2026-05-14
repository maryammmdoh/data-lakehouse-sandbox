#!/bin/bash
set -e

WAREHOUSE="${1:-lakehouse}"
MAIN_CLASS="$2"
JAR_FILE="$3"

if [ -z "$MAIN_CLASS" ] || [ -z "$JAR_FILE" ]; then
  echo "Usage:"
  echo "  submit-aistor-jar.sh <warehouse> <main-class> <jar-file> [app-args...]"
  echo ""
  echo "Example:"
  echo "  submit-aistor-jar.sh jar-lakehouse io.conduktor.demos.OrdersCsvJob /opt/spark/jobs/jars/orders-csv-job.jar /opt/spark/input-data/orders_5k.csv aistor.bronze.orders_from_jar"
  exit 1
fi

shift 3

export HOME=/tmp
export IVY_HOME=/tmp/.ivy2
export SPARK_LOCAL_DIRS=/tmp/spark-local

cd /tmp/spark-work

echo "Submitting JAR to AIStor"
echo "Warehouse: ${WAREHOUSE}"
echo "Main class: ${MAIN_CLASS}"
echo "JAR file: ${JAR_FILE}"
echo "App args: $@"

/opt/spark/bin/spark-submit \
  --class "${MAIN_CLASS}" \
  --driver-java-options "-Duser.home=/tmp" \
  --conf "spark.sql.catalog.aistor.warehouse=${WAREHOUSE}" \
  "${JAR_FILE}" "$@"
