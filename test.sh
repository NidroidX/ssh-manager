serverKeyFile=$(echo "192.168.157.110-rvvmb3901pl,psm.regione.veneto.it,22,filippo-farinazzo@root@192.168.157.110,dvb8mfb2wbt1dzkXWF,,," | awk -F, '{print $6}')

if [ -z $serverKeyFile]
then 
echo "ciao" 
fi

