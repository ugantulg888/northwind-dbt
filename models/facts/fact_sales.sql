with stg_order_details as (
    select
        orderid,
        productid,
        unitprice,
        quantity,
        discount
    from {{ source('northwind','Order_Details') }}
),

stg_orders as (
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from {{ source('northwind','Orders') }}
),

dim_product as (
    select productkey, productid from {{ ref('dim_product') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['od.orderid','od.productid']) }} as saleskey,
    od.orderid,
    dp.productkey,
    o.customerkey,
    o.employeekey,
    o.orderdatekey,

    -- Facts
    od.quantity,
    od.unitprice,
    od.discount,
    od.quantity * od.unitprice as extendedpriceamount,
    od.quantity * od.unitprice * od.discount as discountamount,
    od.quantity * od.unitprice * (1 - od.discount) as soldamount

from stg_order_details od
join stg_orders o
    on od.orderid = o.orderid
join dim_product dp
    on od.productid = dp.productid