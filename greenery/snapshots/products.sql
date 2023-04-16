{% snapshot snapshot_inventory %}

{{
    config(
      target_database='dev_db',
      target_schema='dbt_niallkelehergmailcom',
      unique_key='product_id',
      strategy='check',
      check_cols=['inventory'],
    )
}}

SELECT * FROM {{ source('postgres', 'products') }}

{% endsnapshot %}
