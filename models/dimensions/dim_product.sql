with stg_products as (
    select * from {{ source('northwind','Products') }}
),

stg_suppliers as (
    select * from {{ source('northwind','Suppliers') }}
),

stg_categories as (
    select * from {{ source('northwind','Categories') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['p.productid']) }} as productkey,
    p.productid,
    p.productname,
    p.supplierid,
    s.companyname as suppliercompanyname,
    p.categoryid,
    c.categoryname,
    c.description as categorydescription,
    p.quantityperunit,
    p.unitprice,
    p.unitsinstock,
    p.unitsonorder,
    p.reorderlevel,
    p.discontinued
from stg_products p
left join stg_suppliers s
    on p.supplierid = s.supplierid
left join stg_categories c
    on p.categoryid = c.categoryid