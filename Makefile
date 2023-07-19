create_model:
	cd server && sqlboiler mysql -c database/database.toml -o internal/domain/models -p models --no-tests --wipe
db:
	docker compose exec db mysql -u sharely -D sharely -p
