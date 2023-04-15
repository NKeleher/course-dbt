{{
  config(
    materialized = 'view'
  )
}}

SELECT
  user_id
  , first_name
  , last_name
  , email
  , created_at::timestamp AS created_at_utc
  , updated_at::timestamp AS updated_at_utc
  , address_id
FROM {{ source('postgres', 'users') }}
