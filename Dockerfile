FROM hirotakakato/alpine-glibc:latest

RUN wget -qO factorio.tar.xz https://www.factorio.com/get-download/latest/headless/linux64 && \
    tar Jxf factorio.tar.xz && \
    rm factorio.tar.xz && \
    ( echo '{' && \
      echo '  "name": "Factorio LAN Server",' && \
      echo '  "description": "Factorio LAN Server",' && \
      echo '  "visibility": { "lan": true },' && \
      echo '  "require_user_verification": false,' && \
      echo '  "autosave_interval": 60,' && \
      echo '  "autosave_slots": 2,' && \
      echo '  "auto_pause": false,' && \
      echo '  "non_blocking_saving": true' && \
      echo '}' \
    ) | install -m 644 /dev/stdin /factorio/data/server-settings.json && \
    ( echo '#!/bin/sh -eu' && \
      echo 'cd /factorio' && \
      echo 'if [ -z "${adminlist:-}" ]; then' && \
      echo '  rm -f server-adminlist.json' && \
      echo 'else' && \
      echo '  echo "[\"${adminlist// /\",\"}\"]" > server-adminlist.json' && \
      echo 'fi' && \
      echo 'exec bin/x64/factorio --server-settings data/server-settings.json --start-server-load-latest' \
    ) | install /dev/stdin /cmd.sh

VOLUME ["/factorio/saves"]

CMD ["/cmd.sh"]
