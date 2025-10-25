# 🚀 FleetCart Local Development - Complete Setup Guide

This guide walks you through setting up FleetCart locally using Docker.

---

## 📋 Prerequisites Check

Before starting, ensure you have:

- [x] **Docker Desktop** installed and running
- [x] **8GB+ RAM** available
- [x] **5GB+ disk space** free
- [x] **Ports available:** 8080, 8081, 3306, 6379

---

## 🎯 Step-by-Step Setup

### Step 1: Start Docker Desktop

1. Open **Docker Desktop**
2. Wait for it to say "Docker Desktop is running"
3. Ensure the Docker icon in system tray shows it's active

### Step 2: Navigate to FleetCart Directory

```bash
cd C:\Users\Admin\Downloads\fleetcart_v4.7.2\FleetCart
```

### Step 3: Start All Services

```bash
docker-compose up -d
```

**What this does:**
- Downloads required Docker images (first time only, ~2-3 minutes)
- Starts 4 services:
  - FleetCart application (PHP + Apache)
  - MySQL database
  - Redis cache
  - phpMyAdmin (database management)

**Expected output:**
```
Creating network "fleetcart_fleetcart" with driver "bridge"
Creating volume "fleetcart_mysql_data" with local driver
Pulling mysql (mysql:8.0)...
Pulling redis (redis:7-alpine)...
Pulling phpmyadmin (phpmyadmin/phpmyadmin)...
Creating fleetcart_mysql ... done
Creating fleetcart_redis ... done
Creating fleetcart_app ... done
Creating fleetcart_phpmyadmin ... done
```

### Step 4: Wait for Services (Important!)

Wait **60-90 seconds** for all services to fully start, especially MySQL.

**Check if ready:**
```bash
docker-compose ps
```

**All services should show "Up":**
```
Name                    State     Ports
------------------------------------------------------
fleetcart_app          Up        0.0.0.0:8080->80/tcp
fleetcart_mysql        Up        0.0.0.0:3306->3306/tcp
fleetcart_phpmyadmin   Up        0.0.0.0:8081->80/tcp
fleetcart_redis        Up        0.0.0.0:6379->6379/tcp
```

### Step 5: Check Application Logs

```bash
docker-compose logs app
```

**Look for:**
```
✅ Database connection established!
✅ Starting web server...
AH00558: apache2: Could not reliably determine... (this is normal)
```

### Step 6: Access FleetCart

Open your browser and go to:

**http://localhost:8080**

You should see the **FleetCart Installation Wizard**!

---

## 🎨 Installation Wizard Walkthrough

### Screen 1: Server Requirements

All requirements should be ✅ green (met).

Click **"Continue"** or **"Next Step"**

### Screen 2: Database Configuration

**The form should be pre-filled:**
- Database Type: `MySQL`
- Host: `mysql` (the container name)
- Port: `3306`
- Database: `fleetcart`
- Username: `fleetcart`
- Password: `secret`

Click **"Test Connection"** - should succeed ✅

Click **"Continue"**

### Screen 3: Admin Account

**Create your admin account:**
- First Name: `Admin`
- Last Name: `User`
- Email: `admin@fleetcart.local`
- Password: `admin123` (or your choice)
- Confirm Password: (same as above)

Click **"Continue"**

### Screen 4: Store Information

**Configure your store:**
- Store Name: `My Local Store`
- Store Email: `store@fleetcart.local`
- Country: `United States` (or your choice)
- Timezone: `America/New_York` (or your choice)
- Currency: `USD` (or your choice)

Click **"Install"**

### Installation Progress

Wait 1-2 minutes while FleetCart:
- Creates database tables
- Seeds initial data
- Sets up permissions
- Configures settings

### Success!

You'll see a success message with:
- Store URL: `http://localhost:8080`
- Admin URL: `http://localhost:8080/admin`

---

## 🎉 You're Ready!

### Access Your Local Store

**Frontend (Customer view):**
- URL: http://localhost:8080
- This is what customers see

**Backend (Admin panel):**
- URL: http://localhost:8080/admin
- Email: `admin@fleetcart.local` (or what you set)
- Password: `admin123` (or what you set)

**Database Management:**
- URL: http://localhost:8081
- Server: `mysql`
- Username: `fleetcart`
- Password: `secret`

---

## 🛠️ Development Workflow

### Making Code Changes

#### PHP Changes
1. Edit any PHP file in `FleetCart/` directory
2. Save the file
3. Refresh browser - changes appear immediately!

#### Frontend Changes (CSS/JS)

**Option 1: Quick rebuild**
```bash
docker-compose exec app yarn build
```

**Option 2: Watch mode (auto-rebuild)**
```bash
docker-compose exec app yarn dev
```

#### Config Changes
```bash
docker-compose exec app php artisan config:clear
```

### Common Commands

**View all logs:**
```bash
docker-compose logs -f
```

**View app logs only:**
```bash
docker-compose logs -f app
```

**Run artisan commands:**
```bash
docker-compose exec app php artisan [command]
```

**Examples:**
```bash
# Create a new controller
docker-compose exec app php artisan make:controller ProductController

# Run migrations
docker-compose exec app php artisan migrate

# Clear cache
docker-compose exec app php artisan cache:clear

# Create admin user
docker-compose exec app php artisan tinker
```

**Access MySQL directly:**
```bash
docker-compose exec mysql mysql -u fleetcart -psecret fleetcart
```

**Restart services:**
```bash
docker-compose restart
```

**Stop services:**
```bash
docker-compose down
```

**Stop and remove everything (including database):**
```bash
docker-compose down -v
```

---

## 🎨 Quick Tasks to Try

### 1. Add Your First Product

1. Login to admin: http://localhost:8080/admin
2. Go to **Products** → **Add Product**
3. Fill in:
   - Name: `Test Product`
   - Price: `$29.99`
   - Description: `This is a test product`
4. Upload an image (optional)
5. Click **Save**

### 2. Customize Theme

1. Navigate to `FleetCart/modules/Storefront/Resources/`
2. Edit CSS files in `sass/` folder
3. Rebuild: `docker-compose exec app yarn build`
4. Refresh browser

### 3. Test Database

1. Open phpMyAdmin: http://localhost:8081
2. Login with: `fleetcart` / `secret`
3. Browse tables
4. Run SQL queries

### 4. Check Email (Development)

Emails go to logs in development:
```bash
docker-compose logs app | grep -i "mail"
```

---

## 🐛 Troubleshooting

### Problem: "Cannot connect to Docker"

**Solution:**
1. Open Docker Desktop
2. Wait for it to fully start
3. Check system tray icon is active
4. Try again

### Problem: "Port 8080 already in use"

**Solution:**
Edit `docker-compose.yml`:
```yaml
ports:
  - "8082:80"  # Changed from 8080
```

Then access: http://localhost:8082

### Problem: "Database connection failed"

**Solution:**
Wait 30 more seconds and try again. MySQL takes time to initialize.

**Or check logs:**
```bash
docker-compose logs mysql
```

### Problem: "Containers not starting"

**Solution:**
```bash
# Stop everything
docker-compose down

# Remove volumes
docker-compose down -v

# Rebuild and start
docker-compose up -d --build
```

### Problem: "Permission errors"

**Solution:**
```bash
docker-compose exec app chmod -R 775 storage bootstrap/cache
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
```

### Problem: "White screen / 500 error"

**Solution:**
```bash
# Clear all caches
docker-compose exec app php artisan optimize:clear

# Check logs
docker-compose logs app
```

---

## 📊 Service URLs Reference

| Service | URL | Credentials |
|---------|-----|-------------|
| **FleetCart Store** | http://localhost:8080 | - |
| **Admin Panel** | http://localhost:8080/admin | Set during installation |
| **phpMyAdmin** | http://localhost:8081 | User: `fleetcart`, Pass: `secret` |
| **MySQL Direct** | localhost:3306 | User: `fleetcart`, Pass: `secret`, DB: `fleetcart` |
| **Redis** | localhost:6379 | No password |

---

## 🎓 Next Steps

### Learn FleetCart
1. Explore admin panel features
2. Add products, categories
3. Configure payment gateways (test mode)
4. Set up shipping methods
5. Customize theme

### Prepare for Deployment
1. Test all features locally
2. Backup your database
3. Read `RAILWAY_DEPLOYMENT_GUIDE.md`
4. Deploy to Railway when ready

### Development Tips
1. Use `local-dev-commands.bat` for quick access to commands
2. Keep Docker Desktop running
3. Monitor logs: `docker-compose logs -f`
4. Backup database regularly
5. Commit changes to Git

---

## 🧹 Cleanup

### Stop Services (Keep Data)
```bash
docker-compose down
```

### Stop & Remove Everything
```bash
docker-compose down -v
# Warning: This deletes the database!
```

### Start Fresh
```bash
docker-compose down -v
docker-compose up -d
# Reinstall FleetCart
```

---

## 🎉 Success Checklist

- [x] Docker Desktop running
- [x] Containers started: `docker-compose up -d`
- [x] All services show "Up": `docker-compose ps`
- [x] FleetCart accessible: http://localhost:8080
- [x] Installation wizard completed
- [x] Admin login working
- [x] First product added
- [x] Database accessible via phpMyAdmin

---

## 💡 Pro Tips

1. **Use helper script:** Run `local-dev-commands.bat` for easy access
2. **Keep logs open:** `docker-compose logs -f` in separate terminal
3. **Bookmark URLs:** Save localhost:8080 and localhost:8081
4. **Regular backups:** Export database from phpMyAdmin
5. **Git commits:** Commit working changes regularly

---

## 📞 Need Help?

- **Check logs:** `docker-compose logs -f`
- **Restart:** `docker-compose restart`
- **Full guide:** `LOCAL_DEVELOPMENT.md`
- **Commands:** `railway-commands.md`

---

**Happy Local Development!** 🚀

Your FleetCart store is running locally at **http://localhost:8080**!


