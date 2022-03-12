#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

# 检测用户
TestUser(){
    

    echo "+------------------------------------------------------------------------+"
    echo "|                     欢迎使用codetiger一键部署脚本                        |"
    echo "+------------------------------------------------------------------------+"

    if [[ $(id -u) != 0 ]]
    then
        echo -e "\n 哎呀......请使用${red}root${none}用户运行此脚本"
        exit 8
    fi

}

# 初始化环境
InitSystem(){
    rm -rf /usr/local/xray
    if [[ $(command -v yum) ]] && [[ $(command -v systemctl) ]]
    then
        yum install redhat-lsb-core wget curl unzip -y
    fi
    if [[ $(command -v apt) ]] && [[ $(command -v systemctl) ]]
    then
        apt update -y
        apt install wget curl wget -y
    fi           
}

# 下载Xray
GetXray(){
    cd /usr/local/
    mkdir xray
    cd xray
    wget https://git.gybyt.cn/niening/linux/raw/branch/master/src/linux/linuxsoft/xray.zip --no-check-certificate
    unzip xray.zip
    MakeConfig

}

# 生成配置文件
MakeConfig(){
    cd /usr/local/xray
    mkdir conf 2>/dev/null
    cd conf
    cat << EOF > 00_base.json
{
    "log": {
        "access": "/var/log/xray/access.log",
        "error": "/var/log/xray/error.log",
        "loglevel": "none"
    },
    "routing": {
      "domainStrategy": "AsIs",
        "rules": []
    },
    "inbounds": [],
    "outbounds": [
      {
        "protocol": "freedom",
        "settings": {
          "domainStrategy": "UseIP"
        },
        "tag": "direct"
      },
      {
          "protocol": "blackhole",
          "settings": {},
          "tag": "blocked"
      }
    ]
}
EOF
    cat << EOF > 01_rules.json
{
    "routing": {
        "rules": [
            {
                "type": "field",
                "outboundTag": "blocked",
                "domain": ["geosite:category-ads-all"]
            },
            {
                "type": "field",
                "tag": "base",
                "ip": [
                  "0.0.0.0/8",
                  "10.0.0.0/8",
                  "100.64.0.0/10",
                  "127.0.0.0/8",
                  "169.254.0.0/16",
                  "172.16.0.0/12",
                  "192.0.0.0/24",
                  "192.0.2.0/24",
                  "192.168.0.0/16",
                  "198.18.0.0/15",
                  "198.51.100.0/24",
                  "203.0.113.0/24",
                  "::1/128",
                  "fc00::/7",
                  "fe80::/10"
                ],
                "outboundTag": "blocked"
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "domain": [
                  "geosite:private",
                  "geosite:apple-cn",
                  "geosite:google-cn",
                  "geosite:tld-cn",
                  "geosite:category-games@cn"
                ]
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "network": "tcp,udp"
              }
        ]
    }
}
EOF
    cat << EOF > 03_dns.json
{
    "dns": {
        //国内使用
        "servers": [
			"223.5.5.5",
			"129.29.29.29",
			"localhost"
		]
    }
}
EOF
echo "1.Vmess+Websocket"
echo "2.Vmwss+Tcp+Http"
echo "3.Vless+Websocket"
read -p "请输入传输协议:" protocol
case $protocol in
    1)
        read -p "请输入监听地址:" address
        read -p "请输入监听端口:" port
        read -p "请输入标签:" label
        read -p "请输入监听路径（可留空）:" path
        if [ -n "$label" ]; then
            echo "请输入标签"
        fi
cat << EOF > Vmess+Websocket.json
    {
        "inbounds": [
            {
                "listen": "$address",
                "port": $port,
                "tag": "$label",
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "a4eab664-b719-9aff-4364-385937f21464"
                        }
                    ]
                },
                "streamSettings": {
                    "network": "ws",
                    "security": "auto",
                    "wsSettings": {
                            "path": "$path"
                    }
                },
                "sniffing": {
                    "enabled": true,
                    "destOverride": [
                            "http",
                            "tls"
                    ]
                }
            }
        ]
    }
EOF
        ;;
    2)
        read -p "请输入监听地址:" address
        read -p "请输入监听端口:" port
        read -p "请输入标签:" label
        read -p "请输入监听路径（可留空）:" path
        if [ -n "$label" ]; then
            echo "请输入标签"
        fi
cat << EOF > Vmess+Websocket.json
    {
        "inbounds": [
            {
                "listen": "$address",
                "port": $port,
                "tag": "$label",
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "a4eab664-b719-9aff-4364-385937f21464"
                        }
                    ]
                },
                "streamSettings": {
                    "network": "tcp",
                    "tcpSettings": {
                        "header": {
                            "type": "http",
                            "response": {
                                "version": "1.1",
                                "status": "200",
                                "reason": "OK",
                                "headers": {
                                    "Content-encoding": [
                                            "gzip"
                                    ],
                                    "Content-Type": [
                                            "text/html; charset=utf-8"
                                    ],
                                    "Cache-Control": [
                                            "no-cache"
                                    ],
                                    "Vary": [
                                            "Accept-Encoding"
                                    ],
                                    "X-Frame-Options": [
                                            "deny"
                                    ],
                                    "X-XSS-Protection": [
                                            "1; mode=block"
                                    ],
                                    "X-content-type-options": [
                                            "nosniff"
                                    ]
                                }
                            }
                        }
                    }
                },
                "sniffing": {
                    "enabled": true,
                    "destOverride": [
                            "http",
                            "tls"
                    ]
                }
            }
        ]
    }
EOF
        ;;
    3)
        read -p "请输入监听地址:" address
        read -p "请输入监听端口:" port
        read -p "请输入监听路径（可留空）:" path
cat << EOF > Vless+Websocket.json
    {
        "inbounds": [
            {
                "port": $port,
                "listen": "$address",
                "protocol": "vless",
                "settings": {
                    "clients": [
                        {
                            "id": "a4eab664-b719-9aff-4364-385937f21464",
                            "level": 0,
                            "email": "love@example.com"
                        }
                    ],
                    "decryption": "none"
                },
                "streamSettings": {
                    "network": "ws",
                    "security": "none",
                    "wsSettings": {
                            "path": "$path"
                    }
                },
                "sniffing": {
                    "enabled": true,
                    "destOverride": [
                            "http",
                            "tls"
                    ]
                }
            }
        ]
    }
EOF
        ;;
    *)
        echo "输入有误，请重新输入！！！"
        MakeConfig
        ;;
esac
}

# 安装后配置
AfterInstall(){
    id xray &> /dev/null
    if [ $? -ne 0 ]
    then
        groupadd xray 2>/dev/null
        useradd xray -s /sbin/nologin -g xray 2>/dev/null 
    else
        userdel xray 2>/dev/null
        groupdel xray 2>/dev/null
    fi
    rm -rf /var/log/xray
    mkdir /var/log/xray
    chown -R xray:xray /var/log/xray
    chown -R xray:xray /usr/local/xray
    cd /usr/lib/systemd/system
    rm -rf xray.service
    curl https://git.gybyt.cn/niening/linux/raw/branch/master/scripts/linux/systemctl-scripts/xray.service > xray.service
    systemctl daemon-reload
}

Start(){
    TestUser
    InitSystem
    GetXray
    AfterInstall
}

Start