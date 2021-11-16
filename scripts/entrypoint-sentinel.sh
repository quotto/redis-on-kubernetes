#!/bin/bash
set -e

if [[ -z ${SHARED_MASTER_INFO_FILE} ]]; then
    export SHARED_MASTER_INFO_FILE=/redis/share/master
fi

master_ip=""
if [[ ! -f ${SHARED_MASTER_INFO_FILE} ]]; then
    echo "master info file not found"
    exit 1
else
    master_ip=$(cat ${SHARED_MASTER_INFO_FILE})
    echo "sentinel monitor mymaster ${master_ip} 6379 2" >> ${REDIS_SENTINEL_CONF}
    redis-sentinel ${REDIS_SENTINEL_CONF}
fi