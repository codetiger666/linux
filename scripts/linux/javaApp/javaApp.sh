#!/bin/bash
# 应用名称
APP_NAME=blog-view
# 应用运行目录
PROGRAM_PATH=$(dirname "$(realpath "$0")")
# jvm参数
JAVA_OPS="-Xmx256m -Xms128m -XX:MaxMetaspaceSize=128m"
# java 命令行参数
JAVA_COMMAND_LINE="--server.port=20500 --spring.profiles.active=pro"
# java安装位置
JAVA_HOME=/usr/local/jdk11

case "$1" in
start)
    if ps -ef | grep ${APP_NAME}.jar | grep -v grep > /dev/null ; then
        echo "${APP_NAME} is runing..."
        exit 0
    fi
    $JAVA_HOME/bin/java $JAVA_OPS -jar $PROGRAM_PATH/$APP_NAME.jar $JAVA_COMMAND_LINE > $PROGRAM_PATH/$APP_NAME.log 2>&1 &
    echo $! > $PROGRAM_PATH/$APP_NAME.pid
    ;;
stop)
    if ps -ef | grep ${APP_NAME}.jar | grep -v grep > /dev/null ; then
        kill  $(ps -ef | grep ${APP_NAME}.jar | grep -v grep | awk '{print $2}')
        rm $PROGRAM_PATH/$APP_NAME.pid
    fi
    ;;
status)
    if ps -ef | grep ${APP_NAME}.jar | grep -v grep > /dev/null ; then
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