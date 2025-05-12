#centos7.7.1908_Base--bwlimit=5120 --timeout=120 --contimeout=120
#mkdir -p /mirror/centos/centos/7.7.1908/os/x86_64/
rsync -avzp --exclude-from=/mirror/exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7.7.1908/os/x86_64/ /mirror/centos/7.7.1908/os/x86_64/
#createrepo /mirror/centos/7.7.1908/os/x86_64/

#centos7.7.1908_updates--bwlimit=5120 --timeout=120 --contimeout=120
#mkdir -p /mirror/centos/7.7.1908/updates/x86_64/
rsync -avzp --exclude-from=/mirror/exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7.7.1908/updates/x86_64/ /mirror/centos/7.7.1908/updates/x86_64/
createrepo /mirror/centos/7.7.1908/updates/x86_64/

#centos7.7.1908_extras--bwlimit=5120 --timeout=120 --contimeout=120
#mkdir -p /mirror/centos/7.7.1908/extras/x86_64/
rsync -avzp --exclude-from=/mirror/exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7.7.1908/extras/x86_64/ /mirror/centos/7.7.1908/extras/x86_64/
createrepo /mirror/centos/7.7.1908/extras/x86_64/

#centos7.7.1908_centosplus--bwlimit=5120 --timeout=120 --contimeout=120
#mkdir -p /mirror/centos/7.7.1908/centosplus/x86_64/
rsync -avzp --exclude-from=/mirror/exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7.7.1908/centosplus/x86_64/ /mirror/centos/7.7.1908/centosplus/x86_64/
createrepo /mirror/centos/7.7.1908/centosplus/x86_64/

#epel7
#mkdir -p /epel/7/
rsync -avzp --exclude-from=/mirror/exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/epel/7/ /mirror/epel/7/
createrepo /mirror/epel/7/

#docker
#mkdir -p /mirror/docker-ce/linux/centos/7/
rsync -avzp --exclude-from=/mirror/exclude_docker.list rsync://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/7/ /mirror/docker-ce/linux/centos/7/
createrepo /mirror/docker-ce/linux/centos/7/

#zabbix
#mkdir -p /mirror/zabbix/zabbix/4.4/rhel/7/x86_64/
rsync -avzp rsync://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.4/rhel/7/x86_64/ /mirror/zabbix/zabbix/4.4/rhel/7/x86_64/
createrepo /mirror/zabbix/zabbix/4.4/rhel/7/x86_64/

#remi
#mkdir -p /mirror/remi/enterprise/7/
rsync -avzp --exclude-from=/mirror/exclude_php.list rsync://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/7/ /mirror/remi/enterprise/7/
createrepo /mirror/remi/enterprise/7/

#mariadb
#mkdir -p /mirror/mariadb/10.5
rsync -avzp --exclude-from=/mirror/exclude_mariadb.list rsync://mirrors.tuna.tsinghua.edu.cn/mariadb/yum/10.3/ /mirror/mariadb/10.3/
createrepo /mirror/mariadb/10.3/

#kubernetes
#mkdir -p /mirror/kubernetes/yum/repos/kubernetes-el7-x86_64/
rsync -avzp rsync://mirrors.tuna.tsinghua.edu.cn/kubernetes/yum/repos/kubernetes-el7-x86_64/ /mirror/kubernetes/yum/repos/kubernetes-el7-x86_64/
createrepo /mirror/kubernetes/yum/repos/kubernetes-el7-x86_64/

#elasticstack
#mkdir -p /mirror/elasticstack/yum/

rsync -avzp --exclude-from=/mirror/exclude_elasticstack.list rsync://mirrors.tuna.tsinghua.edu.cn/elasticstack/yum/elastic-7.x/ /mirror/elasticstack/yum/
createrepo /mirror/elasticstack/yum/
