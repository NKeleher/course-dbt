{{
  config(
    materialized = 'view'
  )
}}

SELECT
  address_id
  , address
  , state
  , lpad(zipcode, 5, 0) as zip_code
  , country
FROM {{ source('postgres', 'addresses') }}
