FROM debian:jessie

RUN apt-get update \
 && apt-get install -q -y \
      spamassassin \
      supervisor \
      spampd \
      python3 \
 && rm -rf /var/lib/apt/lists/*

RUN sa-update

COPY editconf.py /opt/editconf.py
COPY startup.sh /startup.sh

RUN chmod u+x /opt/editconf.py \
 && chmod u+x /startup.sh

RUN /opt/editconf.py /etc/default/spamassassin \
    CRON=1

RUN /opt/editconf.py /etc/default/spampd \
    LISTENHOST=##HOSTNAME## \
    DESTPORT=10026 \
    DESTHOST=dovecot \
    ADDOPTS="\"--maxsize=500\"" \
    LOCALONLY=0

RUN /opt/editconf.py /etc/spamassassin/local.cf -s \
    report_safe=0

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD /startup.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
