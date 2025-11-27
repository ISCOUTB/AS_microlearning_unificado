# Deploy FastAPI to Render (step-by-step)

This guide helps you deploy the FastAPI backend to Render so your mobile APK does not depend on a PC.

Why Render? Simple UI, free tier for web services, easy GitHub integration. Use Railway similarly if you prefer.

Pre-reqs:
- Repo pushed to GitHub (if not, push it)
- Render account (https://render.com)
- Environment variables: `DATABASE_URL`, `SECRET_KEY`, any other secrets used by `main.py` or `database.py`

Steps:

1) Push code to GitHub (root of repo should contain `requirements.txt`, `main.py`)

2) In Render -> New -> Web Service -> Connect GitHub -> select your repo

3) In "Environment" select "Python 3"

4) Build Command: leave blank (Render will use `pip install -r requirements.txt`) or set to:

   pip install -r requirements.txt

5) Start Command: use one of the following (better: gunicorn):

   gunicorn -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT

   or (if you prefer uvicorn)

   uvicorn main:app --host 0.0.0.0 --port $PORT

6) In Render dashboard -> Environment -> Add Environment Variables:
   - `DATABASE_URL` = <your-postgres-url>
   - `SECRET_KEY` = <your-secret>
   - Any other env vars required

7) Deploy. When finished you'll have a public HTTPS URL like `https://your-service.onrender.com`.

8) Update your Flutter app's `api_constants.dart` to use that URL (see next file).

Notes:
- If your app writes files (uploads), consider using a cloud storage (S3/GCS) and set credentials as env vars.
- If you need persistent DB, use Render's managed Postgres or keep using Railway's Postgres and set `DATABASE_URL` accordingly.
- If you prefer Docker, Render can build from your `Dockerfile` instead of using the Python runtime.
