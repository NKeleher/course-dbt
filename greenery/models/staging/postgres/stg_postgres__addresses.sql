{{
  config(
    materialized = 'view'
  )
}}

SELECT
    address_id,
    address,
    state,
    country,
    lpad(zipcode, 5, 0) AS zip_code
FROM {{ source('postgres', 'addresses') }}
