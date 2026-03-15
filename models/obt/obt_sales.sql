with fact as (
    select * from {{ ref('fact_sales') }}
),

dim_customer as (
    select * from {{ ref('dim_customer') }}
),

dim_employee as (
    select * from {{ ref('dim_employee') }}
),

dim_product as (
    select * from {{ ref('dim_product') }}
),

dim_date as (
    select * from {{ ref('dim_date') }}
)

select
    -- Fact grain
    fact.saleskey,
    fact.orderid,
    fact.quantity,
    fact.unitprice,
    fact.discount,
    fact.extendedpriceamount,
    fact.discountamount,
    fact.soldamount,

    -- Customer attributes
    dim_customer.customerkey,
    dim_customer.companyname as customercompanyname,
    dim_customer.contactname as customercontactname,
    dim_customer.customercity,
    dim_customer.customercountry,

    -- Employee attributes
    dim_employee.employeekey,
    dim_employee.employeenamelastfirst,
    dim_employee.employeetitle,
    dim_employee.supervisornamelastfirst,

    -- Product attributes
    dim_product.productkey,
    dim_product.productname,
    dim_product.categoryname,
    dim_product.categorydescription,
    dim_product.suppliercompanyname,
    dim_product.quantityperunit,
    dim_product.unitprice as productunitprice,

    -- Date attributes
    orderdate.date as orderdate,
    orderdate.year as orderyear,
    orderdate.month as ordermonth,
    orderdate.day as orderday,
    orderdate.dayname as orderdayname

from fact
left join dim_customer
    on fact.customerkey = dim_customer.customerkey
left join dim_employee
    on fact.employeekey = dim_employee.employeekey
left join dim_product
    on fact.productkey = dim_product.productkey
left join dim_date as orderdate
    on fact.orderdatekey = orderdate.datekey