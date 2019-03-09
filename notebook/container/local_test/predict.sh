#!/bin/bash

payload=$1
content=${2:-text/csv}

curl --connect-timeout 5 \
     --max-time 10 \
     --retry 5 \
     --retry-connrefuse \
     --data-binary @${payload} \
     -H "Content-Type: ${content}" \
     -v http://localhost:8080/invocations