{{log_flag()}}

select * from {{ref('model_log')}} where test_col = dateadd('day', -1, current_timestamp)