FROM debian:jessie

RUN apt-get update \
 && apt-get install -q -y \
      spamassassin \
      supervisor \
      python3 \
 && rm -rf /var/lib/apt/lists/*

RUN sa-update

COPY editconf.py /opt/editconf.py
RUN chmod u+x /opt/editconf.py

RUN /opt/editconf.py /etc/default/spamassassin \
    ENABLED=1

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
