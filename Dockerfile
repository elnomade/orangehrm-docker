# from https://www.drupal.org/requirements/php#drupalversions
FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev unzip \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

RUN docker-php-ext-install mysql

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
#ENV DRUPAL_VERSION 8.0.0-rc4
#ENV DRUPAL_MD5 33a4738989e4b571176e47d26443cb26

#RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	#&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	#&& tar -xz --strip-components=1 -f drupal.tar.gz \
	#&& rm drupal.tar.gz \
	#&& chown -R www-data:www-data sites

# RUN wget http://downloads.sourceforge.net/project/orangehrm/stable/3.3.2/orangehrm-3.3.2.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Forangehrm%2F%3Fsource%3Dtyp_redirect&ts=1447696468&use_mirror=tcpdiag
RUN rm -Rf /var/www/html/*
COPY orangehrm-3.3.2.zip /var/www/html/
# RUN ls -lh;sleep 5
RUN unzip orangehrm*zip; mv orangehrm-3.3.2/* ./ ; mv orangehrm-3.3.2/.htaccess ./;
#COPY kimai_0.9.3.zip /var/www/html/
#RUN unzip kimai*zip
