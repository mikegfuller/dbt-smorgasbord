{%- macro scd2_cols(dt_col, key_col) -%}

{{dt_col}} as eff_from
,case when lead({{key_col}}) over(order by {{key_col}}, {{dt_col}}) = {{key_col}} then lead({{dt_col}}) over(order by {{key_col}}, {{dt_col}}) else null end as eff_to
,case when lead({{key_col}}) over(order by {{key_col}}, {{dt_col}}) = {{key_col}} then 'N' else 'Y' end as current_flg
    
{%- endmacro -%}