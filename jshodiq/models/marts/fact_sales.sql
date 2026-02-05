{{ config(materialized='table') }}

with cte_payment_aggregated as (
    select
        payments_s.order_id,
        listagg(concat(payments_s.payment_type, ' (', payments_s.payment_type_count, ') '), ', ')
            within group (order by payments_s.payment_type_count desc) as payment_type_list,
        max(payments_s.payment_installments_max) as payment_installments_max
    from 
    (
        select
            payments.order_id,
            payments.payment_type,
            count(*) as payment_type_count,
            max(payments.payment_installments) as payment_installments_max
        from {{ ref('stg_payments') }} as payments
        group by payments.order_id, payments.payment_type
    ) as payments_s
    group by payments_s.order_id
)

select
    concat('ORD', row_number() over(order by order_items.order_id)) as order_item_id_glob,
    order_items.order_item_id as order_item_id_seq,
    orders.order_id,
    order_items.product_id,
    orders.customer_id,
    orders.order_status,
    order_items.price,
    order_items.freight_value,
    coalesce(order_items.price, 0) + coalesce(order_items.freight_value, 0) as payment_value,
    payments.payment_type_list,
    payments.payment_installments_max
from {{ ref('stg_order_items') }} as order_items
left join {{ ref('stg_orders') }} as orders
    on orders.order_id = order_items.order_id
left join cte_payment_aggregated as payments
    on payments.order_id = orders.order_id