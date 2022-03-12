#!/bin/sh

install_docker()
{
    if [[ $(command -v yum) ]] && [[ $(command -v systemctl) ]]
    then 
    version=`cat /etc/redhat-release | awk {'print $4'} | cut -f 1 -d .`
    case $version in
    7)
        cat > /etc/yum.repos.d/docker.repo << EOF
        [home_docker]
        name=home_docker
        baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/7/x86_64/stable/
        enabled=1
        gpgcheck=0

        [home_docker_stable_source]
        name=home_docker_stable_source
        baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/7/source/stable
        enabled=0
        gpgcheck=0
EOF
        yum makecache
        yum install docker-ce -y
        mkdir -p /etc/docker
        cat > /etc/docker/daemon.json <<-'EOF'
        {
            "registry-mirrors": ["https://dockerhub.azk8s.cn","https://2lqq34jg.mirror.aliyuncs.com","http://hub-mirror.c.163.com"]
        }
EOF
        systemctl daemon-reload &&sudo systemctl restart docker
        docker ps
        ;;
    *)
        echo -e "${red}哎呀，脚本太垃圾了，不支持当前系统版本"
        ;;
    esac
    fi
    if [[ $(command -v apt) ]] && [[ $(command -v systemctl) ]]
    then
    codename=$(lsb_release -c -s)
    systemid=$(lsb_release  -i --short)
    case $systemid in
    Ubuntu)
        echo "deb https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/ $codename stable" > /etc/apt/sources.list.d/docker.list
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7EA0A9C3F273FCD8
        apt update 
        apt install docker-ce -y
        mkdir -p /etc/docker
        cat > /etc/docker/daemon.json <<-'EOF'
        {
            "registry-mirrors": ["https://dockerhub.azk8s.cn","https://2lqq34jg.mirror.aliyuncs.com","http://hub-mirror.c.163.com"]
        }
EOF
        systemctl daemon-reload &&sudo systemctl restart docker
        docker ps
        ;;
    esac
    fi
}