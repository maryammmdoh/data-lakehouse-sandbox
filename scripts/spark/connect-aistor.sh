#!/bin/bash
set -e

WAREHOUSE="${1:-lakehouse}"

export HOME=/tmp
export IVY_HOME=/tmp/.ivy2
export SPARK_LOCAL_DIRS=/tmp/spark-local

mkdir -p /tmp/.ivy2/cache /tmp/.ivy2/jars /tmp/spark-local
cd /tmp/spark-work

echo "Starting Spark Shell with AIStor warehouse: ${WAREHOUSE}"

/opt/spark/bin/spark-shell \
 --driver-java-options "-Duser.home=/tmp -Djline.history=/dev/null" \
 --conf "spark.sql.catalog.aistor.warehouse=${WAREHOUSE}" 
