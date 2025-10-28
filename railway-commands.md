# 🚂 Railway CLI Commands Cheat Sheet

Quick reference for managing your FleetCart deployment on Railway.

## 🔧 Essential Commands

### Initial Setup
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Initialize new project
railway init

# Link to existing project
railway link
```

### Deployment
```bash
# Deploy current directory
railway up

# Deploy with watch mode (redeploy on changes)
railway up --detach

# Deploy specific service
railway up --service [service-name]
```

### Environment Variables
```bash
# List all variables
railway variables

# Set a variable
railway variables set KEY=value

# Set multiple variables
railway variables set KEY1=value1 KEY2=value2

# Delete a variable
railway variables delete KEY
```

### Logs & Monitoring
```bash
# View logs
railway logs

# Follow logs (live)
railway logs --follow

# Filter logs
railway logs --filter "error"
```

### Database Operations
```bash
# Connect to MySQL
railway run mysql -u $MYSQLUSER -p$MYSQLPASSWORD -h $MYSQLHOST $MYSQLDATABASE

# Export database
railway run mysqldump -u $MYSQLUSER -p$MYSQLPASSWORD -h $MYSQLHOST $MYSQLDATABASE > backup.sql

# Import database
railway run mysql -u $MYSQLUSER -p$MYSQLPASSWORD -h $MYSQLHOST $MYSQLDATABASE < backup.sql
```

### Laravel Artisan Commands
```bash
# Run any artisan command
railway run php artisan [command]

# Generate application key
railway run php artisan key:generate

# Clear all caches
railway run php artisan optimize:clear

# Run migrations
railway run php artisan migrate

# Rollback migrations
railway run php artisan migrate:rollback

# Create admin user
railway run php artisan tinker
>>> User::create(['name' => 'Admin', 'email' => 'admin@example.com', 'password' => bcrypt('password')])

# Clear specific cache
railway run php artisan cache:clear
railway run php artisan config:clear
railway run php artisan route:clear
railway run php artisan view:clear

# Queue commands
railway run php artisan queue:work
railway run php artisan queue:restart

# Create symbolic link for storage
railway run php artisan storage:link
```

### Project Management
```bash
# List all projects
railway list

# Switch project
railway link

# Open project in browser
railway open

# Get project info
railway status

# Disconnect from project
railway unlink
```

### Service Management
```bash
# List services
railway service

# Create new service
railway service create

# Delete service
railway service delete
```

### Domain Management
```bash
# Add custom domain
railway domain

# List domains
railway domain list
```

### Environment Management
```bash
# List environments
railway environment

# Switch environment
railway environment [environment-name]
```

## 🔨 Maintenance Commands

### Clear All Caches
```bash
railway run php artisan optimize:clear
```

### Rebuild Application
```bash
railway up --force
```

### Restart Service
```bash
# In Railway dashboard: Service → Settings → Restart
```

### Update Dependencies
```bash
railway run composer install --no-dev --optimize-autoloader
railway run yarn install && yarn build
```

## 🐛 Debugging Commands

### Check Application Status
```bash
railway run php artisan about
```

### Test Database Connection
```bash
railway run php artisan db:show
```

### Check Environment
```bash
railway run php artisan env
```

### Run in Debug Mode
```bash
railway variables set APP_DEBUG=true
# Don't forget to set it back to false!
railway variables set APP_DEBUG=false
```

### Access Shell
```bash
railway shell
```

## 📦 Backup & Restore

### Full Backup
```bash
# Backup database
railway run mysqldump -u $MYSQLUSER -p$MYSQLPASSWORD -h $MYSQLHOST $MYSQLDATABASE > backup-$(date +%Y%m%d).sql

# Backup files
tar -czf fleetcart-files-$(date +%Y%m%d).tar.gz storage/ public/
```

### Restore
```bash
# Restore database
railway run mysql -u $MYSQLUSER -p$MYSQLPASSWORD -h $MYSQLHOST $MYSQLDATABASE < backup.sql

# Restore files
tar -xzf fleetcart-files.tar.gz
railway up
```

## 🚀 Performance Optimization

### Cache Everything
```bash
railway run php artisan config:cache
railway run php artisan route:cache
railway run php artisan view:cache
```

### Optimize Composer
```bash
railway run composer install --optimize-autoloader --no-dev
```

## 🔄 Updates & Migrations

### Update FleetCart
```bash
# Backup first!
railway run mysqldump [...] > backup.sql

# Pull new code
git pull origin main

# Install dependencies
railway run composer install --no-dev
railway run yarn install && yarn build

# Run migrations
railway run php artisan migrate --force

# Clear caches
railway run php artisan optimize:clear
```

## 📊 Monitoring

### Check Resource Usage
```bash
# In Railway dashboard: Metrics tab
```

### View Build Logs
```bash
railway logs --deployment [deployment-id]
```

## 🆘 Emergency Commands

### Rollback Deployment
```bash
# In Railway dashboard: Deployments → Click previous deployment → Rollback
```

### Force Rebuild
```bash
railway up --force
```

### Reset Database (⚠️ DANGEROUS)
```bash
railway run php artisan migrate:fresh
# This will delete all data!
```

## 💡 Pro Tips

1. **Always backup before running migrations or updates**
   ```bash
   railway run mysqldump [...] > backup-$(date +%Y%m%d).sql
   ```

2. **Use environment variables for sensitive data**
   ```bash
   railway variables set API_KEY=your-secret-key
   ```

3. **Monitor costs regularly**
   ```bash
   railway status
   ```

4. **Test commands locally first**
   ```bash
   # Local test
   php artisan migrate --pretend
   
   # Then on Railway
   railway run php artisan migrate
   ```

5. **Use staging environment**
   ```bash
   railway environment staging
   railway up
   ```

## 📞 Getting Help

```bash
# Get help on any command
railway --help
railway [command] --help

# Check Railway status
railway status

# Open Railway dashboard
railway open
```

---

**Quick Deploy:** `railway up`
**View Logs:** `railway logs --follow`
**Run Command:** `railway run [command]`




