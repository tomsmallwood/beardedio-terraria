# stage 1
FROM debian:bullseye-slim as builder

ENV TERRARIA_SERVER terraria-server-1445

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

# Stage 2
FROM debian:bullseye-slim as runner

WORKDIR /vanilla

# Run server as non-root
USER 1000
# copy vanilla server files from builder
COPY --chown=1000 --chmod=400 --from=builder /vanilla /vanilla
COPY --chown=1000 --chmod=500 --from=builder /vanilla/TerrariaServer* /vanilla
# copy world config files
COPY --chown=1000 --chmod=400 /config /config
COPY --chown=1000 --chmod=600 /config/*.wld /root/.local/share/Terraria/Worlds
COPY --chown=1000 --chmod=500 run-vanilla.sh /vanilla/run-vanilla.sh

# add link to worlds folder in /config
# RUN mkdir -p /root/.local/share/Terraria && \
#     ln -sT /config /root/.local/share/Terraria/Worlds

CMD ["./run-vanilla.sh"]
# ENTRYPOINT ["./run-vanilla.sh"]