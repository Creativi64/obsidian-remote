FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

LABEL maintainer="github@Creativi64.com" \
      org.opencontainers.image.authors="github@Creativi64.com" \
      org.opencontainers.image.source="https://github.com/Creativi64/obsidian-remote" \
      org.opencontainers.image.title="Container hosted Obsidian MD" \
      org.opencontainers.image.description="Hosted Obsidian instance allowing access via web browser"

# Set version label
# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8
# curl -L https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name? | match(".*amd64.deb")) | .browser_download_url'
# curl -L https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.tag_name'

RUN OBSIDIAN_INFO=$(curl -L https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '. | {url: (.assets[] | select(.name? | match(".*amd64.deb")) | .browser_download_url), tag: .tag_name}') && \
    OBSIDIAN_VERSION=$(echo "$OBSIDIAN_INFO" | jq -r '.tag') && \
    OBSIDIAN_DOWNLOAD_URL=$(echo "$OBSIDIAN_INFO" | jq -r '.url')

RUN echo "${OBSIDIAN_DOWNLOAD_URL}" 
RUN echo "${OBSIDIAN_VERSION}" 

    # Update and install extra packages
RUN echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl jq libgtk-3-0 libnotify4 libatspi2.0-0 libsecret-1-0 libnss3 desktop-file-utils fonts-noto-color-emoji git ssh-askpass && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Download and install Obsidian
RUN OBSIDIAN_DOWNLOAD_URL=$(curl -L https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name? | match(".*amd64.deb")) | .browser_download_url') && \
    echo "**** download obsidian ****" && \
    curl --location --output obsidian.deb "${OBSIDIAN_DOWNLOAD_URL}" && \
    dpkg -i obsidian.deb && \
    rm obsidian.deb

# Environment variables
ENV CUSTOM_PORT="8080" \
    CUSTOM_HTTPS_PORT="8443" \
    CUSTOM_USER="" \
    PASSWORD="" \
    SUBFOLDER="" \
    TITLE="Obsidian" \
    FM_HOME="/vaults"

# Add local files
COPY root/ /

# Expose ports and volumes
EXPOSE 8080 8443
VOLUME ["/config","/vaults"]

# Define a healthcheck
HEALTHCHECK CMD /bin/sh -c 'if [ -z "$CUSTOM_USER" ] || [ -z "$PASSWORD" ]; then curl --fail http://localhost:"$CUSTOM_PORT"/ || exit 1; else curl --fail --user "$CUSTOM_USER:$PASSWORD" http://localhost:"$CUSTOM_PORT"/ || exit 1; fi'
