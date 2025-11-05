# Google Cloud Platform (GCP) Free Tier Deployment Guide for FleetCart

Complete step-by-step guide to deploy FleetCart on Google Cloud's always-free tier with full control.

## Why Google Cloud Platform?

- **Always Free Tier** (f1-micro instance forever)
- **Full SSH Root Access** to VM
- **$300 Free Credits** for first 90 days (optional, but helpful)
- **Reliable Infrastructure** - Google's network
- **Docker Support** - can use your existing Dockerfile
- **Easy Domain Setup** with Cloud DNS

## Free Tier Specs
- **Instance**: f1-micro (1 vCPU, 0.6GB RAM)
- **Storage**: 30GB standard persistent disk
- **Traffic**: 1GB network egress per month (Americas/APAC)
- **Always Free**: No time limit (unlike AWS 12-month limit)

## Part 1: Google Cloud Account Setup

### 1.1 Create Account
1. Go to [cloud.google.com](https://cloud.google.com)
2. Click **"Get started for free"**
3. **Sign in** with existing Google account or create new one
4. **Enter credit card** (required but won't be charged for always-free usage)
5. **Select country** and agree to terms
6. **Verify identity** and complete setup

### 1.2 Enable Compute Engine API
1. Go to **Console** → **APIs & Services** → **Library**
2. Search for **"Compute Engine API"**
3. Click **"Enable"**

## Part 2: Create Your VM Instance

### 2.1 Navigate to Compute Engine
1. **Google Cloud Console** → **Compute Engine** → **VM instances**
2. Click **"Create Instance"**

### 2.2 Configure Instance
```
Name: fleetcart-server
Region: us-central1 (Iowa) - always free eligible
Zone: us-central1-a (or any in us-central1)
```

**Important**: Only these regions are always-free eligible:
- `us-west1` (Oregon)
- `us-central1` (Iowa)  
- `us-east1` (South Carolina)

### 2.3 Machine Configuration
**Machine Family**: General-purpose
**Series**: N1
**Machine Type**: f1-micro (1 vCPU, 0.614 GB memory) - **Always Free**

### 2.4 Boot Disk
1. Click **"Change"** on Boot disk
2. **Operating System**: Ubuntu
3. **Version**: Ubuntu 22.04 LTS
4. **Boot disk type**: Standard persistent disk
5. **Size**: 30 GB (always free limit)
6. Click **"Select"**

### 2.5 Firewall
- ✅ **Allow HTTP traffic**
- ✅ **Allow HTTPS traffic**

### 2.6 Create Instance
- Click **"Create"**
- Wait 1-2 minutes for **"RUNNING"** status
- **Note the External IP address**

## Part 3: Configure VM and Install Docker

### 3.1 Connect to Your VM
**Option 1 - Browser SSH (Easiest)**:
1. In **VM instances**, click **SSH** button next to your instance
2. Browser SSH window will open

**Option 2 - Local SSH**:
```powershell
# Install Google Cloud SDK first (optional)
# Or use gcloud command after SDK install:
gcloud compute ssh fleetcart-server --zone=us-central1-a
```

### 3.2 Initial VM Setup
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl wget git htop nano ufw

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Log out and back in for docker group to take effect
exit
```

**Reconnect via SSH** (browser or command line)

**Test Docker**:
```bash
docker --version
docker-compose --version
```

### 3.3 Configure Firewall (UFW)
```bash
# Configure UFW firewall
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
sudo ufw status
```

**Note**: GCP firewall rules are already configured (we enabled HTTP/HTTPS in step 2.5)

## Part 4: Optimize for Limited RAM (Important!)

Since f1-micro only has 0.6GB RAM, we need to optimize:

### 4.1 Create Swap File
```bash
# Create 1GB swap file (helps with memory)
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make swap permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Verify swap is active
free -h
```

### 4.2 Optimize Docker for Low Memory
```bash
# Create Docker daemon config for memory optimization
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker
sudo systemctl restart docker
```

## Part 5: Deploy FleetCart (Optimized)

### 5.1 Clone Your Repository
```bash
# Clone your FleetCart repository
git clone https://github.com/harshjeswani30/Raj-Fashion.git
cd Raj-Fashion
```

### 5.2 Create Lightweight Environment File
```bash
# Copy example environment
cp .env.example .env

# Edit environment variables
nano .env
```

**Update these key variables in .env**:
```bash
APP_ENV=production
APP_DEBUG=false
APP_URL=http://YOUR_EXTERNAL_IP

# Use SQLite instead of MySQL to save memory
DB_CONNECTION=sqlite
DB_DATABASE=/var/www/html/database/database.sqlite

# Disable unnecessary features to save memory
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
BROADCAST_DRIVER=log

# Mail settings (configure later)
MAIL_MAILER=log
```

### 5.3 Create Memory-Optimized Docker Compose
```bash
nano docker-compose.yml
```

**Add this lightweight configuration**:
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "80:80"
    environment:
      - APP_ENV=production
      - DB_CONNECTION=sqlite
      - DB_DATABASE=/var/www/html/database/database.sqlite
    volumes:
      - ./storage:/var/www/html/storage
      - ./bootstrap/cache:/var/www/html/bootstrap/cache
      - ./database:/var/www/html/database
    restart: unless-stopped
    mem_limit: 500m
    memswap_limit: 500m
```

### 5.4 Prepare SQLite Database
```bash
# Create database directory and file
mkdir -p database
touch database/database.sqlite
chmod 666 database/database.sqlite
```

### 5.5 Deploy Application
```bash
# Build and start container (this may take 5-10 minutes on f1-micro)
docker-compose up -d --build

# Check if container is running
docker-compose ps

# View logs
docker-compose logs -f app
```

### 5.6 Initialize Application
```bash
# Wait for container to fully start (2-3 minutes)
sleep 180

# Initialize database and application
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate --force
docker-compose exec app php artisan storage:link

# Clear caches
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear
```

## Part 6: Configure Domain (Optional)

### 6.1 Reserve Static IP (Recommended)
```bash
# Using gcloud command (if SDK installed)
gcloud compute addresses create fleetcart-ip --region=us-central1

# Or via Console: VPC network → External IP addresses → Reserve Static Address
```

### 6.2 Point Domain to GCP
1. **Buy domain** from Namecheap, Google Domains, etc.
2. **Add A record**: `@` pointing to your GCP external IP
3. **Add CNAME record**: `www` pointing to your domain

### 6.3 Update Application URL
```bash
# Edit .env file
nano .env

# Change APP_URL
APP_URL=https://yourdomain.com

# Restart application
docker-compose restart app
```

### 6.4 SSL Certificate (Free with Cloudflare)
1. **Sign up** for Cloudflare (free)
2. **Add your domain** to Cloudflare
3. **Change nameservers** to Cloudflare's
4. **Set SSL mode** to "Flexible" or "Full"
5. Enable **"Always Use HTTPS"**

## Part 7: Performance Monitoring & Optimization

### 7.1 Monitor Resource Usage
```bash
# Check memory and CPU usage
htop

# Check disk usage
df -h

# Check Docker container stats
docker stats

# Check swap usage
free -h
```

### 7.2 Performance Tips for f1-micro

**If site is slow**:
```bash
# Reduce Docker memory limit
# Edit docker-compose.yml, change mem_limit to 400m

# Enable PHP opcache (add to Dockerfile)
RUN docker-php-ext-install opcache

# Use file-based caching instead of Redis/Memcached
# (Already configured in .env above)
```

### 7.3 Useful Commands
```bash
# View application logs
docker-compose logs -f app

# Restart application
docker-compose restart app

# Update application (when you push changes)
git pull
docker-compose up -d --build

# Backup SQLite database
cp database/database.sqlite database/backup-$(date +%Y%m%d).sqlite

# Clean up Docker to free space
docker system prune -a
```

## Part 8: Scaling Up (When Needed)

### 8.1 Upgrade Instance (Paid)
If you need more power later:
1. **Stop the instance**
2. **Change machine type** to n1-standard-1 (1 vCPU, 3.75GB RAM)
3. **Start the instance**
4. **Switch to MySQL** for better performance:
   - Add MySQL container to docker-compose.yml
   - Update .env to use MySQL
   - Migrate SQLite data to MySQL

### 8.2 Load Balancer (Advanced)
For high traffic:
1. **Create instance template**
2. **Set up managed instance group**
3. **Add load balancer**
4. **Use Cloud SQL** for database

## Part 9: Troubleshooting

### 9.1 Common Issues

**Out of Memory**:
```bash
# Check memory usage
free -h

# Add more swap
sudo fallocate -l 2G /swapfile2
sudo chmod 600 /swapfile2
sudo mkswap /swapfile2
sudo swapon /swapfile2
```

**Container keeps restarting**:
```bash
# Check logs
docker-compose logs app

# Usually memory-related, reduce mem_limit in docker-compose.yml
```

**Can't access website**:
1. Check external IP: **Compute Engine** → **VM instances**
2. Check firewall: **VPC network** → **Firewall**
3. Check container: `docker-compose ps`

**Database errors**:
```bash
# Check SQLite file permissions
ls -la database/
sudo chown www-data:www-data database/database.sqlite
```

### 9.2 Cost Monitoring
```bash
# Check if you're using free tier (should show $0.00)
# Console → Billing → Overview

# Set up billing alerts
# Console → Billing → Budgets & alerts
```

## Part 10: Alternative: Render.com (Easier Option)

If GCP f1-micro is too limited, consider **Render.com**:
- **750 hours/month free** (enough for small sites)
- **Automatic deployments** from GitHub
- **Built-in SSL** and CDN
- **PostgreSQL database** included
- **Less control** but much easier setup

**Render Setup** (quick alternative):
1. Sign up at [render.com](https://render.com)
2. **Connect GitHub** repository
3. **Create Web Service**:
   - Build Command: `docker build -t app .`
   - Start Command: `apache2-foreground`
4. **Add PostgreSQL database** (free)
5. **Set environment variables**
6. **Deploy automatically**

## Summary

You now have FleetCart running on Google Cloud's always-free tier:

- ✅ **Free f1-micro instance** (always free)
- ✅ **SQLite database** (lightweight)
- ✅ **Docker deployment** with memory optimization
- ✅ **1GB swap** for better performance
- ✅ **SSL ready** with Cloudflare
- ✅ **Monitoring** and maintenance commands

**Performance Notes**:
- f1-micro is suitable for **low-traffic sites** (100-500 visitors/day)
- For higher traffic, upgrade to paid instance
- Consider Render.com if GCP is too technical

**Your FleetCart site should be live at**: `http://YOUR_EXTERNAL_IP`

Need help with any step? The troubleshooting section covers common issues!