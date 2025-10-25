#!/bin/bash

# FleetCart Railway Startup Script
# This script runs when the container starts

echo "🚀 Starting FleetCart..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
until php artisan db:show --database=mysql > /dev/null 2>&1; do
    echo "Database not ready yet, retrying in 2 seconds..."
    sleep 2
done
echo "✅ Database connection established!"

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env 2>/dev/null || touch .env
fi

# Generate APP_KEY if not set
if ! grep -q "APP_KEY=base64:" .env; then
    echo "🔑 Generating application key..."
    php artisan key:generate --force
fi

# Set permissions
echo "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Run migrations (only if INSTALLED is false)
if [ "$INSTALLED" != "true" ]; then
    echo "📊 Running database migrations..."
    php artisan migrate --force || echo "⚠️  Migrations failed or already run"
fi

# Clear and cache config
echo "🧹 Clearing caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Cache config for production
if [ "$APP_ENV" = "production" ]; then
    echo "⚡ Caching configuration..."
    php artisan config:cache || echo "⚠️  Config cache failed"
    php artisan route:cache || echo "⚠️  Route cache failed"
    php artisan view:cache || echo "⚠️  View cache failed"
fi

# Storage link
echo "🔗 Creating storage symlink..."
php artisan storage:link || echo "⚠️  Storage link already exists"

# Start the application
echo "✅ Starting web server..."
exec "$@"


