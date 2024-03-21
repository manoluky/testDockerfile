#!/bin/bash
RAMA=$1
REPOSITORIO=$2
mkdir /opt/framework
git clone -b $RAMA $REPOSITORIO /opt/framework
chmod 755 /opt/framework
cd /opt/framework/
