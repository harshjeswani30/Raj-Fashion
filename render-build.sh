#!/bin/bash

# Render.com build script for FleetCart
set -e

echo "🚀 Starting FleetCart build for Render.com..."

# Install PHP dependencies
echo "📦 Installing PHP dependencies..."
# Clear any existing caches that might interfere
rm -rf vendor/
rm -f composer.lock

# Install dependencies with fresh resolution
composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Force rebuild the autoloader to include module dependencies
composer dump-autoload --optimize

# Install Node dependencies and build assets
echo "🎨 Building frontend assets..."
npm install
npm run build

# Generate optimized autoloader
echo "⚡ Optimizing autoloader..."
composer dump-autoload --optimize

# Create storage directories
echo "📁 Creating storage directories..."
mkdir -p storage/app/public
mkdir -p storage/framework/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/logs
mkdir -p bootstrap/cache

# Set permissions (Render handles this, but just in case)
chmod -R 755 storage bootstrap/cache

echo "✅ Build complete!"