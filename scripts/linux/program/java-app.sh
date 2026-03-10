#!/usr/bin/bash
PROGRAM_PATH=$(dirname "$(realpath "$0")")
JAVA_HOME=/usr/local/jdk/11
APP_NAME=api
PID_FILE=$PROGRAM_PATH/${APP_NAME}.pid

getStatus() {
    if [[ -f "$PID_FILE" ]]; then
        if ps -p "$(cat $PID_FILE)" -o pid= > /dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

case "$1" in
start)
    if getStatus; then
        echo "${APP_NAME} is runing..."
        exit 1
    else
        cd $PROGRAM_PATH
        ${JAVA_HOME}/bin/java -Xms128m -Xmx256m -jar ${APP_NAME}.jar --spring.profiles.active=pro --server.port=20504 > ${PROGRAM_PATH}/${APP_NAME}.log 2>&1 &
        echo $! > $PROGRAM_PATH/$APP_NAME.pid
    fi
    ;;
stop)
    if getStatus; then
        kill $(echo ${PID_FILE})
        rm ${PID_FILE}
    else
        echo "${APP_NAME} is not runing..."
    fi
    ;;
status)
    if getStatus; then
        echo "${APP_NAME} is runing..."
    else
        echo "${APP_NAME} is not runing..."
    fi
    ;;
restart)
    $0 stop
    sleep 5
    $0 start
    ;;
*)
  echo "Usage: $0 {start|stop|status|restart}"
esac
# 正常退出程序
exit 0