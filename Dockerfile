FROM hypriot/rpi-ruby


RUN apt-get update; apt-get -y install build-essential

WORKDIR /app

ADD . /app

RUN bundle

CMD ["ruby app.rb"]
