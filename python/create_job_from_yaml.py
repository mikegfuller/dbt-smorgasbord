import requests
import json
from requests.api import head
import yaml
import os

def get_jobs():
    r_list_jobs = requests.get(jobs_url, headers=headers)
    payload_list_jobs = json.loads(r_list_jobs.content)

    job_names = []
    if payload_list_jobs['data'] is not None:
        for i in payload_list_jobs['data']:
            job_names.append(str(i['project_id']) + '-' + str(i['environment_id']) + '-' + i['name'])

        return(job_names)


def create_job(jobs_endpoint, headers_input):
    job_config_input = job_config["jobs"][job]['definition']
    job_config_input['account_id'] = account_id
    job_config_input['project_id'] = project_id
    job_config_input['environment_id'] = environment_id
    payload = json.dumps(job_config_input)

    r_create_job = requests.request(
        "POST", jobs_endpoint, headers=headers_input, data=payload)

    create_response = json.loads(r_create_job.content)

    print(create_response['status']['user_message'])


with open('job_config.yml', 'r') as config_file:
    job_config = yaml.safe_load(config_file)

for job in job_config['jobs']:
    for target in job_config['jobs'][job]['targets']:

        account_id = job_config['jobs'][job]['targets'][target]['account_id']
        project_id = job_config['jobs'][job]['targets'][target]['project_id']
        environment_id = job_config['jobs'][job]['targets'][target]['environment_id']
        name = job_config['jobs'][job]['definition']['name']

        api_token = os.getenv('DBT_CLOUD_API_KEY')
        jobs_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/jobs/"
        headers = {
            'Authorization': f"Token {api_token}",
            'Content-Type': 'application/json'
        }

        current_jobs = get_jobs()

        if str(project_id) + "-" + str(environment_id) + "-" + name not in current_jobs:
            create_job(jobs_url, headers)

        else:
            print("found job " + name.upper() + " in project " +
                  str(project_id) + " and envrionment " + str(environment_id) + ", this is where the update logic should go")