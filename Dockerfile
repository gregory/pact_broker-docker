FROM metakungfu/ruby

COPY pact_broker/Gemfile* $WORKDIR/
RUN  apk update \
     && bnl-apk-install-build-deps \
     && apk-install ruby-json=2.2.2-r1 \
                   ruby-sqlite=1.3.10-r1 \
                   ruby-nokogiri=1.6.6.2-r0 \
                   ruby-sqlite=1.3.10-r1 \
    && bundle install --system --without='development test' \
    && rm -rf /var/cache/apk/* \
    && apk del build-deps

RUN chown -R app:app $WORKDIR $GEM_HOME

COPY pact_broker/ $WORKDIR/

EXPOSE 9292
CMD ["sh",  "-c", "bundle exec rackup -o 0.0.0.0"]
