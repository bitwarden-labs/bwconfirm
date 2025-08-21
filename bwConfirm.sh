#!/bin/bash
mp=$(echo $p0 | base64 -d)
if [[ -z "${set_server_url}" ]];
then
	/bw config server $bw_server_url
fi
/bw login --apikey
session_key="$(printf $mp | /bw unlock --raw)"

org_members="$(/bw list --session "$session_key" org-members --organizationid $organization_id | jq -c '.[] | select( .status == 1 )' | jq -c '.id' | tr -d '"')"
for member_id in ${org_members[@]} ;
	do /bw confirm --session $session_key org-member $member_id --organizationid $organization_id;
done
