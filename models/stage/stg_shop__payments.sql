with 

source as (
    select * from {{ source ('shop-data', 'payments')}}
),

transformed as (

  select 
    id payment_id,
    orderid order_id,
    status payment_status,
    round(amount/100.0,2) payment_amount
  from source

)

select * from transformed
