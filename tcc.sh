#!/bin/bash

instalarDocker(){

	echo "*******************"
	echo "*Instalando Docker*"
	echo "*******************"
	
	curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

}

criarConteiners(){


	echo "Subindo os containers"
	docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:10
	docker run -d --name odoo -p 8069:8069 --link db:db -t odoo
	docker run -d --name grafana -p 3000:3000 grafana/grafana

}

echo "###############################"
echo "########Iniciando Script#######"
echo "###############################"
#instalarDocker
criarConteiners
echo "###############################"
echo "#######Script Finalizado#######"
echo "###############################"
exit 0
