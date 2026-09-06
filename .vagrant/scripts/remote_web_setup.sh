#!/bin/bash

USR='devops'

for host in `cat remote_host_names`
do
	echo
	echo "Connecting to $host"
	echo "Pushing Script to host"
	scp automating_remote_hosts.sh $USR@$host:/tmp/
	echo
	echo "Executing script on $host"
	ssh $USR@$host sudo /tmp/automating_remote_hosts.sh
	ssh $USR@$host sudo rm -rf /tmp/automating_remote_hosts.sh
done
