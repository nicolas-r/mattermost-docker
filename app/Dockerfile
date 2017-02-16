FROM ubuntu:14.04

ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive

# Update & install package
RUN apt-get update && apt-get install -y curl netcat

RUN mkdir -p /mattermost/data
RUN curl https://releases.mattermost.com/3.6.2/mattermost-team-3.6.2-linux-amd64.tar.gz | tar -xvz
RUN rm /mattermost/config/config.json
COPY config.template.json /

COPY docker-entry.sh /
RUN chmod +x /docker-entry.sh
ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 8065
