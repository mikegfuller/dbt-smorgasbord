{% macro log_flag() %}

{{ log('>>>>>>>>flag is: ' ~ flags.WHICH, info=True) }}

{% endmacro %}