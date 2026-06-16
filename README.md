![Build Status](https://github.com/saiful-semantic/KohaOnUbuntu/actions/workflows/test.yml/badge.svg)

**Verified on**:

- Ubuntu 26.04 LTS (Resolute Raccoon)
- Ubuntu 24.04 LTS (Noble Numbat)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Debian 12 (Bookworm)
- Debian 11 (Bullseye)

This repository contains the instructions to install the **[Koha](https://koha-community.org/)** on Ubuntu distributions with setup and support scripts.

#### On Ubuntu / Debian

Ensure that `curl` is installed on your system:

```sh
sudo apt-get install -y curl
```

**Run the setup script directly with sudo:**

```sh
curl -fsSL https://raw.githubusercontent.com/saiful-semantic/KohaOnUbuntu/main/koha_setup.sh | sudo -E bash
```

**Alternatively, download and run the Koha setup script with sudo:**

```
curl -fsSLO https://raw.githubusercontent.com/saiful-semantic/KohaOnUbuntu/main/koha_setup.sh
sudo bash koha_setup.sh

# To install a specific Koha release (e.g. `oldstable`):
# sudo KOHA_RELEASE=oldstable bash koha_setup.sh
```

**Install Koha:**

```sh
sudo apt-get install -y koha-common
```

**Install MariaDB or MySQL and enable requried Apache modules**

```sh
sudo apt-get install -y mariadb-server
sudo a2enmod rewrite cgi headers proxy_http ssl
sudo systemctl restart apache2
```

**Proceed with creating a new Koha instance:**

```sh
sudo koha-create --create-db <instance_name>
```
