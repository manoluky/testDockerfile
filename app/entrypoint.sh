#!/bin/bash
RAMA=$1
REPOSITORIO=$2
TAG=$3
NAV=$4
cd /opt
chmod +x clone.sh
chmod +x testgradle.sh
chmod +x report.sh
sh clone.sh ${RAMA} ${REPOSITORIO}
cd /opt/framework
cp /opt/testgradle.sh /opt/framework
cp /opt/report.sh /opt/framework
sh testgradle.sh ${TAG} ${NAV}

