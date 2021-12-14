select 1 as id, 'pending' as status_desc, current_timestamp as updated_at
union all
select 2 as id, 'filled' as status_desc, current_timestamp as updated_at
union all
select 3 as id, 'canceled' as status_desc, current_timestamp as updated_at
union all
select 4 as id, 'picked' as status_desc, current_timestamp as updated_at
union all
select 5 as id, 'pending' as status_desc, current_timestamp as updated_at
union all
select 6 as id, 'shipped' as status_desc, current_timestamp as updated_at
union all
select 7 as id, 'delayed' as status_desc, current_timestamp as updated_at
union all
select 8 as id, 'on-hold' as status_desc, current_timestamp as updated_at
union all
select 9 as id, 'filled' as status_desc, current_timestamp as updated_at
union all
select 10 as id, 'filled' as status_desc, current_timestamp as updated_at