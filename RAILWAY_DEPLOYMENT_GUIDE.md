# 🚀 FleetCart Deployment Guide for Railway.app

This guide will help you deploy FleetCart e-commerce platform to Railway.app with full control and access.

## 📋 Prerequisites

Before you begin, ensure you have:
- A Railway.app account (Sign up at https://railway.app)
- Git installed on your local machine
- Basic understanding of environment variables

## 🎯 Quick Deployment Steps

### Step 1: Prepare Your Project

1. **Navigate to the FleetCart directory:**
   ```bash
   cd FleetCart
   ```

2. **Initialize Git repository (if not already initialized):**
   ```bash
   git init
   git add .
   git commit -m "Initial FleetCart deployment"
   ```

### Step 2: Set Up Railway Project

1. **Install Railway CLI:**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway:**
   ```bash
   railway login
   ```

3. **Create a new Railway project:**
   ```bash
   railway init
   ```
   - Choose "Empty Project"
   - Give it a name like "fleetcart-store"

### Step 3: Add MySQL Database

1. **Add MySQL service from Railway dashboard:**
   - Go to https://railway.app/dashboard
   - Open your project
   - Click "New" → "Database" → "Add MySQL"
   - Railway will automatically create a MySQL database

2. **Note the database credentials** (available in the MySQL service variables)

### Step 4: Configure Environment Variables

1. **In Railway dashboard, go to your app service and add these variables:**

   ```env
   APP_NAME=FleetCart
   APP_ENV=production
   APP_DEBUG=false
   APP_KEY=base64:GENERATE_THIS_LATER
   APP_TIMEZONE=UTC
   APP_LOCALE=en
   
   # Database (these will be auto-filled if you reference MySQL service)
   DB_CONNECTION=mysql
   DB_HOST=${{MySQL.MYSQLHOST}}
   DB_PORT=${{MySQL.MYSQLPORT}}
   DB_DATABASE=${{MySQL.MYSQLDATABASE}}
   DB_USERNAME=${{MySQL.MYSQLUSER}}
   DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
   
   # Cache & Session
   CACHE_DRIVER=file
   SESSION_DRIVER=file
   QUEUE_CONNECTION=sync
   
   # Mail Configuration (Optional - update later)
   MAIL_MAILER=smtp
   MAIL_HOST=smtp.mailtrap.io
   MAIL_PORT=2525
   MAIL_USERNAME=
   MAIL_PASSWORD=
   MAIL_ENCRYPTION=
   MAIL_FROM_ADDRESS=noreply@yourdomain.com
   MAIL_FROM_NAME=FleetCart
   
   # GitHub Authentication (Required!)
   # Create a Personal Access Token at https://github.com/settings/tokens
   # Grant 'repo' scope for private repositories
   GITHUB_TOKEN=your_github_personal_access_token_here
   
   # FleetCart
   INSTALLED=false
   ```

2. **Important:** The `APP_URL` will be auto-set by Railway to your public domain

3. **⚠️ CRITICAL: GitHub Token Setup**
   
   FleetCart requires a GitHub Personal Access Token to access private repositories during the build. 
   Without this, the build will fail with authentication errors.
   
   **Steps to create the token:**
   1. Go to https://github.com/settings/tokens
   2. Click "Generate new token (classic)"
   3. Give it a name like "FleetCart Railway Build"
   4. Grant the `repo` scope (to access private repositories)
   5. Click "Generate token"
   6. Copy the token and paste it in the `GITHUB_TOKEN` variable above

### Step 5: Deploy to Railway

**Option A: Using Railway CLI (Recommended)**

```bash
# Link to your Railway project
railway link

# Deploy
railway up
```

**Option B: Using GitHub Integration**

1. Push your code to GitHub:
   ```bash
   git remote add origin https://github.com/yourusername/fleetcart.git
   git push -u origin main
   ```

2. In Railway dashboard:
   - Click "New" → "GitHub Repo"
   - Select your FleetCart repository
   - Railway will auto-deploy

### Step 6: Run Initial Setup

After deployment, you need to run the installation:

1. **Generate Application Key:**
   ```bash
   railway run php artisan key:generate
   ```

2. **Access your Railway app URL** (found in Railway dashboard under "Settings" → "Domains")
   - Example: `https://your-app.up.railway.app`

3. **Complete the FleetCart installation wizard:**
   - Open your app URL in browser
   - Follow the installation steps
   - Enter your database credentials (already configured)
   - Create admin account
   - Configure store settings

### Step 7: Configure Custom Domain (Optional)

1. In Railway dashboard:
   - Go to your service
   - Click "Settings" → "Domains"
   - Click "Add Domain"
   - Enter your custom domain
   - Update DNS records as instructed

2. Update environment variable:
   ```
   APP_URL=https://yourdomain.com
   ```

## 🔧 Post-Deployment Configuration

### Enable Redis Cache (Recommended for Performance)

1. **Add Redis service in Railway:**
   - Click "New" → "Database" → "Add Redis"

2. **Update environment variables:**
   ```env
   REDIS_HOST=${{Redis.REDISHOST}}
   REDIS_PASSWORD=${{Redis.REDISPASSWORD}}
   REDIS_PORT=${{Redis.REDISPORT}}
   CACHE_DRIVER=redis
   SESSION_DRIVER=redis
   QUEUE_CONNECTION=redis
   ```

3. **Redeploy the application**

### Set Up Email Service

Choose an email service and update the MAIL_* variables:

**Option 1: Mailgun**
```env
MAIL_MAILER=mailgun
MAILGUN_DOMAIN=your-domain.mailgun.org
MAILGUN_SECRET=your-secret-key
```

**Option 2: SendGrid**
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=apikey
MAIL_PASSWORD=your-sendgrid-api-key
MAIL_ENCRYPTION=tls
```

**Option 3: AWS SES**
```env
MAIL_MAILER=ses
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1
```

### Configure Storage

**For File Uploads (AWS S3 Recommended):**

1. **Install S3 driver** (add to composer.json):
   ```bash
   railway run composer require league/flysystem-aws-s3-v3
   ```

2. **Update environment:**
   ```env
   FILESYSTEM_DISK=s3
   AWS_ACCESS_KEY_ID=your-key
   AWS_SECRET_ACCESS_KEY=your-secret
   AWS_DEFAULT_REGION=us-east-1
   AWS_BUCKET=your-bucket-name
   AWS_URL=https://your-bucket.s3.amazonaws.com
   ```

## 🔐 Security Best Practices

1. **Always use HTTPS** (Railway provides this by default)
2. **Set strong APP_KEY** (auto-generated with `php artisan key:generate`)
3. **Keep APP_DEBUG=false** in production
4. **Use strong database passwords**
5. **Regular backups** of your database
6. **Keep dependencies updated**

## 📊 Monitoring & Maintenance

### View Logs
```bash
railway logs
```

### Access Database
```bash
railway run php artisan tinker
```

### Run Migrations
```bash
railway run php artisan migrate
```

### Clear Cache
```bash
railway run php artisan cache:clear
railway run php artisan config:clear
railway run php artisan route:clear
railway run php artisan view:clear
```

### Database Backup
```bash
# Export database
railway run mysqldump -h $MYSQLHOST -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE > backup.sql
```

## 🎨 Customization & Full Control

### Access Admin Panel
- URL: `https://your-app-url/admin`
- Login with credentials created during installation

### Modify Theme
- Edit files in `modules/Storefront/Resources/`
- For CSS/JS changes, run `yarn build` and redeploy

### Install Extensions/Modules
- Upload modules to `modules/` directory
- Run migrations: `railway run php artisan module:migrate ModuleName`
- Clear cache and redeploy

### Update FleetCart
1. Backup database and files
2. Replace files (keep .env)
3. Run migrations: `railway run php artisan migrate`
4. Clear cache

## 🛠️ Troubleshooting

### Issue: 500 Internal Server Error
**Solution:**
```bash
railway run php artisan config:clear
railway run php artisan cache:clear
```
Check logs: `railway logs`

### Issue: Database Connection Failed
**Solution:**
- Verify database service is running
- Check environment variables match MySQL service
- Ensure database is created

### Issue: File Upload Not Working
**Solution:**
- Check storage permissions
- Configure S3 or similar cloud storage
- Verify FILESYSTEM_DISK setting

### Issue: Emails Not Sending
**Solution:**
- Verify MAIL_* environment variables
- Test with `railway run php artisan tinker` then `Mail::raw('test', function($msg) { $msg->to('test@example.com'); })`
- Check email service logs

## 💰 Cost Estimation

Railway.app pricing (as of 2024):
- **Hobby Plan:** $5/month (500 hours of usage)
- **Developer Plan:** $10/month (1000 hours)
- **Team Plan:** $20/month per user

**Recommended setup:**
- App Service: ~$5-10/month
- MySQL Database: ~$5-10/month  
- Redis (optional): ~$5/month
- **Total:** ~$10-25/month depending on traffic

## 📚 Additional Resources

- **FleetCart Documentation:** Check the `/Documentation` folder
- **Railway Documentation:** https://docs.railway.app
- **Laravel Documentation:** https://laravel.com/docs/11.x
- **Support:** envaysoft@gmail.com

## ✅ Deployment Checklist

- [ ] Railway account created
- [ ] Railway CLI installed
- [ ] Project initialized in Railway
- [ ] MySQL database added
- [ ] Environment variables configured
- [ ] Application deployed
- [ ] APP_KEY generated
- [ ] Installation wizard completed
- [ ] Admin account created
- [ ] Custom domain configured (optional)
- [ ] Redis cache enabled (optional)
- [ ] Email service configured
- [ ] Storage configured
- [ ] SSL certificate verified
- [ ] First test order placed

## 🎉 Success!

Your FleetCart e-commerce store is now live on Railway.app! You have full control over:
- ✅ Source code
- ✅ Database
- ✅ Server configuration
- ✅ Environment variables
- ✅ Deployment process
- ✅ Scaling options

**Your store URL:** `https://your-project.up.railway.app`
**Admin panel:** `https://your-project.up.railway.app/admin`

Happy selling! 🛍️


