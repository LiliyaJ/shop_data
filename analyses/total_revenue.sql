with 
payments as(

    select * from {{ ref('stg_shop__payments') }}

)

select
    sum(case when payment_status = 'success' then amount else 0) successed_payments
from payments