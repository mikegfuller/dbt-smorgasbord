import requests
import json
import os

#inputs (should be refactored to be more user friendly)
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <account_id>
project_id = <project_id>
user_id = <user_id>
environment_name = 'Production'
private_key = os.getenv('SNOW_KEY')
passphrase = os.getenv('SNOW_PASSPHRASE')


#dbt cloud base URL (v3)
base_url = 'https://cloud.getdbt.com/api/v3/'

#environment url
env_endpoint = f"accounts/{account_id}/projects/{project_id}/environments/"
env_url = base_url+env_endpoint

# set headers
headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

#get environments in project
list_envs = requests.get(env_url, headers=headers)
response_list_envs = json.loads(list_envs.content)

#find environment based on name and return credentials ID
for env in response_list_envs['data']:
    if env['name'] == environment_name:
        cred_id = env['credentials_id']

#creds url
creds_endpoint = f"accounts/{account_id}/projects/{project_id}/credentials/{cred_id}/"
creds_url = base_url+creds_endpoint

creds_data = json.dumps({
  "id": cred_id,
  "account_id": account_id,
  "project_id": project_id,
  "state": 1,
  "threads": 1,
  "target_name": "default",
  "type": "snowflake",
  "schema": "dbt_smorgasbord",
  "auth_type": "keypair",
  "user": user_id,
  "private_key": private_key,
  "private_key_passphrase": passphrase
})

update_creds = requests.post(creds_url, headers=headers, data=creds_data)
resp_creds = json.loads(update_creds.content)

print(resp_creds['status']['code'])