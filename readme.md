# The shell script to generate self-signed certificates


<p>This shell script can help generate a serial of self-signed certificates</p>
<p>Include ca.pem. intermidiate ca.pem server.pem client.pfx</p>

<p>Required:</p>
<p>openssl version > 1.0</p>

<p>Execute steps (make sure CertGenerater.sh and openssl.cnf in the same directory):</p>
<pre>
chmod +x CertGenerater.sh
./CertGenerater.sh
</pre>
