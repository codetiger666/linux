#!/bin/bash
# 应用名称
APP_NAME=app
# 应用运行目录
PROGRAM_PATH=$(dirname "$(realpath "$0")")

case "$1" in
start)
    $PROGRAM_PATH/$APP_NAME > $PROGRAM_PATH/$APP_NAME.log 2>&1 &
    echo $! > $PROGRAM_PATH/$APP_NAME.pid
    ;;
stop)
    if [ -e ${PROGRAM_PATH}/${APP_NAME}.pid ];then
        kill $(cat ${PROGRAM_PATH}/${APP_NAME}.pid)
        rm $PROGRAM_PATH/$APP_NAME.pid
    fi
    ;;
status)
    if [ -e ${PROGRAM_PATH}/${APP_NAME}.pid ];then
        echo "${APP_NAME} is runing..."
    else
        echo "${APP_NAME} is not runing..."
    fi
    ;;
restart)
    $0 stop
    $0 start
    ;;
*)
  echo "Usage: $0 {start|stop|status|restart}"
esac
# 正常退出程序
exit 0