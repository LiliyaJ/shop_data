with

orders as (

  select 
  *,
    -- new vs returning customer
    case  
      when (
      rank() over (
      partition by customer_id
      order by order_date, order_id
      ) = 1
    ) then 'new'
    else 'return' end as nvsr,


  from {{ ref('stg_shop__orders') }}

),

payments as (

  select * from {{ ref('stg_shop__payments') }}
  where payment_status != 'fail'

),

order_totals as (

  select

    order_id,
    payment_status,
    sum(payment_amount) order_value_dollars

  from payments
  group by order_id, payment_status

),

order_values_joined as (

  select

    orders.*,
    order_totals.payment_status,
    order_totals.order_value_dollars

  from orders
  left join order_totals
    on orders.order_id = order_totals.order_id

)

select * from order_values_joined
