with stg_customers as (
  select * from {{ source('northwind','Customers') }}
)

select
  {{ dbt_utils.generate_surrogate_key(['stg_customers.customerid']) }} as customerkey,
  stg_customers.customerid,
  stg_customers.companyname,
  stg_customers.contactname,
  stg_customers.contacttitle,
  stg_customers.address as customeraddress,
  stg_customers.city as customercity,
  stg_customers.region as customerregion,
  stg_customers.postalcode as customerpostalcode,
  stg_customers.country as customercountry,
  stg_customers.phone as customerphone,
  stg_customers.fax as customerfax
from stg_customers