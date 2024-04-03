#!/bin/bash
RAMA=$1
REPOSITORIO=$2
TAG=$3
NAV=$4
chmod 777 /opt/
cd /opt
chmod +x clone.sh
chmod +x testgradle.sh
sh clone.sh ${RAMA} ${REPOSITORIO}
cd /opt/framework
cp /opt/testgradle.sh /opt/framework
sh testgradle.sh ${TAG} ${NAV}

