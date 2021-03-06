#Bash.sh
app_path="/app"
jre_path="/app/jre"
tomcat_path="/app/tomcat"
tomcat_deploy_path="/app/tomcat/deploy"
if [ ! -d "$app_path" ]; then  
    mkdir "$app_path"
fi
if [ ! -d "$jre_path" ]; then  
    mkdir "$jre_path"
fi
if [ ! -d "$tomcat_path" ]; then  
    mkdir "$tomcat_path"
fi
if [ ! -d "$tomcat_deploy_path" ]; then  
    mkdir "$tomcat_deploy_path"
fi
if [ ! -d "$tomcat_deploy_path/tomcat7" ]; then  
    mkdir "$tomcat_deploy_path/tomcat7"
fi

if [ -d "$jre_path/jre1.8.0_151" ]; then  
    echo 'jre1.8.0_151 already exist'
    exit -1;
fi

if [ -d "$tomcat_path/apache-tomcat-7.0.73" ]; then  
    echo 'apache-tomcat-7.0.73 already exist'
    exit -1;
fi

echo 'deploy jre'
tar -xzf jre-8u151-linux-x64.tar.gz -C "$jre_path"
echo 'deploy tomcat'
tar -xf apache-tomcat-7.0.73.tar -C "$tomcat_path"

mkdir "$tomcat_path/apache-tomcat-7.0.73/run"
mkdir "$tomcat_path/apache-tomcat-7.0.73/cron"
cp_catalina_out="$tomcat_path/apache-tomcat-7.0.73/cron/cp_catalina_out.sh"
touch "$cp_catalina_out"
echo "datetime=\$(date +%Y-%m-%d)" >> "$cp_catalina_out"
echo "cp $tomcat_path/apache-tomcat-7.0.73/logs/catalina.out $tomcat_path/apache-tomcat-7.0.73/logs/catalina.\$datetime.out && echo > $tomcat_path/apache-tomcat-7.0.73/logs/catalina.out" >> "$cp_catalina_out"
chmod +x "$cp_catalina_out"
cp setenv-jre8.sh "$tomcat_path/apache-tomcat-7.0.73/bin/setenv.sh"
cp server.xml "$tomcat_path/apache-tomcat-7.0.73/conf/"
cp tomcat7 /etc/init.d/
chmod +x /etc/init.d/tomcat7
chkconfig --add tomcat7
echo 'tomcat has been deployed on port 80'
echo 'crontab -e and add 0 0 * * * '$cp_catalina_out
