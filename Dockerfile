FROM elixir:1.7-alpine

RUN apk -U upgrade \
    && apk add --no-cache \
       build-base nodejs npm


RUN npm i -g yarn

ENV UID=911 GID=911 \
    MIX_ENV=prod

RUN addgroup -g ${GID} koueki \
    && adduser -h /koueki -s /bin/sh -D -G koueki -u ${UID} koueki


ADD . /koueki
WORKDIR /koueki
ADD docker/run.sh .

RUN chown -R koueki:koueki /koueki

USER koueki
RUN cd frontend && yarn && npx webpack -p && cd .. && rm -rf frontend/node_modules


RUN touch config/prod.secret.exs
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \\
    && mix compile

CMD ["/bin/sh", "run.sh"]
