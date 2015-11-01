FROM hypriot/rpi-ruby

ADD . /app

RUN bundle

CMD ["ruby app.rb"]
