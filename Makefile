build:
	time docker build -t ludx/particl -t docker.io/ludx/particl:latest .

run:
	docker run -d --name particld -v /CHANGE/THIS:/root/.particl docker.io/ludx/particl:latest

start:
	docker start particld

stop:
	docker stop particld

rm:
	docker rm -f particld

logs:
	docker logs -f --tail 1000 particld

push:
	docker push docker.io/ludx/particl:latest
