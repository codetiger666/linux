#!/usr/sbin/sh
user=`env | grep USER | cut -d "=" -f 2`
if [ "$user" == "root"  ]
   then 
    echo -n "请输入容器名称:"
    read name
    id=`docker ps -aq --filter name=$name`
    #echo "$id"
  	if [ -z "$id" ]
   	then echo "容器不存在";
   	else PID=`docker inspect -f {{.State.Pid}} $id`;
        #echo "$PID";
	`nsenter --target $PID --mount --uts --ipc --net --pid`
   fi
   else echo "非root用户！！！，无权执行"
fi
