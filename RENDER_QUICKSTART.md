# FleetCart Render.com Deployment - Quick Start Guide

## Step-by-Step Deployment Instructions

### Step 1: Make Scripts Executable
```bash
# Make the scripts executable (run this on your local machine)
chmod +x render-build.sh render-start.sh
```

### Step 2: Push to GitHub
```bash
# Add all new Render files
git add .

# Commit the changes
git commit -m "feat: add Render.com deployment configuration"

# Push to GitHub
git push origin main
```

### Step 3: Sign Up for Render.com
1. Go to [render.com](https://render.com)
2. Click **"Get Started"**
3. **Sign up with GitHub** (easiest option)
4. **Authorize Render** to access your repositories

### Step 4: Create PostgreSQL Database
1. **Render Dashboard** → **New** → **PostgreSQL**
2. **Configure Database**:
   - **Name**: `fleetcart-db`
   - **Database**: `fleetcart`
   - **User**: `fleetcart`
   - **Region**: Choose closest to your users (e.g., US East)
   - **Plan**: **Free** (0$/month)
3. Click **"Create Database"**
4. **Wait 2-3 minutes** for database to be ready
5. **Copy these values** from the database page:
   - Internal Database URL
   - Host
   - Database
   - Username
   - Password

### Step 5: Create Web Service
1. **Render Dashboard** → **New** → **Web Service**
2. **Connect Repository**: Choose your `Raj-Fashion` repository
3. **Configure Service**:
   - **Name**: `fleetcart` (or your preferred name)
   - **Region**: **Same as your database**
   - **Branch**: `main`
   - **Runtime**: **Docker**
   - **Plan**: **Free** ($0/month, 750 hours)

**IMPORTANT**: When using Docker runtime, Render will automatically:
- Use your `Dockerfile` to build the image
- Use the `CMD` instruction from Dockerfile to start the container
- **DO NOT add Build Command or Start Command** - leave them empty!

### Step 6: Configure Environment Variables
In the **Environment Variables** section, add these:

**Required Variables**:
```bash
APP_NAME=FleetCart
APP_ENV=production
APP_DEBUG=false
APP_URL=https://YOUR_SERVICE_NAME.onrender.com

# Database (use your actual database values)
DB_CONNECTION=pgsql
DB_HOST=dpg-d45mmu3uibrs73f9cbf0-a
DB_PORT=5432
DB_DATABASE=raj_fashion
DB_USERNAME=raj_fashion_user
DB_PASSWORD=nrjZZCNogTb2PXVM1DfL9stFZkDSoAOu

# Cache and Sessions
CACHE_DRIVER=database
SESSION_DRIVER=database
QUEUE_CONNECTION=database

# Logging
LOG_CHANNEL=errorlog
LOG_LEVEL=error

# Mail (set to log for now, configure later)
MAIL_MAILER=log
```

**Optional but Recommended**:
```bash
# File Storage
FILESYSTEM_DISK=public

# Broadcasting
BROADCAST_DRIVER=log

# App Key (will be auto-generated)
APP_KEY=
```

### Step 7: Deploy
1. Click **"Create Web Service"**
2. **Render will automatically**:
   - Clone your repository
   - Run the build script
   - Deploy your application
   - Provide HTTPS URL
3. **Watch the build logs** (usually takes 8-15 minutes first time)
4. **Your site will be live** at `https://your-service-name.onrender.com`

### Step 8: Verify Deployment
1. **Visit your site** - should show FleetCart installation or homepage
2. **Check the logs** if there are any issues
3. **Test basic functionality** - browse products, create account, etc.

## Post-Deployment Configuration

### Configure Custom Domain (Optional)
1. **Render Dashboard** → **Your Service** → **Settings**
2. **Custom Domains** → **Add Custom Domain**
3. **Add your domain**: `yourdomain.com`
4. **Update DNS records** (Render will show you what to add)
5. **SSL automatically configured** by Render

### Configure Email (Recommended for Production)
Update these environment variables in Render:
```bash
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@yourdomain.com
MAIL_FROM_NAME=FleetCart
```

### Monitor Your Application
- **Build Logs**: Check for deployment issues
- **Service Logs**: Monitor runtime errors
- **Metrics**: View performance and usage
- **Automatic Restarts**: Render handles this automatically

## Troubleshooting

### Build Failed
- Check build logs in Render dashboard
- Ensure `render-build.sh` is executable
- Verify all dependencies in `composer.json` and `package.json`

### Database Connection Error
1. Verify database is running (green status in Render)
2. Check environment variables match database credentials
3. Ensure DB_CONNECTION=pgsql (not mysql)

### App Not Loading
1. Check service logs for PHP/Laravel errors
2. Verify APP_KEY is generated (check logs)
3. Ensure migrations ran successfully

### Performance Issues
- Free tier has some limitations
- Consider upgrading to paid plan ($7/month) for better performance
- Monitor usage in Render dashboard

## Automatic Updates

**Every time you push to GitHub main branch**:
1. Render automatically detects changes
2. Runs build script
3. Deploys new version
4. Zero downtime deployment

**To update your site**:
```bash
# Make your changes
git add .
git commit -m "update: your changes"
git push origin main
# Render automatically deploys!
```

## Cost Breakdown

**Free Tier Includes**:
- 750 hours/month web service (enough for small-medium sites)
- PostgreSQL database (500MB storage)
- Automatic SSL certificates
- Custom domains
- Build minutes: 500/month

**When to Upgrade ($7/month)**:
- Need more than 750 hours/month uptime
- Higher traffic volumes
- Faster build times
- More database storage

## Summary

Your FleetCart is now deployed on Render.com with:
- ✅ Professional hosting with automatic SSL
- ✅ PostgreSQL database (much better than SQLite)
- ✅ Automatic deployments from GitHub
- ✅ Zero server management required
- ✅ Built-in monitoring and logging
- ✅ Automatic scaling and restarts

**Your site will be live at**: `https://your-service-name.onrender.com`

This setup is perfect for e-commerce sites like FleetCart and will handle your traffic professionally!