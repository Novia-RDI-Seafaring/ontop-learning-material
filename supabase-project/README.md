# Supabase Docker

This is a minimal Docker Compose setup for self-hosting Supabase. Follow the steps [here](https://supabase.com/docs/guides/hosting/docker) to get started.

# Notes: Windows Setup  
## Supabase Docker – Fix for `supabase-pooler` restart

### 🐛 Issue

When setting up Supabase locally on **Windows**, the `supabase-pooler` container may fail with the following error:

(SyntaxError) unexpected token: carriage return (code point U+000D)


This is caused by **Windows-style line endings (CRLF)** in the `volumes/pooler/pooler.exs` file, which gets evaluated by Elixir inside the container. Elixir expects **Unix-style (LF)** endings, and chokes on `CRLF`.

---

### ✅ Fix

1. Open the file `volumes/pooler/pooler.exs` in **VS Code**
2. Click `CRLF` in the bottom-right corner
3. Select `LF` to convert line endings
4. Save the file
5. Rebuild your containers:

```sh
docker compose down --volumes --remove-orphans
docker compose up --build
```

You might need to do the same for the `.env` and `docker-compose.yaml` files.  

# Add database extensions
I want to add the timescaledb and psotgis extensions by running the following commands in Supabase SQL editor
```sql
CREATE EXTENSION IF NOT EXISTS timescaledb;
CREATE EXTENSION IF NOT EXISTS postgis;
```
verify that it worked by
```sql
SELECT * 
FROM pg_extension
WHERE extname IN ('timescaledb', 'postgis');
```

# Using the Python API
## Create a client
o connect to your Supabase project from Python, create a client like this:
```python
from supabase import create_client, Client
import os

url: str = os.getenv("SUPABASE_PUBLIC_URL")
key: str = os.getenv("SERVICE_ROLE_KEY")

supabase: Client = create_client(url, key)
```

## Insert data
🔐 Use your `SERVICE_ROLE_KEY` for full backend access (e.g. inserts, updates, bypassing RLS).

>Notes: 
>- The Supabase Python client **only works with tables or views exposed through the public schema**.
>- If your actual table lives in another schema (like `my_schema`), you must create a **view in** `public` that points to it.

For example:
```sql
CREATE VIEW public.my_table AS
SELECT * FROM ais_data.my_table;
```
This allows you to access `my_table` via the Python API like so:
```python
supabase.table("my_table").insert(...).execute()
```

### Encountered Issues
**Write permissions:** When inserting into a view of a table that uses a `SERIAL` or `BIGINT GENERATED` column (e.g. `id`), we got this error:
```
permission denied for sequence ais_data_id_seq
```
This means the API user could not access the internal PostgreSQL sequence used to generate IDs.

**Solution:** To enable insert access via Supabase's API:

1. Grant access to the **sequence** used for auto-incrementing. his allows Supabase to call `nextval(...)` on the sequence when inserting rows.
```sql
GRANT USAGE, SELECT ON SEQUENCE ais_data.ais_data_id_seq TO service_role;
```
2. Grant access to the underlying base table. Even if you're inserting into a view, the base table must allow writes.
```sql
GRANT INSERT, SELECT, UPDATE ON ais_data.my_table TO service_role;
``` 
3. Grant access to the view in `public`. The view itself must allow the service_role to use it for data operations.
```sql
GRANT INSERT, SELECT, UPDATE ON public.my_table TO service_role;
```