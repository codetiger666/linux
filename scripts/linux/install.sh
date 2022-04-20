#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

centosversion=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`

install_docker()
{
    if [[ $(command -v yum) ]] && [[ $(command -v systemctl) ]]
    then 
    version=`cat /etc/redhat-release | awk {'print $4'} | cut -f 1 -d .`
    case $version in
    7)
        if [ $centosversion = 7 ];then
            if [[ $(command -v wget) ]]
            then
                cd /etc/yum.repos.d/
                rm -rf *
                wget https://gitee.com/nnproj/linux/raw/master/scripts/linux/centos/centos.repo
            fi
        fi
        yum makecache
        yum install docker-ce -y
        mkdir -p /etc/docker
        cat > /etc/docker/daemon.json <<-'EOF'
        {
            "registry-mirrors": ["https://mirror.ccs.tencentyun.com","https://dockerhub.azk8s.cn"]
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
        curl "https://gitee.com/nnproj/linux/raw/master/scripts/linux/ubuntu/replacerepo" | bash
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


generate_config()
{
    base_path=/usr/local/nginx/conf.d/
    echo -e "\n"
    echo -e '1: websocket'
    echo -e '2: cache'
    echo -e '3: ssl'
    echo -e '4: php'
    read -p "请选择要生成的配置:" selectd

    case $selectd in
    1)
        echo -e "${yellow}将要生成websocket${none}"
        read -p "请输入域名:" domain
        curl https://gitee.com/nnproj/linux/raw/master/scripts/linux/nginx/websocket.conf.example>$base_path$domain.conf
        sed -i "s/域名/$domain/g" $base_path$domain.conf
        read -p "请输入后端ip:" host
        read -p "请输入后端端口:" port
        sed -i "s/后端ip/$host/g" $base_path$domain.conf
        sed -i "s/后端端口/$port/g" $base_path$domain.conf
        ;;
    2)
        echo -e "${yellow}将要生成cache${none}"
        read -p "请输入域名:" domain
        curl https://gitee.com/nnproj/linux/raw/master/scripts/linux/nginx/cache.conf.example>$base_path$domain.conf
        sed -i "s/域名/$domain/g" $base_path$domain.conf
        ;;
    3)   
        echo -e "${yellow}将要生成ssl${none}" 
        read -p "请输入域名:" domain
        curl https://gitee.com/nnproj/linux/raw/master/scripts/linux/nginx/ssl.conf.example>$base_path$domain.conf
        sed -i "s/域名/$domain/g" $base_path$domain.conf
        read -p "请输入证书路径:" file_path
        read -p "请输入密钥路径:" key_path
        sed -i "s/证书文件位置/$file_path/g" $base_path$domain.conf
        sed -i "s/证书key位置/$key_path/g" $base_path$domain.conf
        ;;
    4)   
        echo -e "${yellow}将要生成php${none}" 
        read -p "请输入域名:" domain
        curl https://gitee.com/nnproj/linux/raw/master/scripts/linux/nginx/php.conf.example>$base_path$domain.conf
        sed -i "s/域名/$domain/g" $base_path$domain.conf
        ;;
    *)
        echo -e "${red}请输入正确的选项${none}"
    esac
}

install_lnmp()
{
    if [[ $(command -v yum) ]] && [[ $(command -v systemctl) ]]
    then 
    version=`cat /etc/redhat-release | awk {'print $4'} | cut -f 1 -d .`
    case $version in
    7)
        rm -rf /etc/yum.repos.d/*
        curl https://gitee.com/nnproj/linux/raw/master/scripts/linux/centos/centos.repo > /etc/yum.repos.d/centos.repo
        yum install epel-release -y
        rm -rf /etc/yum.repos.d/e*
        yum makecache
        yum install -y wget pcre-devel openssl-devel libxslt* perl-ExtUtils-Embed at gcc-c++ python subversion gperf make rpm-build git curl bzip2-devel libcurl-devel gd gd-devel t1lib t1lib-devel libmcrypt libmcrypt-devel libtidy libtidy-devel GeoIP-devel libatomic_ops-devel zlib-devel unzip libstdc++* net-snmp net-snmp* gmp gmp-devel openldap openldap-devel libpcap-devel glib2-devel GeoIP-devel libxml2-devel libxml2-devel redis vim wget git htop iftop libtool make automake mlocate openssl-devel pam-devel unzip gcc screen openssl openssl-devel iptables-services bash-completion* pcre-devel openssl-devel libxslt* perl-ExtUtils-Embed at gcc-c++ python subversion gperf make rpm-build git curl bzip2-devel libcurl-devel gd gd-devel t1lib t1lib-devel libmcrypt libmcrypt-devel libtidy libtidy-devel GeoIP-devel libatomic_ops-devel zlib-devel unzip libstdc++* net-snmp net-snmp* gmp gmp-devel openldap openldap-devel net-tools
        yum -y install php72 php72-php-cli php72-php-fpm php72-php-common php72-php-devel php72-php-embedded php72-php-gd php72-php-mbstring php72-php-mysqlnd php72-php-opcache php72-php-pdo php72-php-xml php72-php-bcmath php72-php-with-luajit php72-php-http_gunzip_module php72-php-pcre php72-php-pcre-jit php72-php-http_perl_module php72-php-ld-opt="-Wl,-E" php72-php-http_realip_module php72-php-http_secure_link_module php72-php-http_slice_module php72-php-http_ssl_module php72-php-http_stub_status_module php72-php-http_sub_module php72-php-http_v2_module php72-php-http_addition_module php72-php-http_xslt_module php72-php-http_image_filter_module php72-php-http_geoip_module php72-php-http_dav_module php72-php-http_flv_module php72-php-http_mp4_module php72-php-http_gzip_static_module php72-php-http_auth_request_module php72-php-http_random_index_module php72-php-select_module php72-php-poll_module php72-php-file-aio php72-php-http_degradation_module php72-php-libatomic 
        yum install mysql-community-{server,client,common} -y
        yum install openresty -y
        systemctl start php72-php-fpm.service
        systemctl start mariadb
        systemctl enable php72-php-fpm.service
        systemctl enable mariadb
        mkdir /usr/local/nginx/conf.d -p
        wget -P /usr/local/nginx/nginx/html https://gitee.com/nnproj/linux/raw/master/scripts/linux/nginx/p.php
        curl https://gitee.com/nnproj/linux/raw/master/scripts/linux/nginx/php.conf.example>"$base_path"default.conf
        sed -i "s/域名/localhost/g" "$base_path"default.conf
        sed -i "s/listen       80;/listen       80      default_server;/g" "$base_path"default.conf
        sed -i "s/listen	    [::]:80;/listen	    [::]:80      default_server;/g" "$base_path"default.conf
        systemctl start nginx
        systemctl enable nginx
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
        cat << EOF > /etc/apt/sources.list
        #基础源
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ `lsb_release -c --short` main restricted universe multiverse
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ `lsb_release -c --short`-updates main restricted universe multiverse
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ `lsb_release -c --short`-backports main restricted universe multiverse
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ `lsb_release -c --short`-security main restricted universe multiverse
        #php源
        deb http://ppa.launchpad.net/ondrej/php/ubuntu `lsb_release -c --short` main 
        deb-src http://ppa.launchpad.net/ondrej/php/ubuntu `lsb_release -c --short` main 
        #mysql
        deb https://mirrors.tuna.tsinghua.edu.cn/mysql/apt/ubuntu/ `lsb_release -c --short` mysql-5.7
EOF
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C 8C718D3B5072E1F5
        apt update
        apt install openssl libpcre3 libpcre3-dev zlib1g-dev libssl-dev libxslt-dev libgd-dev libgeoip-dev google-perftools libgoogle-perftools-dev libperl-dev libatomic-ops-dev
        cd /opt
        wget https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/src/linux/lnmp/openresty.tar.gz
        tar xf openresty.tar.gz
        cd openresty-1.15.8.1
        ./configure --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --with-luajit --with-http_gunzip_module --with-pcre --with-pcre-jit --with-http_perl_module --with-ld-opt="-Wl,-E" --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-select_module --with-poll_module --with-file-aio --with-http_degradation_module --with-libatomic --http-client-body-temp-path=/var/tmp/nginx/client_body --http-proxy-temp-path=/var/tmp/nginx/proxy --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi
        make && make install
        useradd nginx -s /sbin/nologin
        mkdir /usr/local/nginx/conf.d -p
        curl https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/lnmp/nginx.conf>/usr/local/nginx/nginx.conf
        mkdir /var/tmp/nginx/proxy_cache -p
        wget -P /usr/local/nginx/nginx/html https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/lnmp/p.php
        wget -P /usr/local/nginx/conf.d/ https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/lnmp/default-php.conf
        wget -P /usr/lib/systemd/system/ https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/systemctl-scripts/nginx.service
        systemctl start nginx
        systemctl enable nginx
        apt install php7.2 php7.2-cli php7.2-fpm php7.2-dev php7.2-mysql php7.2-gd php7.2-common php7.2-zip -y
        sed -i "s#listen = /run/php/php7.2-fpm.sock#listen = 127.0.0.1:9000#g" /etc/php/7.2/fpm/pool.d/www.conf
        apt install mysql-community-{server,client} -y 
        ;;
    *)
        echo -e "${red}哎呀，脚本太垃圾了，不支持当前系统版本"
        ;;
    esac
    fi
}



echo "+------------------------------------------------------------------------+"
echo "|                     欢迎使用codetiger一键部署脚本                        |"
echo "+------------------------------------------------------------------------+"

if [[ $(id -u) != 0 ]]
then
    echo -e "\n 哎呀......请使用${red}root${none}用户运行此脚本"
else
echo -e "\n"
echo -e '1: 安装lnmp环境'
echo -e '2: 安装docker'
echo -e '3: 生成nginx配置文件'
read -p "请选择要进行的操作:" selectd

case $selectd in
1)
    echo -e "${yellow}将要安装lnmp环境${none}"
    install_lnmp
    ;;
2)
    echo -e "${yellow}将要安装docker环境${none}"
    install_docker
    ;;
3)   
    echo -e "${yellow}将要生成nginx配置文件${none}" 
    generate_config
    ;;
*)
    echo -e "${red}请输入正确的选项${none}"
esac

fi