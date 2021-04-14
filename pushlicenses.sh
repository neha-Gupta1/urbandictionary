#!/bin/bash
#.dependencies[] | {name: .name, version: .version, licenses:[.licenses], allowed: .approved}
# arr=($(jq -r '.dependencies[]' l.json))
#printf '%s\n' "${arr[@]}"
#for d in "${arr[@]}"
#do
#	echo $d
#done
$ok 'true'
$no 'false'
jq -r '.dependencies|keys[]' license.json | while read key ; do
    name="$(jq ".dependencies[$key].name" license.json)"
    version="$(jq ".dependencies[$key].version" license.json)"
    #jqCmd=( jq ".dependencies[$key].licenses | join(",")" l.json)
    jqCmd=$(cat license.json | jq '.dependencies['$key'].licenses | map(.) |join(",")' )
    licenses="$jqCmd"
    #fi
    allowed="$(jq '.dependencies['$key'].approved' license.json)"
    al=""
    if [[ $allowed == "Approved" ]]; then
        set al=$ok
    elif [[ $allowed == "Not approved" ]]; then
        set al=$no
    fi
    printf "%s\t%s\t%s\t%s\n" "$name" "$version" "$licenses" "$allowed"
done
