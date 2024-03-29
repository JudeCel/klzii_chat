FROM klzii/phoenix-docker

ENV MIX_ENV=prod \
    NODE_ENV=production \
    PORT=3000

COPY . /var/www/klzii_chat

WORKDIR /var/www/klzii_chat

RUN mix local.hex --force && \
	    mix local.rebar --force && \
	    mix deps.get --only prod && \
      mix compile.protocols

RUN yarn install && \
	    node node_modules/.bin/webpack -p

RUN mix phoenix.digest


EXPOSE 3000

CMD elixir -pa /var/www/klzii_chat/_build/prod/consolidated -S mix phoenix.server
