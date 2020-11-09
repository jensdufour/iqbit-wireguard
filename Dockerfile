FROM alpine:latest

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	findutils \
	jq \
	openssl \
	p7zip \
	python3 \
	rsync \
	tar \
	transmission-cli \
	transmission-daemon \
	unrar \
	unzip && \
 echo "**** install transmission ****" && \
 if [ -z ${TRANSMISSION_VERSION+x} ]; then \
	TRANSMISSION_VERSION=$(curl -s http://dl-cdn.alpinelinux.org/alpine/v3.12/community/x86_64/ \
	| awk -F '(transmission-cli-|.apk)' '/transmission-cli.*.apk/ {print $2}'); \
 fi && \
 apk add --no-cache \
	transmission-cli==${TRANSMISSION_VERSION} \
	transmission-daemon==${TRANSMISSION_VERSION} && \
 echo "**** install wireguard ****" && \
 apk add --no-cache \
	openssh \ 
	wireguard-tools \ 
	wireguard-virt && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# copy wireguard interface
RUN mkdir -p /etc/wireguard/config
ADD wireguard/ /etc/wireguard/config/

# copy local files
ADD root/ /

# Add the iQbit Theme
ADD iqbit/ /theme/

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch