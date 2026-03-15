with fact as (
    select * from {{ ref('fact_order_fulfillment') }}
),

dim_customer as (
    select * from {{ ref('dim_customer') }}
),

dim_employee as (
    select * from {{ ref('dim_employee') }}
),

dim_date as (
    select * from {{ ref('dim_date') }}
)

select
    -- Fact grain
    fact.orderid,
    fact.quantity,
    fact.totalorderamount,
    fact.freight,
    fact.daysfromordertoshipped,
    fact.daysfromordertorequired,
    fact.shippedtorequireddelta,
    fact.shippedontime,

    -- Customer dimension
    dim_customer.customerkey,
    dim_customer.companyname as customercompanyname,
    dim_customer.contactname as customercontactname,
    dim_customer.customercity,
    dim_customer.customercountry,

    -- Employee dimension
    dim_employee.employeekey,
    dim_employee.employeenamelastfirst,
    dim_employee.employeetitle,
    dim_employee.supervisornamelastfirst,

    -- Date dimensions (role-played)
    orderdate.date as orderdate,
    requireddate.date as requireddate,
    shippeddate.date as shippeddate,

    -- Degenerate shipment attributes
    fact.shippercompanyname,
    fact.shipname,
    fact.shipaddress,
    fact.shipcity,
    fact.shipregion,
    fact.shipcountry

from fact
left join dim_customer
    on fact.customerkey = dim_customer.customerkey
left join dim_employee
    on fact.employeekey = dim_employee.employeekey
left join dim_date as orderdate
    on fact.orderdatekey = orderdate.datekey
left join dim_date as requireddate
    on fact.requireddatekey = requireddate.datekey
left join dim_date as shippeddate
    on fact.shippeddatekey = shippeddate.datekey