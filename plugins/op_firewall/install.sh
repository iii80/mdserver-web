#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")


install_tmp=${rootPath}/tmp/mw_install.pl


Install_of(){

	mkdir -p $serverPath/op_firewall
	echo '正在安装脚本文件...' > $install_tmp

	echo '0.1' > $serverPath/op_firewall/version.pl
	echo 'install ok' > $install_tmp
}

Uninstall_of(){

	rm -rf $serverPath/op_firewall
}


action=$1
type=$2

action=$1
if [ "${1}" == 'install' ];then
	Install_of
else
	Uninstall_of
fi
