# Oracle Cloud Always Free Deployment Guide for FleetCart

Complete step-by-step guide to deploy FleetCart on Oracle Cloud's always-free tier with full control.

## Why Oracle Cloud?

- **Always Free Forever** (not a trial)
- **Full Root Access** to VMs
- **Generous Resources**: 2 AMD VMs (1GB RAM each) + 4 ARM VMs (24GB RAM total)
- **No Credit Card** required for always-free resources
- **Docker Support** - can use your existing Dockerfile

## Part 1: Oracle Cloud Account Setup

### 1.1 Create Account
1. Go to [cloud.oracle.com](https://cloud.oracle.com)
2. Click **"Start for free"**
3. Fill out the form:
   - **Account Type**: Personal Use
   - **Country**: Your country
   - **Name & Email**: Your details
4. **Verify email** and **phone number**
5. **No credit card needed** for always-free tier
6. Complete account verification

### 1.2 Choose Home Region
- **Important**: Choose your region carefully (can't change later)
- **Recommended**: Closest to your users
- **Popular**: US East (Ashburn), US West (Phoenix), EU (Frankfurt)

## Part 2: Create Your VM Instance

### 2.1 Navigate to Compute Instances
1. Sign in to Oracle Cloud Console
2. **Main Menu** → **Compute** → **Instances**
3. Click **"Create Instance"**

### 2.2 Configure Instance
```
Name: fleetcart-server
Availability Domain: Choose any (AD-1, AD-2, or AD-3)
```

### 2.3 Choose Image and Shape
**Image**:
- **Platform Images** → **Ubuntu** → **Ubuntu 22.04** (recommended)
- Or choose **Oracle Linux 8** if you prefer

**Shape**:
- **AMD Shape**: VM.Standard.E2.1.Micro (1 OCPU, 1GB RAM) - Always Free
- **ARM Shape**: VM.Standard.A1.Flex (up to 4 OCPU, 24GB RAM) - Always Free
- **Recommended**: Start with ARM Flex, allocate 2 OCPU + 12GB RAM

### 2.4 Configure Networking
- **VCN**: Use default or create new
- **Subnet**: Use default public subnet
- **Assign Public IP**: Yes (required for web access)

### 2.5 Add SSH Keys
**Option 1 - Generate New Keys**:
1. Click **"Generate SSH Key Pair"**
2. **Download both** private and public keys
3. Save them securely (you'll need the private key)

**Option 2 - Use Existing Keys**:
1. **Choose SSH Key Files**
2. Upload your existing public key

### 2.6 Boot Volume
- Keep default (50GB always free)

### 2.7 Create Instance
- Click **"Create"**
- Wait 2-3 minutes for **"RUNNING"** status
- **Note the Public IP address**

## Part 3: Configure VM and Install Docker

### 3.1 Connect to Your VM
**Windows (using built-in SSH)**:
```powershell
# Replace with your actual private key path and public IP
ssh -i "path\to\your\private-key.key" ubuntu@YOUR_PUBLIC_IP
```

**If you get permissions error on Windows**:
```powershell
# Fix private key permissions
icacls "path\to\your\private-key.key" /inheritance:r
icacls "path\to\your\private-key.key" /grant:r "%username%:R"
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

# Add user to docker group (no sudo needed)
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Log out and back in for docker group to take effect
exit
```

**Reconnect to VM**:
```powershell
ssh -i "path\to\your\private-key.key" ubuntu@YOUR_PUBLIC_IP
```

**Test Docker**:
```bash
docker --version
docker-compose --version
```

### 3.3 Configure Firewall
```bash
# Configure UFW firewall
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
sudo ufw status
```

### 3.4 Oracle Cloud Security List (Important!)
Oracle Cloud blocks traffic by default. You must open ports:

1. **Oracle Cloud Console** → **Networking** → **Virtual Cloud Networks**
2. Click your **VCN name**
3. Click **Security Lists** → **Default Security List**
4. Click **Add Ingress Rules**

**Rule 1 - HTTP**:
- **Source CIDR**: 0.0.0.0/0
- **IP Protocol**: TCP
- **Destination Port Range**: 80

**Rule 2 - HTTPS**:
- **Source CIDR**: 0.0.0.0/0
- **IP Protocol**: TCP
- **Destination Port Range**: 443

Click **Add Ingress Rules** for each.

## Part 4: Deploy FleetCart

### 4.1 Clone Your Repository
```bash
# Clone your FleetCart repository
git clone https://github.com/harshjeswani30/Raj-Fashion.git
cd Raj-Fashion
```

### 4.2 Create Environment File
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
APP_URL=http://YOUR_PUBLIC_IP

# Database (we'll use MySQL in Docker)
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=fleetcart
DB_USERNAME=fleetcart
DB_PASSWORD=your_strong_password_here

# Mail settings (optional - configure later)
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
```

### 4.3 Create Docker Compose File
```bash
nano docker-compose.yml
```

**Add this content**:
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "80:80"
    environment:
      - APP_ENV=production
      - DB_HOST=mysql
      - DB_DATABASE=fleetcart
      - DB_USERNAME=fleetcart
      - DB_PASSWORD=your_strong_password_here
    volumes:
      - ./storage:/var/www/html/storage
      - ./bootstrap/cache:/var/www/html/bootstrap/cache
    depends_on:
      - mysql
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password_here
      MYSQL_DATABASE: fleetcart
      MYSQL_USER: fleetcart
      MYSQL_PASSWORD: your_strong_password_here
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped
    command: --default-authentication-plugin=mysql_native_password

volumes:
  mysql_data:
```

### 4.4 Deploy Application
```bash
# Build and start containers
docker-compose up -d --build

# Check if containers are running
docker-compose ps

# View logs if needed
docker-compose logs -f app
```

### 4.5 Initialize Application
```bash
# Wait for containers to start (30-60 seconds)
sleep 60

# Run initial setup (if needed)
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate --force
docker-compose exec app php artisan storage:link
```

## Part 5: Configure Domain (Optional)

### 5.1 Point Domain to Oracle Cloud
1. **Buy domain** from Namecheap, Cloudflare, etc.
2. **Add A record**: `@` pointing to your Oracle Cloud public IP
3. **Add CNAME record**: `www` pointing to your domain

### 5.2 Update Application URL
```bash
# Edit .env file
nano .env

# Change APP_URL
APP_URL=https://yourdomain.com

# Restart application
docker-compose restart app
```

### 5.3 SSL Certificate (Free with Cloudflare)
1. **Sign up** for Cloudflare
2. **Add your domain** to Cloudflare
3. **Change nameservers** to Cloudflare's
4. **Set SSL mode** to "Full (strict)"
5. Cloudflare will automatically provide SSL

## Part 6: Maintenance & Monitoring

### 6.1 Useful Commands
```bash
# View application logs
docker-compose logs -f app

# View database logs
docker-compose logs -f mysql

# Restart application
docker-compose restart app

# Update application (when you push changes)
git pull
docker-compose up -d --build

# Backup database
docker-compose exec mysql mysqldump -u fleetcart -p fleetcart > backup.sql

# Access MySQL
docker-compose exec mysql mysql -u fleetcart -p fleetcart
```

### 6.2 System Monitoring
```bash
# Check disk space
df -h

# Check memory usage
free -h

# Check Docker containers
docker ps

# Check system resources
htop
```

### 6.3 Automatic Updates (Optional)
```bash
# Create update script
nano update.sh
```

**Add this content**:
```bash
#!/bin/bash
cd /home/ubuntu/Raj-Fashion
git pull
docker-compose up -d --build
docker-compose exec app php artisan migrate --force
docker-compose exec app php artisan config:cache
```

```bash
# Make executable
chmod +x update.sh

# Add to crontab for weekly updates (optional)
crontab -e
# Add line: 0 2 * * 0 /home/ubuntu/Raj-Fashion/update.sh
```

## Part 7: Troubleshooting

### 7.1 Common Issues

**Container won't start**:
```bash
docker-compose logs app
# Check for PHP errors or missing dependencies
```

**Can't access website**:
1. Check Oracle Cloud Security Lists (Part 3.4)
2. Check UFW firewall: `sudo ufw status`
3. Check if containers are running: `docker-compose ps`

**Database connection error**:
```bash
# Check MySQL is running
docker-compose logs mysql

# Test connection
docker-compose exec app php artisan tinker
# In tinker: DB::connection()->getPdo();
```

**Out of disk space**:
```bash
# Clean up Docker
docker system prune -a

# Check what's using space
du -sh /*
```

### 7.2 Performance Optimization

**For ARM instances (more power)**:
- Use 2-4 OCPU and 8-16GB RAM
- Enable opcache in PHP
- Add Redis for caching

**For AMD instances (limited resources)**:
- Use 1 OCPU and 1GB RAM
- Optimize Docker image size
- Consider using external database

## Summary

You now have:
- ✅ **Free Oracle Cloud VM** with full control
- ✅ **Docker-based FleetCart deployment**
- ✅ **MySQL database** in container
- ✅ **Automatic restarts** and container management
- ✅ **SSL ready** with Cloudflare
- ✅ **Backup and update procedures**

**Next Steps**:
1. **Test your application** at `http://YOUR_PUBLIC_IP`
2. **Configure email** settings in `.env`
3. **Add your domain** and SSL
4. **Set up monitoring** and backups

**Your FleetCart site should now be live and running with complete control!**

Need help with any step? Check the troubleshooting section or ask for specific assistance.