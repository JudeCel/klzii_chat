FROM dainisl/phoenix-docker

ENV MIX_ENV=prod
ENV NODE_ENV=production

RUN mkdir -p /var/www/klzii_chat

RUN apt-get update && apt-get install imagemagick --assume-yes

WORKDIR /var/www/klzii_chat
COPY . /var/www/klzii_chat
RUN mix local.hex --force && \
	    mix local.rebar --force && \
	    mix deps.get --only prod && \
	    npm install --production --quiet && \
	    nodejs node_modules/.bin/webpack -p && \
	    mix phoenix.digest && \
	    mix compile.protocols

RUN cd /var/www/klzii_chat

ENV PORT=3000

EXPOSE 3000

CMD elixir -pa /var/www/klzii_chat/_build/prod/consolidated -S mix phoenix.server
