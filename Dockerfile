FROM jiting/rails-base:builder-3.3-rc-slim AS Builder

FROM jiting/rails-base:production-3.3-rc-slim

RUN apt install -yq unzip zip

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
