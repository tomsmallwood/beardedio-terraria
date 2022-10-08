deploy: validate login build push
exec: build run
  
push:
	aws --version && docker --version || exit 1
	aws ecr get-login-password --region eu-west-2 --profile 099867171230_TerrariaAdmin | docker login -u AWS --password-stdin 099867171230.dkr.ecr.eu-west-2.amazonaws.com || exit 1
	docker build ./ --file Dockerfile -t terraria-server:latest --tag "terraria-server" || exit 1
	docker push 099867171230.dkr.ecr.eu-west-2.amazonaws.com/terraria-server:latest

# check CLIs
validate: 
	aws --version && docker --version || exit 1

login:
  # docker login
	aws ecr get-login-password --region eu-west-2 --profile 099867171230_TerrariaAdmin | docker login -u AWS --password-stdin 099867171230.dkr.ecr.eu-west-2.amazonaws.com || exit 1

build:
	docker build ./ --file Dockerfile -t terraria-server:latest --tag "terraria-server" || exit 1

push:
    docker push 099867171230.dkr.ecr.eu-west-2.amazonaws.com/terraria-server:latest

run:
	docker run --rm -it -p 7777:7777 \
		-v ${PWD}/config:/config \
		-e world=asd.wld \
		--name=terraria \
		terraria-server:latest