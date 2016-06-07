FROM phusion/baseimage

CMD ["/sbin/my_init"]

RUN apt-add-repository ppa:phalcon/stable \
    && apt-get update \
    && apt-get install -y php5-redis php5-phalcon php5-pgsql php5-common php5-cli php5-dev php5-fpm php5-mcrypt php5-mysql php5-gd php5-curl php5-memcache php5-xdebug php5-geoip

ADD application.ini /etc/php5/fpm/conf.d/
ADD application.ini /etc/php5/cli/conf.d/

RUN rm /etc/php5/fpm/php.ini
ADD php.ini /etc/php5/fpm/php.ini


ADD application.pool.conf /etc/php5/fpm/pool.d/

RUN usermod -u 1000 www-data

RUN mkdir -p /etc/service/php5-fpm
ADD start.sh /etc/service/php5-fpm/run
RUN chmod +x /etc/service/php5-fpm/run


RUN apt-get install -y git curl
RUN git clone https://github.com/phalcon/phalcon-devtools.git
RUN cd ./phalcon-devtools/
RUN ./phalcon-devtools/phalcon.sh
RUN ln -s /phalcon-devtools/phalcon.php /usr/bin/phalcon

RUN cd /

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \

RUN mkdir -p /var/www

EXPOSE 9000

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
