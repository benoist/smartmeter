FROM hypriot/rpi-ruby

RUN apt-get update; apt-get -y install build-essential

WORKDIR /app

ADD Gemfile /app/Gemfile
RUN bundle

ADD . /app


CMD ["ruby app.rb"]
