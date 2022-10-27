import requests
import json
import os

# set token and account
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <your_account>

# base url for dbt cloud
base_url = "https://cloud.getdbt.com/api/v2/"

#endpoint to get users
users_endpoint = f"accounts/{account_id}/users?limit=1000"

#users url
users_url = base_url + users_endpoint

# set headers
headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

# hit users endpoint
get_users = requests.get(users_url, headers=headers)
payload_user_response = json.loads(get_users.content)


#
for user in payload_user_response['data']:
        print(
    "UserID: " + str(user['id']) + "\n"
    "FirstName: " + user['first_name'] + "\n"
    "LastName: " + user['last_name'] + "\n"
    "LastLogin: " + user['last_login'] + "\n"
    "License Type: " + user['permissions'][0]['license_type'] + "\n"
    "Active: " + str(user['is_active']) + "\n"
    "----------------------------------------")


