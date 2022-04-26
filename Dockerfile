FROM alpine:3

ARG FILEBROWSER_VERS=v2.21.1
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN apk --update add ca-certificates \
                     mailcap \
                     curl

RUN if [ "$TARGETOS" != "linux" ]; then exit 1; fi; \
    if [ "$TARGETARCH" = "arm" ]; then arch="arm${TARGETVARIANT}"; \
        elif [ "$TARGETARCH" = "arm64" ]; then arch="arm64"; \
        elif [ "$TARGETARCH" = "amd64" ]; then arch="amd64"; \
        else echo "Unsupported target"; exit 1; fi \
    && curl -fsSL -o filebrowser.tar.gz https://github.com/filebrowser/filebrowser/releases/download/${FILEBROWSER_VERS}/linux-${arch}-filebrowser.tar.gz \
    && mkdir -p /opt/filebrowser \
    && tar -xzvf filebrowser.tar.gz -C /opt/filebrowser \
    && rm -f filebrowser.tar.gz

EXPOSE 8080

RUN mkdir -p /etc/filebrowser /data
COPY ./config.json /etc/filebrowser/.filebrowser.json

COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
