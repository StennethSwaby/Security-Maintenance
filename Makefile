# ============================================================
# Ubuntu Security Maintenance
# Personal Linux Security Checklist
# ============================================================
#
# Usage:
#   make help
#   make status
#   make weekly
#   make monthly
#   make check-virus-db
#   make scan
#   make full-check
#
# Note: Only "make weekly" installs system updates.
# Other targets perform checks or malware scans.
# ============================================================

.DEFAULT_GOAL := help
.RECIPEPREFIX := >

.PHONY: help status weekly monthly check-virus-db scan full-check

# ------------------------------------------------------------
# HELP MENU
# ------------------------------------------------------------

help:
> @echo "========================================"
> @echo "       UBUNTU SECURITY MAINTENANCE"
> @echo "========================================"
> @echo "make help            Show available commands"
> @echo "make status          Check basic security settings"
> @echo "make weekly          Install available system updates"
> @echo "make monthly         Review network and system activity"
> @echo "make check-virus-db  Check ClamAV automatic updater"
> @echo "make scan            Scan Downloads with ClamAV"
> @echo "make full-check      Run all security checks and scan"

# ------------------------------------------------------------
# BASIC SECURITY STATUS
# ------------------------------------------------------------

status:
> @echo "=== FIREWALL STATUS ==="
> @sudo ufw status verbose
> @echo ""
> @echo "=== SSH SERVER STATUS ==="
> @systemctl is-active ssh || true
> @echo ""
> @echo "=== AUTOMATIC UPDATE SETTINGS ==="
> @apt-config dump | grep -E 'APT::Periodic::(Update-Package-Lists|Unattended-Upgrade)' || true
> @echo ""
> @echo "=== RESTART REQUIRED? ==="
> @if test -f /var/run/reboot-required; then \
>   echo "Restart recommended"; \
> else \
>   echo "No restart currently requested"; \
> fi

# ------------------------------------------------------------
# WEEKLY SYSTEM UPDATES
# ------------------------------------------------------------

weekly:
> @echo "=== UPDATING PACKAGE LISTS ==="
> sudo apt update
> @echo ""
> @echo "=== INSTALLING AVAILABLE UPDATES ==="
> sudo apt upgrade
> @echo ""
> @echo "=== RESTART REQUIRED? ==="
> @if test -f /var/run/reboot-required; then \
>   echo "Restart recommended"; \
> else \
>   echo "No restart currently requested"; \
> fi

# ------------------------------------------------------------
# MONTHLY SECURITY AUDIT
# ------------------------------------------------------------

monthly:
> @echo "=== LISTENING NETWORK PORTS ==="
> @sudo ss -tulpen
> @echo ""
> @echo "=== ENABLED SYSTEM SERVICES ==="
> @systemctl list-unit-files --type=service --state=enabled --no-pager
> @echo ""
> @echo "=== FAILED SSH LOGINS (LAST 30 DAYS) ==="
> @sudo journalctl -u ssh --since "30 days ago" --no-pager | \
>   grep -Ei 'failed password|invalid user|authentication failure' || true
> @echo ""
> @echo "=== FAILED SYSTEM SERVICES ==="
> @systemctl --failed --no-pager

# ------------------------------------------------------------
# CLAMAV DATABASE UPDATE SERVICE CHECK
# ------------------------------------------------------------

check-virus-db:
> @echo "=== CLAMAV DATABASE UPDATE STATUS ==="
> @if systemctl is-active --quiet clamav-freshclam; then \
>   echo "ClamAV automatic updater is running."; \
> else \
>   echo "WARNING: ClamAV automatic updater is not running!"; \
>   echo "Start it with:"; \
>   echo "sudo systemctl enable --now clamav-freshclam"; \
> fi

# ------------------------------------------------------------
# MALWARE SCAN
# ------------------------------------------------------------

scan: check-virus-db
> @echo "=== CLAMAV DOWNLOADS SCAN ==="
> @if command -v clamscan >/dev/null 2>&1; then \
>   if test -d "$(HOME)/Downloads"; then \
>     clamscan -r -i "$(HOME)/Downloads"; \
>   else \
>     echo "Downloads folder not found."; \
>   fi; \
> else \
>   echo "ClamAV is not installed."; \
>   echo "Install it with: sudo apt install clamav"; \
>   exit 1; \
> fi

# ------------------------------------------------------------
# FULL SECURITY CHECK
# ------------------------------------------------------------

full-check: status monthly scan
> @echo ""
> @echo "========================================"
> @echo "       SECURITY CHECKS COMPLETED"
> @echo "========================================"
> @echo "Review the output for unexpected activity."
