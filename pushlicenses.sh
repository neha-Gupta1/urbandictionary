#!/bin/bash

# license_finder report --format json --columns=name version licenses approved --enabled-package-managers gomodules > license.json
# sed -i '1d' license.json

# variables
host="dev-secops-core.multicloud-ibm.com"
token="Nh-UYsQoL-2i4rhyEQrAm-ZUWjex4DOdR4F4UIewBKvR1TegDkpv0HLa88BdH6Rp"
allowed='"allowed"'
denied='"denied"'

postToDevopsIntelligence() {
	echo $1 $2 $3 $4 "$TRAVIS_COMMIT"
# 	curl --location --request POST ''"$1"'/dash/api/dev_secops/v1/services/testLicense/licenses?scannedBy=license_finder' \
#  	--header 'Authorization: Token '"$2"'' \
# 	--header 'Content-Type: application/json' \
# 	--data-raw '{
# 			"license_name": '"$4"',
#    			"status": '"$3"',
#     	    "href":"github.com/urbandictionary",
# 		    "endpoint_hostname":"github.com",
#             "commit": '"$TRAVIS_COMMIT"'
# 			}' -k
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
