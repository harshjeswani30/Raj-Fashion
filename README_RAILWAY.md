# 🚂 FleetCart on Railway.app - Complete Deployment Package

> **Deploy FleetCart e-commerce platform to Railway.app in minutes with full control and access**

![PHP](https://img.shields.io/badge/PHP-8.2+-777BB4?style=flat&logo=php&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-11.x-FF2D20?style=flat&logo=laravel&logoColor=white)
![Railway](https://img.shields.io/badge/Railway-Deployed-0B0D0E?style=flat&logo=railway&logoColor=white)
![License](https://img.shields.io/badge/License-Commercial-blue)

## 📖 Table of Contents

- [Overview](#-overview)
- [What's Included](#-whats-included)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Deployment Methods](#-deployment-methods)
- [Configuration](#-configuration)
- [Post-Deployment](#-post-deployment)
- [Management](#-management)
- [Troubleshooting](#-troubleshooting)
- [Cost Estimation](#-cost-estimation)
- [Support](#-support)

## 🎯 Overview

**FleetCart** is a powerful Laravel-based e-commerce platform. This package provides everything you need to deploy it on **Railway.app** - a modern Platform-as-a-Service (PaaS) that makes deployment simple.

### Why Railway.app?

✅ **Easy Deployment** - Deploy with one command  
✅ **Auto-Scaling** - Handles traffic spikes automatically  
✅ **Free SSL** - HTTPS enabled by default  
✅ **Database Included** - MySQL/PostgreSQL/Redis available  
✅ **Fair Pricing** - Pay only for what you use  
✅ **Full Control** - Complete access to your application  
✅ **Zero DevOps** - No server management needed  

## 📦 What's Included

This deployment package includes:

```
FleetCart/
├── 📄 Dockerfile                      # Production-ready Docker configuration
├── 📄 docker-compose.yml              # Local development setup (optional)
├── 📄 railway.json                    # Railway configuration
├── 📄 nixpacks.toml                   # Alternative build config
├── 📄 Procfile                        # Process definition
├── 📄 startup.sh                      # Startup script
├── 📄 .dockerignore                   # Docker optimization
├── 📄 railway-env-template.txt        # Environment variables template
├── 📜 deploy-to-railway.sh            # Automated deployment (Mac/Linux)
├── 📜 deploy-to-railway.bat           # Automated deployment (Windows)
├── 📚 RAILWAY_DEPLOYMENT_GUIDE.md     # Complete deployment guide
├── 📚 QUICK_START.md                  # Quick start guide
├── 📚 railway-commands.md             # CLI commands reference
└── 📚 README_RAILWAY.md               # This file
```

## 🔧 Prerequisites

Before deploying, ensure you have:

- [x] **Railway.app account** - Free signup at https://railway.app
- [x] **Git** (for CLI deployment) - Download from https://git-scm.com
- [x] **Node.js & npm** (for Railway CLI) - Download from https://nodejs.org

**Optional but recommended:**
- GitHub account (for continuous deployment)
- Custom domain name
- Email service (SendGrid, Mailgun, etc.)
- AWS S3 account (for file storage)

## ⚡ Quick Start

Choose your preferred deployment method:

### 🚀 Method 1: One-Click Script Deployment (Easiest)

**Windows:**
```bash
cd FleetCart
.\deploy-to-railway.bat
```

**Mac/Linux:**
```bash
cd FleetCart
chmod +x deploy-to-railway.sh
./deploy-to-railway.sh
```

The script will:
- Install Railway CLI
- Login to Railway
- Create/link project
- Guide you through database setup
- Deploy your application

### 🎮 Method 2: Manual CLI Deployment

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Navigate to project
cd FleetCart

# 4. Initialize project
railway init

# 5. Deploy
railway up
```

### 🔗 Method 3: GitHub Integration (No CLI)

1. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/fleetcart.git
   git push -u origin main
   ```

2. **Connect to Railway:**
   - Go to https://railway.app/dashboard
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository
   - Railway deploys automatically!

## 🛠️ Deployment Methods

We support 3 deployment methods:

| Method | Difficulty | Speed | Best For |
|--------|-----------|-------|----------|
| **Automated Script** | 🟢 Easy | ⚡ Fast | Beginners |
| **Railway CLI** | 🟡 Medium | ⚡ Fast | Developers |
| **GitHub Integration** | 🟢 Easy | 🚀 Fastest | Teams |

## ⚙️ Configuration

### Step 1: Add MySQL Database

In Railway Dashboard:
1. Click **"New"** → **"Database"** → **"Add MySQL"**
2. Railway automatically provisions the database
3. Connection details are auto-configured

### Step 2: Configure Environment Variables

In Railway Dashboard → Your Service → **Variables**, add:

**Required Variables:**
```bash
APP_ENV=production
APP_DEBUG=false
APP_URL=${{RAILWAY_PUBLIC_DOMAIN}}
INSTALLED=false
```

**Database (auto-configured when MySQL added):**
```bash
DB_CONNECTION=mysql
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PORT=${{MySQL.MYSQLPORT}}
DB_DATABASE=${{MySQL.MYSQLDATABASE}}
DB_USERNAME=${{MySQL.MYSQLUSER}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
```

**Optional but Recommended:**
```bash
# Redis Cache
CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=${{Redis.REDISHOST}}
REDIS_PASSWORD=${{Redis.REDISPASSWORD}}
REDIS_PORT=${{Redis.REDISPORT}}

# Email
MAIL_MAILER=smtp
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=apikey
MAIL_PASSWORD=your-sendgrid-api-key
```

See `railway-env-template.txt` for complete list.

### Step 3: Generate APP_KEY

```bash
railway run php artisan key:generate
```

Or copy the output from:
```bash
php artisan key:generate --show
```
And add it to Railway variables as `APP_KEY`.

## 🎉 Post-Deployment

### 1. Access Your Application

Your app will be available at:
```
https://your-project-name.up.railway.app
```

Find your URL in: **Railway Dashboard → Settings → Domains**

### 2. Complete Installation Wizard

1. Open your app URL in browser
2. Follow FleetCart installation wizard
3. Database details are pre-filled
4. Create your admin account
5. Configure store settings

### 3. Access Admin Panel

```
https://your-app-url/admin
```

Login with credentials created during setup.

### 4. Configure Custom Domain (Optional)

**In Railway:**
1. Go to **Settings → Domains**
2. Click **"Add Domain"**
3. Enter your domain
4. Update DNS with provided CNAME record

**Update environment:**
```bash
railway variables set APP_URL=https://yourdomain.com
```

## 🔐 Management

### Essential Commands

```bash
# View logs
railway logs --follow

# Run artisan commands
railway run php artisan [command]

# Clear cache
railway run php artisan optimize:clear

# Access database
railway run php artisan tinker

# Backup database
railway run mysqldump -h $MYSQLHOST -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE > backup.sql
```

See `railway-commands.md` for complete command reference.

### Recommended Enhancements

#### Add Redis Cache

```bash
# In Railway Dashboard
New → Database → Add Redis
```

Update variables:
```bash
CACHE_DRIVER=redis
SESSION_DRIVER=redis
```

#### Configure Email Service

**SendGrid Example:**
```bash
MAIL_MAILER=smtp
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=apikey
MAIL_PASSWORD=your-sendgrid-api-key
MAIL_FROM_ADDRESS=noreply@yourstore.com
```

#### Set Up File Storage (AWS S3)

```bash
# Install S3 driver
railway run composer require league/flysystem-aws-s3-v3

# Configure
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket-name
```

## 🐛 Troubleshooting

### Common Issues

**Issue: 500 Internal Server Error**
```bash
railway run php artisan optimize:clear
railway logs
```

**Issue: Database Connection Failed**
- Verify MySQL service is running
- Check environment variables match
- Ensure database migration completed

**Issue: Assets Not Loading**
```bash
railway run php artisan storage:link
railway up --force
```

**Issue: Slow Performance**
- Add Redis cache
- Enable Laravel caching:
  ```bash
  railway run php artisan config:cache
  railway run php artisan route:cache
  railway run php artisan view:cache
  ```

See complete troubleshooting in `RAILWAY_DEPLOYMENT_GUIDE.md`

## 💰 Cost Estimation

### Railway.app Pricing

**Starter Plan** (Free Trial):
- $5 credit/month
- Good for testing

**Developer Plan**:
- $10/month base
- $0.000231/GB-hour for RAM
- $0.000463/vCPU-hour

**Estimated Monthly Cost:**

| Configuration | Cost/Month |
|--------------|-----------|
| **Basic** (App + MySQL) | $10-15 |
| **Standard** (App + MySQL + Redis) | $15-25 |
| **Production** (App + MySQL + Redis + High availability) | $30-50 |

**Cost Optimization Tips:**
- Use Railway's hobby plan for development
- Scale down during low-traffic hours
- Use CDN for static assets
- Enable caching (Redis)

## 📊 Performance Optimization

### Recommended Settings

```bash
# Cache configuration
railway run php artisan config:cache
railway run php artisan route:cache
railway run php artisan view:cache

# Enable OPcache in production
railway variables set PHP_OPCACHE_ENABLE=1

# Use Redis for sessions
railway variables set SESSION_DRIVER=redis
```

### Monitoring

```bash
# View resource usage
railway status

# Check response times
railway logs | grep "request completed"

# Monitor errors
railway logs --filter "error"
```

## 🔒 Security Best Practices

- ✅ Always use HTTPS (enabled by default)
- ✅ Set `APP_DEBUG=false` in production
- ✅ Keep `APP_KEY` secret and unique
- ✅ Use environment variables for secrets
- ✅ Regular backups of database
- ✅ Keep dependencies updated
- ✅ Use strong passwords
- ✅ Enable 2FA for admin accounts
- ✅ Configure firewall rules

## 📚 Documentation

- **Quick Start:** `QUICK_START.md`
- **Complete Guide:** `RAILWAY_DEPLOYMENT_GUIDE.md`
- **CLI Reference:** `railway-commands.md`
- **FleetCart Docs:** `Documentation/` folder
- **Railway Docs:** https://docs.railway.app

## 🆘 Support

### Getting Help

1. **Check Documentation**
   - Read `RAILWAY_DEPLOYMENT_GUIDE.md`
   - Check `railway-commands.md`

2. **View Logs**
   ```bash
   railway logs --follow
   ```

3. **FleetCart Support**
   - Email: envaysoft@gmail.com

4. **Railway Support**
   - Discord: https://discord.gg/railway
   - Docs: https://docs.railway.app

### Useful Links

- 🌐 **Railway Dashboard:** https://railway.app/dashboard
- 📖 **Railway Docs:** https://docs.railway.app
- 💬 **Railway Community:** https://discord.gg/railway
- 📧 **FleetCart Support:** envaysoft@gmail.com

## ✅ Deployment Checklist

Use this checklist to ensure successful deployment:

- [ ] Railway account created
- [ ] Railway CLI installed (if using CLI method)
- [ ] Project deployed to Railway
- [ ] MySQL database added
- [ ] Environment variables configured
- [ ] APP_KEY generated
- [ ] Application is accessible via URL
- [ ] Installation wizard completed
- [ ] Admin account created
- [ ] First test product created
- [ ] Test order placed successfully
- [ ] Email notifications working
- [ ] Custom domain configured (optional)
- [ ] Redis cache enabled (optional)
- [ ] Backup strategy in place
- [ ] Monitoring configured

## 🎓 Learning Resources

### For Beginners
1. Start with `QUICK_START.md`
2. Use automated deployment script
3. Follow installation wizard
4. Watch Railway tutorials on YouTube

### For Developers
1. Review `RAILWAY_DEPLOYMENT_GUIDE.md`
2. Explore `railway-commands.md`
3. Customize `Dockerfile` and `railway.json`
4. Set up CI/CD with GitHub Actions

## 🚀 Next Steps

After successful deployment:

1. **Customize Your Store**
   - Add products
   - Configure payment gateways
   - Set up shipping methods
   - Customize theme

2. **Optimize Performance**
   - Enable Redis caching
   - Configure CDN
   - Optimize images
   - Enable compression

3. **Set Up Marketing**
   - Configure SEO settings
   - Set up email campaigns
   - Enable social integrations
   - Add analytics

4. **Launch!**
   - Test thoroughly
   - Announce your store
   - Monitor performance
   - Gather feedback

## 📄 License

FleetCart is a commercial product by Envaysoft. This deployment package is provided as a helper tool for Railway.app deployment.

## 🌟 Features

FleetCart includes:
- 🛍️ Product Management
- 🛒 Shopping Cart
- 💳 Multiple Payment Gateways
- 📦 Shipping Management
- 🎫 Coupon & Discounts
- 👥 Customer Management
- 📊 Analytics & Reports
- 🎨 Customizable Themes
- 📱 Responsive Design
- 🌐 Multi-language Support
- 💱 Multi-currency Support
- 📧 Email Marketing
- ⭐ Reviews & Ratings
- 🔍 Advanced Search
- And much more!

## 🎉 Success!

**Congratulations!** You now have a fully functional e-commerce store running on Railway.app with complete control and access.

Your store is ready to start selling! 🛍️

---

Made with ❤️ for FleetCart users deploying to Railway.app

**Questions?** Open an issue or contact support.

**Happy Selling!** 🚀


