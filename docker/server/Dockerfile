FROM elixir:1.7-alpine
  
ENV UID=911 GID=911 \
    MIX_ENV=prod

RUN apk -U upgrade \
    && apk add --no-cache \
       build-base git

RUN addgroup -g ${GID} koueki \
    && adduser -h /koueki -s /bin/sh -D -G koueki -u ${UID} koueki

USER koueki

RUN git clone https://github.com/FloatingGhost/Koueki.git /koueki
WORKDIR /koueki

ADD write_config_file.sh .
ADD run.sh .

RUN touch config/prod.secret.exs
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \\
    && mix compile

CMD ["/bin/sh", "run.sh"]
