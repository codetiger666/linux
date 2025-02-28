#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

if [[ $(id -u) != 0 ]]
then 
  echo -e "\n 哎呀......请使用${red}root${none}用户运行此脚本"
else
  if [[ $(command -v yum) ]] && [[ $(command -v systemctl) ]]
  then 
    version=`cat /etc/redhat-release | awk {'print $4'} | cut -f 1 -d .`
    case $version in
    7)
      rm -rf /etc/yum.repos.d/*
      curl https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/centos/centos.repo > /etc/yum.repos.d/repo.repo
      yum install epel-release -y
      rm -rf /etc/yum.repos.d/e*
      yum makecache
      yum install -y wget pcre-devel openssl-devel libxslt* perl-ExtUtils-Embed at gcc-c++ python subversion gperf make rpm-build git curl bzip2-devel libcurl-devel gd gd-devel t1lib t1lib-devel libmcrypt libmcrypt-devel libtidy libtidy-devel GeoIP-devel libatomic_ops-devel zlib-devel unzip libstdc++* net-snmp net-snmp* gmp gmp-devel openldap openldap-devel libpcap-devel glib2-devel GeoIP-devel libxml2-devel libxml2-devel redis vim wget git htop iftop libtool make automake mlocate openssl-devel pam-devel unzip gcc screen openssl openssl-devel iptables-services bash-completion* pcre-devel openssl-devel libxslt* perl-ExtUtils-Embed at gcc-c++ python subversion gperf make rpm-build git curl bzip2-devel libcurl-devel gd gd-devel t1lib t1lib-devel libmcrypt libmcrypt-devel libtidy libtidy-devel GeoIP-devel libatomic_ops-devel zlib-devel unzip libstdc++* net-snmp net-snmp* gmp gmp-devel openldap openldap-devel net-tools
      yum -y install php72 php72-php-cli php72-php-fpm php72-php-common php72-php-devel php72-php-embedded php72-php-gd php72-php-mbstring php72-php-mysqlnd php72-php-opcache php72-php-pdo php72-php-xml php72-php-bcmath php72-php-with-luajit php72-php-http_gunzip_module php72-php-pcre php72-php-pcre-jit php72-php-http_perl_module php72-php-ld-opt="-Wl,-E" php72-php-http_realip_module php72-php-http_secure_link_module php72-php-http_slice_module php72-php-http_ssl_module php72-php-http_stub_status_module php72-php-http_sub_module php72-php-http_v2_module php72-php-http_addition_module php72-php-http_xslt_module php72-php-http_image_filter_module php72-php-http_geoip_module php72-php-http_dav_module php72-php-http_flv_module php72-php-http_mp4_module php72-php-http_gzip_static_module php72-php-http_auth_request_module php72-php-http_random_index_module php72-php-select_module php72-php-poll_module php72-php-file-aio php72-php-http_degradation_module php72-php-libatomic 
      yum install mysql-community-{server,client,common} -y
      cd /opt
      wget https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/src/linux/lnmp/openresty.tar.gz
      tar xf openresty.tar.gz
      cd openresty-1.15.8.1
      ./configure --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --with-luajit --with-http_gunzip_module --with-pcre --with-pcre-jit --with-http_perl_module --with-ld-opt="-Wl,-E" --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-select_module --with-poll_module --with-file-aio --with-http_degradation_module --with-libatomic --http-client-body-temp-path=/var/tmp/nginx/client_body --http-proxy-temp-path=/var/tmp/nginx/proxy --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi
      make && make install
      useradd nginx -s /sbin/nologin
      curl https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/lnmp/nginx.conf>/usr/local/nginx/nginx.conf 
      systemctl start php72-php-fpm.service
      systemctl start mariadb
      systemctl enable php72-php-fpm.service
      systemctl enable mariadb
      mkdir /usr/local/nginx/conf.d -p
      wget -P /usr/local/nginx/nginx/html https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/lnmp/p.php
      wget -P /usr/local/nginx/conf.d/ https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/lnmp/default-php.conf
      mkdir /var/tmp/nginx/proxy_cache -p
      wget -P /usr/lib/systemd/system/ https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/scripts/linux/systemctl-scripts/nginx.service
      systemctl start nginx
      systemctl enable nginx
    esac
  fi
  if [[ $(command -v apt) ]] && [[ $(command -v systemctl) ]]
  then
  codename=$(lsb_release -c -s)
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
  fi
fi