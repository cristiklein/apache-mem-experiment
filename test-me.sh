#!/bin/sh
set -e

docker rm -f apache-obama || true
docker build -t apache-obama .
docker run -d --name apache-obama apache-obama

docker stats apache-obama > stats.log &
PID_STATS=$!

SERVER_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' apache-obama`
echo "Server IP: $SERVER_IP"

docker pull cklein/httpmon

docker run --rm cklein/httpmon --url https://$SERVER_IP/Barack_Obama.html --concurrency 2500 --thinktime 10 &
PID_HTTPMON=$!
sleep 30
kill $PID_HTTPMON

docker run --rm cklein/httpmon --url https://$SERVER_IP/Barack_Obama.html --concurrency 10 --thinktime 10 &
PID_HTTPMON=$!
sleep 30
kill $PID_HTTPMON

kill $PID_STATS

wait
cat -t stats.log

