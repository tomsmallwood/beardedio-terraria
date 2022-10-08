all: build test

build:
	docker build ./ --file Dockerfile -t terraria-server:latest --tag "terraria-server"

test:
	docker run --rm -it -p 7777:7777 \
  -v ${PWD}/config:/config \
  -e world=asd.wld \
  --name=terraria \
  terraria-server:latest