# check CLIs
aws --version && docker --version || exit 1

# docker login
aws ecr get-login-password --region eu-west-2 --profile 099867171230_TerrariaAdmin | docker login -u AWS --password-stdin 099867171230.dkr.ecr.eu-west-2.amazonaws.com || exit 1

# build
docker build ./ --file Dockerfile -t terraria-server:latest --tag "terraria-server" || exit 1

# push
docker push 099867171230.dkr.ecr.eu-west-2.amazonaws.com/terraria-server:latest