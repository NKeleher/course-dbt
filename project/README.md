# Project Stages

<details>
<summary>Week 1</summary>

## Week 1 Project Outputs

* I created dbt models in [greenery/models/staging/postgres](https://github.com/NKeleher/course-dbt/tree/main/greenery/models/staging/postgres)
* All models were run and materialized as views on Snowflake.
* I set up a [products_snapshot](https://github.com/NKeleher/course-dbt/blob/main/greenery/snapshots/products.sql)
* Responses to the question prompts

    > _How many users do we have?_

    There are 130 unique users.

    ```sql
    SELECT
        COUNT(DISTINCT user_id)
    FROM DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__USERS;
    ```

    > _On average, how many orders do we receive per hour?_

    On average, there were 7.52 orders per hour.

    ```sql
    WITH hourly_orders AS (
        SELECT
            DATE(created_at_utc) AS order_date,
            HOUR(created_at_utc) AS order_hour,
            COUNT(*) AS orders_per_hour
        FROM DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__ORDERS
        GROUP BY 1,2
    )

    SELECT
        AVG(orders_per_hour)
    FROM hourly_orders;
    ```

    > _On average, how long does an order take from being placed to being delivered?_

    On average, orders are delivered in 93.4 hours (approximately 3 days and 21 hours) from the time when the order is created.

    ```sql
    SELECT
        AVG(TIMESTAMPDIFF('hour', created_at_utc, delivered_at_utc)) AS avg_hours_to_delivery
    FROM DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__ORDERS
    WHERE order_status = 'delivered';
    ```

    > _How many users have only made one purchase? Two purchases? Three+ purchases?_
    > _Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase._

    There are 25 users with one order. 28 users with two orders. And 71 users have 3 or more purchases.

    ```sql
    WITH user_order_count AS (
        SELECT
            DISTINCT users.user_id,
            COUNT(*)
                OVER (PARTITION BY users.user_id) AS orders_per_user
        FROM DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__ORDERS AS orders
        LEFT JOIN DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__USERS AS users
            ON orders.user_id = users.user_id
        ORDER BY orders_per_user DESC
    )

    SELECT
        orders_per_user,
        COUNT(*) AS user_count
    FROM user_order_count
    GROUP BY orders_per_user
    ORDER BY orders_per_user ASC;
    ```

    > _On average, how many unique sessions do we have per hour?_

    There are 16.32 sessions per hour.

    ```sql
    WITH hourly_sessions AS (
        SELECT
            DATE(created_at_utc) AS order_date,
            HOUR(created_at_utc) AS order_hour,
            COUNT(DISTINCT session_id) AS sessions_per_hour
        FROM DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__EVENTS
        GROUP BY 1,2
    )

    SELECT AVG(sessions_per_hour) FROM hourly_sessions;
    ```
</details>

<details>
<summary>Week 2</summary>

## Week 2 Project Outputs

>  What is our user repeat rate?
> Repeat Rate = Users who purchased 2 or more times / users who purchased

124 users have made at least one purchase; of those 99 have made
more than one purchase. Thus the repeat rate is 79.8%.

```sql
WITH user_orders AS (
    SELECT
        user_id,
        COUNT(*) AS order_count
    FROM DEV_DB.DBT_NIALLKELEHERGMAILCOM.STG_POSTGRES__ORDERS
    GROUP BY user_id
    HAVING COUNT(*) > 0
)

SELECT
  COUNT(DISTINCT CASE WHEN order_count > 1 THEN user_id
END) AS repeat_users,
  COUNT(DISTINCT user_id) AS unique_users,
  repeat_users / unique_users AS repeat_user_ratio
FROM user_orders;
```

> What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

I hypothesize that
- users that have viewed more pages are more likely to make a repeat purchase;
- users that added items to their cart but have not yet purchased those items are also more likely to make a repeat purchase;
- users who have their first order delivered prior to or on the day of the expected delivery date are more likely to be a repeat customer.

> Create a marts folder, so we can organize our models

- I created fact tables for product analytics to track the average number of events per session (`greenery/models/marts/product/fct_events_per_session.sql`) and the average number of events per user (`greenery/models/marts/product/fct_events_per_user.sql`)

- I generated docs for the project using `dbt docs generate`

- I ran `dbt snapshot` to update the product inventory snapshot.

</details>
