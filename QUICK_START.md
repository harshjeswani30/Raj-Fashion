# ⚡ FleetCart Railway Quick Start Guide

The fastest way to deploy FleetCart to Railway.app in 10 minutes!

## 🎯 Quick Deployment (3 Methods)

### Method 1: Automated Script (Easiest)

**For Windows:**
```bash
cd FleetCart
deploy-to-railway.bat
```

**For Mac/Linux:**
```bash
cd FleetCart
chmod +x deploy-to-railway.sh
./deploy-to-railway.sh
```

### Method 2: Railway CLI (Fast)

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Navigate to FleetCart folder
cd FleetCart

# 4. Initialize
railway init

# 5. Deploy
railway up
```

### Method 3: GitHub Integration (No CLI)

```bash
# 1. Create GitHub repository
# 2. Push FleetCart folder to GitHub
# 3. Go to railway.app
# 4. New Project → Deploy from GitHub → Select repo
```

## 📦 Essential Setup Steps

### 1. Add MySQL Database
In Railway dashboard:
- Click "New" → "Database" → "MySQL"
- Done! Railway auto-configures connection

### 2. Configure Environment Variables
In Railway dashboard → Your Service → Variables, add:

```
APP_ENV=production
APP_DEBUG=false
INSTALLED=false
```

Reference MySQL service (Railway does this automatically):
```
DB_CONNECTION=mysql
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PORT=${{MySQL.MYSQLPORT}}
DB_DATABASE=${{MySQL.MYSQLDATABASE}}
DB_USERNAME=${{MySQL.MYSQLUSER}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
```

### 3. Generate APP_KEY
```bash
railway run php artisan key:generate
```

### 4. Access Your Store
- Get your URL from Railway dashboard (Settings → Domains)
- Open in browser
- Complete installation wizard
- Create admin account

## 🎉 Done!

Your store is live at: `https://your-app.up.railway.app`

Admin panel: `https://your-app.up.railway.app/admin`

## 🚀 Optional Enhancements

### Add Redis (Better Performance)
Railway dashboard → "New" → "Database" → "Redis"

Update variables:
```
CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=${{Redis.REDISHOST}}
REDIS_PASSWORD=${{Redis.REDISPASSWORD}}
REDIS_PORT=${{Redis.REDISPORT}}
```

### Add Custom Domain
Railway dashboard → Settings → Domains → Add Domain

### Configure Email
Update in Railway variables:
```
MAIL_MAILER=smtp
MAIL_HOST=smtp.your-service.com
MAIL_PORT=587
MAIL_USERNAME=your-username
MAIL_PASSWORD=your-password
MAIL_ENCRYPTION=tls
```

## 🛠️ Common Commands

```bash
# View logs
railway logs

# Run artisan commands
railway run php artisan [command]

# Clear cache
railway run php artisan cache:clear

# Run migrations
railway run php artisan migrate

# Access database
railway run php artisan tinker
```

## 📞 Need Help?

- 📖 Full Guide: See `RAILWAY_DEPLOYMENT_GUIDE.md`
- 🐛 Issues: Check Railway logs with `railway logs`
- 📧 Support: envaysoft@gmail.com

## 💡 Pro Tips

1. **Always backup** before updates
2. **Use Redis** for better performance
3. **Enable HTTPS** (Railway does this automatically)
4. **Monitor costs** in Railway dashboard
5. **Set up email** for order notifications
6. **Use S3** for file storage in production

---

**Deployment Time:** ~10 minutes
**Cost:** ~$10-15/month (Railway Hobby plan)
**Difficulty:** Easy 🟢




