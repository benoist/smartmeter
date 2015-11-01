FROM hypriot/rpi-ruby

RUN apt-get update; apt-get -y install build-essential

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle

ADD . /app


CMD ["ruby app.rb"]
