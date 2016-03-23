FROM marcelocg/phoenix

ENV DEBIAN_FRONTEND=noninteractive

ENV MIX_ENV=prod
ENV NODE_ENV=production

RUN sudo apt-get install erlang-parsetools
RUN sudo apt-get install erlang-dev

RUN mkdir -p /var/www/klzii_chat
WORKDIR /var/www/klzii_chat

COPY . /var/www/klzii_chat

RUN mix local.hex --force && mix local.rebar --force && mix deps.get --only prod

RUN npm install --production --quiet

RUN set NODE_ENV=production && node node_modules/.bin/webpack -p
RUN mix phoenix.digest && mix compile.protocols

RUN cd /var/www/klzii_chat

ENV PORT=3000

EXPOSE 3000

CMD elixir -pa /var/www/klzii_chat/_build/prod/consolidated -S mix phoenix.server
