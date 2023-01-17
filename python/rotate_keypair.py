import requests
import json
import os

#inputs
account_id = <your_account_id>
project_id = <your_project_id>
environment_id = <your_environment_id>

#set these env vars on local machine after a keypair has been generated and added to snowflake
api_token = os.getenv('DBT_CLOUD_API_KEY')
keyfile = os.getenv('SNOW_KEYFILE_PATH')
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

#return credentials id for specified environment id
for env in response_list_envs['data']:
    if env['id'] == environment_id:
        cred_id = env['credentials_id']

#creds url
creds_endpoint = f"accounts/{account_id}/projects/{project_id}/credentials/{cred_id}/"
creds_url = base_url+creds_endpoint

#get current cred settings
get_creds = requests.get(creds_url, headers=headers)
resp_cred = json.loads(get_creds.content)

#set current values for post
cur_target_name = resp_cred['data']['target_name']
cur_user = resp_cred['data']['user']
cur_role = resp_cred['data']['role']
cur_database = resp_cred['data']['database']
cur_warehouse = resp_cred['data']['warehouse']
cur_schema = resp_cred['data']['schema']

#get private key
with open(keyfile, 'r') as file:
    private_key = file.read()

#data to update creds
creds_data = json.dumps({
  "id": cred_id,
  "account_id": account_id,
  "project_id": project_id,
  "type": "snowflake",
  "state": 1,
  "threads": 1,
  "auth_type": "keypair",
  "schema": cur_schema,
  "user": cur_user,
  "target_name": cur_target_name,
  "role": cur_role,
  "database": cur_database,
  "warehouse": cur_warehouse,
  "private_key": private_key,
  "private_key_passphrase": passphrase
})

#update credentials
update_creds = requests.post(creds_url, headers=headers, data=creds_data)
resp_creds = json.loads(update_creds.content)

print(resp_creds['status']['code'])