# 🔧 Local Development Setup for FleetCart

Quick guide for running FleetCart locally before deploying to Railway.

## 🚀 Quick Start with Docker

### Prerequisites
- Docker Desktop installed
- Git (optional)

### Start Development Environment

```bash
# Navigate to project directory
cd FleetCart

# Start all services
docker-compose up -d

# Wait for services to start (about 30 seconds)

# Access your local store
# http://localhost:8080
```

### Services Running

| Service | URL | Credentials |
|---------|-----|-------------|
| **FleetCart** | http://localhost:8080 | Complete installation wizard |
| **phpMyAdmin** | http://localhost:8081 | User: `fleetcart`, Pass: `secret` |
| **MySQL** | localhost:3306 | User: `fleetcart`, Pass: `secret`, DB: `fleetcart` |
| **Redis** | localhost:6379 | No password |

## 🛠️ Development Commands

### Docker Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Rebuild containers
docker-compose up -d --build

# Stop and remove everything
docker-compose down -v
```

### Laravel Commands (Inside Container)

```bash
# Access container shell
docker-compose exec app bash

# Run artisan commands
docker-compose exec app php artisan [command]

# Examples:
docker-compose exec app php artisan migrate
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan tinker
docker-compose exec app php artisan make:controller ProductController
```

### Database Operations

```bash
# Access MySQL
docker-compose exec mysql mysql -u fleetcart -psecret fleetcart

# Backup database
docker-compose exec mysql mysqldump -u fleetcart -psecret fleetcart > backup.sql

# Restore database
docker-compose exec -T mysql mysql -u fleetcart -psecret fleetcart < backup.sql
```

## 📝 Making Changes

### Edit PHP Code

1. Make changes to any PHP files
2. Refresh browser (changes reflect immediately)
3. For config changes: `docker-compose exec app php artisan config:clear`

### Edit Frontend Assets

```bash
# Inside container
docker-compose exec app yarn dev

# Or rebuild assets
docker-compose exec app yarn build
```

### Install New Composer Package

```bash
docker-compose exec app composer require vendor/package
```

### Install New NPM Package

```bash
docker-compose exec app yarn add package-name
```

## 🧹 Maintenance

### Clear All Caches

```bash
docker-compose exec app php artisan optimize:clear
```

### Reset Database

```bash
docker-compose exec app php artisan migrate:fresh --seed
```

### Fix Permissions

```bash
docker-compose exec app chmod -R 775 storage bootstrap/cache
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
```

## 🐛 Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs

# Remove and recreate
docker-compose down -v
docker-compose up -d --build
```

### Database connection error

```bash
# Wait for MySQL to fully start
docker-compose logs mysql

# Verify database exists
docker-compose exec mysql mysql -u root -proot -e "SHOW DATABASES;"
```

### Permission errors

```bash
# Fix permissions
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

### Port already in use

Edit `docker-compose.yml` and change ports:
```yaml
ports:
  - "8080:80"  # Change 8080 to another port like 8082
```

## 🚀 Deploy to Railway

Once you're happy with local development:

```bash
# Stop local containers
docker-compose down

# Deploy to Railway
railway up
```

See `QUICK_START.md` for Railway deployment guide.

## 📊 Monitoring

### View Application Logs

```bash
docker-compose logs -f app
```

### View MySQL Logs

```bash
docker-compose logs -f mysql
```

### Monitor Resource Usage

```bash
docker stats
```

## 🎨 Customization

### Modify Theme

1. Edit files in `modules/Storefront/Resources/`
2. Rebuild assets: `docker-compose exec app yarn build`
3. Clear cache: `docker-compose exec app php artisan cache:clear`

### Add Custom Module

1. Create module: `docker-compose exec app php artisan module:make ModuleName`
2. Develop your module
3. Enable it: `docker-compose exec app php artisan module:enable ModuleName`

## 💡 Pro Tips

1. **Use hot reload for frontend:**
   ```bash
   docker-compose exec app yarn dev
   ```

2. **Keep phpMyAdmin open** for easy database inspection

3. **Use tinker for testing:**
   ```bash
   docker-compose exec app php artisan tinker
   ```

4. **Tail logs while developing:**
   ```bash
   docker-compose logs -f app
   ```

5. **Create database backups regularly:**
   ```bash
   docker-compose exec mysql mysqldump -u fleetcart -psecret fleetcart > backup-$(date +%Y%m%d).sql
   ```

## 🔄 Sync with Production

### Pull Production Database

```bash
# Export from Railway
railway run mysqldump -h $MYSQLHOST -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE > production.sql

# Import to local
docker-compose exec -T mysql mysql -u fleetcart -psecret fleetcart < production.sql
```

### Push to Production

```bash
# Commit changes
git add .
git commit -m "Your changes"

# Push to Railway
railway up
```

## 📚 Resources

- **Laravel Documentation:** https://laravel.com/docs
- **Docker Documentation:** https://docs.docker.com
- **FleetCart Docs:** See `Documentation/` folder

## ✅ Development Checklist

- [ ] Docker Desktop installed
- [ ] Project cloned/downloaded
- [ ] `docker-compose up -d` executed
- [ ] Services are running
- [ ] Accessed http://localhost:8080
- [ ] Completed installation wizard
- [ ] Created test products
- [ ] Made customizations
- [ ] Tested all features
- [ ] Ready to deploy to Railway!

---

Happy Coding! 🎉




