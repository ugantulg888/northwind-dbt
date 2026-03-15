with stg_categories as (
    select * from {{ source('northwind','Categories') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['categoryid']) }} as categorykey,
    categoryid,
    categoryname,
    description as categorydescription
from stg_categories