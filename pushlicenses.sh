#!/bin/bash

# license_finder report --format json --columns=name version licenses approved --enabled-package-managers gomodules > license.json
# sed -i '1d' license.json

# variables
host="local-core.gravitant.net"
token="mYTewSyVBNyZW_sp9PXt-isnqpdhbKc026u9vdJjHh2sOmI-ep4Q_vUp4D19UECf"
allowed='"allowed"'
denied='"denied"'
TRAVIS_COMMIT=12344
postToDevopsIntelligence() {
	CODE=$(curl --location --request POST -sSL -w '%{http_code}' ''"$1"'/dash/api/dev_secops/v1/services/testLicense/licenses?scannedBy=license_finder' \
 	--header 'Authorization: Token '"$2"'' \
	--header 'Content-Type: application/json' \
	--data-raw '{
			"license_name": '"$4"',
   			"status": '"$3"',
    	    "href":"github.com/urbandictionary",
		    "endpoint_hostname":"github.com"
			}' -k)
    if [[ "$CODE" == *"200"* ]]; then
    # server return 2xx response
        echo $CODE
    else
        echo "possibly a duplicate record response :: $CODE"
    fi
}

jq -r '.dependencies|keys[]' license.json | while read key ; do
    jqCmd=$(cat license.json | jq '.dependencies['$key'].licenses | map(.) |join(",")' )
    licenses="$jqCmd"
    status="$(jq '.dependencies['$key'].approved' license.json)"
    # printf "%s\t%s\t%s\t%s\n" "$name" "$version" "$licenses" "$allowed"
    # echo $allowed
    # echo "$allowed"
    # echo '"Not Approved"'
    case $status in 
      '"Approved"')
        # echo "OK"
        postToDevopsIntelligence $host $token $allowed "$licenses"
        ;;

      *)
        # echo "NOTOK"
        postToDevopsIntelligence $host $token $denied "$licenses"
        ;;
    esac    
done
