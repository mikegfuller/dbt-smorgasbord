import requests
import json
import os
import pandas as pd
import datetime

# set token and dbt Cloud account id
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <your_account_id>

#set the number of days to go back for _active users_
num_days = 90

# base url for dbt cloud
base_url = "https://cloud.getdbt.com/api/v2/"

#endpoint to get users
users_endpoint = f"accounts/{account_id}/users"

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

# json to table
df = pd.json_normalize(payload_user_response,
                           record_path="data",
                           max_level=0
                           )

#pare down fields
df = df[['id','first_name','last_name','email','last_login']]

#convert last_login to date
df['last_login'] = pd.to_datetime(df['last_login']).dt.date

#do some math to get the _n_ days ago date
today = datetime.date.today()
ago_days = datetime.timedelta(days = num_days)
ago_date = today - ago_days

#filter the dataframe using the ago_date
df = df[df['last_login'] > ago_date]

#output to csv
df.to_csv('active_users.csv', index=False)
