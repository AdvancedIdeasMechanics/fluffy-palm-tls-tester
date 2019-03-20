#!/usr/bin/env bash

# Created by Advanced Ideas & Mechanics, LLC.
# User: Matthew Pallotta
# Date: 03/14/19
# Time: 8:10 PM

SERVER=$1
PORT=$2

TLSS="ssl2 ssl3 tls1 tls1_1 tls1_2 tls1_3"

echo "Checking ${SERVER}....YES"
for TLS in ${TLSS[@]}
do
	echo " "
        echo -n Testing $TLS....
        TLSRESULT=$(echo -n | openssl s_client -$TLS -host $SERVER -port $PORT 2>&1)
        if [[ "$TLSRESULT" =~ "New, (NONE)" ]] ; then
                error=$(echo -n $TLSRESULT | cut -d':' -f6)
                echo NO
        else
                if [[ "$TLSRESULT" =~ "TLSv1/SSLv3" ]] ; then
                        echo YES
			if [[ "$TLSRESULT" =~ "Protocol  : TLSv1.1" || "Protocol  : TLSv1"  || "Protocol  : TLSv1" ]] ; then
				TLSCIPHER="-tls1"
				CIPHERS=$(openssl ciphers $TLSCHIPER | sed -e 's/:/ /g')
                        	for CIPHER in ${CIPHERS[@]}
                        	do
                                	echo -n "        $CIPHER...."
					CIPHERRESULT=$(echo -n | openssl s_client -$TLS -cipher "$CIPHER" -host $SERVER -port $PORT 2>&1)
                                	if [[ "$CIPHERRESULT" =~ ":error:" ]] ; then
                                        	echo NO
                                	else
                                        	if [[ "$CIPHERRESULT" =~ "Cipher is ${CIPHER}" ]] ; then
                                                	echo YES
                                        	else
							if [[ "$CIPHERRESULT" =~ "New, (NONE), Cipher is (NONE)" ]] ; then
								echo No
							else 
								echo UNKOWN RESPONSE
								echo $CIPHERRESULT
							fi
                                        	fi

                                	fi
                        	done
			fi
                fi
        fi
done
