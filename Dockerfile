FROM ubuntu:22.04

LABEL maintainer="Santiago Alessandri <santiago@salessandri.name>"

ARG MONERO_VERSION=0.18.1.0
ARG MONERO_SHA256=9318e522a5cf95bc856772f15d7507fdef2c028e01f70d020078ad5e208f1304
ARG UID=1337

RUN useradd --uid ${UID} --user-group \
        --shell /bin/bash --create-home --home-dir /home/monero --no-log-init monero && \
    mkdir /home/monero/.bitmonero && chown monero:monero /home/monero/.bitmonero

RUN apt-get update && apt-get install -y \
  curl bzip2 && \
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
