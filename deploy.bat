echo ============================== 
echo   DEPLOYING APEX + LWC         
echo ============================== 
sf project deploy start --source-dir force-app --target-org rinkeshrayewar702-tjzu@force.com 
echo ============================== 
echo   DEPLOYING OMNISTUDIO METADATA 
echo ============================== 
vlocity packDeploy -sfdx.username rinkeshrayewar702-tjzu@force.com -job vlocity\build.json 
echo ============================== 
echo   DEPLOYMENT COMPLETED         
echo ============================== 
