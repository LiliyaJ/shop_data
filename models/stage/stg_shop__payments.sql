{{ config( required_tests = None ) }}
with 

source as (
    select * from {{ source ('shop-data', 'payments')}}
),

transformed as (

  select 
    id payment_id,
    orderid order_id,
    status payment_status,
    PAYMENTMETHOD payment_method,
    amount,
    round(amount/100.0,2) payment_amount
  from source

)

select * from transformed
