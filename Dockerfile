FROM marcelocg/phoenix

ENV MIX_ENV=prod
ENV NODE_ENV=production

RUN mkdir -p /var/www/klzii_chat
WORKDIR /var/www/klzii_chat


COPY . /var/www/klzii_chat

RUN sudo apt-get --assume-yes install erlang-dev
RUN sudo apt-get --assume-yes install esl-erlang

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile.protocols

RUN npm install webpack --global
RUN npm install --production

RUN mix phoenix.digest
RUN webpack -p

RUN cd /var/www/klzii_chat

ENV PORT=3000

EXPOSE 3000

CMD elixir -pa /var/www/klzii_chat/_build/prod/consolidated -S mix phoenix.server
