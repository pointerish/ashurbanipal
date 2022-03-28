# ---- Build Stage ----
FROM elixir:1.13-alpine as base

# ---- Set build ENV ----
ENV MIX_ENV=prod

# ---- Install build dependencies ----
RUN apk --no-cache add build-base git

# ---- Prepare build dir ----
RUN mkdir /app
WORKDIR /app

# --- Install hex + rebar ----
RUN mix local.rebar --force \
    && mix local.hex --force 

# ---- Install mix dependencies ----
COPY mix.exs mix.lock ./
COPY lib ./lib
RUN mix do deps.get, deps.compile

#######################################
### Build Stage
#######################################
FROM base AS builder
RUN mix compile
RUN mix release

#######################################
### Deploy  Stage
#######################################
FROM alpine AS app
RUN apk add --no-cache --update openssl ncurses-libs

WORKDIR /app
RUN chown nobody:nobody /app

USER nobody:nobody

RUN ls /app
COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/ashurbanipal    ./

ENV LANG=C.UTF-8
ENV HOME=/app

CMD ["bin/ashurbanipal", "start"]