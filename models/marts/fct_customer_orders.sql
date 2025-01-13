with

orders as (

    select * from {{ ref('int_orders') }}

),


customers as (

  select * from {{ ref('stg_shop__customers') }}

),

customer_orders as (
  
  select

    orders.*,
    customers.full_name,
    customers.surname,
    customers.givenname,
    
    -- customer level aggregations

    min(orders.order_date) over(
      partition by orders.customer_id
        ) customer_first_order_date,

    min(orders.valid_order_date) over(
      partition by orders.customer_id
        ) customer_first_non_returned_order_date,

    max(orders.valid_order_date) over(
      partition by orders.customer_id
        ) customer_most_recent_non_returned_order_date,

    count(*) over(
      partition by orders.customer_id
        ) customer_order_count,

    sum(case
      when orders.valid_order_date is not null then 1
      else 0
      end) over (
        partition by orders.customer_id
    ) as customer_non_returned_order_count,

   sum(case
      when orders.valid_order_date is not null then orders.order_value_dollars
      else 0
      end) over (
        partition by orders.customer_id
     ) as customer_total_lifetime_value,

    array_agg(orders.order_id) over (
      partition by orders.customer_id
    ) as customer_order_ids


  from orders
  inner join customers 
    on orders.customer_id = customers.customer_id


),

add_avg_order_values as (

    select

      *,

      customer_total_lifetime_value / customer_non_returned_order_count customer_avg_non_returned_order_value

    from customer_orders


),

final as (
    
  select 
    order_id,
    customer_id,
    surname,
    givenname,
    full_name,
    nvsr,
    customer_first_order_date,
    customer_order_count
    customer_total_lifetime_value,
    order_value_dollars,
    order_status,
    payment_status
    
  from add_avg_order_values

)

select * from final

