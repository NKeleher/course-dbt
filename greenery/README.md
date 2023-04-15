# Greenery Analytics - Data Workflow

This repository covers the data workflow for Greenery's product analytics.

## Structure

The directory is organized as follows

- `analyses`
- `dbt_packages`
- `logs`
- `macros`
- `models`
    - `staging`
        - `postgres`

# Testing models

```bash
dbt run --models _model_name
```

# Linting

```bash
sqlfluff lint models/staging/postgres/*.sql --dialect snowflake
```
