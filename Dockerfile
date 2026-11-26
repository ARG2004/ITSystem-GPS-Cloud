FROM php:8.2-apache

# Habilitar mod_rewrite de Apache para .htaccess
RUN a2enmod rewrite headers

# Instalar dependencias requeridas para SQLite y librerías del sistema
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    sqlite3 \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_sqlite zip \
    && rm -rf /var/lib/apt/lists/*

# Configurar Apache para servir desde la raíz del proyecto
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Permitir directivas en .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Copiar el código del proyecto al contenedor
WORKDIR /var/www/html
COPY . /var/www/html/

# Asegurar permisos de escritura para la base de datos SQLite y sesiones
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html \
    && chmod 664 /var/www/html/database.sqlite 2>/dev/null || true

EXPOSE 80

CMD ["apache2-foreground"]
