# Nushell for Linux

Package and release the official Nushell binaries in `deb`, `rpm`, and `apk` etc. formats for seamless installation across Linux distributions and Alpine systems.

**Notes**: Once stabilized, this repository may be transferred to the Nushell organization.

## Install Nushell for Ubuntu/Debian

```nu
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
sudo apt update
sudo apt install nushell
which nu
nu -c 'version'
```

## Install Nushell for RedHat/Fedora/RockyLinux/AlmaLinux/OpenEuler

```nu
echo "[nushell]
name=Nushell Repo
baseurl=https://yum.fury.io/nushell/
enabled=1
gpgcheck=0
gpgkey=https://yum.fury.io/nushell/gpg.key" | tee /etc/yum.repos.d/fury-nushell.repo
dnf install -y nushell
nu -c 'version'
```

## Install Nushell for Alpine Linux

```nu
echo "https://alpine.fury.io/nushell/" | tee -a /etc/apk/repositories
apk update || true
apk add --allow-untrusted nushell
which nu
nu -c 'version'
```

OR Read the [Test workflow](https://github.com/hustcer/distro/blob/main/.github/workflows/test.yml) for more details.

## License

Licensed under:

- MIT license ([LICENSE](LICENSE) or http://opensource.org/licenses/MIT)
