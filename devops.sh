#!/bin/bash

instalarNginx(){

	echo "******************"
	echo "*Instalando Nginx*"
	echo "******************"
	
	apt-get update -y && apt-get install -y nginx
	systemctl enable nginx
	systemctl start nginx
	
	echo "**************"
	echo "*Status Nginx*"
	echo "**************"

}

instalarDocker(){

	echo "*******************"
	echo "*Instalando Docker*"
	echo "*******************"
	
	curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

}

configurarNginx(){

	echo "********************"
	echo "*Configurar o Nginx*"
	echo "********************"
	
	cd /etc/nginx/sites-available/	
	echo "Criando arquivos .conf"
	touch app1.conf app2.conf app3.conf
	
	echo "server {
	listen       80;        
	server_name app1.gabriel.com.br;
	access_log  /var/log/nginx/proxy-nginx.log;

        location / {
                proxy_pass http://127.0.0.1:8081;
        }
}" > /etc/nginx/sites-available/app1.conf


	echo "server {
	listen       80;        
	server_name app2.gabriel.com.br;
	access_log  /var/log/nginx/proxy-nginx.log;

        location / {
                proxy_pass http://127.0.0.1:8082;
        }
}" > /etc/nginx/sites-available/app2.conf


	echo "server {
	listen       80;        
	server_name app3.gabriel.com.br;
	access_log  /var/log/nginx/proxy-nginx.log;

        location / {
                proxy_pass http://127.0.0.1:8083;
        }
}" > /etc/nginx/sites-available/app3.conf
	
	echo "Removendo arquivo default"
	rm /etc/nginx/sites-enabled/default
	echo "Linkando arquivos .conf"
	ln -s /etc/nginx/sites-available/app1.conf /etc/nginx/sites-enabled/app1.conf
	ln -s /etc/nginx/sites-available/app2.conf /etc/nginx/sites-enabled/app2.conf
	ln -s /etc/nginx/sites-available/app3.conf /etc/nginx/sites-enabled/app3.conf
	echo "Restartando o Nginx"
	systemctl restart nginx

}

criarConteiners(){

	echo "**************************************************************************"
	echo "*Criando os Contêiners com apache e mapear volume dos arquivos index.html*"
	echo "**************************************************************************"

	echo "Criando arquivos index.html"
	touch ~/index/app1/index.html
	echo "App1" > ~/index/app1/index.html
	touch ~/index/app2/index.html
	echo "App2" > ~/index/app2/index.html
	touch ~/index/app3/index.html
	echo "App3" > ~/index/app3/index.html

	echo "Subindo os contêiners"
	docker run -dit --name app1 -p 8081:80 -v ~/index/app1/:/usr/local/apache2/htdocs/ httpd:2.4
	docker run -dit --name app2 -p 8082:80 -v ~/index/app2/:/usr/local/apache2/htdocs/ httpd:2.4
	docker run -dit --name app3 -p 8083:80 -v ~/index/app3/:/usr/local/apache2/htdocs/ httpd:2.4

}

echo "###############################"
echo "########Iniciando Script#######"
echo "###############################"
instalarNginx	
instalarDocker
configurarNginx
criarConteiners
echo "###############################"
echo "######Realizar Conferência#####"
echo "###############################"
echo "####Conferindo Status Nginx####"
echo "###############################"
systemctl status nginx
echo "###############################"
echo "#Conferindo Contêiners Criados#"
echo "###############################"
docker ps -a
echo "###############################"
echo "#######Script Finalizado#######"
echo "###############################"
exit 0
