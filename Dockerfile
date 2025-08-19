FROM debian:bookworm
WORKDIR /

COPY ./bwConfirm.sh /
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y curl \
	tzdata \
	unzip \
	jq 
RUN /bin/bash
RUN curl -Ls -o bw.zip 'https://vault.bitwarden.com/download/?app=cli&platform=linux' && unzip bw.zip && chmod +x ./bw
ENTRYPOINT ["/bwConfirm.sh"]
