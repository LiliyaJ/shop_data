# apply in yml file
{% test assert_column_greater_five(model, column) %}

select
    {{ column }}
from{{ model }}
where
    {{ column }} <= 5