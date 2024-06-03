# Utiliser une image de base PHP avec Apache
FROM php:8.1-apache

# Installer les extensions PHP nécessaires
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Ajouter la configuration Apache pour résoudre le problème de ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configurer les permissions du répertoire
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Configurer Apache pour permettre l'accès au répertoire
RUN echo '<Directory /var/www/>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride None\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

# Configurer le site par défaut pour Apache
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    <Directory /var/www/html>\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride None\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Exposer le port 80
EXPOSE 80

# Démarrer le serveur Apache
CMD ["apache2-foreground"]
