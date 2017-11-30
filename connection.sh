#!/bin/bash

###Criando a view, com a senha já decodificada
#CREATE VIEW VW_MYPMS AS
#SELECT t1.id, t1.type, t2.host, t2.ip, t1.user, (CONVERT(FROM_BASE64(t1.passwd) USING latin2)) as passwd
#FROM tpd.usuarios t1 LEFT JOIN tpd.servidores t2 on (t1.id = t2.id);

###Selecionando a Lista de Servidores 
#SELECT user AS USERS, ip AS HOSTS, passwd AS PASS
#FROM tpd.vw_mypms 
#WHERE type=1 AND HOST IS NOT NULL;


checkPing(){
	ping -c2 -W2 "$HOST" > /dev/null;
}

checkSSH(){
	sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no $USER@$HOST hostname >> ips_ok.txt;
}	

for i in `cat Lista_mypms.csv`; do

	USER=`echo $i | awk -F"," '{print $1}'`
	HOST=`echo $i | awk -F"," '{print $2}'`
	PASS=`echo $i | awk -F"," '{print $3}'`

	if checkPing; then
		echo "----------------------------------------------------------"
		echo "             IP "$HOST" Válido                            "
		echo "----------------------------------------------------------"

		if checkSSH; then
			echo "----------------------------------------------------------"
			echo "					***Conectado***                         "
			echo "----------------------------------------------------------"
		else
			echo "----------------------------------------------------------"
			echo "               ###Senha Inválida###                       "
			echo "----------------------------------------------------------"
			echo "$HOST" >> ips_nok.txt
		fi

	else
		echo "----------------------------------------------------------"
		echo "             IP "$HOST" Inválido                          "
		echo "----------------------------------------------------------"
		echo "$HOST" >> ips_off.txt

	fi
done
exit 0