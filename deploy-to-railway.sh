#!/bin/bash

# FleetCart Railway.app Deployment Script
# This script automates the deployment process

echo "🚀 FleetCart Railway Deployment Script"
echo "========================================"

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null
then
    echo "❌ Railway CLI not found!"
    echo "📦 Installing Railway CLI..."
    npm install -g @railway/cli
fi

# Login to Railway
echo ""
echo "🔐 Logging into Railway..."
railway login

# Initialize project (if not already initialized)
echo ""
echo "📋 Setting up Railway project..."
read -p "Do you want to create a new Railway project? (y/n): " create_new

if [ "$create_new" = "y" ]; then
    railway init
fi

# Link to project
echo ""
echo "🔗 Linking to Railway project..."
railway link

# Add MySQL database prompt
echo ""
echo "📊 Database Setup"
echo "Please add a MySQL database to your Railway project:"
echo "1. Go to https://railway.app/dashboard"
echo "2. Open your project"
echo "3. Click 'New' → 'Database' → 'Add MySQL'"
echo ""
read -p "Press Enter after you've added MySQL database..."

# Add Redis prompt (optional)
echo ""
read -p "Do you want to add Redis cache? (recommended) (y/n): " add_redis

if [ "$add_redis" = "y" ]; then
    echo "📊 Redis Setup"
    echo "Please add Redis to your Railway project:"
    echo "1. In Railway dashboard, click 'New' → 'Database' → 'Add Redis'"
    echo ""
    read -p "Press Enter after you've added Redis..."
fi

# Generate APP_KEY
echo ""
echo "🔑 Generating application key..."
php artisan key:generate --show

echo ""
echo "⚙️  Environment Variables Setup"
echo "Please add the following environment variables in Railway dashboard:"
echo "Go to your service → Variables → Add the variables from 'railway-env-template.txt'"
echo ""
read -p "Press Enter after you've configured environment variables..."

# Deploy
echo ""
echo "🚀 Deploying to Railway..."
railway up

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "📝 Next Steps:"
echo "1. Check deployment status in Railway dashboard"
echo "2. Once deployed, access your app URL (found in Railway dashboard)"
echo "3. Complete the FleetCart installation wizard"
echo "4. Configure your store settings"
echo ""
echo "🎉 Your FleetCart store will be ready soon!"


