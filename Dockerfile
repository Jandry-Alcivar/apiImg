# Usa una imagen base que contenga PHP y Composer
FROM php:8.0-fpm

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configura el directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . .

# Instala las dependencias de PHP con Composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Configura y optimiza Laravel
RUN php artisan optimize
RUN php artisan config:clear
RUN php artisan route:cache
RUN php artisan view:cache

# Ejecuta las migraciones de la base de datos
RUN php artisan migrate:fresh --force

# Exponer el puerto
EXPOSE 8000

# Comando para iniciar PHP-FPM
CMD ["php-fpm"]
