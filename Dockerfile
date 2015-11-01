FROM hypriot/rpi-ruby

WORKDIR /app

ADD . /app

RUN bundle

CMD ["ruby app.rb"]
