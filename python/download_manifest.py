import requests
import json
from requests.api import head
import yaml
import os
import re

# set token and variables (need to get rid of this hardcoding nonsense)
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <your_account_id>
run_id = <your_run_id>

# base url for dbt cloud
base_url = "https://cloud.getdbt.com/api/v2/"

#endpoint to get manifest json file
manifest_endpoint = f"accounts/{account_id}/runs/{run_id}/artifacts/manifest.json"

#manifest url
manifest_url = base_url + manifest_endpoint

# set headers
headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

# hit artifacts endpoint and return manifest file
get_manifest = requests.get(manifest_url, headers=headers)
payload_manifest_file = json.loads(get_manifest.content)
formatted_manifest = json.dumps(payload_manifest_file, indent=2)

# output file in current working directory
manifest_filename = 'manifest.json'

# delete the existing file
try:
    os.remove(manifest_filename)
except OSError:
    pass

with open(manifest_filename, "a") as manifest:
    manifest.write(str(formatted_manifest))

