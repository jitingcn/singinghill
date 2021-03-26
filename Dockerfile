FROM jiting/rails-base:builder-latest AS Builder

FROM jiting/rails-base:production-latest

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
