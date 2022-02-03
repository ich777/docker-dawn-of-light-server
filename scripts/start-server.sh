#!/bin/bash
LAT_V="$(curl -s https://api.github.com/repos/Dawn-of-Light/DOLSharp/releases | grep 'tag_name' | head -1 | cut -d '"' -f4)"
CUR_V="$(find ${DATA_DIR} -name DoLv* | cut -d 'v' -f2)"

echo "---Version Check---"
if [ ! -f "${DATA_DIR}/DOLServer.exe" ]; then
   	echo "---Dawn of Light Server not found, downloading!---"
   	cd ${DATA_DIR}
   	if wget -q -nc --show-progress --progress=bar:force:noscroll -O DoL-$LAT_V.zip "https://github.com/Dawn-of-Light/DOLSharp/releases/download/$LAT_V/DOLServer_net45_Release.zip" ; then
		echo "---Successfully downloaded Dawn of Light Server v$LAT_V---"
	else
		echo "-----------------------------------------------------------------------------------------------------"
		echo "------------Can't download Dawn of Light Server v$LAT_V, putting server into sleep mode-----------"
		echo "-----------------------------------------------------------------------------------------------------"
        sleep infinity
	fi
    unzip -q ${DATA_DIR}/DoL-$LAT_V.zip
    rm ${DATA_DIR}/DoL-$LAT_V.zip
    touch ${DATA_DIR}/DoLv$LAT_V
elif [ "$LAT_V" != "$CUR_V" ]; then
    echo "---Newer version found, installing!---"
    cd ${DATA_DIR}
    mkdir ${DATA_DIR}/userbackup
    cp -R ${DATA_DIR}/config ${DATA_DIR}/userbackup/
    cp -R ${DATA_DIR}/logs ${DATA_DIR}/userbackup/
    cp -R ${DATA_DIR}/scripts ${DATA_DIR}/userbackup/
    cp ${DATA_DIR}/dol.sqlite* ${DATA_DIR}/userbackup/
    find . -maxdepth 1 -not -name 'userbackup' -print0 | xargs -0 -I {} rm -R {} 2&>/dev/null
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O DoL-$LAT_V.zip "https://github.com/Dawn-of-Light/DOLSharp/releases/download/$LAT_V/DOLServer_net45_Release.zip" ; then
		echo "---Successfully downloaded Dawn of Light Server v$LAT_V---"
	else
		echo "-----------------------------------------------------------------------------------------------------"
		echo "------------Can't download Dawn of Light Server v$LAT_V, putting server into sleep mode-----------"
		echo "-----------------------------------------------------------------------------------------------------"
        sleep infinity
	fi
    unzip -q ${DATA_DIR}/DoL-$LAT_V.zip
    rm ${DATA_DIR}/DoL-$LAT_V.zip
    touch ${DATA_DIR}/DoLv$LAT_V
    cp -R ${DATA_DIR}/userbackup/* ${DATA_DIR}
    rm -R ${DATA_DIR}/userbackup
elif [ "$LAT_V" == "$CUR_V" ]; then
    echo "---Dawn of Light Server Version up-to-date---"
else
 	echo "---Something went wrong, putting server in sleep mode---"
 	sleep infinity
fi

echo "---Preparing Server---"
if [ ! -f "${DATA_DIR}/config/serverconfig.xml" ]; then
    echo "---No server configuration found, creating template---"
    if [ ! -d "${DATA_DIR}/config" ]; then
        mkdir -p ${DATA_DIR}/config
    fi
    cp /tmp/serverconfig.xml ${DATA_DIR}/config/serverconfig.xml
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null

cd ${DATA_DIR}
screen -S DoL -L -Logfile ${DATA_DIR}/masterLog.0 -d -m mono ${DATA_DIR}/DOLServer.exe ${GAME_PARAMS}
sleep 2
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -f ${DATA_DIR}/masterLog.0
