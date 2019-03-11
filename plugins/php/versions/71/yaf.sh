#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`

rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
rootPath=$(dirname "$rootPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")
sourcePath=${serverPath}/source/php



actionType=$1
version=$2

LIBNAME=yaf
LIBV='2.3.5'
if [ "$version" = '70' ] || [ "$version" = '71' ] || [ "$version" = '72' ] || [ "$version" = '73' ];then
	LIBV='3.0.7';
fi
extFile=$serverPath/php/${version}/lib/php/extensions/no-debug-non-zts-20160303/${LIBNAME}.so

Install_lib()
{
	
	isInstall=`cat $serverPath/php/$version/etc/php.ini|grep "${LIBNAME}.so"`
	if [ "${isInstall}" != "" ];then
		echo "php-$version 已安装${LIBNAME},请选择其它版本!"
		return
	fi
	
	if [ ! -f "$extFile" ];then
		
		

		php_lib=$sourcePath/php_${version}_lib

		mkdir -p $php_lib
		wget -O $php_lib/${LIBNAME}-${LIBV}.tgz http://pecl.php.net/get/${LIBNAME}-${LIBV}.tgz
		cd $php_lib
		tar xvf ${LIBNAME}-${LIBV}.tgz
		cd ${LIBNAME}-${LIBV}

		$serverPath/php/$version/bin/phpize
		./configure --with-php-config=$serverPath/php/$version/bin/php-config
		make && make install
		cd ..
		rm -rf ${LIBNAME}-*
		rm -f package.xml
	fi
	
	if [ ! -f "$extFile" ];then
		echo "ERROR!"
		return;
	fi
	
	echo  "" >> $serverPath/php/$version/etc/php.ini
	echo  "[${LIBNAME}]" >> $serverPath/php/$version/etc/php.ini
	echo  "extension=${LIBNAME}.so" >> $serverPath/php/$version/etc/php.ini
	echo  "${LIBNAME}.use_namespace=1" >> $serverPath/php/$version/etc/php.ini
	
	$serverPath/php/init.d/php$version reload
	echo '==========================================================='
	echo 'successful!'
}


Uninstall_lib()
{
	if [ ! -f "$serverPath/php/$version/bin/php-config" ];then
		echo "php-$version 未安装,请选择其它版本!"
		return
	fi

	if [ ! -f "$extFile" ];then
		echo "php-$version 未安装${LIBNAME},请选择其它版本!"
		return
	fi
	
	echo $serverPath/php/$version/etc/php.ini
	sed -i '_bak' "/${LIBNAME}.so/d" $serverPath/php/$version/etc/php.ini
	sed -i '_bak' "/${LIBNAME}.use_namespace/d" $serverPath/php/$version/etc/php.ini
	sed -i '_bak' "/\[${LIBNAME}\]/d"  $serverPath/php/$version/etc/php.ini
		
	rm -f $extFile
	$serverPath/php/init.d/php$version reload
	echo '==============================================='
	echo 'successful!'
}


if [ "$actionType" == 'install' ];then
	Install_lib
elif [ "$actionType" == 'uninstall' ];then
	Uninstall_lib
fi