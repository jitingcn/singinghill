FROM jiting/rails-base:builder-latest AS Builder

FROM jiting/rails-base:production-latest

RUN apk add --no-cache zip

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
