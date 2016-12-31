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

if [ -d "$jre_path/jre1.7.0_80" ]; then  
    echo 'jre1.7.0_80 already exist'
    exit -1;
fi

if [ -d "$tomcat_path/apache-tomcat-7.0.73" ]; then  
    echo 'apache-tomcat-7.0.73 already exist'
    exit -1;
fi

echo 'deploy jre'
tar -xzf jre-7u80-linux-x64.tar.gz -C "$jre_path"
echo 'deploy tomcat'
tar -xf apache-tomcat-7.0.73.tar -C "$tomcat_path"

mkdir "$tomcat_path/apache-tomcat-7.0.73/run"
mkdir "$tomcat_path/apache-tomcat-7.0.73/cron"
cp_catalina_out="$tomcat_path/apache-tomcat-7.0.73/cron/cp_catalina_out.sh"
touch "$cp_catalina_out"
echo "datename=\$(date +%Y-%m-%d)" >> "$cp_catalina_out"
echo "cat $tomcat_path/apache-tomcat-7.0.73/logs/catalina.out > $tomcat_path/apache-tomcat-7.0.73/logs/catalina.\$datename.out && echo > $tomcat_path/apache-tomcat-7.0.73/logs/catalina.out" >> "$cp_catalina_out"
chmod +x "$cp_catalina_out"
cp setenv.sh "$tomcat_path/apache-tomcat-7.0.73/bin/"
cp server.xml "$tomcat_path/apache-tomcat-7.0.73/conf/"
cp tomcat7 /etc/init.d/
chmod +x /etc/init.d/tomcat7
chkconfig --add tomcat7
echo 'tomcat has been deployed on port 80'
echo 'crontab -e and add 0 0 * * * '$cp_catalina_out
