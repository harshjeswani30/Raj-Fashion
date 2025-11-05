# Render.com Environment Variables - Copy & Paste Ready

## For Your Render Web Service Environment Variables Section

Copy and paste these exact values into your Render web service:

```bash
APP_NAME=FleetCart
APP_ENV=production
APP_DEBUG=false
APP_URL=https://YOUR_SERVICE_NAME.onrender.com

# Database - Your Actual Values
DB_CONNECTION=pgsql
DB_HOST=dpg-d45mmu3uibrs73f9cbf0-a
DB_PORT=5432
DB_DATABASE=raj_fashion
DB_USERNAME=raj_fashion_user
DB_PASSWORD=nrjZZCNogTb2PXVM1DfL9stFZkDSoAOu

# Alternative: Use DATABASE_URL (Render preferred method)
DATABASE_URL=postgresql://raj_fashion_user:nrjZZCNogTb2PXVM1DfL9stFZkDSoAOu@dpg-d45mmu3uibrs73f9cbf0-a/raj_fashion

# Cache and Sessions
CACHE_DRIVER=database
SESSION_DRIVER=database
QUEUE_CONNECTION=database

# Logging
LOG_CHANNEL=errorlog
LOG_LEVEL=error

# Mail (set to log for now)
MAIL_MAILER=log

# File Storage
FILESYSTEM_DISK=public

# Broadcasting
BROADCAST_DRIVER=log
```

## Instructions:

1. **Go to your Render web service** → **Environment**
2. **Add each variable** one by one
3. **Don't forget to update APP_URL** with your actual service name
4. **Save and redeploy**

## Alternative: Use DATABASE_URL Only

Instead of individual DB_* variables, you can use just:
```bash
DATABASE_URL=postgresql://raj_fashion_user:nrjZZCNogTb2PXVM1DfL9stFZkDSoAOu@dpg-d45mmu3uibrs73f9cbf0-a/raj_fashion
```

This should fix your "Database not ready" issue!