# Terraform Infrastructure - DigitalOcean Web Hosting

This repository contains Terraform configuration for a production-ready web hosting infrastructure on DigitalOcean, featuring load balancing, SSL/TLS encryption, private networking, and MySQL database hosting.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Infrastructure Components](#infrastructure-components)
- [Security Features](#security-features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Accessing Resources](#accessing-resources)
- [Maintenance](#maintenance)
- [Security Considerations](#security-considerations)
- [Cost Estimation](#cost-estimation)
- [Troubleshooting](#troubleshooting)

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                    Internet                         │
└────────────────────┬────────────────────────────────┘
                     │
                     │ HTTPS (443)
                     ▼
            ┌─────────────────┐
            │  Load Balancer  │
            │   (SSL/TLS)     │
            └────────┬────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    HTTP (80)               HTTP (80)
         │                       │
    ┌────▼────┐            ┌────▼────┐
    │ www-1   │            │ www-2   │
    │ Nginx   │            │ Nginx   │
    └────┬────┘            └────┬────┘
         │                       │
         └───────────┬───────────┘
                     │
              Private Network
                     │
              ┌──────▼──────┐
              │   MySQL     │
              │  Database   │
              └─────────────┘

All resources within VPC (10.10.0.0/16)
```

## 🔧 Infrastructure Components

### Compute Resources

| Resource | Name | Specs | Purpose |
|----------|------|-------|---------|
| Droplet | www-1 | 1 vCPU, 1GB RAM, Ubuntu 24.04 | Web server (Nginx) |
| Droplet | www-2 | 1 vCPU, 1GB RAM, Ubuntu 24.04 | Web server (Nginx) |

### Networking

| Resource | Name | Configuration |
|----------|------|---------------|
| VPC | vpc-tor1-production | 10.10.0.0/16 (Toronto) |
| Load Balancer | www-lb | HTTPS → HTTP forwarding |
| Firewall | web-firewall | HTTP, HTTPS, SSH rules |
| Domain | maximeconnolly.xyz | DNS management |

### Database

| Resource | Name | Specs |
|----------|------|-------|
| MySQL Cluster | secs1027 | MySQL 8, 1 node, 1GB RAM |

### SSL/TLS

| Resource | Certificate |
|----------|-------------|
| Let's Encrypt | maximeconnolly.xyz |

### DNS Records

| Type | Name | Target |
|------|------|--------|
| A | @ | Load Balancer IP |
| CNAME | www | maximeconnolly.xyz |

## 🔒 Security Features

### Network Security
- ✅ **VPC Isolation**: All resources in private network (10.10.0.0/16)
- ✅ **Private Database**: MySQL only accessible via private network
- ✅ **Firewall Rules**: Restrict incoming traffic to HTTP, HTTPS, and SSH
- ✅ **SSL/TLS**: Let's Encrypt certificate for HTTPS encryption

### Access Control
- ✅ **Non-root User**: `webadmin` user created with sudo privileges
- ✅ **Root Login Disabled**: SSH root login disabled on all droplets
- ✅ **SSH Key Authentication**: Password authentication disabled
- ✅ **Sensitive Variables**: API tokens and keys marked as sensitive

### Infrastructure Protection
- ✅ **Lifecycle Rules**: Database has `prevent_destroy` enabled
- ✅ **Resource Tagging**: All resources tagged for organization
- ✅ **Health Checks**: Load balancer monitors HTTP service health

## 📦 Prerequisites

Before deploying this infrastructure, ensure you have:

1. **Terraform** >= 1.5.0 installed ([Download](https://www.terraform.io/downloads))
2. **DigitalOcean Account** with billing enabled
3. **DigitalOcean API Token** ([Generate here](https://cloud.digitalocean.com/account/api/tokens))
4. **SSH Key** uploaded to DigitalOcean named `lenovo-max`
5. **Local SSH Public Key** at `~/.ssh/lenovo-max.pub`

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd terraform-infra
```

### 2. Set Up Environment Variables

Create a `terraform.tfvars` file (this file is gitignored):

```hcl
do_token = "your-digitalocean-api-token-here"
pvt_key  = "/path/to/your/private/key"
```

**Alternative**: Use environment variables:

```bash
export TF_VAR_do_token="your-digitalocean-api-token"
export TF_VAR_pvt_key="/path/to/your/private/key"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the Deployment

```bash
terraform plan
```

Review the planned changes carefully.

### 5. Deploy the Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm.

## ⚙️ Configuration

### Variable Reference

| Variable | Description | Required | Sensitive |
|----------|-------------|----------|-----------|
| `do_token` | DigitalOcean API token | Yes | Yes |
| `pvt_key` | Path to SSH private key | Yes | Yes |

### Customization Options

#### Change Region

Edit the `region` field in resource files (default: `tor1`):

```hcl
region = "nyc1"  # New York
region = "sfo3"  # San Francisco
region = "lon1"  # London
```

#### Increase Database High Availability

Edit `mysql-secs1027.tf`:

```hcl
node_count = 3  # Creates 3-node cluster (recommended for production)
```

**Note**: This increases costs but provides redundancy.

#### Restrict SSH Access

Edit `firewall.tf` to limit SSH to specific IPs:

```hcl
inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["your.ip.address/32"]  # Replace with your IP
}
```

## 📤 Deployment

### Initial Deployment

```bash
terraform init
terraform plan
terraform apply
```

### Updating Infrastructure

After making changes to `.tf` files:

```bash
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Destroying Infrastructure

⚠️ **Warning**: This will delete all resources!

```bash
terraform destroy
```

**Note**: The database has `prevent_destroy` enabled. To destroy it, you must first remove or comment out the lifecycle block in `mysql-secs1027.tf`.

## 🔐 Accessing Resources

### Web Servers (SSH)

After deployment, SSH to web servers using the `webadmin` user:

```bash
# Get droplet IPs
terraform output

# SSH to droplet
ssh webadmin@<droplet-ip>
```

**Note**: Root login is disabled for security.

### Database Connection

The database is only accessible from within the VPC. To connect:

1. SSH into a web server droplet
2. Use the private database hostname:

```bash
# Get database credentials from DigitalOcean dashboard
mysql -h <private-hostname> -u <username> -p
```

**Database connection details** can be found in the DigitalOcean control panel under Databases.

### Domain Access

Once DNS propagates (may take up to 48 hours):

- **HTTPS**: https://maximeconnolly.xyz
- **www**: https://www.maximeconnolly.xyz

## 🔧 Maintenance

### Updating Nginx Configuration

SSH into droplets and edit `/etc/nginx/sites-available/default`:

```bash
ssh webadmin@<droplet-ip>
sudo nano /etc/nginx/sites-available/default
sudo systemctl restart nginx
```

### Viewing Logs

```bash
# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# System logs
sudo journalctl -u nginx -f
```

### Database Backups

DigitalOcean provides automatic daily backups for database clusters. To configure:

1. Go to DigitalOcean Dashboard → Databases → secs1027
2. Click "Settings" → "Backups"
3. Configure backup window

### Monitoring

Monitor resources via:
- **DigitalOcean Dashboard**: Metrics, graphs, alerts
- **Load Balancer Health**: Check status in LB dashboard
- **Firewall Logs**: Available in DigitalOcean control panel

## 🛡️ Security Considerations

### Current Security Posture

✅ **Implemented:**
- VPC isolation
- Private database networking
- Firewall rules
- SSL/TLS encryption
- Non-root SSH access
- Sensitive variable protection

⚠️ **Recommended Improvements:**

1. **Restrict SSH Access**: Currently SSH is open to all IPs. Limit to your IP:
   ```hcl
   source_addresses = ["YOUR.IP.HERE/32"]
   ```

2. **Configure Remote State**: Use remote backend for state management:
   ```hcl
   terraform {
     backend "s3" {
       bucket = "terraform-state-bucket"
       key    = "production/terraform.tfstate"
       region = "us-east-1"
     }
   }
   ```

3. **Enable Database Backups**: Configure automated backups in DigitalOcean dashboard

4. **Add Monitoring/Alerting**: Set up alerts for:
   - High CPU usage
   - Low disk space
   - Failed health checks
   - Unusual traffic patterns

5. **Implement Secret Management**: Consider using:
   - HashiCorp Vault
   - DigitalOcean App Platform Secrets
   - Encrypted environment variables

6. **Regular Updates**: Keep droplets updated:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

### Secrets Management

**Never commit** the following to Git:
- `terraform.tfvars` (contains API tokens) ✅ Already in .gitignore
- `*.tfstate` files (contain sensitive data) ✅ Already in .gitignore
- SSH private keys
- Database passwords

## 💰 Cost Estimation

### Monthly Cost Breakdown (USD)

| Resource | Quantity | Unit Price | Monthly Cost |
|----------|----------|------------|--------------|
| Droplets (1GB) | 2 | $6/month | $12 |
| Load Balancer | 1 | $12/month | $12 |
| MySQL Database (1GB) | 1 | $15/month | $15 |
| VPC | 1 | Free | $0 |
| Firewall | 1 | Free | $0 |
| Domain (if registered) | 1 | ~$12/year | ~$1 |
| Let's Encrypt SSL | 1 | Free | $0 |

**Total Estimated Monthly Cost**: ~$40/month

**Notes**:
- Prices as of 2025 (check current pricing on DigitalOcean)
- Bandwidth included up to transfer limits
- Upgrading to 3-node database cluster: +$30/month

## 🐛 Troubleshooting

### Common Issues

#### 1. SSH Connection Refused

**Problem**: Cannot SSH to droplets

**Solution**:
```bash
# Verify droplet is running
terraform show | grep "status"

# Check firewall rules allow SSH
# Verify you're using the correct user: webadmin (not root)
ssh webadmin@<ip>
```

#### 2. Website Not Loading

**Problem**: HTTPS site not accessible

**Solutions**:
- Check DNS propagation: `dig maximeconnolly.xyz`
- Verify load balancer health checks are passing
- Check Nginx is running: `sudo systemctl status nginx`
- Review load balancer logs in DigitalOcean dashboard

#### 3. Database Connection Failed

**Problem**: Cannot connect to MySQL

**Solution**:
```bash
# Database is private-only
# Must connect from within VPC (from a droplet)
ssh webadmin@<droplet-ip>
mysql -h <private-db-host> -u <user> -p
```

#### 4. Terraform Apply Fails

**Problem**: Provider authentication error

**Solution**:
```bash
# Verify API token is set
echo $TF_VAR_do_token  # Should show token

# Or check terraform.tfvars exists
cat terraform.tfvars
```

#### 5. Certificate Issues

**Problem**: SSL certificate not working

**Solution**:
- Verify domain DNS points to load balancer
- Let's Encrypt requires domain to resolve correctly
- Check certificate status in DigitalOcean dashboard
- May take a few minutes to provision

### Getting Help

- **DigitalOcean Documentation**: https://docs.digitalocean.com/
- **Terraform Documentation**: https://www.terraform.io/docs
- **Community Support**: DigitalOcean Community Forums

## 📚 File Structure

```
terraform-infra/
├── provider.tf                 # Provider config & variables
├── vpc.tf                      # VPC network configuration
├── www-1.tf                   # First web server
├── www-2.tf                   # Second web server
├── loadbalancer.tf            # Load balancer setup
├── firewall.tf                # Firewall rules
├── mysql-secs1027.tf          # MySQL database cluster
├── certificate.tf             # Let's Encrypt SSL cert
├── maximeconnolly_xyz_root.tf # Root domain resource
├── maximeconnollyxyz_a.tf     # DNS A record
├── maximeconnollyxyz_cname.tf # DNS CNAME records
├── .gitignore                 # Git ignore rules
├── .terraform.lock.hcl        # Provider version lock
└── README.md                  # This file
```

## 🔄 CI/CD

### GitHub Actions

This repository includes automated security scanning via tfsec:

- **File**: `.github/workflows/tfsec.yml`
- **Trigger**: On push and pull requests
- **Purpose**: Detect security vulnerabilities in Terraform code

## 📝 License

This infrastructure configuration is provided as-is for educational and production use.

## 🤝 Contributing

When making changes:

1. Create a feature branch
2. Make changes to `.tf` files
3. Run `terraform fmt` to format code
4. Run `terraform validate` to check syntax
5. Test with `terraform plan`
6. Submit pull request

## 📞 Support

For issues or questions:
- Open an issue in this repository
- Contact the infrastructure team
- Review DigitalOcean documentation

---

**Last Updated**: 2025-11-16
**Terraform Version**: >= 1.5.0
**Provider Version**: ~> 2.66.0
