FROM marcelocg/phoenix

ENV MIX_ENV=prod
ENV NODE_ENV=production

RUN mkdir -p /var/www/klzii_chat
WORKDIR /var/www/klzii_chat


COPY . /var/www/klzii_chat

RUN sudo apt-get --assume-yes install esl-erlang

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod

RUN npm install --production

RUN set NODE_ENV=production && node node_modules/.bin/webpack -p
RUN mix phoenix.digest
RUN mix compile.protocols

RUN cd /var/www/klzii_chat

ENV PORT=3000

EXPOSE 3000

CMD elixir -pa /var/www/klzii_chat/_build/prod/consolidated -S mix phoenix.server
