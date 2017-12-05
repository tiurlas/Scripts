#!/bin/bash

checkPing()
	{
	ping -c2 -W2 "$IP" > /dev/null;
	}

checkSSH()
	{	
	sshpass -p ${PASS} ssh -o StrictHostKeyChecking=no $USER@$IP hostname;
	}

copyID()
	{
	ssh-keyscan -H $IP >> ~/.ssh/known_hosts;
	ssh-keyscan -H $HOST >> ~/.ssh/known_hosts;
	sshpass -p ${PASS} ssh-copy-id $USER@$IP;
	}

for i in `cat lista_teste.csv`; do

	USER=`echo $i | awk -F"," '{print $3}'`
	IP=`echo $i | awk -F"," '{print $2}'`
	PASS=`echo $i | awk -F"," '{print $4}'`
	HOST=`echo $i | awk -F"," '{print $1}'`

	if checkPing; then
		echo "-----------------------------------------------"
		echo "           IP "$IP" Válido                   "
		echo "-----------------------------------------------"

	
		if copyID; then
			echo "-----------------------------------------------"
			echo "              ***Conectado***                  "
			echo "-----------------------------------------------"
			echo "$IP ansible_user=$USER" >> hosts
			echo "$HOST,$IP,$USER,$PASS" >> ips_ok.txt
		else
			echo "-----------------------------------------------"
			echo "            ###Senha Inválida###               "
			echo "-----------------------------------------------"
			echo "$IP,$USER,$PASS" >> ips_nok.txt
		fi
	else
		echo "-----------------------------------------------"
		echo "           IP "$IP" Inválido                 "
		echo "-----------------------------------------------"
		echo "$IP" >> ips_off.txt
	fi
done
exit 0
