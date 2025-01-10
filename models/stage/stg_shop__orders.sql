with 
source as(

    select * from {{ source ('shop-data', 'orders')}}

),

transformed as (

  select 
  id order_id,
  user_id customer_id,
  order_date,
  status order_status,

  row_number() over(
    partition by user_id 
    order by order_date, id
    ) user_order_seq
    from source

)

select * from transformed