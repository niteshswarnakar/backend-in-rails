run:
	rails server

up:
	docker compose up -d

down:
	docker compose down

db-migrate:
	bin/rails db:migrate

console:
	bin/rails console
