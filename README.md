# Ubuntu Security Maintenance

A lightweight, Makefile-based security and system maintenance toolkit for Ubuntu Linux.

This project provides a convenient command-line interface for checking basic security settings, installing system updates, reviewing system activity, and scanning downloaded files for malware.

## Features

- Check UFW firewall configuration
- Check SSH server status
- Inspect automatic update settings
- Detect pending restart requests
- Install available APT package updates
- Review listening network ports
- List enabled and failed system services
- Review failed SSH login attempts
- Check the ClamAV database updater service
- Scan the Downloads directory for malware

## Requirements

- Ubuntu Linux
- GNU Make
- APT package manager
- systemd
- UFW
- ClamAV for malware scanning
- sudo privileges for administrative checks

Install the main dependencies:

```bash
sudo apt update
sudo apt install make ufw clamav clamav-freshclam
```

ClamAV's `clamav-freshclam` service should be running to receive signature updates. Verify its status with:

```bash
systemctl status clamav-freshclam
```

## Installation

Clone the repository:

```bash
git clone https://github.com/StennethSwaby/Security-Maintenance.git
cd Security-Maintenance
```

No compilation is required.

## Available Commands

| Command | Description |
|---------|-------------|
| `make help` | Display available commands |
| `make status` | Check basic security settings |
| `make weekly` | Update APT package lists and install upgrades |
| `make monthly` | Review network activity, services, and failed SSH logins |
| `make check-virus-db` | Check whether the ClamAV updater service is running |
| `make scan` | Scan the user's Downloads directory |
| `make full-check` | Run status, monthly checks, and the Downloads scan |

## Suggested Maintenance Routine

### Weekly

```bash
make weekly
```

Refreshes APT package lists and installs available upgrades. APT may request confirmation.

### Monthly

```bash
make monthly
```

Reviews network listeners, enabled services, failed SSH logins, and failed system services.

### Malware Scan

```bash
make scan
```

Uses ClamAV to recursively scan files in the Downloads directory. Infected-file findings are displayed in the terminal. Files are not automatically deleted or quarantined.

### Comprehensive Check

```bash
make full-check
```

Runs the security status checks, monthly audit, and Downloads malware scan. It does not install system updates.

## Security Considerations

This project is a personal security maintenance aid, not a complete security audit or endpoint protection solution.

- Some checks require `sudo`.
- The SSH login review examines the `ssh` systemd journal unit, which may differ between Ubuntu configurations.
- The ClamAV updater check confirms service activity but does not validate signature freshness.
- ClamAV scans do not guarantee detection of all malware.
- APT updates do not cover every application installation method.
- Users should review commands before running them with administrative privileges.

## License

No license has been selected yet. All rights are reserved unless a license is added.

## Author

[StennethSwaby](https://github.com/StennethSwaby)
