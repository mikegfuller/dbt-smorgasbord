select 'this is schema 2' as descrip
from {{ ref('model_s1') }}