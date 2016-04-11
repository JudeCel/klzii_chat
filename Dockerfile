FROM marcelocg/phoenix

ENV MIX_ENV=prod
ENV NODE_ENV=production

RUN mkdir -p /var/www/klzii_chat
WORKDIR /var/www/klzii_chat
COPY . /var/www/klzii_chat

RUN mix local.hex --force && \
	    mix local.rebar --force && \
	    mix deps.get --only prod && \ 
	    npm install --production --quiet && \
	    node node_modules/.bin/webpack -p && \
	    mix phoenix.digest && \
	    mix compile.protocols

RUN cd /var/www/klzii_chat

ENV PORT=3000

EXPOSE 3000

CMD elixir -pa /var/www/klzii_chat/_build/prod/consolidated -S mix phoenix.server
