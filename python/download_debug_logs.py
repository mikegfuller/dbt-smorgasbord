import requests
import json
from requests.api import head
import yaml
import os
import re

# set token and variables (need to get rid of this hardcoding nonsense)
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <account_id>
job_id = <job_id>
run_id = <run_id>

# endpoint to get steps
steps_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/runs/{run_id}/?include_related=[\"run_steps\"]"

# set headers
headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

# hit steps endpoint and return content
list_steps = requests.get(steps_url, headers=headers)
payload_list_steps = json.loads(list_steps.content)

# output file in same directory
debug_log_filename = 'dbt_cloud_api_debug_logs.log'

# delete the existing file
try:
    os.remove(debug_log_filename)
except OSError:
    pass

# for each step get the id
for step in payload_list_steps['data']['run_steps']:

    step_id = step['id']

# pass the id in to the debug logs endpoint
    debug_logs_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/steps/{step_id}/?include_related=[\"debug_logs\"]"

# get request to steps endpoint
    get_debug_logs = requests.get(debug_logs_url, headers=headers)

    payload_debug_logs = json.loads(get_debug_logs.content)

# traverse to debug logs key
    debug_logs = payload_debug_logs['data']['debug_logs']

# write(append) debug logs to the target file for all steps in the job
# this could probably use some cleanup
    with open(debug_log_filename, "a") as logfile:
        logfile.write(str(debug_logs))