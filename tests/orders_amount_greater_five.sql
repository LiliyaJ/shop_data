select
    amount
from{{ ref ('stg_shop__orders') }}
where
    amount <= 5