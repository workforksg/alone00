#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh
source ${ABSDIR}/switch.sh

IDLE_PORT=$(find_idle_port)

echo "> health 체크 스타트"
echo "> IDLE_PORT: $IDLE_PORT"
echo "> curl -s http://localhost:$IDLE_PORT/profile"
sleep 10

for RETRY_COUNT in {1..10}
do
  RESPONSE=$(curl -s http://localhost:${IDLE_PORT}/profile)
  UP_COUNT=$(echo ${RESPONSE} | grep 'real' | wc -1)

  if [ ${UP_COUNT} -ge 1 ]
  then # $up_count >= 1 ("리얼 문자열이 있는지 검증"
    echo "> 헬스 체크 성공"
    switch_proxy
    break
  else
    echo "> 헬스체크의 응답을 알 수 없거나 혹은 실행 상태가 아닙니다"
    echo "> 헬스 체크 : ${RESPONSE}"
  fi

  if [ ${RETRY_COUNT} -eq 10 ]
  then
    echo "> 헬스체크 실패"
    echo "> 엔진 엑스에 연결하지 않고 배포를 종료합니다."
    exit 1
  fi

  echo "> 헬스 체크 연결 실패 재시도"
  sleep 10
done