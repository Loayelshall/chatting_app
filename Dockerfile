# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION

# Rails app lives here

# Set production environment


# Install packages needed to build gems
RUN apt-get update -qq && \
apt-get install -y build-essential default-libmysqlclient-dev libvips curl default-mysql-client 

WORKDIR /rails

ENV RAILS_ENV="development" \
BUNDLE_DEPLOYMENT="1" \
BUNDLE_PATH="/usr/local/bundle" \
BUNDLE_WITHOUT="development"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ./bin/rails server --binding 0.0.0.0
