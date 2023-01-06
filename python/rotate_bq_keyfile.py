import requests
import json
import os

api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <your account_id>
project_id = <your project_id
connection_id = <your connection_id>
keyfile = '<path/to/keyfile.json'

base_url = 'https://cloud.getdbt.com/api/v3/'

connection_endpoint = f"accounts/{account_id}/projects/{project_id}/connections/{connection_id}"
connection_url = base_url+connection_endpoint

# set headers
headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

with open(keyfile, "r") as f:
    bq_sa = json.load(f)

bq_sa_type = bq_sa['type']
bq_sa_project_id = bq_sa['project_id']
bq_sa_private_key_id = bq_sa['private_key_id']
bq_sa_private_key = bq_sa['private_key']
bq_sa_client_email = bq_sa['client_email']
bq_sa_client_id = bq_sa['client_id']
bq_sa_auth_uri = bq_sa['auth_uri']
bq_sa_token_uri = bq_sa['token_uri']
bq_sa_auth_provider_x509_cert_url = bq_sa['auth_provider_x509_cert_url']
bq_sa_client_x509_cert_url = bq_sa['client_x509_cert_url']

creds_data = json.dumps({
    "id": connection_id,
    "name": "Bigquery",
    "type": "bigquery",
    "details": {
        "retries": 1,
        "location": None,
        "timeout_seconds": 300,
        "project_id": bq_sa_project_id,
        "private_key_id": bq_sa_private_key_id,
        "private_key": bq_sa_private_key,
        "client_email": bq_sa_client_email,
        "client_id": bq_sa_client_id,
        "auth_uri": bq_sa_auth_uri,
        "token_uri": bq_sa_token_uri,
        "auth_provider_x509_cert_url": bq_sa_auth_provider_x509_cert_url,
        "client_x509_cert_url": bq_sa_client_x509_cert_url
    }
})

#update credentials
update_creds = requests.post(connection_url, headers=headers, data=creds_data)
resp_creds = json.loads(update_creds.content)

print(resp_creds['status']['code'])