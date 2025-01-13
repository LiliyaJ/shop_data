-- transformations with Jinja
{%- set payment_methods = ['bank_transfer','coupon', 'credit_card', 'gift_card'] -%}

with

payments as (

    select * from {{ ref('stg_shop__payments') }}

),

pivoted as (

    select

        order_id,
        
        {% for payment_method in payment_methods -%}

        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) {{ payment_method }}_amount

        {%- if not loop.last -%}
            ,

        {%- endif %}

        {% endfor -%}
    
    from payments
    where payment_status = 'success'
    group by order_id
)

select * from pivoted
