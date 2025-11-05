# FleetCart 500 Server Error - Troubleshooting Guide

## Step 1: Check Render Logs (Most Important)

1. **Go to your Render Dashboard**
2. **Click on your Web Service**
3. **Go to "Logs" tab**
4. **Look for error messages** in the logs

**Common errors you might see:**
- Database connection errors
- Missing APP_KEY
- PHP fatal errors
- Laravel configuration issues

## Step 2: Verify Environment Variables

**Go to Environment tab and make sure these are set:**

### Critical Variables (Must Have):
```
APP_NAME = FleetCart
APP_ENV = production
APP_DEBUG = false
APP_URL = https://YOUR_ACTUAL_SERVICE_NAME.onrender.com
APP_KEY = (should be auto-generated, or add one manually)

DB_CONNECTION = pgsql
DB_HOST = dpg-d45mmu3uibrs73f9cbf0-a
DB_PORT = 5432
DB_DATABASE = raj_fashion
DB_USERNAME = raj_fashion_user
DB_PASSWORD = nrjZZCNogTb2PXVM1DfL9stFZkDSoAOu
```

### Important Configuration:
```
LOG_CHANNEL = errorlog
CACHE_DRIVER = database
SESSION_DRIVER = database
QUEUE_CONNECTION = database
FILESYSTEM_DISK = public
MAIL_MAILER = log
```

## Step 3: Check APP_KEY

**APP_KEY is critical!** If missing, you'll get 500 errors.

### Option A: Let it auto-generate
- Leave APP_KEY empty, the startup script should generate it

### Option B: Generate manually
Add this environment variable:
```
APP_KEY = base64:YOUR_GENERATED_KEY_HERE
```

To generate a key locally:
```bash
php -r "echo 'base64:' . base64_encode(random_bytes(32)) . PHP_EOL;"
```

## Step 4: Fix APP_URL

**CRITICAL**: Make sure APP_URL matches your actual Render URL.

If your service URL is `https://fleetcart-abc123.onrender.com`, then:
```
APP_URL = https://fleetcart-abc123.onrender.com
```

## Step 5: Check Database Connection

**In your Render logs, look for:**
- "Database connected!" (good)
- "Database not ready" (bad - check DB credentials)
- "SQLSTATE" errors (bad - database issue)

## Step 6: Enable Debug Mode (Temporarily)

To see detailed error messages:

1. **Change this environment variable:**
```
APP_DEBUG = true
```

2. **Save and redeploy**
3. **Visit your site** - you'll see detailed error messages
4. **Fix the issue**
5. **Change back to:** `APP_DEBUG = false`

## Step 7: Common Fixes

### Fix 1: Missing APP_KEY
**Add this environment variable:**
```
APP_KEY = base64:$(echo -n 'your-32-character-secret-key-here' | base64)
```

### Fix 2: Database Not Ready
**Make sure database status is "Available" in Render dashboard**

### Fix 3: Wrong APP_URL
**Update APP_URL to match your actual service URL**

### Fix 4: Missing Storage Directory
**The startup script should handle this, but if not, check logs for storage permissions**

## Step 8: Manual APP_KEY Generation

If APP_KEY is the issue, generate one:

**Method 1: Online Generator**
- Go to https://generate-random.org/laravel-key-generator
- Copy the generated key
- Add to environment variables

**Method 2: Command Line (if you have PHP)**
```bash
php -r "echo 'base64:' . base64_encode(random_bytes(32)) . PHP_EOL;"
```

## Step 9: Check Build Logs

**Also check the Build logs** (separate from Service logs):
- Look for build failures
- Check if composer install succeeded
- Verify all dependencies installed

## Step 10: Common Environment Variable Issues

**Make sure you don't have:**
- Empty values (remove variables with no value)
- Spaces in variable names
- Quotes around values (Render handles this)

## Quick Checklist

- [ ] Render service status is "Live"
- [ ] Database status is "Available"
- [ ] APP_URL matches actual service URL
- [ ] APP_KEY is set (auto-generated or manual)
- [ ] Database credentials are correct
- [ ] Build completed successfully
- [ ] No errors in service logs

## Next Steps

1. **Check your Render logs first** - this will tell you the exact error
2. **Copy the error message** and I can help you fix it
3. **Try enabling APP_DEBUG=true temporarily** to see detailed errors
4. **Verify all environment variables** are set correctly

**Most common cause: Missing or incorrect APP_KEY!**

Tell me what you see in the Render logs and I'll help you fix it!