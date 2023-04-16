{{
  config(
    materialized = 'view'
  )
}}

SELECT
    order_id,
    user_id,
    promo_id,
    address_id,
    created_at::timestamp AS created_at_utc,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at::timestamp AS estimated_delivery_at,
    delivered_at::timestamp AS delivered_at_utc,
    status AS order_status
FROM {{ source('postgres', 'orders') }}
