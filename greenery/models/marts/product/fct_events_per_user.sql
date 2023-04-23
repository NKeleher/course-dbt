{{
  config(
    materialized = 'view'
  )
}}

WITH events_per_user AS (
    SELECT
      event_type,
      user_id,
      COUNT(*) AS cnt
    FROM {{ref('stg_postgres__events')}}
    WHERE event_type IN ('add_to_cart', 'page_view')
    GROUP BY 1,2
)

SELECT
  event_type,
  AVG(cnt) AS avg_events
FROM events_per_user
GROUP BY event_type;
