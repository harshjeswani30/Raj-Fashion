# 📸 Visual Step-by-Step Deployment Guide

A visual walkthrough of deploying FleetCart to Railway.app.

---

## 🎬 Overview

**Total Time:** 15-20 minutes  
**Difficulty:** 🟢 Easy  
**Cost:** ~$10-25/month  

---

## Step 1️⃣: Create Railway Account

### What to do:
1. Go to **https://railway.app**
2. Click **"Start a New Project"** or **"Login with GitHub"**
3. Complete signup process

### What you'll see:
```
┌──────────────────────────────────────┐
│         Railway.app                  │
│                                      │
│   [Start a New Project]              │
│                                      │
│   or                                 │
│                                      │
│   [Login with GitHub]                │
│                                      │
└──────────────────────────────────────┘
```

✅ **Success:** You're logged into Railway dashboard

---

## Step 2️⃣: Deploy FleetCart

### Option A: Automated Script (Recommended)

**Windows:**
```
1. Open Command Prompt or PowerShell
2. Navigate to FleetCart folder:
   cd C:\path\to\FleetCart
   
3. Run script:
   deploy-to-railway.bat
   
4. Follow prompts
```

**Mac/Linux:**
```bash
1. Open Terminal
2. Navigate to FleetCart folder:
   cd /path/to/FleetCart
   
3. Make script executable:
   chmod +x deploy-to-railway.sh
   
4. Run script:
   ./deploy-to-railway.sh
   
5. Follow prompts
```

### Option B: Railway CLI

```bash
# Terminal/Command Prompt

# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login
# Browser opens → Login → Return to terminal

# 3. Initialize project
railway init
# Choose: "Empty Project"
# Name: "fleetcart-store"

# 4. Deploy
railway up
# Wait for deployment... ⏳
```

### Option C: GitHub

```
1. In GitHub:
   - Create new repository
   - Push FleetCart code

2. In Railway:
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your FleetCart repository
   - Click "Deploy"
```

### What you'll see during deployment:

```
╔══════════════════════════════════╗
║   🚂 Deploying to Railway...     ║
╠══════════════════════════════════╣
║                                  ║
║  ⏳ Building Docker image...     ║
║  ✓ Installing dependencies       ║
║  ✓ Building assets              ║
║  ✓ Optimizing application       ║
║  ⏳ Deploying...                 ║
║                                  ║
╚══════════════════════════════════╝

⏱️  Estimated time: 3-5 minutes
```

✅ **Success:** Deployment complete!

---

## Step 3️⃣: Add MySQL Database

### In Railway Dashboard:

```
1. Click your project name

2. Layout will show:
┌─────────────────┐
│   FleetCart     │
│   (your app)    │
└─────────────────┘

3. Click "+ New" button (top right)

4. Select "Database"

5. Select "Add MySQL"
```

### Visual:

```
┌────────────────────────────────────┐
│  Your Project                      │
├────────────────────────────────────┤
│                                    │
│  ┌──────────┐         [+ New ▼]   │
│  │FleetCart │                      │
│  │          │                      │
│  └──────────┘                      │
│                                    │
└────────────────────────────────────┘

Click "+ New" →

┌────────────────┐
│ New Service    │
│ Empty Service  │
│ Database   ◄── │ Click this
│ GitHub Repo    │
│ Docker Image   │
└────────────────┘

Select "Database" →

┌────────────────┐
│ Add MySQL   ◄──│ Click this
│ Add Postgres   │
│ Add MongoDB    │
│ Add Redis      │
└────────────────┘
```

### After adding MySQL:

```
┌─────────────────────────────────────┐
│  Your Project                       │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────┐      ┌──────────┐    │
│  │FleetCart │─────▶│  MySQL   │    │
│  │          │      │          │    │
│  └──────────┘      └──────────┘    │
│                                     │
└─────────────────────────────────────┘
```

✅ **Success:** Database added and auto-connected!

---

## Step 4️⃣: Configure Environment Variables

### In Railway Dashboard:

```
1. Click on "FleetCart" service

2. Click "Variables" tab

3. Click "+ New Variable"
```

### Visual:

```
┌────────────────────────────────────────┐
│ FleetCart                              │
├────────────────────────────────────────┤
│ [Deployments] [Variables] [Settings]   │
│                  ↑                     │
│              Click here                │
└────────────────────────────────────────┘

Variables Tab:
┌────────────────────────────────────────┐
│ Variables                   [+ New]    │
├────────────────────────────────────────┤
│                                        │
│ DB_CONNECTION = ${{MySQL.TYPE}}        │
│ DB_HOST = ${{MySQL.MYSQLHOST}}         │
│ DB_PORT = ${{MySQL.MYSQLPORT}}         │
│ DB_DATABASE = ${{MySQL.MYSQLDATABASE}} │
│ DB_USERNAME = ${{MySQL.MYSQLUSER}}     │
│ DB_PASSWORD = ${{MySQL.MYSQLPASSWORD}} │
│                                        │
│ APP_ENV = production                   │
│ APP_DEBUG = false                      │
│ APP_KEY = [will generate]              │
│                                        │
└────────────────────────────────────────┘
```

### Required Variables:

Add these manually:
```
APP_ENV=production
APP_DEBUG=false
INSTALLED=false
```

Database variables are auto-filled when you reference MySQL service:
```
DB_CONNECTION=mysql
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PORT=${{MySQL.MYSQLPORT}}
DB_DATABASE=${{MySQL.MYSQLDATABASE}}
DB_USERNAME=${{MySQL.MYSQLUSER}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
```

✅ **Success:** Variables configured!

---

## Step 5️⃣: Generate APP_KEY

### Using Railway CLI:

```bash
# In terminal
railway run php artisan key:generate
```

### Or manually:

```bash
# Locally
php artisan key:generate --show

# Copy the output (looks like):
base64:abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx1234yz==

# Add to Railway Variables:
APP_KEY=base64:abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx1234yz==
```

### Visual:

```
┌────────────────────────────────────┐
│ Terminal                           │
├────────────────────────────────────┤
│ $ railway run php artisan key:gen │
│                                    │
│ Application key set successfully   │
│                                    │
└────────────────────────────────────┘
```

✅ **Success:** APP_KEY generated!

---

## Step 6️⃣: Access Your Store

### Find Your URL:

```
In Railway Dashboard:

1. Click "Settings" tab
2. Look for "Domains" section
3. You'll see your Railway domain:

┌────────────────────────────────────────┐
│ Settings                               │
├────────────────────────────────────────┤
│ Domains                                │
│                                        │
│ ┌────────────────────────────────────┐ │
│ │ https://fleetcart-production-abc.  │ │
│ │ up.railway.app                     │ │
│ │                          [Copy]    │ │
│ └────────────────────────────────────┘ │
│                                        │
│ [+ Add Domain] ← Add custom domain     │
└────────────────────────────────────────┘
```

### Open in Browser:

```
Copy the URL and open in browser:

https://your-app-name.up.railway.app

You should see:
┌────────────────────────────────────────┐
│         FleetCart Installation         │
├────────────────────────────────────────┤
│                                        │
│  Welcome to FleetCart!                 │
│                                        │
│  Let's set up your store              │
│                                        │
│             [Start Setup]              │
│                                        │
└────────────────────────────────────────┘
```

✅ **Success:** Store is accessible!

---

## Step 7️⃣: Complete Installation Wizard

### Screen 1: Server Requirements

```
┌────────────────────────────────────────┐
│ FleetCart Installation - Requirements  │
├────────────────────────────────────────┤
│                                        │
│ ✓ PHP Version >= 8.2                  │
│ ✓ MySQL Extension                     │
│ ✓ GD Extension                        │
│ ✓ ...all requirements met             │
│                                        │
│              [Continue]                │
└────────────────────────────────────────┘
```

Click **Continue**

### Screen 2: Database Configuration

```
┌────────────────────────────────────────┐
│ FleetCart Installation - Database      │
├────────────────────────────────────────┤
│                                        │
│ Database Type: [MySQL ▼]              │
│                                        │
│ Host: [pre-filled]                    │
│ Port: [pre-filled]                    │
│ Database: [pre-filled]                │
│ Username: [pre-filled]                │
│ Password: [pre-filled]                │
│                                        │
│              [Test Connection]         │
│              [Continue]                │
└────────────────────────────────────────┘
```

Fields should be pre-filled. Click **Continue**

### Screen 3: Admin Account

```
┌────────────────────────────────────────┐
│ FleetCart Installation - Admin Account │
├────────────────────────────────────────┤
│                                        │
│ Full Name: [John Doe]                 │
│ Email: [admin@yourstore.com]          │
│ Password: [●●●●●●●●]                  │
│ Confirm Password: [●●●●●●●●]          │
│                                        │
│              [Continue]                │
└────────────────────────────────────────┘
```

Fill in your details. Click **Continue**

### Screen 4: Store Configuration

```
┌────────────────────────────────────────┐
│ FleetCart Installation - Store Info    │
├────────────────────────────────────────┤
│                                        │
│ Store Name: [My Awesome Store]        │
│ Store Email: [store@example.com]      │
│ Country: [United States ▼]            │
│ Timezone: [America/New_York ▼]        │
│ Currency: [USD ▼]                     │
│                                        │
│              [Install]                 │
└────────────────────────────────────────┘
```

Configure your store. Click **Install**

### Installation Progress:

```
┌────────────────────────────────────────┐
│ Installing FleetCart...                │
├────────────────────────────────────────┤
│                                        │
│ ✓ Creating database tables            │
│ ✓ Seeding initial data                │
│ ✓ Setting up permissions              │
│ ✓ Configuring settings                │
│ ⏳ Finalizing installation...          │
│                                        │
│ [████████████████░░░░] 85%            │
└────────────────────────────────────────┘
```

Wait for completion (1-2 minutes)

### Success Screen:

```
┌────────────────────────────────────────┐
│          🎉 Success!                   │
├────────────────────────────────────────┤
│                                        │
│ FleetCart has been installed!         │
│                                        │
│ Store URL: https://your-store.com     │
│ Admin URL: https://your-store.com/admin│
│                                        │
│         [Go to Store]                  │
│         [Go to Admin Panel]            │
│                                        │
└────────────────────────────────────────┘
```

✅ **Success:** Installation complete!

---

## Step 8️⃣: Access Admin Panel

### Login to Admin:

```
URL: https://your-store.com/admin

┌────────────────────────────────────────┐
│       FleetCart Admin Login            │
├────────────────────────────────────────┤
│                                        │
│ Email:    [admin@yourstore.com]       │
│                                        │
│ Password: [●●●●●●●●●●]                │
│                                        │
│ [x] Remember Me                        │
│                                        │
│            [Login]                     │
│                                        │
└────────────────────────────────────────┘
```

### Admin Dashboard:

```
┌────────────────────────────────────────┐
│ FleetCart  [Dashboard] [Products] ...  │
├────────────────────────────────────────┤
│                                        │
│ Welcome back, Admin!                   │
│                                        │
│ ┌──────────┐ ┌──────────┐ ┌─────────┐ │
│ │  0       │ │  $0.00   │ │  0      │ │
│ │ Orders   │ │ Sales    │ │Products │ │
│ └──────────┘ └──────────┘ └─────────┘ │
│                                        │
│ Recent Activity                        │
│ (empty)                                │
│                                        │
└────────────────────────────────────────┘
```

✅ **Success:** You're in the admin panel!

---

## Step 9️⃣: Add Your First Product

### Navigate to Products:

```
Click "Products" → "Add Product"

┌────────────────────────────────────────┐
│ Add New Product                        │
├────────────────────────────────────────┤
│                                        │
│ Product Name: [My First Product]      │
│                                        │
│ Description:                           │
│ ┌────────────────────────────────────┐ │
│ │ This is an amazing product...      │ │
│ └────────────────────────────────────┘ │
│                                        │
│ Price: [$19.99]                       │
│                                        │
│ [Upload Images]                        │
│                                        │
│          [Save Product]                │
└────────────────────────────────────────┘
```

Fill in details and click **Save Product**

✅ **Success:** First product added!

---

## Step 🔟: Optional Enhancements

### Add Redis Cache:

```
In Railway Dashboard:

1. Click "+ New"
2. Select "Database"
3. Select "Add Redis"

Result:
┌──────────────────────────────────────┐
│                                      │
│ ┌──────┐    ┌──────┐    ┌──────┐   │
│ │Fleet │───▶│MySQL │    │Redis │   │
│ │Cart  │    └──────┘    └──────┘   │
│ └──────┘         ▲           │      │
│                  └───────────┘      │
└──────────────────────────────────────┘
```

Update variables:
```
CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=${{Redis.REDISHOST}}
REDIS_PASSWORD=${{Redis.REDISPASSWORD}}
REDIS_PORT=${{Redis.REDISPORT}}
```

### Add Custom Domain:

```
In Railway Dashboard → Settings → Domains:

1. Click "+ Add Domain"
2. Enter: yourdomain.com
3. Add DNS record at your domain registrar:

Type: CNAME
Name: @ (or www)
Value: [provided by Railway]

4. Wait for DNS propagation (5-30 minutes)
```

---

## 🎉 You're Live!

### Your Store is Now:

✅ Deployed on Railway.app  
✅ Database connected  
✅ Admin panel accessible  
✅ First product added  
✅ Ready to sell!  

### Store URLs:

```
Frontend: https://your-store.up.railway.app
Admin:    https://your-store.up.railway.app/admin
```

---

## 📊 Monitoring Your Store

### View Logs:

```
Terminal:
$ railway logs --follow

┌────────────────────────────────────────┐
│ [2024-10-23 10:30:15] INFO: Server    │
│ [2024-10-23 10:30:16] INFO: Request   │
│ [2024-10-23 10:30:17] INFO: Response  │
└────────────────────────────────────────┘
```

### Check Metrics:

```
Railway Dashboard → Metrics tab:

┌────────────────────────────────────────┐
│ CPU Usage:    [████░░░░] 45%          │
│ Memory:       [███░░░░░] 312 MB       │
│ Network In:   125 KB/s                │
│ Network Out:  450 KB/s                │
└────────────────────────────────────────┘
```

---

## 🆘 Troubleshooting Visual Guide

### Problem: Can't Access Store

```
Check:
1. Railway Dashboard → Deployments
   Status should show: "Active ●"
   
2. Railway Dashboard → Settings → Domains
   URL should be present
   
3. Railway Variables
   APP_URL should match your domain
```

### Problem: Database Error

```
Check:
1. Railway Dashboard
   MySQL service shows: "Active ●"
   
2. Variables tab
   DB_* variables are set correctly
   
3. Logs
   $ railway logs | grep "database"
```

---

## ✅ Final Checklist

```
Deployment:
[✓] Railway account created
[✓] Application deployed
[✓] MySQL database added
[✓] Environment variables set
[✓] APP_KEY generated

Access:
[✓] Store URL accessible
[✓] Installation completed
[✓] Admin login working
[✓] Dashboard accessible

Configuration:
[✓] First product added
[✓] Payment gateway configured
[✓] Shipping methods set
[✓] Theme customized

Ready to Launch:
[✓] Test order placed
[✓] Email notifications working
[✓] Backups configured
[✓] Monitoring enabled
```

---

## 🎊 Congratulations!

Your FleetCart store is now live on Railway.app!

**Next Steps:**
1. Add more products
2. Configure payment methods
3. Set up shipping zones
4. Customize your theme
5. Start marketing
6. Make your first sale! 🚀

**Happy Selling!** 🛍️

---

Need help? Check:
- `QUICK_START.md` for quick reference
- `RAILWAY_DEPLOYMENT_GUIDE.md` for detailed info
- `railway-commands.md` for CLI commands
- Support: envaysoft@gmail.com


