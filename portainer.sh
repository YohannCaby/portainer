#!/bin/bash

function usage {
	echo "./$(basename $0) <arg1>"
	echo "arg1 : version portainer"
}

if [[ -z $1 ]]
then
	usage
	exit 1
else
	version=$1
	if [[ $version != 'latest' ]] && ! [[ $version =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
		echo "Format de version incorrect $version"
		exit 1
	fi	
fi


CMD="docker run -d -p 9000:9000 -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:$version"


container=$(docker ps | grep portainer)

if [[ -z $container ]]
then
	echo "Aucun container Portainer lancé."
	while :
	do
		echo "Souhaitez vous exécuter une instance ? [Y/N]"
		read res
		if [[ $res = 'Y' ]] || [[ $res = 'N' ]]
		then
			break
		fi
	done
	if [[ $res = 'N' ]]
	then
		exit 0
	fi

	if [[ $res = 'Y' ]]
	then
		$CMD
	fi
else
	while :
	do
		echo "Souhaitez vous tuer l'instance existante? [Y/N]"
		read res
		if [[ $res = 'Y' ]] || [[ $res = 'N' ]]
		then
			break
		fi
	done
	if [[ $res = 'N' ]]
	then
		exit 0
	fi

	if [[ $res = 'Y' ]]
	then
		docker kill portainer
		docker container rm portainer
	fi

	$CMD

fi

#docker kill portainer

#docker run -d -p 9000:9000 -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/agent:$version
