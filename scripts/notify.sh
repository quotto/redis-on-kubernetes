#!/bin/bash

echo $1 >> /redis/event.log
echo $2 >> /redis/event.log
# +switch-masterが発生したら詳細情報から切替先のマスターIPを抽出して共有ストレージのファイルを上書きする
if [[ $1 == "+switch-master" ]]; then
    if [[ $2 =~ .+[[:space:]][0-9]+\.[0-9]+\.[0-9]+\.[0-9]+[[:space:]][0-9]+[[:space:]]([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
        master_ip=${BASH_REMATCH[1]}
        echo "Over write master ip on shared file: ${master_ip}" >> /redis/event.log
        echo  ${master_ip} > ${SHARED_MASTER_INFO_FILE}
    fi
fi