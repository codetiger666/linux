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

find_run_command() {
    ps -ef | grep ${APP_NAME}.jar | grep -v $0 | grep -vE "ps|grep|systemd --user|sd-pam|awk|xargs|systemctl"
}

get_status() {
    if find_run_command > /dev/null ; then
        return 1
    else
        return 0
    fi
}

case "$1" in
start)
    get_status
    if [ $? -eq 1 ]; then
        echo "${APP_NAME} is runing..."
        exit 0
    fi
    $JAVA_HOME/bin/java $JAVA_OPS -jar $PROGRAM_PATH/$APP_NAME.jar $JAVA_COMMAND_LINE > $PROGRAM_PATH/$APP_NAME.log 2>&1 &
    echo $! > $PROGRAM_PATH/$APP_NAME.pid
    ;;
stop)
    get_status
    if [ $? -eq 1 ]; then
        find_run_command | awk '{print $2}' | xargs -I {} kill {}
        rm $PROGRAM_PATH/$APP_NAME.pid
        rm $PROGRAM_PATH/$APP_NAME.log
    fi
    ;;
status)
    get_status
    if [ $? -eq 1 ]; then
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