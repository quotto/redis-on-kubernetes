#!/bin/bash
set -e

if [[ -z ${SHARED_MASTER_INFO_FILE} ]]; then
    export SHARED_MASTER_INFO_FILE=/redis/share/master
fi

# masterで再起動された場合,Sentinelのフェイルオーバーを追い越してしまう可能性があるため
# 起動まで30秒待機（Sentinelのフェイルオーバー判断するまでの待機時間がデフォルト30秒）
echo "waiting for start in 30 seconds..."
sleep 30

if [[ $(hostname) =~ (.+)-([0-9]+)$ ]]; then
    podname=${BASH_REMATCH[1]}
    ordinal=${BASH_REMATCH[2]}
    if [[ ${ordinal} -eq 0 ]] && [[ ! -f ${SHARED_MASTER_INFO_FILE} ]]; then
        # マスターの場合は共有ストレージのファイルにIPアドレスを書き込む
        master_ip=$(hostname -i)
        echo "This is master, set own ip: ${master_ip}"
        echo ${master_ip} >> ${SHARED_MASTER_INFO_FILE}
    else
        # スレーブの場合はマスターのIPアドレスを指定してslaveofを設定
        master_ip=$(cat ${SHARED_MASTER_INFO_FILE})
        echo "This is slave, use master info file: ${master_ip}"
        echo "slaveof ${master_ip} 6379" >> ${REDIS_CONF}
    fi
    redis-server ${REDIS_CONF}
fi