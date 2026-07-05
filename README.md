# Backend in Rails

A JSON API (users + contents) built with Rails 8, PostgreSQL, and JWT auth.

## Run with Docker

Everything runs in containers — you don't need Ruby or Postgres installed, just Docker.

### 1. Clone

```bash
git clone <repo-url>
cd backend-in-rails
```

### 2. Create a `.env` file

The app reads its config from `.env` (gitignored). Create one in the project root:

```dotenv
POSTGRES_USER=testuser
POSTGRES_PASSWORD=testpassword
POSTGRES_DB=testdb
RAILS_MAX_THREADS=5
RAILS_MASTER_KEY=<value from config/master.key>
```

> `RAILS_MASTER_KEY` must match `config/master.key` (ask the project owner if you don't have it) — it decrypts credentials in production.

### 3. Start it

```bash
docker compose up --build
```

This builds the app image, starts PostgreSQL, waits for it to be healthy, and runs
database setup + migrations automatically on boot.

### 4. Use it

The API is available at:

```
http://localhost:3000
```

Example — create a user:

```bash
curl -X POST http://localhost:3000/api/v1/users/signup \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Mark","lastName":"Doe","email":"mark@example.com","password":"Password1@"}'
```

### Stop

```bash
docker compose down          # stop containers
docker compose down -v       # stop and wipe the database volume
```

## Run the tests (without Docker)

```bash
bundle install
bin/rails db:test:prepare
bundle exec rspec
```
