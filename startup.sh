#!/bin/bash

# FleetCart Railway Startup Script
# This script runs when the container starts

echo "🚀 Starting FleetCart..."

# Configure Composer GitHub token at runtime if provided
if [ -n "$GITHUB_TOKEN" ]; then
    echo "🔐 Configuring Composer GitHub token..."
    composer config -g github-oauth.github.com "$GITHUB_TOKEN" 2>/dev/null || true
fi

# Ensure dependencies exist (fallback if build step was skipped/failed)
if [ ! -f vendor/autoload.php ]; then
    echo "📦 Installing PHP dependencies (runtime fallback)..."
    composer install --no-dev --no-scripts --prefer-dist --no-interaction --no-progress 2>/dev/null || true
fi

# Create .env if it doesn't exist (do this BEFORE database check)
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env 2>/dev/null || touch .env
fi

# Generate APP_KEY if not set
if ! grep -q "APP_KEY=base64:" .env 2>/dev/null; then
    echo "🔑 Generating application key..."
    php artisan key:generate --force 2>/dev/null || true
fi

# Wait for database to be ready with timeout
echo "⏳ Waiting for database connection..."
MAX_RETRIES=30
RETRY_COUNT=0
until php artisan db:show --database=mysql > /dev/null 2>&1; do
    RETRY_COUNT=$((RETRY_COUNT+1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "⚠️  Database connection timeout after ${MAX_RETRIES} attempts"
        echo "⚠️  Starting web server anyway - database may not be configured yet"
        break
    fi
    echo "Database not ready yet (attempt $RETRY_COUNT/$MAX_RETRIES), retrying in 2 seconds..."
    sleep 2
done

if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
    echo "✅ Database connection established!"
fi

# Set permissions
echo "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Run migrations (only if database is connected and INSTALLED is false)
if [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ "$INSTALLED" != "true" ]; then
    echo "📊 Running database migrations..."
    php artisan migrate --force 2>/dev/null || echo "⚠️  Migrations failed or already run"
fi

# Clear caches (don't fail if cache operations fail)
echo "🧹 Clearing caches..."
php artisan config:clear 2>/dev/null || true
php artisan route:clear 2>/dev/null || true
php artisan view:clear 2>/dev/null || true
php artisan cache:clear 2>/dev/null || true

# Cache config for production (only if database is connected)
if [ "$APP_ENV" = "production" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
    echo "⚡ Caching configuration..."
    php artisan config:cache 2>/dev/null || echo "⚠️  Config cache failed"
    php artisan route:cache 2>/dev/null || echo "⚠️  Route cache failed"
    php artisan view:cache 2>/dev/null || echo "⚠️  View cache failed"
fi

# Storage link
echo "🔗 Creating storage symlink..."
php artisan storage:link 2>/dev/null || echo "⚠️  Storage link already exists"

# Start the application
echo "✅ Starting web server..."
"$@" &
APACHE_PID=$!

# proceed with setup without blocking web server availability

# Wait for apache to exit to terminate container properly
wait $APACHE_PID



