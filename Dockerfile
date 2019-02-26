FROM elixir:1.7-alpine

RUN apk -U upgrade \
    && apk add --no-cache \
       build-base nodejs npm \
    && npm i -g yarn

ENV MIX_ENV=prod

ADD . /koueki
WORKDIR /koueki
ADD docker/run.sh .
ADD docker/wait-for /usr/bin/wait-for

RUN cd frontend \
    && yarn \
    && npx webpack -p \
    && cd .. \
    && rm -rf frontend/node_modules \
    && touch config/prod.secret.exs \
    && mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && mix compile

CMD ["/bin/sh", "run.sh"]
