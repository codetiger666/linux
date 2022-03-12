#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

echo "+------------------------------------------------------------------------+"
echo "|                     欢迎使用codetiger一键部署脚本                        |"
echo "+------------------------------------------------------------------------+"

if [[ $(id -u) != 0 ]]
then
    echo -e "\n 哎呀......请使用${red}root${none}用户运行此脚本"
else
echo -e "\n"
echo -e '1: lnmp环境'
echo -e '2: docker'
read -p "请选择要安装的软件集:" selectd

. include/lnmp.sh
. include/docker.sh
case $selectd in
1)
    echo -e "${yellow}将要安装lnmp环境"
    install_lnmp
    ;;
2)
    echo -e "${yellow}将要安装docker环境"
    install_docker
    ;;
3)   
    echo "3"   
    ;;
*)
    echo -e "${red}请输入正确的选项${none}"
esac

fi