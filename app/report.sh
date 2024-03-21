#!/bin/bash
JTOKEN=$!

# Busqueda de informe de pruebas
REPORT=$(find /opt/framework/results -type f -iname "*.pdf")
echo $REPORT

# Creacion de Test Execution o Sub-test Execution
echo "Generando token"
export token=$(curl -H "Content-Type: application/json" -X POST --data @"infra/cloud_auth.json" https://xray.cloud.getxray.app/api/v2/authenticate| tr -d '"')
echo $token
echo "Token Generado"
echo "Cargando TestExecution"
echo ${TP}
echo ${TE}
export INFO=''
if [ $OP = TE ]; then
 INFO=infoTE.json
 echo "Entre a TE"
 sed -i '' -e "s|TE|${TE}|g" infra/${INFO} || true
 chmod +x searchTP.sh
 sh searchTP.sh $TE
 cat tpe.txt
 export TP=$(grep "RQA-" tpe.txt | cut -d '"' -f 8)
 echo $TP
elif [ $OP = TP ]; then
 INFO=infoTP.json
 echo "Entre a TP"
else
 echo "No se encuentra opción de ejecucion"
fi

# Reemplazo de valores en info.json
sed -i '' -e "s|TP|${TP}|g" infra/${INFO} || true
sed -i '' -e "s|DES|${USUARIO}|g" infra/${INFO} || true

# Adjunto del reporte de pruebas a Jira
curl -H "Authorization: Bearer $token" -X POST 'https://xray.cloud.getxray.app/api/v2/import/execution/cucumber/multipart' -H "Content-Type:multipart/form-data" -F 'info=@"infra/'${INFO}'"' -F 'results=@"results/Cucumber.json"' > log.txt
cat log.txt
export TESTEXECUTION=$(grep "RQA-" log.txt | cut -d '"' -f 8)
echo "ID de ejecucion: $TESTEXECUTION"
echo "Attachment para ejecucion"
export url=https://banchile.atlassian.net/rest/api/3/issue/$TESTEXECUTION/attachments
echo $url
echo "imprimiendo InfoTE"
cat infra/infoTE.json
TIEMPO_TRANSCURRIDO=$(cat tiempo_transcurrido.txt)
HORA_CHILE=$(TZ="America/Santiago" date +"%H:%M:%S")

curl -H 'Authorization: Basic '$JTOKEN' ' -X POST $url -H 'Content-Type: multipart/form-data' -H 'X-Atlassian-Token: no-check' -F 'file=@"$REPORT"'
