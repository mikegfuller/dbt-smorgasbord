import requests
import json
from requests.api import head
import yaml
import os
import re

#api token should be set in an env var, IDs need to be set to appropriate values
api_token = os.getenv('DBT_CLOUD_API_KEY')
account_id = <account_id>
job_id = <job_id>
run_id = <run_id>

#jobs endpoint that includes the run steps info
jobs_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/runs/{run_id}/?include_related=[\"run_steps\"]"

headers = {
    'Authorization': f"Token {api_token}",
    'Content-Type': 'application/json'
}

#get job info with run steps
r_list_jobs = requests.get(jobs_url, headers=headers)
payload_list_jobs = json.loads(r_list_jobs.content)

#create a list of tasks that include "Invoke dbt with `<execute step>`"
#right now this is done by looking for the `` ticks, that may need to be more explicit
#the returned list includes the index (i.e. execute order), the human readable status name, and the actual command

steps_with_status = []
for step in payload_list_jobs['data']['run_steps']:
    if re.search(r"(?<=\`)(.*?)(?=\`)",step['name']) is not None:
        steps_with_status.append([step['index'],step['status_humanized'],re.search(r"(?<=\`)(.*?)(?=\`)",step['name']).group(0)])

#return the task that failed - the assumption that there will only be one
error_task = []
for step in steps_with_status:
    if step[1] in "Error":
        error_task.append(step[2])

#return all tasks that were skipped
skipped_tasks = []
for step in steps_with_status:
    if step[1] in "Skipped":
        skipped_tasks.append(step[2])

#get run_results.json for the run id that contains a faillure
run_results_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/runs/{run_id}/artifacts/run_results.json"
r_run_results = requests.get(run_results_url, headers=headers)

payload_run_results = json.loads(r_run_results.content)

#return the unique id (fully qualified name) of the model(s) that failed
output_payload_run_results = [x['unique_id'] for x in payload_run_results['results'] if x['status'] == 'error']

#strip off the first 2 parts of the fully qualified name, leaving the model name itself and append the '+' selection syntax
failed_model = ''.join(output_payload_run_results).split('.')[2] + '+'

#construct the new execute step command for the failed step
#should look something like dbt run --models failed_model+
restart_from_failed_model = [s + " --models " + failed_model for s in error_task]

#concat the failed and skipped steps to build the new execute step
all_restart_steps = restart_from_failed_model + skipped_tasks

#trigger job with steps_override
run_url = f"https://cloud.getdbt.com/api/v2/accounts/{account_id}/jobs/{job_id}/run/"
run_data = json.dumps({"cause": "Triggered by some Python, yo!", "steps_override": all_restart_steps})
trigger_job = requests.post(run_url, headers=headers, data=run_data)

payload_trigger_job = trigger_job.json()
print(payload_trigger_job['status']['code'])