FROM ubuntu:22.10

# Install app dependencies.
WORKDIR /usr/src/app
RUN apt-get update
RUN apt-get install wget unzip curl jq -y
RUN wget "https://github.com/boss-net/releases/latest/download/cli_linux_x86_64.zip"
RUN unzip cli_linux_x86_64.zip
RUN chmod +x ./tg
RUN rm cli_linux_x86_64.zip -f
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
