# How to Add Environment Variables to Render

## Step 1: Access Environment Variables
1. Go to your **Render Dashboard**
2. Click on your **Web Service** (fleetcart)
3. Go to **Environment** tab
4. Click **Add Environment Variable**

## Step 2: Add Variables One by One

**CRITICAL VARIABLES (Add these first):**

```
APP_NAME = FleetCart
APP_ENV = production
APP_DEBUG = false
APP_URL = https://YOUR_ACTUAL_SERVICE_NAME.onrender.com
DB_CONNECTION = pgsql
DB_HOST = dpg-d45mmu3uibrs73f9cbf0-a
DB_PORT = 5432
DB_DATABASE = raj_fashion
DB_USERNAME = raj_fashion_user
DB_PASSWORD = nrjZZCNogTb2PXVM1DfL9stFZkDSoAOu
```

**IMPORTANT VARIABLES (Add these next):**

```
LOG_CHANNEL = errorlog
LOG_LEVEL = error
CACHE_DRIVER = database
SESSION_DRIVER = database
QUEUE_CONNECTION = database
FILESYSTEM_DISK = public
MAIL_MAILER = log
SESSION_LIFETIME = 120
BROADCAST_DRIVER = log
```

**PERFORMANCE VARIABLES (Optional but recommended):**

```
OPCACHE_ENABLE = 1
OPCACHE_VALIDATE_TIMESTAMPS = 0
SESSION_ENCRYPT = false
BCRYPT_ROUNDS = 10
PORT = 80
NODE_ENV = production
```

## Step 3: Update APP_URL
**IMPORTANT:** Replace `YOUR_ACTUAL_SERVICE_NAME` with your actual Render service name.

For example, if your service URL is `https://fleetcart-abc123.onrender.com`, then:
```
APP_URL = https://fleetcart-abc123.onrender.com
```

## Step 4: Save and Deploy
1. Click **Save Changes**
2. Render will automatically redeploy your service
3. Watch the deployment logs

## Alternative: Bulk Import (Advanced)
If Render supports it, you can try to import all variables at once using the complete environment file.

## Troubleshooting
- **APP_KEY will be auto-generated** by the startup script
- **Don't add empty variables** (leave out variables with no value)
- **Make sure APP_URL matches your actual service URL**
- **Database variables must match exactly** as provided