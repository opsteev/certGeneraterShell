#!/bin/sh
#07-13-2015 Feng Ding
if test -x "/usr/bin/openssl" ; then
    echo "Openssl"
else
    echo "No openssl"
    exit 1
fi
if [ ! -f ./openssl.cnf ] ; then
    exit 1
fi
certdir=`date "+%Y%m%d%H%M%S"`
mkdir $certdir
cd $certdir
cp ../openssl.cnf ./
touch index.txt
openssl genrsa -des3 -out ca.key -passout pass:whatever 4096
openssl req -new -key ca.key -out ca.csr -days 3650 -config ./openssl.cnf  -batch
openssl req -x509 -in ca.csr -key ca.key -out ca.crt -days 3650 -config ./openssl.cnf -batch 

openssl genrsa -des3 -out server.key   -passout pass:whatever 4096
openssl req -new -key server.key -out server.csr -days 3650 -config ./openssl.cnf -subj "/C=CN/ST=Beijing/O=Aruba Networks/O=an HP company/OU=Aruba Instant (Server)/CN=www.fding.com" -batch
openssl ca -in server.csr -out server.crt -cert ca.crt -config ./openssl.cnf -keyfile ca.key  -extensions ssl_server  -passin pass:whatever -create_serial -batch

openssl genrsa -des3 -out client.key  -passout pass:whatever 4096
openssl req -new -key client.key -out client.csr -days 3650 -config ./openssl.cnf -subj "/C=CN/ST=Beijing/O=Aruba Networks/O=an HP company/OU=Aruba Instant (Client)/CN=Feng Ding (Client)"
openssl ca -in client.csr -out client.crt -cert ca.crt -config ./openssl.cnf -keyfile ca.key  -extensions ssl_client -passin pass:whatever -create_serial -batch

cat server.key server.crt > server.pem
cat client.key client.crt > client.pem
openssl pkcs12 -export -in client.pem -out client.pfx -passin pass:whatever -passout pass:whatever
cd ..
certfiledir=`date "+%Y%m%d%H%M%S"`
mkdir $certfiledir
cp ./$certdir/ca.crt ./$certfiledir/
cp ./$certdir/ca.key ./$certfiledir/
cp ./$certdir/server.pem ./$certfiledir/
cp ./$certdir/client.pem ./$certfiledir/
cp ./$certdir/client.pfx ./$certfiledir/
rm -rf $certdir
tar zcvf $certfiledir.tar.gz $certfiledir
rm -rf $certfiledir
exit 0
