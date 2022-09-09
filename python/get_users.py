import requests
import json
import os

# set token and variables (need to get rid of this hardcoding nonsense)
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <your_account>

# base url for dbt cloud
base_url = "https://cloud.getdbt.com/api/v2/"

#endpoint to get manifest json file
users_endpoint = f"accounts/{account_id}/users"

#manifest url
users_url = base_url + users_endpoint

# set headers
headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

# hit artifacts endpoint and return manifest file
get_users = requests.get(users_url, headers=headers)
payload_user_response = json.loads(get_users.content)
#formatted_users = json.dumps(payload_user_response, indent=2)

for user in payload_user_response['data']:
    print(
    "UserID: " + str(user['id']) + "\n"
    "FirstName: " + user['first_name'] + "\n"
    "LastName: " + user['last_name'] + "\n"
    "LastLogin: " + user['last_login'] + "\n"
    "----------------------------------------")


