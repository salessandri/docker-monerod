FROM ubuntu:20.04

LABEL maintainer="Santiago Alessandri <santiago@salessandri.name>"

ARG MONERO_VERSION=0.17.1.9
ARG MONERO_SHA256=0fb6f53b7b9b3b205151c652b6c9ca7e735f80bfe78427d1061f042723ee6381
ARG UID=1337

RUN useradd --uid ${UID} --user-group \
        --shell /bin/bash --create-home --home-dir /home/monero --no-log-init monero && \
    mkdir /home/monero/.bitmonero && chown monero:monero /home/monero/.bitmonero

RUN apt-get update && apt-get install -y \
  curl && \
  curl https://downloads.getmonero.org/cli/monero-linux-x64-v${MONERO_VERSION}.tar.bz2 -O && \
  echo "${MONERO_SHA256}  monero-linux-x64-v${MONERO_VERSION}.tar.bz2" | sha256sum -c - && \
  tar xvfj monero-linux-x64-v${MONERO_VERSION}.tar.bz2 && \
  cp ./monero-x86_64-linux-gnu-v${MONERO_VERSION}/monerod /usr/bin/ && \
  apt-get purge -y curl && apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/* \
    monero-x86_64-linux-gnu-v${MONERO_VERSION} \
    monero-linux-x64-v${MONERO_VERSION}.tar.bz2

USER monero
WORKDIR /home/monero

VOLUME /home/monero/.bitmonero
EXPOSE 18080 18081

ENTRYPOINT ["/usr/bin/monerod"]
CMD ["--non-interactive", \
    "--restricted-rpc", \
    "--rpc-bind-ip=0.0.0.0", \
    "--confirm-external-bind", \
    "--enable-dns-blocklist" \
    ]
