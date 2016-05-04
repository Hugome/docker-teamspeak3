#!/bin/bash
VOLUME=/teamspeak3

echo " ----- docker-ts3 RECOVERY MODE ------"
echo "1. Linking host mounted database"
ln -s $VOLUME/ts3server.sqlitedb /opt/teamspeak3-server_linux_amd64/ts3server.sqlitedb

echo "2. Link the files-folder into the host-mounted volume."
mkdir -p /teamspeak3/files
if ! [ -L /opt/teamspeak3-server_linux_amd64/files ]; then
  rm -rf /opt/teamspeak3-server_linux_amd64/files
  ln -s /teamspeak3/files /opt/teamspeak3-server_linux_amd64/files
fi

echo "3. Starting TS3-Server in recoevry mode."
echo "Check if ts3server.ini exists in host-mounted volume."
if [ -f $VOLUME/ts3server.ini ]; then
    echo "$VOLUME/ts3server.ini found. Using ini as config file."
	echo "HINT: If this ini was transfered from another ts3-install you may want to make sure the following settings are active for the usage of host-mounted volume: (OPTIONAL)"
	echo "query_ip_whitelist='/teamspeak3/query_ip_whitelist.txt'"
	echo "query_ip_backlist='/teamspeak3/query_ip_blacklist.txt'"
	echo "logpath='/teamspeak3/logs/'"
	echo "licensepath='/teamspeak3/'"
	echo "inifile='/teamspeak3/ts3server.ini'"
	echo "serveradmin_password='$RECOVERY_PASS'"
	/opt/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh \
		inifile="/teamspeak3/ts3server.ini" \
		serveradmin_password="$RECOVERY_PASS"
else
	echo "$VOLUME/ts3server.ini not found. Creating new config file."
	/opt/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh \
		query_ip_whitelist="/teamspeak3/query_ip_whitelist.txt" \
		query_ip_backlist="/teamspeak3/query_ip_blacklist.txt" \
		logpath="/teamspeak3/logs/" \
		licensepath="/teamspeak3/" \
		inifile="/teamspeak3/ts3server.ini" \
		createinifile=1
fi
