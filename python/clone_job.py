import requests
import json
import yaml
import os
import re
import logging
import click

#api token should be set in DBT_CLOUD_API_KEY env var, IDs need to be set to appropriate values
api_token = os.getenv('DBT_CLOUD_API_KEY')


@click.command()
@click.option(
    "--account",
    "-a",
    "account_id",
    help="account id to work within",
    type = int,
    multiple=False,
    required=True
)

@click.option(
    "--project", 
    "-p",
    "project_id",
    help="project id to work within",
    type = int,
    multiple=False,
    required=True
)

@click.option(
    "-target-environment",
    "-e",
    "target_environment_id",
    help="target environment id to deploy the job to",
    type = int,
    multiple=False,
    required=True
)

@click.option(
    "--job", 
    "-j",
    "job_id",
    help="job id to clone",
    type = int,
    multiple=False,
    required=True
)

def clone_job(account_id, project_id, target_environment_id, job_id):

    jobs_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/jobs/{job_id}/"
    create_job_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/jobs/"

    headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
    }   

    get_job = requests.get(jobs_url, headers=headers)
    existing_job_def = json.loads(get_job.content)['data']

    target_job_def = json.dumps({
        "account_id": account_id,
        "project_id": project_id,
        "id": None,
        "environment_id": target_environment_id,
        "name": existing_job_def['name'],
        "dbt_version": existing_job_def['dbt_version'],
        "triggers": {
        "github_webhook": False,
        "schedule": False, #setting to false negates the schedule below - set to true to schedule
        "custom_branch_only": False
        },
        "execute_steps": [
        "dbt run",
        "dbt test",
        "dbt source snapshot-freshness"
        ],
        "settings": {
        "threads": existing_job_def['settings']['threads'],
        "target_name": existing_job_def['settings']['target_name']
        },
        "state": 1,
        "generate_docs": existing_job_def['generate_docs'],
        "schedule": existing_job_def['schedule']
    })

    create_job = requests.post(create_job_url, headers=headers, data=target_job_def)

    create_response = json.loads(create_job.content)

    print(create_response)

if __name__ == '__main__':
    clone_job()