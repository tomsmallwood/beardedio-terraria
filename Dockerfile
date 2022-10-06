# stage 1
FROM debian:bullseye-slim

ENV TERRARIA_SERVER terraria-server-1444

RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg dirmngr ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && apt-key list | grep Xamarin \
    && apt-get purge -y --auto-remove gnupg dirmngr

# use latest version of mono
RUN echo "deb https://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get install -y mono-runtime \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# download and install Terraria
ADD "https://terraria.org/api/download/pc-dedicated-server/$TERRARIA_SERVER.zip" terraria-server.zip
RUN apt-get update && \
    apt-get install -y zip && \
    mkdir /tmp/terraria && \
    cp terraria-server.zip /tmp/terraria && \
    cd /tmp/terraria && \
    unzip -q terraria-server.zip && \
    mv */Linux /vanilla && \
    chmod +x /vanilla/TerrariaServer* && \
    apt-get purge -y --auto-remove zip && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Allow for external data
VOLUME ["/config"]

# link Worlds folder to /config
RUN mkdir -p /root/.local/share/Terraria && \
    ln -sT /config /root/.local/share/Terraria/Worlds

# Run the server
WORKDIR /vanilla
COPY run-vanilla.sh /vanilla/run.sh
ENTRYPOINT ["./run.sh"]