This repository contains the instructions to install the **[Koha](https://koha-community.org/)** on Ubuntu distributions with setup and support scripts.

#### On Ubuntu / Debian

Before you begin, ensure that `curl` is installed on your system. If `curl` is not installed, you can install it using the following command:

```sh
sudo apt-get install -y curl
```

1. **Download the setup script:**

   ```sh
   curl -fsSL https://raw.githubusercontent.com/saiful-semantic/KohaOnUbuntu/main/koha_setup.sh -o koha_setup.sh
   ```

2. **Run the Koha setup script with sudo:**

   ```sh
   sudo -E bash koha_setup.sh
   ```

3. **Install Koha:**

   ```sh
   sudo apt-get install -y koha-common
   ```
