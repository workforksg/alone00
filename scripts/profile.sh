#!/usr/bin/env bash

function find_idle_profile() {

  RESPONSE_CODE=$(curl -s -0 /dev/null -w "%{http_code}" http://localhost/profile)

  if [ ${RESOPONSE_CODE} -ge 400 ]

  then
    CURRENT_PROFILE=real12
  else
    CURRENT_PROFILE=$(curl -s http://localhost/profile)
  fi

  if [ ${CURRENT_PROFILE} == real1 ]
  then
    IDLE_PROFILE=real2
  else
    IDLE_PROFILE=real1
  fi

  echo "${IDLE_PROFILE}"
}

function find_idle_port(){
  IDLE_PROFILE=$(find_idle_profile)

  if [ ${IDLE_PROFILE} == real1 ]
  then
    echo "8081"
  else
    echo "8082"
  fi
}