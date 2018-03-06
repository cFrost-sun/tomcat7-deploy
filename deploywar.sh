datetime=$(date +%Y-%m-%dT%H:%M:%S)
deploy_tmp_dir=/root/cfrost/deploy_tmp
deploy_dir=/app/tomcat/deploy
webappname=tomcat7
bak_dir=/app/tomcat/deploy/bak

ueditor=false
war_url=http://localhost
war=test.war

while getopts "n:ua:w:" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
        n)
            webappname=$OPTARG
            ;;
        u)
            ueditor=true
            ;;
        a)
            war_url=$OPTARG
            ;;
        w)
            war=$OPTARG
            ;;
        esac
done

if [ ! -d "$deploy_tmp_dir" ]; then
    mkdir -p "$deploy_tmp_dir"
fi

if [ ! -d "$bak_dir" ]; then
    mkdir -p "$bak_dir"
fi

#清空下载临时目录
rm -rf $deploy_tmp_dir/*

#下载新包
wget $war_url/$war -P $deploy_tmp_dir

#停止tomcat
service tomcat7 stop
sleep 5

#备份
mkdir -p $bak_dir/$webappname/$datetime
cp -rp $deploy_dir/$webappname/* $bak_dir/$webappname/$datetime

#清空部署目录
rm -rf $deploy_dir/$webappname/*

#部署新文件
unzip $deploy_tmp_dir/$war -d $deploy_dir/$webappname/

#恢复UE文件
if [ "$ueditor" == "true" ]; then
    cp -rp $bak_dir/$webappname/$datetime/ueditor $deploy_dir/$webappname/u                                                                                  editor
fi

#启动服务
service tomcat7 start
