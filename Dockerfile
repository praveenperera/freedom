# STEP 1 - DEPS GETTER
FROM hexpm/elixir:1.13.2-erlang-24.2.1-alpine-3.15.0  AS deps-getter

# setup up variables
ARG APP_NAME
ARG APP_VSN
ARG PHOENIX_SUBDIR=.

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} 

# make directory
RUN mkdir /app
WORKDIR /app

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# elixir create diretories
ENV MIX_ENV=prod
RUN mkdir \ 
    /app/_build/ \
    /app/config/ \
    /app/lib/ \
    /app/priv/ \ 
    /app/deps/ \
    /app/rel/ \
    /app/assets

# install deps and compile deps
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
RUN mix do deps.get --only $MIX_ENV, deps.compile
RUN mix compile

################################################################################
# STEP 2 - ASSET BUILDER
FROM node:14 AS asset-builder

RUN mkdir /app
WORKDIR /app

COPY --from=deps-getter /app/assets /app/assets
COPY --from=deps-getter /app/priv /app/priv
COPY --from=deps-getter /app/deps /app/deps

# assets -- install javascript deps
COPY assets/package.json /app/assets/package.json
COPY assets/package-lock.json /app/assets/package-lock.json
RUN cd /app/assets 

# assets -- copy asset files so purgecss doesnt remove css files
COPY lib/freedom_web/templates/ /app/lib/freedom_web/templates/
COPY lib/freedom_web/views/ /app/lib/freedom_web/views/
COPY lib/freedom_web/live/ /app/lib/freedom_web/live/

# assets -- build assets
COPY assets /app/assets
RUN cd /app/assets && npm i && npm run deploy  


################################################################################
# STEP 3 - RELEASE BUILDER
FROM hexpm/elixir:1.13.2-erlang-24.2.1-alpine-3.15.0  AS release-builder

ENV MIX_ENV=prod

RUN mkdir /app
WORKDIR /app

# setup up variables
ARG APP_NAME
ARG APP_VSN

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} 

# need to install deps again to run mix phx.digest
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# copy elixir deps
COPY --from=deps-getter /app /app

# copy config, priv and release directories
COPY config /app/config
COPY priv /app/priv
COPY rel /app/rel

# copy built assets
COPY --from=asset-builder /app/priv/static /app/priv/static

RUN mix phx.digest

# copy application code
COPY lib /app/lib

# create release
RUN mkdir -p /opt/built &&\
    mix release ${APP_NAME} &&\
    cp -r _build/prod/rel/${APP_NAME} /opt/built

################################################################################
## STEP 4 - FINAL
FROM alpine:3.15.0

ENV MIX_ENV=prod

RUN apk update && \
    apk add --no-cache \
    libstdc++ \
    libgcc \
    bash \
    openssl-dev

COPY --from=release-builder /opt/built /app
WORKDIR /app

ENV PATH="/app/freedom/bin/:${PATH}"

CMD ["freedom", "start"]
