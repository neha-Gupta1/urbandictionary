#!/bin/bash

# license_finder report --format json --columns=name version licenses approved --enabled-package-managers gomodules > license.json
# sed -i '1d' license.json

# variables
host="https://dev-secops-core.multicloud-ibm.com"
token="Nh-UYsQoL-2i4rhyEQrAm-ZUWjex4DOdR4F4UIewBKvR1TegDkpv0HLa88BdH6Rp"
allowed=("MIT" "GPL")
denied=("New BSD")
branch=$(echo "\"$TRAVIS_BRANCH\"")
repo=$(echo "\"$TRAVIS_REPO_SLUG\"")
# TRAVIS_COMMIT=12344

postToDevopsIntelligence() {
	echo $branch "\"$branch\"" "\"$repo\""
	CODE=$(curl --location --request POST -sSL -w '%{http_code}' ''"$1"'/dash/api/dev_secops/v1/services/newTestLicense/licenses?scannedBy=license_finder' \
 	--header 'Authorization: Token '"$2"'' \
	--header 'Content-Type: application/json' \
	--data-raw '{
			"license_name": '"$4"',
   			"status": '"$3"',
    	    "href":"github.com/urbandictionary",
		    "endpoint_hostname":"github.com",
		    "commit":'"$branch"'
			}' -k)
    if [[ "$CODE" == *"200"* ]]; then
    # server return 2xx response
        echo $CODE
    else
        echo "possibly a duplicate record response :: $CODE"
    fi
}


# list=$(license_finder --prepare-no-fail --format=json --no-recursive --no-debug | awk '!/^[A-Z]/' | jq '.dependencies[].licenses[]')
listcsv=$(license_finder --prepare-no-fail --format=csv --no-recursive --no-debug | awk '!/^[A-Z]/' > ll.csv)


arr=()

while IFS="," read -r rec_column1 rec_column2 rec_column3 
do
  arr+=("$rec_column3")
done < <(tail -n +2 ll.csv)

echo "Done"
echo "Allowed Licenses : "${allowed[@]}
echo "Denied Denied : "${denied[@]}

# uniques=($(for v in "${arr[@]}"; do echo "'$v'";done| sort| uniq| xargs))

IFS=$'\n' uniques=(`printf "%s\n" "${arr[@]}" |sort -u`)

# uniques=($(printf "%s\n" "${arr[@]}" | sort -u))

echo "Done" 
for v in "${uniques[@]}";do
  echo "$v"
done

for i in "'${uniques[@]}'"
do
  for a in "${allowed[@]}" 
  do
    if [ "$i" == "$a" ]; then
        echo $i is "Allowed"
        # postToDevopsIntelligence $host $token 
        continue
    fi
  done
done


for i in "${uniques[@]}"
do
  for b in "${denied[@]}" 
  do
    if [ "$i" == "$b" ]; then
        echo $i is "denied"
        # postToDevopsIntelligence $host $token 
        continue
    fi
  done
done
