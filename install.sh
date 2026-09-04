#!/bin/bash
# ============================================================
#  Mohammad Ahmad VPN Manager Manager — installer
#  Installs the full SSH/VPN management suite (CLI + web panel)
# ============================================================
set -e

INSTALL_PATH="/usr/local/bin/naveedghanizada"
SHORTCUT_PATH="/usr/local/bin/menu"

c_reset="\033[0m"; c_cyan="\033[36m"; c_green="\033[32m"; c_yellow="\033[33m"; c_red="\033[31m"; c_bold="\033[1m"
info()  { echo -e "${c_cyan}[*]${c_reset} $1"; }
ok()    { echo -e "${c_green}[OK]${c_reset} $1"; }
err()   { echo -e "${c_red}[ERROR]${c_reset} $1" >&2; }

# --- Root check ---
if [ "$(id -u)" -ne 0 ]; then
    err "This installer must be run as root (try: sudo bash install.sh)"
    exit 1
fi

# --- Write the manager script ---
info "Installing Mohammad Ahmad VPN Manager Manager to $INSTALL_PATH ..."
cat > "$INSTALL_PATH" << '__NG_MENU_SH_EOF__'
#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

C_RESET=$'\033[0m'
C_BOLD=$'\033[1m'
C_DIM=$'\033[2m'
C_UL=$'\033[4m'

# Neon Cyberpunk Color Palette (matches the Mohammad Ahmad VPN Manager web panel theme)
C_RED=$'\033[38;5;197m'      # Neon Red
C_GREEN=$'\033[38;5;48m'     # Neon Green
C_YELLOW=$'\033[38;5;226m'   # Bright Yellow
C_BLUE=$'\033[38;5;45m'      # Electric Blue
C_PURPLE=$'\033[38;5;201m'   # Neon Magenta
C_CYAN=$'\033[38;5;51m'      # Neon Cyan
C_WHITE=$'\033[38;5;255m'    # Bright White
C_GRAY=$'\033[38;5;245m'     # Gray
C_ORANGE=$'\033[38;5;213m'   # Neon Pink

# Semantic Aliases
C_TITLE=$C_CYAN
C_CHOICE=$C_PURPLE
C_PROMPT=$C_CYAN
C_WARN=$C_YELLOW
C_DANGER=$C_RED
C_STATUS_A=$C_GREEN
C_STATUS_I=$C_GRAY
C_ACCENT=$C_ORANGE

DB_DIR="/etc/firewallfalcon"
DB_FILE="$DB_DIR/users.db"
INSTALL_FLAG_FILE="$DB_DIR/.install"
BADVPN_SERVICE_FILE="/etc/systemd/system/badvpn.service"
BADVPN_BUILD_DIR="/root/badvpn-build"
HAPROXY_CONFIG="/etc/haproxy/haproxy.cfg"
NGINX_CONFIG_FILE="/etc/nginx/sites-available/default"
SSL_CERT_DIR="/etc/firewallfalcon/ssl"
SSL_CERT_FILE="$SSL_CERT_DIR/firewallfalcon.pem"
SSL_CERT_CHAIN_FILE="$SSL_CERT_DIR/firewallfalcon.crt"
SSL_CERT_KEY_FILE="$SSL_CERT_DIR/firewallfalcon.key"
EDGE_CERT_INFO_FILE="$DB_DIR/edge_cert.conf"
NGINX_PORTS_FILE="$DB_DIR/nginx_ports.conf"
EDGE_PUBLIC_HTTP_PORT="80"
EDGE_PUBLIC_TLS_PORT="443"
NGINX_INTERNAL_HTTP_PORT="8880"
NGINX_INTERNAL_TLS_PORT="8443"
HAPROXY_INTERNAL_DECRYPT_PORT="10443"
DNSTT_SERVICE_FILE="/etc/systemd/system/dnstt.service"
DNSTT_BINARY="/usr/local/bin/dnstt-server"
DNSTT_KEYS_DIR="/etc/firewallfalcon/dnstt"
DNSTT_CONFIG_FILE="$DB_DIR/dnstt_info.conf"
DNS_INFO_FILE="$DB_DIR/dns_info.conf"
UDP_CUSTOM_DIR="/root/udp"
UDP_CUSTOM_SERVICE_FILE="/etc/systemd/system/udp-custom.service"
UDPGW_BINARY="/usr/local/bin/udpgw"
UDPGW_SERVICE_FILE="/etc/systemd/system/udpgw.service"
SSH_BANNER_FILE="/etc/bannerssh"
FALCONPROXY_SERVICE_FILE="/etc/systemd/system/falconproxy.service"
FALCONPROXY_BINARY="/usr/local/bin/falconproxy"
FALCONPROXY_CONFIG_FILE="$DB_DIR/falconproxy_config.conf"
LIMITER_SCRIPT="/usr/local/bin/firewallfalcon-limiter.sh"
LIMITER_SERVICE="/etc/systemd/system/firewallfalcon-limiter.service"
BANDWIDTH_DIR="$DB_DIR/bandwidth"
BANDWIDTH_SCRIPT="/usr/local/bin/firewallfalcon-bandwidth.sh"
BANDWIDTH_SERVICE="/etc/systemd/system/firewallfalcon-bandwidth.service"
LEGACY_BANDWIDTH_DIR="/usr/local/bin/firewallfalcon-bandwidth"
TRIAL_CLEANUP_SCRIPT="/usr/local/bin/firewallfalcon-trial-cleanup.sh"
LOGIN_INFO_SCRIPT="/usr/local/bin/firewallfalcon-login-info.sh"
SSHD_FF_CONFIG="/etc/ssh/sshd_config.d/firewallfalcon.conf"

# --- Web Panel Variables ---
PANEL_SCRIPT="/usr/local/bin/firewallfalcon-panel.py"
PANEL_HTML_DIR="$DB_DIR/panel"
PANEL_HTML_FILE="$DB_DIR/panel/index.html"
PANEL_CONF="$DB_DIR/panel.conf"
PANEL_SERVICE_FILE="/etc/systemd/system/firewallfalcon-panel.service"
PANEL_PORT=44380
PANEL_REPO_BASE="https://raw.githubusercontent.com/FirewallFalconsLabs/FirewallFalcon-Manager/main/panel"

# --- ZiVPN Variables ---
ZIVPN_DIR="/etc/zivpn"
ZIVPN_BIN="/usr/local/bin/zivpn"
ZIVPN_SERVICE_FILE="/etc/systemd/system/zivpn.service"
ZIVPN_CONFIG_FILE="$ZIVPN_DIR/config.json"
ZIVPN_CERT_FILE="$ZIVPN_DIR/zivpn.crt"
ZIVPN_KEY_FILE="$ZIVPN_DIR/zivpn.key"

DESEC_TOKEN="V55cFY8zTictLCPfviiuX5DHjs15"
DESEC_DOMAIN="manager.firewallfalcon.qzz.io"

SELECTED_USER=""
UNINSTALL_MODE="interactive"
BANNER_CACHE_TTL=15
BANNER_CACHE_TS=0
BANNER_CACHE_OS_NAME=""
BANNER_CACHE_UP_TIME=""
BANNER_CACHE_RAM_USAGE=""
BANNER_CACHE_CPU_LOAD=""
BANNER_CACHE_ONLINE_USERS=0
BANNER_CACHE_TOTAL_USERS=0
SSH_SESSION_CACHE_TTL=10
SSH_SESSION_CACHE_TS=0
SSH_SESSION_CACHE_DB_MTIME=0
SSH_SESSION_TOTAL=0
APT_CACHE_READY=0
FF_USERS_GROUP="ffusers"
declare -A SSH_SESSION_COUNTS=()
declare -A SSH_SESSION_PIDS=()

# --- Package Manager Abstraction ---
FF_PKG_MGR=""
_detect_pkg_manager() {
    if command -v apt-get &>/dev/null; then
        FF_PKG_MGR="apt"
    elif command -v dnf &>/dev/null; then
        FF_PKG_MGR="dnf"
    elif command -v yum &>/dev/null; then
        FF_PKG_MGR="yum"
    elif command -v zypper &>/dev/null; then
        FF_PKG_MGR="zypper"
    elif command -v pacman &>/dev/null; then
        FF_PKG_MGR="pacman"
    else
        echo -e "${C_RED}❌ No supported package manager found (apt/dnf/yum/zypper/pacman).${C_RESET}"
        exit 1
    fi
}
_detect_pkg_manager

_map_pkg_names() {
    local -a result=()
    local pkg
    for pkg in "$@"; do
        case "$FF_PKG_MGR" in
            dnf|yum)
                case "$pkg" in
                    build-essential) result+=(gcc gcc-c++ make) ;;
                    libssl-dev) result+=(openssl-devel) ;;
                    libnspr4-dev) result+=(nspr-devel) ;;
                    libnss3-dev) result+=(nss-devel) ;;
                    nginx-common) result+=(nginx) ;;
                    pkg-config) result+=(pkgconf) ;;
                    *) result+=("$pkg") ;;
                esac ;;
            zypper)
                case "$pkg" in
                    build-essential) result+=(gcc gcc-c++ make) ;;
                    libssl-dev) result+=(libopenssl-devel) ;;
                    libnspr4-dev) result+=(mozilla-nspr-devel) ;;
                    libnss3-dev) result+=(mozilla-nss-devel) ;;
                    nginx-common) result+=(nginx) ;;
                    *) result+=("$pkg") ;;
                esac ;;
            pacman)
                case "$pkg" in
                    build-essential) result+=(base-devel) ;;
                    libssl-dev) result+=(openssl) ;;
                    libnspr4-dev) result+=(nspr) ;;
                    libnss3-dev) result+=(nss) ;;
                    nginx-common) result+=(nginx) ;;
                    bc) result+=(bc) ;;
                    *) result+=("$pkg") ;;
                esac ;;
            *) result+=("$pkg") ;;
        esac
    done
    printf '%s\n' "${result[@]}"
}

if [[ $EUID -ne 0 ]]; then
   echo -e "${C_RED}❌ Error: This script requires root privileges to run.${C_RESET}"
   exit 1
fi

get_ubuntu_codename() {
    local codename=""

    if [[ -r /etc/os-release ]]; then
        codename=$(awk -F= '/^(VERSION_CODENAME|UBUNTU_CODENAME)=/{gsub(/"/, "", $2); if ($2 != "") { print $2; exit }}' /etc/os-release 2>/dev/null)
    fi

    if [[ -z "$codename" ]] && command -v lsb_release &>/dev/null; then
        codename=$(lsb_release -sc 2>/dev/null)
    fi

    echo "$codename"
}

is_known_eol_ubuntu_codename() {
    case "$1" in
        yakkety|zesty|artful|cosmic|disco|eoan|groovy|hirsute|impish|kinetic|lunar|mantic|oracular|plucky)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

rewrite_ubuntu_apt_sources() {
    local mode="$1"
    local os_id=""
    local changed=false
    local file backup_file
    local from_archive to_archive from_security to_security from_ports to_ports
    local -a source_files=("/etc/apt/sources.list" /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources)

    if [[ -r /etc/os-release ]]; then
        os_id=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2; exit}' /etc/os-release 2>/dev/null)
    fi
    [[ "$os_id" == "ubuntu" ]] || return 1

    case "$mode" in
        primary)
            from_archive='https?://([A-Za-z0-9-]+\.)?archive\.ubuntu\.com/ubuntu'
            to_archive='http://archive.ubuntu.com/ubuntu'
            from_security='https?://security\.ubuntu\.com/ubuntu'
            to_security='http://security.ubuntu.com/ubuntu'
            from_ports='https?://ports\.ubuntu\.com/ubuntu-ports'
            to_ports='http://ports.ubuntu.com/ubuntu-ports'
            ;;
        old-releases)
            from_archive='https?://([A-Za-z0-9-]+\.)?archive\.ubuntu\.com/ubuntu'
            to_archive='http://old-releases.ubuntu.com/ubuntu'
            from_security='https?://security\.ubuntu\.com/ubuntu'
            to_security='http://old-releases.ubuntu.com/ubuntu'
            from_ports='https?://ports\.ubuntu\.com/ubuntu-ports'
            to_ports='http://old-releases.ubuntu.com/ubuntu'
            ;;
        *)
            return 1
            ;;
    esac

    for file in "${source_files[@]}"; do
        [[ -f "$file" ]] || continue
        if grep -Eq "$from_archive|$from_security|$from_ports" "$file" 2>/dev/null; then
            backup_file="${file}.bak.firewallfalcon"
            [[ -f "$backup_file" ]] || cp "$file" "$backup_file" 2>/dev/null || true
            sed -i -E \
                -e "s|$from_archive|$to_archive|g" \
                -e "s|$from_security|$to_security|g" \
                -e "s|$from_ports|$to_ports|g" \
                "$file" 2>/dev/null
            changed=true
        fi
    done

    $changed
}

repair_ubuntu_apt_mirrors() {
    rewrite_ubuntu_apt_sources "primary"
}

switch_ubuntu_to_old_releases() {
    local codename
    codename=$(get_ubuntu_codename)
    [[ -n "$codename" ]] || return 1
    is_known_eol_ubuntu_codename "$codename" || return 1
    rewrite_ubuntu_apt_sources "old-releases"
}

ff_apt_update() {
    local -a apt_opts=(
        -o Acquire::Retries=3
        -o Acquire::ForceIPv4=true
        -o Acquire::http::Timeout=20
        -o Acquire::https::Timeout=20
        -o Acquire::http::Pipeline-Depth=0
    )

    if (( APT_CACHE_READY == 1 )); then
        return 0
    fi

    if DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update; then
        APT_CACHE_READY=1
        return 0
    fi

    if repair_ubuntu_apt_mirrors; then
        echo -e "${C_YELLOW}⚠️ APT mirror timed out. Switching Ubuntu sources to archive.ubuntu.com and retrying...${C_RESET}"
        apt-get clean >/dev/null 2>&1 || true
        if DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update; then
            APT_CACHE_READY=1
            return 0
        fi
    fi

    if switch_ubuntu_to_old_releases; then
        echo -e "${C_YELLOW}⚠️ Detected an end-of-life Ubuntu release. Switching APT sources to old-releases.ubuntu.com and retrying...${C_RESET}"
        apt-get clean >/dev/null 2>&1 || true
        if DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update; then
            APT_CACHE_READY=1
            return 0
        fi
    fi

    echo -e "${C_RED}❌ Failed to refresh package lists. Please check VPS network, DNS, or blocked Ubuntu mirrors.${C_RESET}"
    return 1
}

ff_apt_install() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0

    ff_apt_update || return 1
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Use-Pty=0 install "${packages[@]}"
}

ff_apt_purge() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Use-Pty=0 purge "${packages[@]}"
}

ff_pkg_install() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0
    local -a mapped=()
    mapfile -t mapped < <(_map_pkg_names "${packages[@]}")
    case "$FF_PKG_MGR" in
        apt) ff_apt_install "${mapped[@]}" ;;
        dnf) dnf install -y -q "${mapped[@]}" ;;
        yum) yum install -y -q "${mapped[@]}" ;;
        zypper) zypper install -y -q "${mapped[@]}" ;;
        pacman) pacman -S --noconfirm --needed "${mapped[@]}" ;;
        *) echo -e "${C_RED}❌ Unsupported package manager.${C_RESET}"; return 1 ;;
    esac
}

ff_pkg_purge() {
    local -a packages=("$@")
    (( ${#packages[@]} > 0 )) || return 0
    local -a mapped=()
    mapfile -t mapped < <(_map_pkg_names "${packages[@]}")
    case "$FF_PKG_MGR" in
        apt) ff_apt_purge "${mapped[@]}" ;;
        dnf) dnf remove -y -q "${mapped[@]}" ;;
        yum) yum remove -y -q "${mapped[@]}" ;;
        zypper) zypper remove -y "${mapped[@]}" ;;
        pacman) pacman -Rns --noconfirm "${mapped[@]}" 2>/dev/null ;;
        *) echo -e "${C_RED}❌ Unsupported package manager.${C_RESET}"; return 1 ;;
    esac
}

ff_pkg_autoremove() {
    case "$FF_PKG_MGR" in
        apt) apt-get autoremove -y >/dev/null 2>&1 ;;
        dnf) dnf autoremove -y -q >/dev/null 2>&1 ;;
        yum) yum autoremove -y -q >/dev/null 2>&1 ;;
        zypper) zypper packages --unneeded 2>/dev/null | awk -F'|' 'NR>3{print $3}' | xargs -r zypper remove -y >/dev/null 2>&1 ;;
        pacman) pacman -Qdtq 2>/dev/null | xargs -r pacman -Rns --noconfirm >/dev/null 2>&1 ;;
    esac
    return 0
}

ff_pkg_is_installed() {
    local pkg="$1"
    case "$FF_PKG_MGR" in
        apt) dpkg -s "$pkg" &>/dev/null ;;
        dnf|yum) rpm -q "$pkg" &>/dev/null ;;
        zypper) rpm -q "$pkg" &>/dev/null ;;
        pacman) pacman -Q "$pkg" &>/dev/null ;;
    esac
}

# Mandatory Dependency Check (Added jq and curl)
check_environment() {
    local missing_packages=()
    local cmd

    for cmd in bc jq curl wget; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_packages+=("$cmd")
        fi
    done

    if (( ${#missing_packages[@]} > 0 )); then
        echo -e "${C_YELLOW}⚠️ Installing missing dependencies: ${missing_packages[*]}${C_RESET}"
        ff_pkg_install "${missing_packages[@]}" >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Error: Failed to install required dependencies: ${missing_packages[*]}.${C_RESET}"
            exit 1
        }
    fi
}

ensure_firewallfalcon_dirs() {
    mkdir -p "$DB_DIR" "$SSL_CERT_DIR" "$BANDWIDTH_DIR" /etc/ssh/sshd_config.d
    touch "$DB_FILE"
}

ensure_firewallfalcon_system_group() {
    getent group "$FF_USERS_GROUP" >/dev/null 2>&1 || groupadd "$FF_USERS_GROUP" >/dev/null 2>&1 || true
}

db_has_user() {
    [[ -f "$DB_FILE" ]] || return 1
    awk -F: -v target="$1" '$1 == target { found=1; exit } END { exit(found ? 0 : 1) }' "$DB_FILE"
}

is_firewallfalcon_orphan_user() {
    local username="$1"
    local passwd_line system_user _ uid _ home shell

    passwd_line=$(getent passwd "$username" 2>/dev/null) || return 1
    IFS=: read -r system_user _ uid _ _ home shell <<< "$passwd_line"
    [[ "$uid" =~ ^[0-9]+$ ]] || return 1
    db_has_user "$username" && return 1

    if id -nG "$username" 2>/dev/null | tr ' ' '\n' | grep -Fxq "$FF_USERS_GROUP"; then
        return 0
    fi

    (( uid >= 1000 )) || return 1
    [[ "$home" == "/home/$username" || "$home" == /home/* ]] || return 1

    case "$shell" in
        /usr/sbin/nologin|/usr/bin/false|/bin/false) return 0 ;;
    esac

    return 1
}

get_firewallfalcon_orphan_users() {
    local username
    while IFS=: read -r username _rest; do
        [[ -n "$username" ]] || continue
        if is_firewallfalcon_orphan_user "$username"; then
            echo "$username"
        fi
    done < /etc/passwd
}

get_firewallfalcon_known_users() {
    local username
    local -A seen_users=()

    if [[ -f "$DB_FILE" ]]; then
        while IFS=: read -r username _rest; do
            [[ -n "$username" && "$username" != \#* ]] || continue
            seen_users["$username"]=1
        done < "$DB_FILE"
    fi

    while IFS= read -r username; do
        [[ -n "$username" ]] && seen_users["$username"]=1
    done < <(get_firewallfalcon_orphan_users)

    (( ${#seen_users[@]} > 0 )) || return 0
    printf "%s\n" "${!seen_users[@]}" | sort
}

delete_firewallfalcon_user_accounts() {
    local -a users_to_delete=("$@")
    local username

    [[ ${#users_to_delete[@]} -gt 0 ]] || return 0

    for username in "${users_to_delete[@]}"; do
        [[ -n "$username" ]] || continue
        killall -u "$username" -9 &>/dev/null
        pkill -9 -u "$username" &>/dev/null
        sleep 0.5
        if id "$username" &>/dev/null; then
            if userdel -rf "$username" &>/dev/null; then
                echo -e " ✅ System user '${C_YELLOW}$username${C_RESET}' deleted."
            else
                # Retry after harder kill
                pkill -9 -u "$username" &>/dev/null
                sleep 1
                if userdel -rf "$username" &>/dev/null; then
                    echo -e " ✅ System user '${C_YELLOW}$username${C_RESET}' deleted (retry)."
                else
                    echo -e " ❌ Failed to delete system user '${C_YELLOW}$username${C_RESET}'."
                fi
            fi
        else
            echo -e " ℹ️ System user '${C_YELLOW}$username${C_RESET}' was already missing. Removing manager data only."
        fi
        rm -f "$BANDWIDTH_DIR/${username}.usage"
        rm -f "$BANDWIDTH_DIR/${username}.daily_usage"
        rm -f "$BANDWIDTH_DIR/${username}.conn_locked"
        rm -f "$BANDWIDTH_DIR/${username}.daily_locked"
        rm -rf "$BANDWIDTH_DIR/pidtrack/${username}"
    done

    if [[ -f "$DB_FILE" ]]; then
        local db_tmp
        db_tmp=$(mktemp)
        awk -F: 'NR==FNR { drop[$1]=1; next } !($1 in drop)' <(printf "%s\n" "${users_to_delete[@]}") "$DB_FILE" > "$db_tmp" && mv "$db_tmp" "$DB_FILE"
        rm -f "$db_tmp" 2>/dev/null
    fi

    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

require_interactive_terminal() {
    if [[ ! -t 0 || ! -t 1 ]]; then
        echo -e "${C_RED}❌ Error: The Mohammad Ahmad VPN Manager menu must be run from an interactive terminal.${C_RESET}"
        exit 1
    fi
}

initial_setup() {
    echo -e "${C_BLUE}⚙️ Initializing Mohammad Ahmad VPN Manager Manager setup...${C_RESET}"
    check_environment
    
    ensure_firewallfalcon_dirs
    ensure_firewallfalcon_system_group
    
    echo -e "${C_BLUE}🔹 Configuring user limiter service...${C_RESET}"
    setup_limiter_service
    
    echo -e "${C_BLUE}🔹 Configuring bandwidth monitoring service...${C_RESET}"
    setup_bandwidth_service
    
    echo -e "${C_BLUE}🔹 Installing trial account cleanup script...${C_RESET}"
    setup_trial_cleanup_script
    
    echo -e "${C_BLUE}🔹 Cleaning legacy dynamic SSH banner hooks...${C_RESET}"
    disable_dynamic_ssh_banner_system
    systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || true
    
    if [ ! -f "$INSTALL_FLAG_FILE" ]; then
        touch "$INSTALL_FLAG_FILE"
    fi
    echo -e "${C_GREEN}✅ Setup finished.${C_RESET}"
}

_is_valid_ipv4() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

check_and_open_firewall_port() {
    local port="$1"
    local protocol="${2:-tcp}"
    local firewall_detected=false

    if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
        firewall_detected=true
        if ! ufw status | grep -qw "$port/$protocol"; then
            echo -e "${C_YELLOW}🔥 UFW firewall is active and port ${port}/${protocol} is closed.${C_RESET}"
            read -p "👉 Do you want to open this port now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                ufw allow "$port/$protocol"
                echo -e "${C_GREEN}✅ Port ${port}/${protocol} has been opened in UFW.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Port ${port}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
             echo -e "${C_GREEN}✅ Port ${port}/${protocol} is already open in UFW.${C_RESET}"
        fi
    fi

    if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
        firewall_detected=true
        if ! firewall-cmd --list-ports --permanent | grep -qw "$port/$protocol"; then
            echo -e "${C_YELLOW}🔥 firewalld is active and port ${port}/${protocol} is not open.${C_RESET}"
            read -p "👉 Do you want to open this port now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                firewall-cmd --add-port="$port/$protocol" --permanent
                firewall-cmd --reload
                echo -e "${C_GREEN}✅ Port ${port}/${protocol} has been opened in firewalld.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Port ${port}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Port ${port}/${protocol} is already open in firewalld.${C_RESET}"
        fi
    fi

    if ! $firewall_detected; then
        echo -e "${C_BLUE}ℹ️ No active firewall (UFW or firewalld) detected. Assuming ports are open.${C_RESET}"
    fi
    return 0
}

check_and_open_firewall_port_range() {
    local port_range="$1"
    local protocol="${2:-tcp}"
    local firewall_detected=false

    if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
        firewall_detected=true
        if ! ufw status | grep -Fq "$port_range/$protocol"; then
            echo -e "${C_YELLOW}🔥 UFW firewall is active and range ${port_range}/${protocol} is closed.${C_RESET}"
            read -p "👉 Do you want to open this port range now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                ufw allow "$port_range/$protocol"
                echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} has been opened in UFW.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Range ${port_range}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} is already open in UFW.${C_RESET}"
        fi
    fi

    if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
        firewall_detected=true
        if ! firewall-cmd --quiet --query-port="$port_range/$protocol"; then
            echo -e "${C_YELLOW}🔥 firewalld is active and range ${port_range}/${protocol} is not open.${C_RESET}"
            read -p "👉 Do you want to open this port range now? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                firewall-cmd --add-port="$port_range/$protocol" --permanent
                firewall-cmd --reload
                echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} has been opened in firewalld.${C_RESET}"
            else
                echo -e "${C_RED}❌ Warning: Range ${port_range}/${protocol} was not opened. The service may not work correctly.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Range ${port_range}/${protocol} is already open in firewalld.${C_RESET}"
        fi
    fi

    if ! $firewall_detected; then
        echo -e "${C_BLUE}ℹ️ No active firewall (UFW or firewalld) detected. Assuming range ${port_range}/${protocol} is open.${C_RESET}"
    fi
    return 0
}

check_and_free_ports() {
    local ports_to_check=("$@")
    for port in "${ports_to_check[@]}"; do
        echo -e "\n${C_BLUE}🔎 Checking if port $port is available...${C_RESET}"
        local conflicting_process_info
        conflicting_process_info=$(
            ss -H -lntp "( sport = :$port )" 2>/dev/null
            ss -H -lunp "( sport = :$port )" 2>/dev/null
        )
        
        if [[ -n "$conflicting_process_info" ]]; then
            local conflicting_pid
            conflicting_pid=$(echo "$conflicting_process_info" | grep -oP 'pid=\K[0-9]+' | head -n 1)
            local conflicting_name
            conflicting_name=$(echo "$conflicting_process_info" | grep -oP 'users:\(\("(\K[^"]+)' | head -n 1)
            
            echo -e "${C_YELLOW}⚠️ Warning: Port $port is in use by process '${conflicting_name:-unknown}' (PID: ${conflicting_pid:-N/A}).${C_RESET}"
            read -p "👉 Do you want to attempt to stop this process? (y/n): " kill_confirm
            if [[ "$kill_confirm" == "y" || "$kill_confirm" == "Y" ]]; then
                if [[ -z "$conflicting_pid" ]]; then
                    echo -e "${C_RED}❌ Could not determine which PID owns port $port. Please free it manually.${C_RESET}"
                    return 1
                fi
                echo -e "${C_GREEN}🛑 Stopping process PID $conflicting_pid...${C_RESET}"
                systemctl stop "$(ps -p "$conflicting_pid" -o comm=)" &>/dev/null || kill -9 "$conflicting_pid"
                sleep 2
                
                if ss -H -lntp "( sport = :$port )" 2>/dev/null | grep -q . || ss -H -lunp "( sport = :$port )" 2>/dev/null | grep -q .; then
                     echo -e "${C_RED}❌ Failed to free port $port. Please handle it manually. Aborting.${C_RESET}"
                     return 1
                else
                     echo -e "${C_GREEN}✅ Port $port has been successfully freed.${C_RESET}"
                fi
            else
                echo -e "${C_RED}❌ Cannot proceed without freeing port $port. Aborting.${C_RESET}"
                return 1
            fi
        else
            echo -e "${C_GREEN}✅ Port $port is free to use.${C_RESET}"
        fi
    done
    return 0
}

setup_limiter_service() {
    # Combined limiter + bandwidth monitoring
    cat > "$LIMITER_SCRIPT" << 'EOF'
#!/bin/bash
# Mohammad Ahmad VPN Manager limiter version 2026-07-23.4
DB_FILE="/etc/firewallfalcon/users.db"
BW_DIR="/etc/firewallfalcon/bandwidth"
PID_DIR="$BW_DIR/pidtrack"
BANNER_DIR="/etc/firewallfalcon/banners"
SCAN_INTERVAL=10
CONN_LOCK_DURATION=60

mkdir -p "$BW_DIR" "$PID_DIR"
shopt -s nullglob

write_banner_if_changed() {
    local user="$1"
    local content="$2"
    local banner_file="$BANNER_DIR/${user}.txt"
    local tmp_file="${banner_file}.tmp"

    printf "%s" "$content" > "$tmp_file"
    if ! cmp -s "$tmp_file" "$banner_file" 2>/dev/null; then
        mv "$tmp_file" "$banner_file"
    else
        rm -f "$tmp_file"
    fi
}

# Excess sessions are killed immediately every scan cycle. No account locking.

while true; do
    if [[ ! -s "$DB_FILE" ]]; then
        sleep "$SCAN_INTERVAL"
        continue
    fi
    
    # Daily reset logic
    today=$(date +%Y-%m-%d)
    if [[ ! -f "$BW_DIR/current_date" ]]; then
        echo "$today" > "$BW_DIR/current_date"
    fi
    saved_date=$(cat "$BW_DIR/current_date" 2>/dev/null || echo "$today")
    if [[ "$today" != "$saved_date" ]]; then
        # New day! Reset daily usage and unlock users locked due to daily limit
        rm -f "$BW_DIR/"*.daily_usage 2>/dev/null
        for locked_file in "$BW_DIR/"*.daily_locked; do
            [[ -f "$locked_file" ]] || continue
            locked_user=$(basename "$locked_file" .daily_locked)
            usermod -U "$locked_user" &>/dev/null
            rm -f "$locked_file"
        done
        echo "$today" > "$BW_DIR/current_date"
    fi

    # Connection limit auto-unlock: check marker files and unlock after CONN_LOCK_DURATION seconds
    for conn_lock_file in "$BW_DIR/"*.conn_locked; do
        [[ -f "$conn_lock_file" ]] || continue
        lock_ts=0
        read -r lock_ts < "$conn_lock_file" 2>/dev/null || lock_ts=0
        [[ "$lock_ts" =~ ^[0-9]+$ ]] || lock_ts=0
        printf -v now_ts '%(%s)T' -1
        if (( now_ts - lock_ts >= CONN_LOCK_DURATION )); then
            conn_locked_user=$(basename "$conn_lock_file" .conn_locked)
            usermod -U "$conn_locked_user" &>/dev/null
            rm -f "$conn_lock_file"
        fi
    done

    printf -v current_ts '%(%s)T' -1
    dynamic_banners_enabled=false

    # Reset associative arrays each cycle (unset first to avoid stale data)
    unset session_pids locked_users uid_to_user loginuid_pids
    declare -A session_pids=()
    declare -A locked_users=()
    declare -A uid_to_user=()
    declare -A loginuid_pids=()

    while IFS=: read -r username _ uid _rest; do
        [[ -n "$username" && "$uid" =~ ^[0-9]+$ ]] && uid_to_user["$uid"]="$username"
    done < /etc/passwd

    # Method 1: process owner from ps (primary source for connection counting)
    # sshd-session is the user-owned process on Ubuntu 24.04+ (OpenSSH 9.8+)
    # On Ubuntu 22, the per-session sshd is user-owned instead.
    # Either way, exactly 1 user-owned process exists per SSH session.
    while read -r ssh_pid ssh_owner; do
        [[ "$ssh_pid" =~ ^[0-9]+$ ]] || continue
        if [[ -n "$ssh_owner" && "$ssh_owner" != "root" && "$ssh_owner" != "sshd" ]]; then
            session_pids["$ssh_owner"]+="$ssh_pid "
        fi
    done < <(ps -C sshd,sshd-session -o pid=,user= 2>/dev/null)

    # Method 2: kernel loginuid (reliable even when sshd runs as root)
    for p in /proc/[0-9]*/loginuid; do
        [[ -f "$p" ]] || continue
        login_uid=""
        read -r login_uid < "$p" || login_uid=""
        [[ "$login_uid" =~ ^[0-9]+$ && "$login_uid" != "4294967295" ]] || continue

        session_user="${uid_to_user[$login_uid]}"
        [[ -n "$session_user" ]] || continue

        pid_dir=$(dirname "$p")
        pid_num=$(basename "$pid_dir")
        comm=""
        read -r comm < "$pid_dir/comm" || comm=""
        [[ "$comm" == "sshd" ]] || continue

        ppid_val=""
        while read -r key value; do
            if [[ "$key" == "PPid:" ]]; then
                ppid_val="${value:-}"
                break
            fi
        done < "$pid_dir/status"
        [[ "$ppid_val" == "1" ]] && continue

        loginuid_pids["$session_user"]+="$pid_num "
    done

    # Detect locked users via /etc/shadow (cheaper than passwd -Sa)
    if [[ -r /etc/shadow ]]; then
        while IFS=: read -r shadow_user shadow_hash _rest; do
            [[ -n "$shadow_user" && "${shadow_hash:0:1}" == "!" ]] && locked_users["$shadow_user"]=1
        done < /etc/shadow
    else
        while read -r passwd_user _ passwd_status _rest; do
            [[ "$passwd_status" == "L" ]] && locked_users["$passwd_user"]=1
        done < <(passwd -Sa 2>/dev/null)
    fi

    if [[ -f "/etc/firewallfalcon/banners_enabled" ]]; then
        mkdir -p "$BANNER_DIR"
        dynamic_banners_enabled=true
    fi

    while IFS=: read -r user pass expiry limit bandwidth_gb daily_bandwidth_gb _extra; do
        [[ -z "$user" || "$user" == \#* ]] && continue
        
        [[ ! "$daily_bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]] && daily_bandwidth_gb=0

        # CRITICAL: unset before declare to reset per-user (bash declare is function-scoped)
        unset unique_pids
        declare -A unique_pids=()

        # Use ONLY ps-based session_pids for connection counting.
        # loginuid_pids can double-count (root-owned sshd has user's loginuid on Ubuntu 24)
        for pid in ${session_pids[$user]}; do
            [[ "$pid" =~ ^[0-9]+$ ]] && unique_pids["$pid"]=1
        done

        online_count=${#unique_pids[@]}
        user_locked=false
        if [[ -n "${locked_users[$user]+x}" ]]; then
            user_locked=true
        fi

        expiry_ts=0
        if [[ "$expiry" != "Never" && -n "$expiry" && "$expiry" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            expiry_ts=$(date -d "$expiry" +%s 2>/dev/null || echo 0)
            if [[ "$expiry_ts" =~ ^[0-9]+$ ]] && (( expiry_ts > 0 && expiry_ts < current_ts )); then
                if ! $user_locked; then
                    usermod -L "$user" &>/dev/null
                    killall -u "$user" -9 &>/dev/null
                    locked_users["$user"]=1
                fi
                continue
            fi
        fi

        [[ "$limit" =~ ^[0-9]+$ ]] || limit=1
        if (( online_count > limit )); then
            # Kill only the EXCESS sessions, keep the oldest ones alive
            sorted_pids=()
            for pid in "${!unique_pids[@]}"; do
                sorted_pids+=("$pid")
            done
            IFS=$'\n' sorted_pids=($(sort -n <<<"${sorted_pids[*]}")); unset IFS

            for (( i=limit; i<${#sorted_pids[@]}; i++ )); do
                kill -9 "${sorted_pids[$i]}" &>/dev/null
            done

            # Remove killed PIDs from unique_pids so bandwidth tracking is correct
            for (( i=limit; i<${#sorted_pids[@]}; i++ )); do
                unset unique_pids["${sorted_pids[$i]}"]
            done
            online_count=${#unique_pids[@]}
        fi

        if $dynamic_banners_enabled; then
            days_left="N/A"
            if [[ "$expiry" != "Never" && -n "$expiry" && "$expiry_ts" =~ ^[0-9]+$ && $expiry_ts -gt 0 ]]; then
                diff_secs=$((expiry_ts - current_ts))
                if (( diff_secs <= 0 )); then
                    days_left="EXPIRED"
                else
                    d_l=$(( diff_secs / 86400 ))
                    h_l=$(( (diff_secs % 86400) / 3600 ))
                    if (( d_l == 0 )); then
                        days_left="${h_l}h left"
                    else
                        days_left="${d_l}d ${h_l}h"
                    fi
                fi
            fi

            bw_info="Unlimited"
            if [[ "$bandwidth_gb" != "0" && -n "$bandwidth_gb" ]]; then
                usagefile="$BW_DIR/${user}.usage"
                accum_disp=0
                if [[ -f "$usagefile" ]]; then
                    read -r accum_disp < "$usagefile"
                    [[ "$accum_disp" =~ ^[0-9]+$ ]] || accum_disp=0
                fi
                used_gb_int=$((accum_disp / 1073741824))
                used_gb_frac=$(( (accum_disp % 1073741824) * 100 / 1073741824 ))
                printf -v used_gb "%d.%02d" "$used_gb_int" "$used_gb_frac"
                quota_b=$(( ${bandwidth_gb%%.*} * 1073741824 ))
                remain_b=$(( quota_b - accum_disp ))
                (( remain_b < 0 )) && remain_b=0
                remain_gb_int=$((remain_b / 1073741824))
                remain_gb_frac=$(( (remain_b % 1073741824) * 100 / 1073741824 ))
                printf -v remain_gb "%d.%02d" "$remain_gb_int" "$remain_gb_frac"
                bw_info="${used_gb}/${bandwidth_gb} GB used | ${remain_gb} GB left"
            fi

            banner_content="<br><font color=\"yellow\"><b>      ✨ ACCOUNT STATUS ✨      </b></font><br><br>"
            banner_content+="<font color=\"white\">👤 <b>Username   :</b> $user</font><br>"
            banner_content+="<font color=\"white\">📅 <b>Expiration :</b> $expiry ($days_left)</font><br>"
            
            if [[ "$bandwidth_gb" != "0" ]]; then
                banner_content+="<font color=\"white\">📊 <b>Total BW   :</b> $bw_info</font><br>"
            fi
            
            if [[ "$daily_bandwidth_gb" != "0" ]]; then
                daily_usagefile="$BW_DIR/${user}.daily_usage"
                accum_disp=0
                if [[ -f "$daily_usagefile" ]]; then
                    read -r accum_disp < "$daily_usagefile"
                    [[ "$accum_disp" =~ ^[0-9]+$ ]] || accum_disp=0
                fi
                used_gb_int=$((accum_disp / 1073741824))
                used_gb_frac=$(( (accum_disp % 1073741824) * 100 / 1073741824 ))
                printf -v used_gb "%d.%02d" "$used_gb_int" "$used_gb_frac"
                quota_b=$(( ${daily_bandwidth_gb%%.*} * 1073741824 ))
                remain_b=$(( quota_b - accum_disp ))
                (( remain_b < 0 )) && remain_b=0
                remain_gb_int=$((remain_b / 1073741824))
                remain_gb_frac=$(( (remain_b % 1073741824) * 100 / 1073741824 ))
                printf -v remain_gb "%d.%02d" "$remain_gb_int" "$remain_gb_frac"
                daily_bw_info="${used_gb}/${daily_bandwidth_gb} GB used | ${remain_gb} GB left"
                banner_content+="<font color=\"white\">📊 <b>Daily BW   :</b> $daily_bw_info</font><br>"
            fi
            
            banner_content+="<font color=\"white\">🔌 <b>Sessions   :</b> $online_count/$limit</font><br><br>"
            write_banner_if_changed "$user" "$banner_content"
        fi

        [[ ( -z "$bandwidth_gb" || "$bandwidth_gb" == "0" ) && ( -z "$daily_bandwidth_gb" || "$daily_bandwidth_gb" == "0" ) ]] && continue

        usagefile="$BW_DIR/${user}.usage"
        accumulated=0
        if [[ -f "$usagefile" ]]; then
            read -r accumulated < "$usagefile"
            [[ "$accumulated" =~ ^[0-9]+$ ]] || accumulated=0
        fi

        if (( ${#unique_pids[@]} == 0 )); then
            rm -f "$PID_DIR/${user}__"*.last 2>/dev/null
            continue
        fi

        delta_total=0
        for pid in "${!unique_pids[@]}"; do
            io_file="/proc/$pid/io"
            cur=0
            if [[ -r "$io_file" ]]; then
                rchar=0
                wchar=0
                while read -r key value; do
                    case "$key" in
                        rchar:) rchar=${value:-0} ;;
                        wchar:) wchar=${value:-0} ;;
                    esac
                done < "$io_file"
                cur=$((rchar + wchar))
            fi

            pidfile="$PID_DIR/${user}__${pid}.last"
            if [[ -f "$pidfile" ]]; then
                read -r prev < "$pidfile"
                [[ "$prev" =~ ^[0-9]+$ ]] || prev=0
                if (( cur >= prev )); then
                    d=$((cur - prev))
                else
                    d=$cur
                fi
                delta_total=$((delta_total + d))
            fi
            printf "%s\n" "$cur" > "$pidfile"
        done

        for f in "$PID_DIR/${user}__"*.last; do
            [[ -f "$f" ]] || continue
            fpid=${f##*__}
            fpid=${fpid%.last}
            [[ -d "/proc/$fpid" ]] || rm -f "$f"
        done

        new_total=$((accumulated + delta_total))
        printf "%s\n" "$new_total" > "$usagefile"

        if awk "BEGIN{exit(!($bandwidth_gb > 0))}" 2>/dev/null; then
            quota_bytes=$(awk "BEGIN{printf \"%.0f\", $bandwidth_gb * 1073741824}")
            if [[ "$quota_bytes" =~ ^[0-9]+$ ]] && (( quota_bytes > 0 && new_total >= quota_bytes )); then
                if ! $user_locked; then
                    usermod -L "$user" &>/dev/null
                    locked_users["$user"]=1
                    user_locked=true
                fi
            fi
        fi
        
        daily_usagefile="$BW_DIR/${user}.daily_usage"
        daily_accumulated=0
        if [[ -f "$daily_usagefile" ]]; then
            read -r daily_accumulated < "$daily_usagefile"
            [[ "$daily_accumulated" =~ ^[0-9]+$ ]] || daily_accumulated=0
        fi
        new_daily_total=$((daily_accumulated + delta_total))
        printf "%s\n" "$new_daily_total" > "$daily_usagefile"
        
        if awk "BEGIN{exit(!($daily_bandwidth_gb > 0))}" 2>/dev/null; then
            d_quota_bytes=$(awk "BEGIN{printf \"%.0f\", $daily_bandwidth_gb * 1073741824}")
            if [[ "$d_quota_bytes" =~ ^[0-9]+$ ]] && (( d_quota_bytes > 0 && new_daily_total >= d_quota_bytes )); then
                if ! $user_locked; then
                    usermod -L "$user" &>/dev/null
                    locked_users["$user"]=1
                    user_locked=true
                    touch "$BW_DIR/${user}.daily_locked"
                fi
            fi
        fi
    done < "$DB_FILE"

    sleep "$SCAN_INTERVAL"
done
EOF
    chmod +x "$LIMITER_SCRIPT"
    # Strip DOS line endings in case menu.sh was uploaded from Windows
    sed -i 's/\r$//' "$LIMITER_SCRIPT" 2>/dev/null

    cat > "$LIMITER_SERVICE" << EOF
[Unit]
Description=Mohammad Ahmad VPN Manager Active User Limiter
After=network.target

[Service]
Type=simple
ExecStart=$LIMITER_SCRIPT
Restart=always
RestartSec=10
Nice=10
IOSchedulingClass=best-effort
IOSchedulingPriority=7
MemoryHigh=48M
MemoryMax=64M

[Install]
WantedBy=multi-user.target
EOF
    sed -i 's/\r$//' "$LIMITER_SERVICE" 2>/dev/null

    pkill -f "firewallfalcon-limiter" 2>/dev/null

    if ! systemctl is-active --quiet firewallfalcon-limiter; then
        systemctl daemon-reload
        systemctl enable firewallfalcon-limiter &>/dev/null
        systemctl start firewallfalcon-limiter --no-block &>/dev/null
        
    else
        systemctl restart firewallfalcon-limiter --no-block &>/dev/null
        
    fi
}

sync_runtime_components_if_needed() {
    local limiter_marker="# Mohammad Ahmad VPN Manager limiter version 2026-07-23.8"
    cleanup_legacy_bandwidth_runtime
    setup_trial_cleanup_script >/dev/null 2>&1
    if [[ ! -f "$LIMITER_SCRIPT" ]] || ! grep -Fqx "$limiter_marker" "$LIMITER_SCRIPT" 2>/dev/null; then
        setup_limiter_service >/dev/null 2>&1
    fi
    if [[ -f "$BADVPN_SERVICE_FILE" ]]; then
        ensure_badvpn_service_is_quiet
    fi
    if [[ -f "/etc/firewallfalcon/banners_enabled" ]]; then
        update_ssh_banners_config
    elif [[ -f "$SSHD_FF_CONFIG" ]]; then
        disable_dynamic_ssh_banner_system
        systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || true
    fi
}

setup_bandwidth_service() {
    mkdir -p "$BANDWIDTH_DIR"
    # Bandwidth monitoring is now integrated into the limiter service above.
    cleanup_legacy_bandwidth_runtime
}

cleanup_legacy_bandwidth_runtime() {
    local needs_reload=false

    systemctl stop firewallfalcon-bandwidth &>/dev/null || true
    systemctl disable firewallfalcon-bandwidth &>/dev/null || true
    pkill -f "firewallfalcon-bandwidth" &>/dev/null || true

    if [[ -e "$BANDWIDTH_SERVICE" || -e "$BANDWIDTH_SCRIPT" || -e "$LEGACY_BANDWIDTH_DIR" ]]; then
        rm -f "$BANDWIDTH_SERVICE" "$BANDWIDTH_SCRIPT" 2>/dev/null
        rm -rf "$LEGACY_BANDWIDTH_DIR" 2>/dev/null
        needs_reload=true
    fi

    if $needs_reload; then
        systemctl daemon-reload &>/dev/null || true
    fi
}

setup_trial_cleanup_script() {
    cat > "$TRIAL_CLEANUP_SCRIPT" << 'TREOF'
#!/bin/bash
# Mohammad Ahmad VPN Manager Trial Account Auto-Cleanup
# Usage: firewallfalcon-trial-cleanup.sh <username>
DB_FILE="/etc/firewallfalcon/users.db"
BW_DIR="/etc/firewallfalcon/bandwidth"

username="$1"
if [[ -z "$username" ]]; then exit 1; fi

db_line=$(grep "^${username}:" "$DB_FILE" 2>/dev/null | head -n 1)
if [[ -z "$db_line" ]]; then exit 0; fi

IFS=: read -r _ _ _ _ _ trial_marker _rest <<< "$db_line"
if [[ "$trial_marker" != "trial" ]]; then
    exit 0
fi

# Kill active sessions
killall -u "$username" -9 &>/dev/null
pkill -9 -u "$username" &>/dev/null
sleep 1

# Delete system user
userdel -rf "$username" &>/dev/null

# Remove from DB
sed -i "/^${username}:/d" "$DB_FILE"

# Remove bandwidth tracking
rm -f "$BW_DIR/${username}.usage"
rm -rf "$BW_DIR/pidtrack/${username}"
TREOF
    chmod +x "$TRIAL_CLEANUP_SCRIPT"
}

disable_dynamic_ssh_banner_system() {
    rm -f "/etc/firewallfalcon/banners_enabled" "$SSHD_FF_CONFIG" /usr/local/bin/firewallfalcon-login-info.sh 2>/dev/null
    rm -rf "/etc/firewallfalcon/banners" 2>/dev/null
    invalidate_banner_cache
}

disable_static_ssh_banner_in_sshd_config() {
    sed -i.bak -E "s|^[[:space:]]*Banner[[:space:]]+$SSH_BANNER_FILE[[:space:]]*$|# Banner $SSH_BANNER_FILE|" /etc/ssh/sshd_config 2>/dev/null
}

is_static_ssh_banner_enabled() {
    grep -q -E "^[[:space:]]*Banner[[:space:]]+$SSH_BANNER_FILE[[:space:]]*$" /etc/ssh/sshd_config 2>/dev/null && [ -f "$SSH_BANNER_FILE" ]
}

is_dynamic_ssh_banner_enabled() {
    [[ -f "/etc/firewallfalcon/banners_enabled" && -f "$SSHD_FF_CONFIG" ]]
}

get_ssh_banner_mode() {
    if is_dynamic_ssh_banner_enabled; then
        echo "dynamic"
    elif is_static_ssh_banner_enabled; then
        echo "static"
    else
        echo "disabled"
    fi
}

refresh_dynamic_banner_routing_if_enabled() {
    if is_dynamic_ssh_banner_enabled; then
        update_ssh_banners_config
    fi
}

update_ssh_banners_config() {
    local tmp_conf

    if [[ ! -f "/etc/firewallfalcon/banners_enabled" ]]; then
        if [[ -f "$SSHD_FF_CONFIG" ]]; then
            rm -f "$SSHD_FF_CONFIG" 2>/dev/null
            systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
        fi
        return
    fi

    ensure_firewallfalcon_dirs
    tmp_conf="/tmp/ff_banners_new.conf"
    echo "# Mohammad Ahmad VPN Manager - Dynamic per-user SSH banners" > "$tmp_conf"

    if [[ -f "$DB_FILE" ]]; then
        while IFS=: read -r u _rest; do
            [[ -z "$u" || "$u" == \#* ]] && continue
            echo "Match User $u" >> "$tmp_conf"
            echo "    Banner /etc/firewallfalcon/banners/${u}.txt" >> "$tmp_conf"
        done < "$DB_FILE"
    fi

    if ! cmp -s "$tmp_conf" "$SSHD_FF_CONFIG" 2>/dev/null; then
        mv "$tmp_conf" "$SSHD_FF_CONFIG"
        if ! grep -q "^Include /etc/ssh/sshd_config.d/" /etc/ssh/sshd_config 2>/dev/null; then
            echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config
        fi
        systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
    else
        rm -f "$tmp_conf"
    fi
}

setup_ssh_login_info() {
    ensure_firewallfalcon_dirs || return 1
    if ! touch "/etc/firewallfalcon/banners_enabled"; then
        echo -e "${C_RED}❌ Failed to enable dynamic SSH banners.${C_RESET}"
        return 1
    fi
    disable_static_ssh_banner_in_sshd_config
    update_ssh_banners_config
    return 0
}


generate_dns_record() {
    echo -e "\n${C_BLUE}⚙️ Generating a random domain...${C_RESET}"
    if ! command -v jq &> /dev/null; then
        echo -e "${C_YELLOW}⚠️ jq not found, attempting to install...${C_RESET}"
        ff_pkg_install jq >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to install jq. Cannot manage DNS records.${C_RESET}"
            return 1
        }
    fi
    local SERVER_IPV4
    SERVER_IPV4=$(curl -s -4 icanhazip.com)
    if ! _is_valid_ipv4 "$SERVER_IPV4"; then
        echo -e "\n${C_RED}❌ Error: Could not retrieve a valid public IPv4 address from icanhazip.com.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Please check your server's network connection and DNS resolver settings.${C_RESET}"
        echo -e "   Output received: '$SERVER_IPV4'"
        return 1
    fi

    local SERVER_IPV6
    SERVER_IPV6=$(curl -s -6 icanhazip.com --max-time 5)

    local RANDOM_SUBDOMAIN="vps-$(tr -dc a-z0-9 < /dev/urandom | head -c 8)"
    local FULL_DOMAIN="$RANDOM_SUBDOMAIN.$DESEC_DOMAIN"
    local HAS_IPV6="false"

    local API_DATA
    API_DATA=$(printf '[{"subname": "%s", "type": "A", "ttl": 3600, "records": ["%s"]}]' "$RANDOM_SUBDOMAIN" "$SERVER_IPV4")

    if [[ -n "$SERVER_IPV6" ]]; then
        local aaaa_record
        aaaa_record=$(printf ',{"subname": "%s", "type": "AAAA", "ttl": 3600, "records": ["%s"]}' "$RANDOM_SUBDOMAIN" "$SERVER_IPV6")
        API_DATA="${API_DATA%?}${aaaa_record}]"
        HAS_IPV6="true"
    fi

    local CREATE_RESPONSE
    CREATE_RESPONSE=$(curl -s -w "%{http_code}" -X POST "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/" \
        -H "Authorization: Token $DESEC_TOKEN" -H "Content-Type: application/json" \
        --data "$API_DATA")
    
    local HTTP_CODE=${CREATE_RESPONSE: -3}
    local RESPONSE_BODY=${CREATE_RESPONSE:0:${#CREATE_RESPONSE}-3}

    if [[ "$HTTP_CODE" -ne 201 ]]; then
        echo -e "${C_RED}❌ Failed to create DNS records. API returned HTTP $HTTP_CODE.${C_RESET}"
        if ! echo "$RESPONSE_BODY" | jq . > /dev/null 2>&1; then
            echo "Raw Response: $RESPONSE_BODY"
        else
            echo "Response: $RESPONSE_BODY" | jq
        fi
        return 1
    fi
    
    cat > "$DNS_INFO_FILE" <<-EOF
SUBDOMAIN="$RANDOM_SUBDOMAIN"
FULL_DOMAIN="$FULL_DOMAIN"
HAS_IPV6="$HAS_IPV6"
EOF
    echo -e "\n${C_GREEN}✅ Successfully created domain: ${C_YELLOW}$FULL_DOMAIN${C_RESET}"
}

delete_dns_record() {
    if [ ! -f "$DNS_INFO_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ No domain to delete.${C_RESET}"
        return
    fi
    echo -e "\n${C_BLUE}🗑️ Deleting DNS records...${C_RESET}"
    source "$DNS_INFO_FILE"
    if [[ -z "$SUBDOMAIN" ]]; then
        echo -e "${C_RED}❌ Could not read record details from config file. Skipping deletion.${C_RESET}"
        return
    fi

    curl -s -X DELETE "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/$SUBDOMAIN/A/" \
         -H "Authorization: Token $DESEC_TOKEN" > /dev/null

    if [[ "$HAS_IPV6" == "true" ]]; then
        curl -s -X DELETE "https://desec.io/api/v1/domains/$DESEC_DOMAIN/rrsets/$SUBDOMAIN/AAAA/" \
             -H "Authorization: Token $DESEC_TOKEN" > /dev/null
    fi

    echo -e "\n${C_GREEN}✅ Deleted domain: ${C_YELLOW}$FULL_DOMAIN${C_RESET}"
    rm -f "$DNS_INFO_FILE"
}

dns_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🌐 DNS Domain Management ---${C_RESET}"
    if [ -f "$DNS_INFO_FILE" ]; then
        source "$DNS_INFO_FILE"
        echo -e "\nℹ️ A domain already exists for this server:"
        echo -e "  - ${C_CYAN}Domain:${C_RESET} ${C_YELLOW}$FULL_DOMAIN${C_RESET}"
        echo
        read -p "👉 Do you want to DELETE this domain? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            delete_dns_record
        else
            echo -e "\n${C_YELLOW}❌ Action cancelled.${C_RESET}"
        fi
    else
        echo -e "\nℹ️ No domain has been generated for this server yet."
        echo
        read -p "👉 Do you want to generate a new random domain now? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            generate_dns_record
        else
            echo -e "\n${C_YELLOW}❌ Action cancelled.${C_RESET}"
        fi
    fi
}

_select_user_interface() {
    local title="$1"
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}${title}${C_RESET}\n"
    if [[ ! -s $DB_FILE ]]; then
        echo -e "${C_YELLOW}ℹ️ No users found in the database.${C_RESET}"
        SELECTED_USER="NO_USERS"; return
    fi
    
    mapfile -t all_users < <(cut -d: -f1 "$DB_FILE" | sort)
    local -A all_user_lookup=()
    local username
    for username in "${all_users[@]}"; do
        all_user_lookup["$username"]=1
    done
    
    if [ ${#all_users[@]} -ge 15 ]; then
        read -p "👉 Enter a search term (or press Enter to list all): " search_term
        if [[ -n "$search_term" ]]; then
            mapfile -t users < <(printf "%s\n" "${all_users[@]}" | grep -i "$search_term")
        else
            users=("${all_users[@]}")
        fi
    else
        users=("${all_users[@]}")
    fi

    if [ ${#users[@]} -eq 0 ]; then
        echo -e "\n${C_YELLOW}ℹ️ No users found matching your criteria.${C_RESET}"
        SELECTED_USER="NO_USERS"; return
    fi
    echo -e "\nPlease select a user:\n"
    for i in "${!users[@]}"; do
        printf "  ${C_GREEN}[%2d]${C_RESET} %s\n" "$((i+1))" "${users[$i]}"
    done
    echo -e "\n  ${C_RED} [ 0]${C_RESET} ↩️ Cancel"
    echo -e "${C_CYAN}💡 Tip: you can also type the exact username directly.${C_RESET}"
    echo
    local choice
    while true; do
        if ! read -r -p "👉 Enter the number or exact username: " choice; then
            echo
            SELECTED_USER=""
            return
        fi
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le "${#users[@]}" ]; then
            if [ "$choice" -eq 0 ]; then
                SELECTED_USER=""; return
            else
                SELECTED_USER="${users[$((choice-1))]}"; return
            fi
        elif [[ -n "${all_user_lookup[$choice]+x}" ]]; then
            SELECTED_USER="$choice"; return
        else
            echo -e "${C_RED}❌ Invalid selection. Please try again.${C_RESET}"
        fi
    done
}

_select_multi_user_interface() {
    local title="$1"
    local include_orphan_users="${2:-false}"
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}${title}${C_RESET}\n"
    SELECTED_USERS=()
    local -a all_users=()
    local -a orphan_users=()
    local -A all_user_lookup=()
    local -A orphan_user_lookup=()
    local username

    if [[ -s $DB_FILE ]]; then
        mapfile -t all_users < <(cut -d: -f1 "$DB_FILE" | sort)
    fi

    if [[ "$include_orphan_users" == "true" ]]; then
        mapfile -t orphan_users < <(get_firewallfalcon_orphan_users)
        for username in "${orphan_users[@]}"; do
            orphan_user_lookup["$username"]=1
            if ! printf "%s\n" "${all_users[@]}" | grep -Fxq "$username"; then
                all_users+=("$username")
            fi
        done
        if [[ ${#all_users[@]} -gt 0 ]]; then
            mapfile -t all_users < <(printf "%s\n" "${all_users[@]}" | sort)
        fi
    fi

    if [[ ${#all_users[@]} -eq 0 ]]; then
        echo -e "${C_YELLOW}ℹ️ No users found in the manager database.${C_RESET}"
        if [[ "$include_orphan_users" == "true" ]]; then
            echo -e "${C_DIM}No orphan Mohammad Ahmad VPN Manager system users were found either.${C_RESET}"
        fi
        SELECTED_USERS=("NO_USERS"); return
    fi

    for username in "${all_users[@]}"; do
        all_user_lookup["$username"]=1
    done
    
    if [ ${#all_users[@]} -ge 15 ]; then
        read -p "👉 Enter a search term (or press Enter to list all): " search_term
        if [[ -n "$search_term" ]]; then
            mapfile -t users < <(printf "%s\n" "${all_users[@]}" | grep -i "$search_term")
        else
            users=("${all_users[@]}")
        fi
    else
        users=("${all_users[@]}")
    fi

    if [ ${#users[@]} -eq 0 ]; then
        echo -e "\n${C_YELLOW}ℹ️ No users found matching your criteria.${C_RESET}"
        SELECTED_USERS=("NO_USERS"); return
    fi
    echo -e "\nPlease select users:\n"
    for i in "${!users[@]}"; do
        local display_user="${users[$i]}"
        if [[ "$include_orphan_users" == "true" && -n "${orphan_user_lookup[${users[$i]}]+x}" ]]; then
            display_user="${display_user} ${C_DIM}(system-only)${C_RESET}"
        fi
        printf "  ${C_GREEN}[%2d]${C_RESET} %s\n" "$((i+1))" "$display_user"
    done
    echo -e "\n  ${C_GREEN}[all]${C_RESET} Select ALL listed users"
    echo -e "  ${C_RED}  [0]${C_RESET} ↩️ Cancel and return to main menu"
    echo -e "\n${C_CYAN}💡 You can select multiple by number, range, or exact username.${C_RESET}"
    echo -e "${C_CYAN}   Examples: '1 3 5' or '1,3' or '1-4' or 'alice bob'${C_RESET}"
    if [[ "$include_orphan_users" == "true" ]]; then
        echo -e "${C_CYAN}   Users marked '(system-only)' are old accounts still on the VPS but missing from users.db${C_RESET}"
    fi
    echo
    local choice
    while true; do
        if ! read -r -p "👉 Enter user numbers or usernames: " choice; then
            echo
            SELECTED_USERS=()
            return
        fi
        choice=${choice//,/ } # Replace commas with spaces
        
        if [[ -z "$choice" ]]; then
            echo -e "${C_RED}❌ Invalid selection. Please try again.${C_RESET}"
            continue
        fi

        if [[ "$choice" == "0" ]]; then
            SELECTED_USERS=(); return
        fi
        
        if [[ "${choice,,}" == "all" ]]; then
            SELECTED_USERS=("${users[@]}")
            return
        fi
        
        local valid=true
        local selected_indices=()
        local selected_names=()
        for token in $choice; do
            if [[ "$token" =~ ^[0-9]+-[0-9]+$ ]]; then
                local start=${token%-*}
                local end=${token#*-}
                if [ "$start" -le "$end" ]; then
                    for (( idx=start; idx<=end; idx++ )); do
                        if [ "$idx" -ge 1 ] && [ "$idx" -le "${#users[@]}" ]; then
                            selected_indices+=($idx)
                        else
                            valid=false; break
                        fi
                    done
                else
                    valid=false; break
                fi
            elif [[ "$token" =~ ^[0-9]+$ ]]; then
                if [ "$token" -ge 1 ] && [ "$token" -le "${#users[@]}" ]; then
                    selected_indices+=($token)
                elif [[ -n "${all_user_lookup[$token]+x}" ]]; then
                    selected_names+=("$token")
                else
                    valid=false; break
                fi
            elif [[ -n "${all_user_lookup[$token]+x}" ]]; then
                selected_names+=("$token")
            else
                valid=false; break
            fi
        done
        
        if [[ "$valid" == true && ( ${#selected_indices[@]} -gt 0 || ${#selected_names[@]} -gt 0 ) ]]; then
            mapfile -t unique_indices < <(printf "%s\n" "${selected_indices[@]}" | sort -u -n)
            for idx in "${unique_indices[@]}"; do
                SELECTED_USERS+=("${users[$((idx-1))]}")
            done
            if (( ${#selected_names[@]} > 0 )); then
                mapfile -t unique_names < <(printf "%s\n" "${selected_names[@]}" | sort -u)
                for username in "${unique_names[@]}"; do
                    if [[ -n "$username" ]] && ! printf "%s\n" "${SELECTED_USERS[@]}" | grep -Fxq "$username"; then
                        SELECTED_USERS+=("$username")
                    fi
                done
            fi
            return
        else
            echo -e "${C_RED}❌ Invalid selection. Please check your numbers or usernames.${C_RESET}"
            SELECTED_USERS=()
            selected_indices=()
            selected_names=()
        fi
    done
}

get_user_status() {
    local username="$1"
    if ! id "$username" &>/dev/null; then echo -e "${C_RED}Not Found${C_RESET}"; return; fi
    local expiry_date=$(grep "^$username:" "$DB_FILE" | cut -d: -f3)
    if passwd -S "$username" 2>/dev/null | grep -q " L "; then echo -e "${C_YELLOW}🔒 Locked${C_RESET}"; return; fi
    local expiry_ts=$(date -d "$expiry_date" +%s 2>/dev/null || echo 0)
    local current_ts=$(date +%s)
    if [[ $expiry_ts -lt $current_ts ]]; then echo -e "${C_RED}🗓️ Expired${C_RESET}"; return; fi
    echo -e "${C_GREEN}🟢 Active${C_RESET}"
}

create_user() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- ✨ Create New SSH User ---${C_RESET}"
    read -p "👉 Enter username (or '0' to cancel): " username
    local adopt_existing=false
    if [[ "$username" == "0" ]]; then
        echo -e "\n${C_YELLOW}❌ User creation cancelled.${C_RESET}"
        return
    fi
    if [[ -z "$username" ]]; then
        echo -e "\n${C_RED}❌ Error: Username cannot be empty.${C_RESET}"
        return
    fi
    if db_has_user "$username"; then
        echo -e "\n${C_RED}❌ Error: User '$username' already exists in Mohammad Ahmad VPN Manager.${C_RESET}"
        return
    fi
    if id "$username" &>/dev/null; then
        if is_firewallfalcon_orphan_user "$username"; then
            echo -e "\n${C_YELLOW}⚠️ User '$username' already exists on the system but is missing from users.db.${C_RESET}"
            echo -e "${C_DIM}This usually happens after uninstalling the script without deleting the SSH users.${C_RESET}"
            read -p "👉 Do you want to take control of this existing user and manage it with Mohammad Ahmad VPN Manager? (y/n): " adopt_confirm
            if [[ "$adopt_confirm" == "y" || "$adopt_confirm" == "Y" ]]; then
                adopt_existing=true
            else
                echo -e "\n${C_YELLOW}❌ User creation cancelled.${C_RESET}"
                return
            fi
        else
            echo -e "\n${C_RED}❌ Error: System user '$username' already exists and does not look like a Mohammad Ahmad VPN Manager SSH account.${C_RESET}"
            return
        fi
    fi
    local password=""
    while true; do
        read -p "🔑 Enter password (or press Enter for auto-generated): " password
        if [[ -z "$password" ]]; then
            password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
            echo -e "${C_GREEN}🔑 Auto-generated password: ${C_YELLOW}$password${C_RESET}"
            break
        else
            break
        fi
    done
    read -p "🗓️ Enter account duration (in days) [30]: " days
    days=${days:-30}
    if ! [[ "$days" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    read -p "📶 Enter simultaneous connection limit [1]: " limit
    limit=${limit:-1}
    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    read -p "📦 Enter bandwidth limit in GB (0 = unlimited) [0]: " bandwidth_gb
    bandwidth_gb=${bandwidth_gb:-0}
    if ! [[ "$bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    read -p "📦 Enter DAILY bandwidth limit in GB (0 = unlimited) [0]: " daily_bandwidth_gb
    daily_bandwidth_gb=${daily_bandwidth_gb:-0}
    if ! [[ "$daily_bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    local expire_date
    expire_date=$(date -d "+$days days" +%Y-%m-%d)
    ensure_firewallfalcon_system_group
    if [[ "$adopt_existing" == "true" ]]; then
        usermod -s /usr/sbin/nologin "$username" &>/dev/null
    else
        useradd -m -s /usr/sbin/nologin "$username"
    fi
    usermod -aG "$FF_USERS_GROUP" "$username" 2>/dev/null
    echo "$username:$password" | chpasswd; chage -E "$expire_date" "$username"
    echo "$username:$password:$expire_date:$limit:$bandwidth_gb:$daily_bandwidth_gb:trial" >> "$DB_FILE"
    
    local bw_display="Unlimited"
    if [[ "$bandwidth_gb" != "0" ]]; then bw_display="${bandwidth_gb} GB"; fi
    local daily_bw_display="Unlimited"
    if [[ "$daily_bandwidth_gb" != "0" ]]; then daily_bw_display="${daily_bandwidth_gb} GB/day"; fi
    
    clear; show_banner
    if [[ "$adopt_existing" == "true" ]]; then
        echo -e "${C_GREEN}✅ Existing system user '$username' has been imported into Mohammad Ahmad VPN Manager!${C_RESET}\n"
    else
        echo -e "${C_GREEN}✅ User '$username' created successfully!${C_RESET}\n"
    fi
    echo -e "  - 👤 Username:          ${C_YELLOW}$username${C_RESET}"
    echo -e "  - 🔑 Password:          ${C_YELLOW}$password${C_RESET}"
    echo -e "  - 🗓️ Expires on:        ${C_YELLOW}$expire_date${C_RESET}"
    echo -e "  - 📶 Connection Limit:  ${C_YELLOW}$limit${C_RESET}"
    echo -e "  - 📦 Total Bandwidth:   ${C_YELLOW}$bw_display${C_RESET}"
    echo -e "  - 📦 Daily Bandwidth:   ${C_YELLOW}$daily_bw_display${C_RESET}"
    echo -e "    ${C_DIM}(Active monitoring service will enforce these limits)${C_RESET}"

    # Auto-ask for config generation
    echo
    read -p "👉 Do you want to generate a client connection config for this user? (y/n): " gen_conf
    if [[ "$gen_conf" == "y" || "$gen_conf" == "Y" ]]; then
        generate_client_config "$username" "$password"
    fi
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

delete_user() {
    _select_multi_user_interface "--- 🗑️ Delete Mohammad Ahmad VPN Manager Users ---" "true"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi
    
    echo -e "\n${C_RED}⚠️ You selected ${#SELECTED_USERS[@]} user(s) to delete: ${C_YELLOW}${SELECTED_USERS[*]}${C_RESET}"
    read -p "👉 Are you sure you want to PERMANENTLY delete them? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then echo -e "\n${C_YELLOW}❌ Deletion cancelled.${C_RESET}"; return; fi
    
    echo -e "\n${C_BLUE}🗑️ Deleting selected users...${C_RESET}"
    delete_firewallfalcon_user_accounts "${SELECTED_USERS[@]}"
}

edit_user() {
    _select_user_interface "--- ✏️ Edit a User ---"
    local username=$SELECTED_USER
    if [[ "$username" == "NO_USERS" ]] || [[ -z "$username" ]]; then return; fi
    while true; do
        clear; show_banner; echo -e "${C_BOLD}${C_PURPLE}--- Editing User: ${C_YELLOW}$username${C_PURPLE} ---${C_RESET}"
        
        # Show current user details
        local current_line; current_line=$(grep "^$username:" "$DB_FILE")
        local cur_pass cur_expiry cur_limit cur_bw cur_daily_bw
        IFS=: read -r _ cur_pass cur_expiry cur_limit cur_bw cur_daily_bw _ <<< "$current_line"
        [[ -z "$cur_bw" ]] && cur_bw="0"
        [[ ! "$cur_daily_bw" =~ ^[0-9]+\.?[0-9]*$ ]] && cur_daily_bw="0"
        
        local cur_bw_display="Unlimited"; [[ "$cur_bw" != "0" ]] && cur_bw_display="${cur_bw} GB"
        local cur_daily_bw_display="Unlimited"; [[ "$cur_daily_bw" != "0" ]] && cur_daily_bw_display="${cur_daily_bw} GB/day"
        
        # Show bandwidth usage
        local bw_used_display="N/A"
        if [[ -f "$BANDWIDTH_DIR/${username}.usage" ]]; then
            local used_bytes=0; read -r used_bytes < "$BANDWIDTH_DIR/${username}.usage" 2>/dev/null || used_bytes=0
            if [[ -n "$used_bytes" && "$used_bytes" != "0" ]]; then
                bw_used_display=$(awk "BEGIN {printf \"%.2f GB\", $used_bytes / 1073741824}")
            else
                bw_used_display="0.00 GB"
            fi
        fi
        
        local daily_bw_used_display="N/A"
        if [[ -f "$BANDWIDTH_DIR/${username}.daily_usage" ]]; then
            local d_used_bytes=0; read -r d_used_bytes < "$BANDWIDTH_DIR/${username}.daily_usage" 2>/dev/null || d_used_bytes=0
            if [[ -n "$d_used_bytes" && "$d_used_bytes" != "0" ]]; then
                daily_bw_used_display=$(awk "BEGIN {printf \"%.2f GB\", $d_used_bytes / 1073741824}")
            else
                daily_bw_used_display="0.00 GB"
            fi
        fi
        
        echo -e "\n  ${C_DIM}Current: Pass=${C_YELLOW}$cur_pass${C_RESET}${C_DIM} Exp=${C_YELLOW}$cur_expiry${C_RESET}${C_DIM} Conn=${C_YELLOW}$cur_limit${C_RESET}${C_DIM} BW=${C_YELLOW}$cur_bw_display${C_RESET}${C_DIM} Used=${C_CYAN}$bw_used_display${C_RESET}${C_DIM} Daily BW=${C_YELLOW}$cur_daily_bw_display${C_RESET}${C_DIM} Daily Used=${C_CYAN}$daily_bw_used_display${C_RESET}"
        echo -e "\nSelect a detail to edit:\n"
        printf "  ${C_GREEN}[ 1]${C_RESET} %-35s\n" "🔑 Change Password"
        printf "  ${C_GREEN}[ 2]${C_RESET} %-35s\n" "🗓️ Change Expiration Date"
        printf "  ${C_GREEN}[ 3]${C_RESET} %-35s\n" "📶 Change Connection Limit"
        printf "  ${C_GREEN}[ 4]${C_RESET} %-35s\n" "📦 Change Total Bandwidth Limit"
        printf "  ${C_GREEN}[ 5]${C_RESET} %-35s\n" "📦 Change Daily Bandwidth Limit"
        printf "  ${C_GREEN}[ 6]${C_RESET} %-35s\n" "🔄 Reset Bandwidth Counters"
        echo -e "\n  ${C_RED}[ 0]${C_RESET} ✅ Finish Editing"
        echo
        if ! read -r -p "👉 Enter your choice: " edit_choice; then
            echo
            return
        fi
        case $edit_choice in
            1)
               local new_pass=""
               read -p "Enter new password (or press Enter for auto-generated): " new_pass
               if [[ -z "$new_pass" ]]; then
                   new_pass=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
                   echo -e "${C_GREEN}🔑 Auto-generated: ${C_YELLOW}$new_pass${C_RESET}"
               fi
               echo "$username:$new_pass" | chpasswd
               sed -i "s/^$username:.*/$username:$new_pass:$cur_expiry:$cur_limit:$cur_bw:$cur_daily_bw/" "$DB_FILE"
               echo -e "\n${C_GREEN}✅ Password for '$username' changed to: ${C_YELLOW}$new_pass${C_RESET}"
               ;;
            2) read -p "Enter new duration (in days from today): " days
               if [[ "$days" =~ ^[0-9]+$ ]]; then
                   local new_expire_date; new_expire_date=$(date -d "+$days days" +%Y-%m-%d); chage -E "$new_expire_date" "$username"
                   sed -i "s/^$username:.*/$username:$cur_pass:$new_expire_date:$cur_limit:$cur_bw:$cur_daily_bw/" "$DB_FILE"
                   echo -e "\n${C_GREEN}✅ Expiration for '$username' set to ${C_YELLOW}$new_expire_date${C_RESET}."
               else echo -e "\n${C_RED}❌ Invalid number of days.${C_RESET}"; fi ;;
            3) read -p "Enter new simultaneous connection limit: " new_limit
               if [[ "$new_limit" =~ ^[0-9]+$ ]]; then
                   sed -i "s/^$username:.*/$username:$cur_pass:$cur_expiry:$new_limit:$cur_bw:$cur_daily_bw/" "$DB_FILE"
                   echo -e "\n${C_GREEN}✅ Connection limit for '$username' set to ${C_YELLOW}$new_limit${C_RESET}."
               else echo -e "\n${C_RED}❌ Invalid limit.${C_RESET}"; fi ;;
            4) read -p "Enter new TOTAL bandwidth limit in GB (0 = unlimited): " new_bw
               if [[ "$new_bw" =~ ^[0-9]+\.?[0-9]*$ ]]; then
                   sed -i "s/^$username:.*/$username:$cur_pass:$cur_expiry:$cur_limit:$new_bw:$cur_daily_bw/" "$DB_FILE"
                   local bw_msg="Unlimited"; [[ "$new_bw" != "0" ]] && bw_msg="${new_bw} GB"
                   echo -e "\n${C_GREEN}✅ Total bandwidth limit for '$username' set to ${C_YELLOW}$bw_msg${C_RESET}."
                   # Unlock user if they were locked due to bandwidth
                   if [[ "$new_bw" == "0" ]] || [[ -f "$BANDWIDTH_DIR/${username}.usage" ]]; then
                       local used_bytes; used_bytes=$(cat "$BANDWIDTH_DIR/${username}.usage" 2>/dev/null || echo 0)
                       local new_quota_bytes; new_quota_bytes=$(awk "BEGIN {printf \"%.0f\", $new_bw * 1073741824}")
                       if [[ "$new_bw" == "0" ]] || [[ "$used_bytes" -lt "$new_quota_bytes" ]]; then
                           usermod -U "$username" &>/dev/null
                       fi
                   fi
               else echo -e "\n${C_RED}❌ Invalid bandwidth value.${C_RESET}"; fi ;;
            5) read -p "Enter new DAILY bandwidth limit in GB (0 = unlimited): " new_daily_bw
               if [[ "$new_daily_bw" =~ ^[0-9]+\.?[0-9]*$ ]]; then
                   sed -i "s/^$username:.*/$username:$cur_pass:$cur_expiry:$cur_limit:$cur_bw:$new_daily_bw/" "$DB_FILE"
                   local daily_bw_msg="Unlimited"; [[ "$new_daily_bw" != "0" ]] && daily_bw_msg="${new_daily_bw} GB/day"
                   echo -e "\n${C_GREEN}✅ Daily bandwidth limit for '$username' set to ${C_YELLOW}$daily_bw_msg${C_RESET}."
                   # Unlock user if they were locked due to daily bandwidth
                   if [[ "$new_daily_bw" == "0" ]] || [[ -f "$BANDWIDTH_DIR/${username}.daily_usage" ]]; then
                       local d_used_bytes; d_used_bytes=$(cat "$BANDWIDTH_DIR/${username}.daily_usage" 2>/dev/null || echo 0)
                       local new_d_quota_bytes; new_d_quota_bytes=$(awk "BEGIN {printf \"%.0f\", $new_daily_bw * 1073741824}")
                       if [[ "$new_daily_bw" == "0" ]] || [[ "$d_used_bytes" -lt "$new_d_quota_bytes" ]]; then
                           usermod -U "$username" &>/dev/null
                           rm -f "$BANDWIDTH_DIR/${username}.daily_locked"
                       fi
                   fi
               else echo -e "\n${C_RED}❌ Invalid bandwidth value.${C_RESET}"; fi ;;
            6)
               echo "0" > "$BANDWIDTH_DIR/${username}.usage"
               echo "0" > "$BANDWIDTH_DIR/${username}.daily_usage"
               rm -f "$BANDWIDTH_DIR/${username}.daily_locked"
               # Unlock user if they were locked due to bandwidth
               usermod -U "$username" &>/dev/null
               echo -e "\n${C_GREEN}✅ All bandwidth counters for '$username' have been reset to 0.${C_RESET}"
               ;;
            0) return ;;
            *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" ;;
        esac
        echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to continue editing..." && read -r || return
    done
}

lock_user() {
    _select_multi_user_interface "--- 🔒 Lock Users (from DB) ---"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi
    
    echo -e "\n${C_BLUE}🔒 Locking selected users...${C_RESET}"
    for u in "${SELECTED_USERS[@]}"; do
        if ! id "$u" &>/dev/null; then
             echo -e " ❌ User '${C_YELLOW}$u${C_RESET}' does not exist on this system."
             continue
        fi
        
        usermod -L "$u"
        if [ $? -eq 0 ]; then
            killall -u "$u" -9 &>/dev/null
            echo -e " ✅ ${C_YELLOW}$u${C_RESET} locked and active sessions killed."
        else
            echo -e " ❌ Failed to lock ${C_YELLOW}$u${C_RESET}."
        fi
    done
}

unlock_user() {
    _select_multi_user_interface "--- 🔓 Unlock Users (from DB) ---"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi
    
    echo -e "\n${C_BLUE}🔓 Unlocking selected users...${C_RESET}"
    for u in "${SELECTED_USERS[@]}"; do
        if ! id "$u" &>/dev/null; then
             echo -e " ❌ User '${C_YELLOW}$u${C_RESET}' does not exist on this system."
             continue
        fi
        
        usermod -U "$u"
        if [ $? -eq 0 ]; then
            echo -e " ✅ ${C_YELLOW}$u${C_RESET} unlocked."
        else
            echo -e " ❌ Failed to unlock ${C_YELLOW}$u${C_RESET}."
        fi
    done
}

list_users() {
    clear; show_banner
    if [[ ! -s "$DB_FILE" ]]; then
        echo -e "\n${C_YELLOW}ℹ️ No users are currently being managed.${C_RESET}"
        return
    fi
    echo -e "${C_BOLD}${C_PURPLE}--- 📋 Managed Users ---${C_RESET}"
    echo -e "${C_YELLOW}---------------------------------------------------------------------------------------------------${C_RESET}"
    printf "${C_BOLD}${C_WHITE}%-18s | %-12s | %-10s | %-25s | %-20s${C_RESET}\n" "USERNAME" "EXPIRATION" "SESSIONS" "BANDWIDTH" "STATUS"
    echo -e "${C_YELLOW}---------------------------------------------------------------------------------------------------${C_RESET}"

    local current_ts
    printf -v current_ts '%(%s)T' -1
    local -A system_user_lookup=()
    local -A locked_user_lookup=()

    while IFS=: read -r system_user _rest; do
        [[ -n "$system_user" ]] && system_user_lookup["$system_user"]=1
    done < /etc/passwd

    if [[ -r /etc/shadow ]]; then
        while IFS=: read -r shadow_user shadow_hash _rest; do
            [[ -n "$shadow_user" && "${shadow_hash:0:1}" == "!" ]] && locked_user_lookup["$shadow_user"]=1
        done < /etc/shadow
    else
        while read -r passwd_user _ passwd_status _rest; do
            [[ -z "$passwd_user" ]] && continue
            [[ "$passwd_status" == "L" ]] && locked_user_lookup["$passwd_user"]=1
        done < <(passwd -Sa 2>/dev/null)
    fi
    refresh_ssh_session_cache

    while IFS=: read -r user pass expiry limit bandwidth_gb daily_bandwidth_gb _extra; do
        local online_count="${SSH_SESSION_COUNTS[$user]:-0}"
        local connection_string="$online_count / $limit"
        local plain_status="Active"
        local status="${C_GREEN}🟢 Active${C_RESET}"
        local quota_exceeded=false

        [[ -z "$bandwidth_gb" ]] && bandwidth_gb="0"
        [[ ! "$daily_bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]] && daily_bandwidth_gb="0"
        
        local bw_string="Unlimited"
        local total_str=""
        local daily_str=""
        
        if [[ "$bandwidth_gb" != "0" ]]; then
            local used_bytes=0
            if [[ -f "$BANDWIDTH_DIR/${user}.usage" ]]; then
                read -r used_bytes < "$BANDWIDTH_DIR/${user}.usage" 2>/dev/null || used_bytes=0
                [[ "$used_bytes" =~ ^[0-9]+$ ]] || used_bytes=0
            fi
            local used_gb
            used_gb=$(awk "BEGIN {printf \"%.1f\", $used_bytes / 1073741824}")
            total_str="${used_gb}/${bandwidth_gb}G"
            local quota_bytes
            quota_bytes=$(awk "BEGIN {printf \"%.0f\", $bandwidth_gb * 1073741824}")
            if [[ "$quota_bytes" =~ ^[0-9]+$ ]] && (( used_bytes >= quota_bytes )); then
                quota_exceeded=true
            fi
        fi
        
        if [[ "$daily_bandwidth_gb" != "0" ]]; then
            local d_used_bytes=0
            if [[ -f "$BANDWIDTH_DIR/${user}.daily_usage" ]]; then
                read -r d_used_bytes < "$BANDWIDTH_DIR/${user}.daily_usage" 2>/dev/null || d_used_bytes=0
                [[ "$d_used_bytes" =~ ^[0-9]+$ ]] || d_used_bytes=0
            fi
            local d_used_gb
            d_used_gb=$(awk "BEGIN {printf \"%.1f\", $d_used_bytes / 1073741824}")
            daily_str="${d_used_gb}/${daily_bandwidth_gb}G/d"
            local d_quota_bytes
            d_quota_bytes=$(awk "BEGIN {printf \"%.0f\", $daily_bandwidth_gb * 1073741824}")
            if [[ "$d_quota_bytes" =~ ^[0-9]+$ ]] && (( d_used_bytes >= d_quota_bytes )); then
                quota_exceeded=true
            fi
        fi
        
        if [[ -n "$total_str" && -n "$daily_str" ]]; then
            bw_string="$total_str | $daily_str"
        elif [[ -n "$total_str" ]]; then
            bw_string="$total_str"
        elif [[ -n "$daily_str" ]]; then
            bw_string="$daily_str"
        fi

        if [[ -z "${system_user_lookup[$user]+x}" ]]; then
            plain_status="Not Found"
            status="${C_RED}Not Found${C_RESET}"
        elif [[ -n "$expiry" && "$expiry" != "Never" ]]; then
            local expiry_ts
            expiry_ts=$(date -d "$expiry" +%s 2>/dev/null || echo 0)
            if [[ "$expiry_ts" =~ ^[0-9]+$ ]] && (( expiry_ts > 0 && expiry_ts < current_ts )); then
                plain_status="Expired"
                status="${C_RED}🗓️ Expired${C_RESET}"
            fi
        fi

        if [[ "$plain_status" == "Active" && "$quota_exceeded" == true ]]; then
            if [[ -n "${locked_user_lookup[$user]+x}" ]]; then
                plain_status="BW Locked"
                status="${C_RED}🔒 BW Locked${C_RESET}"
            else
                plain_status="Quota Exceeded"
                status="${C_RED}📦 Quota Exceeded${C_RESET}"
            fi
        elif [[ "$plain_status" == "Active" && -n "${locked_user_lookup[$user]+x}" ]]; then
            plain_status="Locked"
            status="${C_YELLOW}🔒 Locked${C_RESET}"
        fi

        local line_color="$C_WHITE"
        case "$plain_status" in
            "Active") line_color="$C_GREEN" ;;
            "Locked") line_color="$C_YELLOW" ;;
            "Expired") line_color="$C_RED" ;;
            "BW Locked") line_color="$C_RED" ;;
            "Quota Exceeded") line_color="$C_RED" ;;
            "Not Found") line_color="$C_DIM" ;;
        esac

        printf "${line_color}%-18s ${C_RESET}| ${C_YELLOW}%-12s ${C_RESET}| ${C_CYAN}%-10s ${C_RESET}| ${C_ORANGE}%-25s ${C_RESET}| %-20s\n" "$user" "$expiry" "$connection_string" "$bw_string" "$status"
    done < <(sort "$DB_FILE")
    echo -e "${C_CYAN}=========================================================================================${C_RESET}\n"
}

renew_user() {
    _select_multi_user_interface "--- 🔄 Renew Users ---"
    if [[ ${#SELECTED_USERS[@]} -eq 0 || "${SELECTED_USERS[0]}" == "NO_USERS" ]]; then return; fi
    read -p "👉 Enter number of days to extend the account(s): " days; if ! [[ "$days" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    local new_expire_date; new_expire_date=$(date -d "+$days days" +%Y-%m-%d)
    
    echo -e "\n${C_BLUE}🔄 Renewing selected users for $days days...${C_RESET}"
    for u in "${SELECTED_USERS[@]}"; do
        chage -E "$new_expire_date" "$u"
        local line pass _expiry limit bw
        line=$(grep "^$u:" "$DB_FILE")
        IFS=: read -r _ pass _expiry limit bw _ <<< "$line"
        [[ -z "$bw" ]] && bw="0"
        sed -i "s/^$u:.*/$u:$pass:$new_expire_date:$limit:$bw/" "$DB_FILE"
        echo -e " ✅ ${C_YELLOW}$u${C_RESET} renewed until ${C_GREEN}${new_expire_date}${C_RESET}."
    done
}

cleanup_expired() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🧹 Cleanup Expired Users ---${C_RESET}"
    
    local expired_users=()
    local current_ts
    current_ts=$(date +%s)

    if [[ ! -s "$DB_FILE" ]]; then
        echo -e "\n${C_GREEN}✅ User database is empty. No expired users found.${C_RESET}"
        return
    fi
    
    while IFS=: read -r user pass expiry limit bandwidth_gb _extra; do
        local expiry_ts
        expiry_ts=$(date -d "$expiry" +%s 2>/dev/null || echo 0)
        
        if [[ $expiry_ts -lt $current_ts && $expiry_ts -ne 0 ]]; then
            expired_users+=("$user")
        fi
    done < "$DB_FILE"

    if [ ${#expired_users[@]} -eq 0 ]; then
        echo -e "\n${C_GREEN}✅ No expired users found.${C_RESET}"
        return
    fi

    echo -e "\nThe following users have expired: ${C_RED}${expired_users[*]}${C_RESET}"
    read -p "👉 Do you want to delete all of them? (y/n): " confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo -e "\n${C_BLUE}🗑️ Deleting expired users...${C_RESET}"
        delete_firewallfalcon_user_accounts "${expired_users[@]}"
        echo -e "\n${C_GREEN}✅ Expired users have been cleaned up.${C_RESET}"
    else
        echo -e "\n${C_YELLOW}❌ Cleanup cancelled.${C_RESET}"
    fi
}


backup_user_data() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 💾 Backup User Data ---${C_RESET}"
    read -p "👉 Enter path for backup file [/root/firewallfalcon_users.tar.gz]: " backup_path
    backup_path=${backup_path:-/root/firewallfalcon_users.tar.gz}
    if [ ! -d "$DB_DIR" ] || [ ! -s "$DB_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ No user data found to back up.${C_RESET}"
        return
    fi
    echo -e "\n${C_BLUE}⚙️ Backing up user database and settings to ${C_YELLOW}$backup_path${C_RESET}..."
    tar -czf "$backup_path" -C "$(dirname "$DB_DIR")" "$(basename "$DB_DIR")"
    if [ $? -eq 0 ]; then
        echo -e "\n${C_GREEN}✅ SUCCESS: User data backup created at ${C_YELLOW}$backup_path${C_RESET}"
    else
        echo -e "\n${C_RED}❌ ERROR: Backup failed.${C_RESET}"
    fi
}

restore_user_data() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📥 Restore User Data ---${C_RESET}"
    read -p "👉 Enter the full path to the user data backup file [/root/firewallfalcon_users.tar.gz]: " backup_path
    backup_path=${backup_path:-/root/firewallfalcon_users.tar.gz}
    if [ ! -f "$backup_path" ]; then
        echo -e "\n${C_RED}❌ ERROR: Backup file not found at '$backup_path'.${C_RESET}"
        return
    fi
    echo -e "\n${C_RED}${C_BOLD}⚠️ WARNING:${C_RESET} This will overwrite all current users and settings."
    echo -e "It will restore user accounts, passwords, limits, and expiration dates from the backup file."
    read -p "👉 Are you absolutely sure you want to proceed? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then echo -e "\n${C_YELLOW}❌ Restore cancelled.${C_RESET}"; return; fi
    local temp_dir
    temp_dir=$(mktemp -d)
    echo -e "\n${C_BLUE}⚙️ Extracting backup file to a temporary location...${C_RESET}"
    tar -xzf "$backup_path" -C "$temp_dir"
    if [ $? -ne 0 ]; then
        echo -e "\n${C_RED}❌ ERROR: Failed to extract backup file. Aborting.${C_RESET}"
        rm -rf "$temp_dir"
        return
    fi
    local restored_db_file="$temp_dir/firewallfalcon/users.db"
    if [ ! -f "$restored_db_file" ]; then
        echo -e "\n${C_RED}❌ ERROR: users.db not found in the backup. Cannot restore user accounts.${C_RESET}"
        rm -rf "$temp_dir"
        return
    fi
    echo -e "${C_BLUE}⚙️ Overwriting current user database...${C_RESET}"
    mkdir -p "$DB_DIR"
    cp "$restored_db_file" "$DB_FILE"
    if [ -d "$temp_dir/firewallfalcon/ssl" ]; then
        cp -r "$temp_dir/firewallfalcon/ssl" "$DB_DIR/"
    fi
    if [ -d "$temp_dir/firewallfalcon/dnstt" ]; then
        cp -r "$temp_dir/firewallfalcon/dnstt" "$DB_DIR/"
    fi
    if [ -f "$temp_dir/firewallfalcon/dns_info.conf" ]; then
        cp "$temp_dir/firewallfalcon/dns_info.conf" "$DB_DIR/"
    fi
    if [ -f "$temp_dir/firewallfalcon/dnstt_info.conf" ]; then
        cp "$temp_dir/firewallfalcon/dnstt_info.conf" "$DB_DIR/"
    fi
    if [ -f "$temp_dir/firewallfalcon/falconproxy_config.conf" ]; then
        cp "$temp_dir/firewallfalcon/falconproxy_config.conf" "$DB_DIR/"
    fi
    
    echo -e "${C_BLUE}⚙️ Re-synchronizing system accounts with the restored database...${C_RESET}"
    ensure_firewallfalcon_system_group
    
    while IFS=: read -r user pass expiry limit; do
        echo "Processing user: ${C_YELLOW}$user${C_RESET}"
        if ! id "$user" &>/dev/null; then
            echo " - User does not exist in system. Creating..."
            useradd -m -s /usr/sbin/nologin "$user"
        fi
        usermod -aG "$FF_USERS_GROUP" "$user" 2>/dev/null
        echo " - Setting password..."
        echo "$user:$pass" | chpasswd
        echo " - Setting expiration to $expiry..."
        chage -E "$expiry" "$user"
        echo " - Connection limit is $limit (enforced by PAM)"
    done < "$DB_FILE"
    rm -rf "$temp_dir"
    echo -e "\n${C_GREEN}✅ SUCCESS: User data restore completed.${C_RESET}"
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

_enable_banner_in_sshd_config() {
    echo -e "\n${C_BLUE}⚙️ Configuring sshd_config...${C_RESET}"
    disable_dynamic_ssh_banner_system
    sed -i.bak -E 's/^( *Banner *).*/#\1/' /etc/ssh/sshd_config
    if ! grep -q -E "^Banner $SSH_BANNER_FILE" /etc/ssh/sshd_config; then
        echo -e "\n# Mohammad Ahmad VPN Manager SSH Banner\nBanner $SSH_BANNER_FILE" >> /etc/ssh/sshd_config
    fi
    echo -e "${C_GREEN}✅ sshd_config updated.${C_RESET}"
}

_restart_ssh() {
    echo -e "\n${C_BLUE}🔄 Restarting SSH service to apply changes...${C_RESET}"
    local ssh_service_name=""
    if [ -f /lib/systemd/system/sshd.service ]; then
        ssh_service_name="sshd.service"
    elif [ -f /lib/systemd/system/ssh.service ]; then
        ssh_service_name="ssh.service"
    else
        echo -e "${C_RED}❌ Could not find sshd.service or ssh.service. Cannot restart SSH.${C_RESET}"
        return 1
    fi

    systemctl restart "${ssh_service_name}"
    if [ $? -eq 0 ]; then
        echo -e "${C_GREEN}✅ SSH service ('${ssh_service_name}') restarted successfully.${C_RESET}"
    else
        echo -e "${C_RED}❌ Failed to restart SSH service ('${ssh_service_name}'). Please check 'journalctl -u ${ssh_service_name}' for errors.${C_RESET}"
    fi
}

set_ssh_banner_paste() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📋 Paste Static SSH Banner ---${C_RESET}"
    echo -e "Paste your custom banner below. Press ${C_YELLOW}[Ctrl+D]${C_RESET} when you are finished."
    echo -e "${C_DIM}This will be shown to all SSH users through 'Banner $SSH_BANNER_FILE'.${C_RESET}"
    echo -e "${C_DIM}The current banner (if any) will be overwritten.${C_RESET}"
    echo -e "--------------------------------------------------"
    cat > "$SSH_BANNER_FILE"
    chmod 644 "$SSH_BANNER_FILE"
    echo -e "\n--------------------------------------------------"
    echo -e "\n${C_GREEN}✅ Static banner content saved.${C_RESET}"
    _enable_banner_in_sshd_config
    _restart_ssh
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

view_ssh_banner() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 👁️ Current SSH Banner ---${C_RESET}"
    if [ -f "$SSH_BANNER_FILE" ]; then
        echo -e "\n${C_CYAN}--- BEGIN BANNER ---${C_RESET}"
        cat "$SSH_BANNER_FILE"
        echo -e "${C_CYAN}---- END BANNER ----${C_RESET}"
    else
        echo -e "\n${C_YELLOW}ℹ️ No banner file found at $SSH_BANNER_FILE.${C_RESET}"
    fi
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

remove_ssh_banner() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🗑️ Disable SSH Banners ---${C_RESET}"
    read -p "👉 Are you sure you want to disable all SSH banners? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        echo -e "\n${C_YELLOW}❌ Action cancelled.${C_RESET}"
        echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
        return
    fi
    if [ -f "$SSH_BANNER_FILE" ]; then
        rm -f "$SSH_BANNER_FILE"
        echo -e "\n${C_GREEN}✅ Removed banner file: $SSH_BANNER_FILE${C_RESET}"
    else
        echo -e "\n${C_YELLOW}ℹ️ No banner file to remove.${C_RESET}"
    fi
    disable_dynamic_ssh_banner_system
    echo -e "\n${C_BLUE}⚙️ Disabling banner in sshd_config...${C_RESET}"
    disable_static_ssh_banner_in_sshd_config
    echo -e "${C_GREEN}✅ Banner disabled in configuration.${C_RESET}"
    _restart_ssh
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return..." && read -r
}

preview_dynamic_ssh_banner() {
    if ! is_dynamic_ssh_banner_enabled; then
        echo -e "\n${C_RED}❌ Dynamic banners are not enabled right now.${C_RESET}"
        press_enter
        return
    fi

    echo -e "${C_DIM}Refreshing dynamic banner worker...${C_RESET}"
    setup_limiter_service >/dev/null 2>&1
    _select_user_interface "--- 📝 Preview Dynamic Banner ---"
    local u=$SELECTED_USER
    if [[ -z "$u" || "$u" == "NO_USERS" ]]; then
        return
    fi

    echo -e "\n${C_CYAN}--- Dynamic Banner Preview for user '$u' ---${C_RESET}\n"
    if [[ -f "/etc/firewallfalcon/banners/${u}.txt" ]]; then
        cat "/etc/firewallfalcon/banners/${u}.txt"
    else
        echo -e "${C_RED}Banner file not generated yet. Waiting up to 10s for the worker...${C_RESET}"
        sleep 5
        if ! cat "/etc/firewallfalcon/banners/${u}.txt" 2>/dev/null; then
            echo -e "\n${C_RED}Still not generated. Here are the last limiter logs:${C_RESET}"
            echo -e "----------------------------------------------------------------------"
            journalctl -u firewallfalcon-limiter -n 15 --no-pager
            echo -e "----------------------------------------------------------------------"
        fi
    fi
    press_enter
}

# NOTE: The full ssh_banner_menu() with dynamic/static support is defined later in the file.

install_udp_custom() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing udp-custom ---${C_RESET}"
    if [ -f "$UDP_CUSTOM_SERVICE_FILE" ] || [ -f "$UDPGW_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ udp-custom is already installed.${C_RESET}"
        return
    fi

    check_and_free_ports 36712 7800 || return
    check_and_open_firewall_port 36712 udp || return

    echo -e "\n${C_GREEN}⚙️ Creating directory for udp-custom...${C_RESET}"
    rm -rf "$UDP_CUSTOM_DIR"
    mkdir -p "$UDP_CUSTOM_DIR"

    echo -e "\n${C_GREEN}⚙️ Detecting system architecture...${C_RESET}"
    local arch
    arch=$(uname -m)
    local binary_url=""
    if [[ "$arch" == "x86_64" ]]; then
        binary_url="https://raw.githubusercontent.com/FirewallFalconsLabs/FirewallFalcon-Manager/main/udp/udp-custom-linux-amd64"
        echo -e "${C_BLUE}ℹ️ Detected x86_64 (amd64) architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        binary_url="https://raw.githubusercontent.com/FirewallFalconsLabs/FirewallFalcon-Manager/main/udp/udp-custom-linux-arm"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Unsupported architecture: $arch. Cannot install udp-custom.${C_RESET}"
        rm -rf "$UDP_CUSTOM_DIR"
        return
    fi

    echo -e "\n${C_GREEN}📥 Downloading udp-custom binary...${C_RESET}"
    wget -q --show-progress -O "$UDP_CUSTOM_DIR/udp-custom" "$binary_url"
    if [ $? -ne 0 ]; then
        echo -e "\n${C_RED}❌ Failed to download the udp-custom binary.${C_RESET}"
        rm -rf "$UDP_CUSTOM_DIR"
        return
    fi
    chmod +x "$UDP_CUSTOM_DIR/udp-custom"

    echo -e "\n${C_GREEN}📦 Setting up udpgw helper...${C_RESET}"
    if [[ "$arch" == "x86_64" ]]; then
        wget -q --show-progress -O "$UDPGW_BINARY" "https://raw.githubusercontent.com/http-custom/udp-custom/main/module/udpgw"
        if [ $? -ne 0 ]; then
            echo -e "\n${C_RED}❌ Failed to download the udpgw helper binary.${C_RESET}"
            rm -rf "$UDP_CUSTOM_DIR"
            return
        fi
        chmod +x "$UDPGW_BINARY"
    else
        echo -e "${C_YELLOW}ℹ️ Architecture is $arch. Compiling udpgw from source (this may take a minute)...${C_RESET}"
        ff_pkg_install cmake g++ make git >/dev/null 2>&1
        local temp_build="/tmp/badvpn_build"
        rm -rf "$temp_build"
        git clone -q https://github.com/ambrop72/badvpn.git "$temp_build"
        (cd "$temp_build" && cmake . >/dev/null 2>&1 && make >/dev/null 2>&1)
        local compiled_bin=$(find "$temp_build" -name "badvpn-udpgw" -type f | head -n 1)
        if [[ -n "$compiled_bin" && -f "$compiled_bin" ]]; then
            cp "$compiled_bin" "$UDPGW_BINARY"
            chmod +x "$UDPGW_BINARY"
        else
            echo -e "\n${C_RED}❌ Failed to compile udpgw helper for $arch.${C_RESET}"
            rm -rf "$UDP_CUSTOM_DIR" "$temp_build"
            return
        fi
        rm -rf "$temp_build"
    fi

    echo -e "\n${C_GREEN}📝 Creating default config.json...${C_RESET}"
    cat > "$UDP_CUSTOM_DIR/config.json" <<EOF
{
  "listen": ":36712",
  "stream_buffer": 33554432,
  "receive_buffer": 83886080,
  "auth": {
    "mode": "passwords"
  }
}
EOF
    chmod 644 "$UDP_CUSTOM_DIR/config.json"

    echo -e "\n${C_GREEN}📝 Creating udpgw systemd service file...${C_RESET}"
    cat > "$UDPGW_SERVICE_FILE" <<EOF
[Unit]
Description=Mohammad Ahmad VPN Manager UDPGW Backend
After=network.target

[Service]
User=root
Type=simple
ExecStart=$UDPGW_BINARY --listen-addr 127.0.0.1:7800 --max-clients 1000 --max-connections-for-client 100
Restart=always
RestartSec=2s

[Install]
WantedBy=multi-user.target
EOF

    echo -e "\n${C_GREEN}📝 Creating systemd service file...${C_RESET}"
    cat > "$UDP_CUSTOM_SERVICE_FILE" <<EOF
[Unit]
Description=UDP Custom by Mohammad Ahmad VPN Manager
After=network.target

[Service]
User=root
Type=simple
ExecStart=$UDP_CUSTOM_DIR/udp-custom server
WorkingDirectory=$UDP_CUSTOM_DIR/
Restart=always
RestartSec=2s

[Install]
WantedBy=multi-user.target
EOF

    echo -e "\n${C_GREEN}▶️ Enabling and starting udp-custom service...${C_RESET}"
    systemctl daemon-reload
    systemctl enable udpgw.service
    systemctl start udpgw.service
    systemctl enable udp-custom.service
    systemctl start udp-custom.service
    sleep 2
    if systemctl is-active --quiet udpgw && systemctl is-active --quiet udp-custom; then
        echo -e "\n${C_GREEN}✅ SUCCESS: udp-custom is installed and active.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ ERROR: udp-custom service failed to start.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Displaying last 15 lines of the udp-custom and udpgw logs for diagnostics:${C_RESET}"
        journalctl -u udp-custom.service -n 15 --no-pager
        journalctl -u udpgw.service -n 15 --no-pager
    fi
}

uninstall_udp_custom() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling udp-custom ---${C_RESET}"
    if [ ! -f "$UDP_CUSTOM_SERVICE_FILE" ] && [ ! -f "$UDPGW_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ udp-custom is not installed, skipping.${C_RESET}"
        return
    fi
    echo -e "${C_GREEN}🛑 Stopping and disabling udpgw service...${C_RESET}"
    systemctl stop udpgw.service >/dev/null 2>&1
    systemctl disable udpgw.service >/dev/null 2>&1
    echo -e "${C_GREEN}🛑 Stopping and disabling udp-custom service...${C_RESET}"
    systemctl stop udp-custom.service >/dev/null 2>&1
    systemctl disable udp-custom.service >/dev/null 2>&1
    echo -e "${C_GREEN}🗑️ Removing systemd service file...${C_RESET}"
    rm -f "$UDP_CUSTOM_SERVICE_FILE"
    rm -f "$UDPGW_SERVICE_FILE"
    systemctl daemon-reload
    echo -e "${C_GREEN}🗑️ Removing udp-custom directory and files...${C_RESET}"
    rm -rf "$UDP_CUSTOM_DIR"
    rm -f "$UDPGW_BINARY"
    echo -e "${C_GREEN}✅ udp-custom has been uninstalled successfully.${C_RESET}"
}


ensure_badvpn_service_is_quiet() {
    if [[ ! -f "$BADVPN_SERVICE_FILE" ]] || grep -q "^StandardOutput=null$" "$BADVPN_SERVICE_FILE" 2>/dev/null; then
        return
    fi

    local tmp_service
    tmp_service=$(mktemp)
    awk '
        /^\[Service\]$/ {
            print
            print "StandardOutput=null"
            print "StandardError=null"
            next
        }
        { print }
    ' "$BADVPN_SERVICE_FILE" > "$tmp_service" && mv "$tmp_service" "$BADVPN_SERVICE_FILE"
    rm -f "$tmp_service" 2>/dev/null
    systemctl daemon-reload
    systemctl restart badvpn.service >/dev/null 2>&1 || true
}

install_badvpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing badvpn (udpgw) ---${C_RESET}"
    if [ -f "$BADVPN_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ badvpn is already installed.${C_RESET}"
        return
    fi
    check_and_open_firewall_port 7300 udp || return
    echo -e "\n${C_GREEN}🔄 Updating package lists...${C_RESET}"
    ff_apt_update || return
    echo -e "\n${C_GREEN}📦 Installing all required packages...${C_RESET}"
    ff_pkg_install cmake g++ make screen git build-essential libssl-dev libnspr4-dev libnss3-dev pkg-config || {
        echo -e "${C_RED}❌ Failed to install badvpn build dependencies.${C_RESET}"
        return
    }
    echo -e "\n${C_GREEN}📥 Cloning badvpn from github...${C_RESET}"
    git clone https://github.com/ambrop72/badvpn.git "$BADVPN_BUILD_DIR"
    cd "$BADVPN_BUILD_DIR" || { echo -e "${C_RED}❌ Failed to change directory to build folder.${C_RESET}"; return; }
    echo -e "\n${C_GREEN}⚙️ Running CMake...${C_RESET}"
    cmake . || { echo -e "${C_RED}❌ CMake configuration failed.${C_RESET}"; rm -rf "$BADVPN_BUILD_DIR"; return; }
    echo -e "\n${C_GREEN}🛠️ Compiling source...${C_RESET}"
    make || { echo -e "${C_RED}❌ Compilation (make) failed.${C_RESET}"; rm -rf "$BADVPN_BUILD_DIR"; return; }
    local badvpn_binary
    badvpn_binary=$(find "$BADVPN_BUILD_DIR" -name "badvpn-udpgw" -type f | head -n 1)
    if [[ -z "$badvpn_binary" || ! -f "$badvpn_binary" ]]; then
        echo -e "${C_RED}❌ ERROR: Could not find the compiled 'badvpn-udpgw' binary after compilation.${C_RESET}"
        rm -rf "$BADVPN_BUILD_DIR"
        return
    fi
    echo -e "${C_GREEN}ℹ️ Found binary at: $badvpn_binary${C_RESET}"
    chmod +x "$badvpn_binary"
    echo -e "\n${C_GREEN}📝 Creating systemd service file...${C_RESET}"
    cat > "$BADVPN_SERVICE_FILE" <<-EOF
[Unit]
Description=BadVPN UDP Gateway
After=network.target
[Service]
ExecStart=$badvpn_binary --listen-addr 0.0.0.0:7300 --max-clients 1000 --max-connections-for-client 8
User=root
Restart=always
RestartSec=3
StandardOutput=null
StandardError=null
[Install]
WantedBy=multi-user.target
EOF
    echo -e "\n${C_GREEN}▶️ Enabling and starting badvpn service...${C_RESET}"
    systemctl daemon-reload
    systemctl enable badvpn.service
    systemctl start badvpn.service
    sleep 2
    if systemctl is-active --quiet badvpn; then
        echo -e "\n${C_GREEN}✅ SUCCESS: badvpn (udpgw) is installed and active on port 7300.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ ERROR: badvpn service failed to start.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Displaying last 15 lines of the service log for diagnostics:${C_RESET}"
        journalctl -u badvpn.service -n 15 --no-pager
    fi
}

uninstall_badvpn() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling badvpn (udpgw) ---${C_RESET}"
    if [ ! -f "$BADVPN_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ badvpn is not installed, skipping.${C_RESET}"
        return
    fi
    echo -e "${C_GREEN}🛑 Stopping and disabling badvpn service...${C_RESET}"
    systemctl stop badvpn.service >/dev/null 2>&1
    systemctl disable badvpn.service >/dev/null 2>&1
    echo -e "${C_GREEN}🗑️ Removing systemd service file...${C_RESET}"
    rm -f "$BADVPN_SERVICE_FILE"
    systemctl daemon-reload
    echo -e "${C_GREEN}🗑️ Removing badvpn build directory...${C_RESET}"
    rm -rf "$BADVPN_BUILD_DIR"
    echo -e "${C_GREEN}✅ badvpn has been uninstalled successfully.${C_RESET}"
}

load_edge_cert_info() {
    EDGE_CERT_MODE=""
    EDGE_DOMAIN=""
    EDGE_EMAIL=""
    if [ -f "$EDGE_CERT_INFO_FILE" ]; then
        source "$EDGE_CERT_INFO_FILE"
    fi
}

save_edge_cert_info() {
    local cert_mode="$1"
    local cert_domain="$2"
    local cert_email="$3"
    mkdir -p "$DB_DIR"
    cat > "$EDGE_CERT_INFO_FILE" <<EOF
EDGE_CERT_MODE="$cert_mode"
EDGE_DOMAIN="$cert_domain"
EDGE_EMAIL="$cert_email"
EOF
}

detect_preferred_host() {
    local host_domain=""
    load_edge_cert_info
    if [[ -n "$EDGE_DOMAIN" ]]; then
        host_domain="$EDGE_DOMAIN"
    fi
    if [[ -z "$host_domain" && -f "$DNS_INFO_FILE" ]]; then
        host_domain=$(grep 'FULL_DOMAIN' "$DNS_INFO_FILE" | cut -d'"' -f2)
    fi
    if [[ -z "$host_domain" && -f "$NGINX_CONFIG_FILE" ]]; then
        local nginx_domain
        nginx_domain=$(grep -oP 'server_name \K[^\s;]+' "$NGINX_CONFIG_FILE" 2>/dev/null | head -n 1)
        if [[ "$nginx_domain" != "_" && -n "$nginx_domain" ]]; then
            host_domain="$nginx_domain"
        fi
    fi
    if [[ -z "$host_domain" ]]; then
        host_domain=$(curl -s -4 icanhazip.com)
    fi
    echo "$host_domain"
}

backup_edge_configs() {
    if [ -f "$NGINX_CONFIG_FILE" ] && [ ! -f "${NGINX_CONFIG_FILE}.bak.firewallfalcon" ]; then
        cp "$NGINX_CONFIG_FILE" "${NGINX_CONFIG_FILE}.bak.firewallfalcon" 2>/dev/null
    fi
    if [ -f "$HAPROXY_CONFIG" ] && [ ! -f "${HAPROXY_CONFIG}.bak.firewallfalcon" ]; then
        cp "$HAPROXY_CONFIG" "${HAPROXY_CONFIG}.bak.firewallfalcon" 2>/dev/null
    fi
}

ensure_edge_stack_packages() {
    local missing_packages=()
    if ! command -v haproxy &> /dev/null || [ ! -f "/etc/haproxy/haproxy.cfg" ]; then
        missing_packages+=("haproxy")
    fi
    if ! command -v nginx &> /dev/null || [ ! -f "/etc/nginx/nginx.conf" ]; then
        missing_packages+=("nginx")
    fi
    command -v openssl &> /dev/null || missing_packages+=("openssl")

    if (( ${#missing_packages[@]} > 0 )); then
        echo -e "\n${C_BLUE}📦 Installing required packages: ${missing_packages[*]}${C_RESET}"
        if ! ff_pkg_install "${missing_packages[@]}"; then
            echo -e "${C_YELLOW}⚠️ Package installation failed. Attempting to fix broken configurations...${C_RESET}"
            if command -v apt-get &>/dev/null; then
                apt-get purge -y nginx nginx-common haproxy >/dev/null 2>&1
            fi
            if ! ff_pkg_install "${missing_packages[@]}"; then
                echo -e "${C_RED}❌ Failed to install the required packages.${C_RESET}"
                return 1
            fi
        fi
    fi
    return 0
}

build_shared_tls_bundle() {
    if [ ! -s "$SSL_CERT_CHAIN_FILE" ] || [ ! -s "$SSL_CERT_KEY_FILE" ]; then
        echo -e "${C_RED}❌ Certificate chain or key is missing.${C_RESET}"
        return 1
    fi
    cat "$SSL_CERT_CHAIN_FILE" "$SSL_CERT_KEY_FILE" > "$SSL_CERT_FILE" || return 1
    chmod 644 "$SSL_CERT_CHAIN_FILE"
    chmod 600 "$SSL_CERT_KEY_FILE" "$SSL_CERT_FILE"
    return 0
}

generate_self_signed_edge_cert() {
    local common_name="$1"
    mkdir -p "$SSL_CERT_DIR"
    echo -e "\n${C_GREEN}🔐 Generating a shared self-signed certificate...${C_RESET}"
    openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout "$SSL_CERT_KEY_FILE" \
        -out "$SSL_CERT_CHAIN_FILE" \
        -subj "/CN=$common_name" \
        >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to generate the self-signed certificate.${C_RESET}"
            return 1
        }
    build_shared_tls_bundle || return 1
    save_edge_cert_info "self-signed" "$common_name" ""
    echo -e "${C_GREEN}✅ Shared certificate created for ${C_YELLOW}$common_name${C_RESET}"
    return 0
}

_install_certbot() {
    if command -v certbot &> /dev/null; then
        echo -e "${C_GREEN}✅ Certbot is already installed.${C_RESET}"
        return 0
    fi
    echo -e "${C_BLUE}📦 Installing Certbot...${C_RESET}"
    ff_pkg_install certbot || {
        echo -e "${C_RED}❌ Failed to install Certbot.${C_RESET}"
        return 1
    }
    echo -e "${C_GREEN}✅ Certbot installed successfully.${C_RESET}"
    return 0
}

obtain_certbot_edge_cert() {
    local domain_name="$1"
    local email="$2"
    local restart_haproxy=0
    local restart_nginx=0

    mkdir -p "$SSL_CERT_DIR"
    _install_certbot || return 1

    if systemctl is-active --quiet haproxy; then restart_haproxy=1; fi
    if systemctl is-active --quiet nginx; then restart_nginx=1; fi

    echo -e "\n${C_BLUE}🛑 Stopping HAProxy and Nginx for Certbot validation...${C_RESET}"
    systemctl stop haproxy >/dev/null 2>&1
    systemctl stop nginx >/dev/null 2>&1
    sleep 2

    check_and_free_ports "$EDGE_PUBLIC_HTTP_PORT" "$EDGE_PUBLIC_TLS_PORT" || {
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        [[ "$restart_haproxy" -eq 1 ]] && systemctl start haproxy >/dev/null 2>&1
        return 1
    }

    echo -e "\n${C_BLUE}🚀 Requesting a Certbot certificate for ${C_YELLOW}$domain_name${C_RESET}"
    certbot certonly --standalone -d "$domain_name" --non-interactive --agree-tos -m "$email"
    if [ $? -ne 0 ]; then
        echo -e "\n${C_RED}❌ Certbot failed to obtain a certificate.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Make sure the domain points to this server and port 80 is reachable.${C_RESET}"
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        [[ "$restart_haproxy" -eq 1 ]] && systemctl start haproxy >/dev/null 2>&1
        return 1
    fi

    local certbot_chain="/etc/letsencrypt/live/$domain_name/fullchain.pem"
    local certbot_key="/etc/letsencrypt/live/$domain_name/privkey.pem"
    if [ ! -f "$certbot_chain" ] || [ ! -f "$certbot_key" ]; then
        echo -e "\n${C_RED}❌ Certbot completed, but the certificate files were not found.${C_RESET}"
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        [[ "$restart_haproxy" -eq 1 ]] && systemctl start haproxy >/dev/null 2>&1
        return 1
    fi

    cp "$certbot_chain" "$SSL_CERT_CHAIN_FILE"
    cp "$certbot_key" "$SSL_CERT_KEY_FILE"
    build_shared_tls_bundle || {
        [[ "$restart_nginx" -eq 1 ]] && systemctl start nginx >/dev/null 2>&1
        [[ "$restart_haproxy" -eq 1 ]] && systemctl start haproxy >/dev/null 2>&1
        return 1
    }
    save_edge_cert_info "certbot" "$domain_name" "$email"
    echo -e "${C_GREEN}✅ Certbot certificate copied into ${C_YELLOW}$SSL_CERT_DIR${C_RESET}"
    return 0
}

select_edge_certificate() {
    local preferred_host
    local cert_choice
    local has_existing_cert=false

    preferred_host=$(detect_preferred_host)
    if [[ -z "$preferred_host" ]]; then
        preferred_host="firewallfalcon.local"
    fi

    if [ -s "$SSL_CERT_FILE" ] && [ -s "$SSL_CERT_CHAIN_FILE" ] && [ -s "$SSL_CERT_KEY_FILE" ]; then
        has_existing_cert=true
    fi

    load_edge_cert_info

    echo -e "\n${C_BOLD}${C_PURPLE}--- 🔐 Shared TLS Certificate ---${C_RESET}"
    echo -e "${C_DIM}The same certificate will be used by HAProxy and the internal Nginx proxy.${C_RESET}"

    if $has_existing_cert; then
        local existing_label="${EDGE_CERT_MODE:-existing}"
        if [[ -n "$EDGE_DOMAIN" ]]; then
            existing_label="$existing_label - $EDGE_DOMAIN"
        fi
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-52s\n" "Reuse existing certificate (${existing_label})"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-52s\n" "Replace with a new self-signed certificate"
        printf "  ${C_CHOICE}[ 3]${C_RESET} %-52s\n" "Replace with a Certbot certificate"
        echo
        read -p "👉 Enter choice [1]: " cert_choice
        cert_choice=${cert_choice:-1}
    else
        printf "  ${C_CHOICE}[ 1]${C_RESET} %-52s\n" "Generate a self-signed certificate"
        printf "  ${C_CHOICE}[ 2]${C_RESET} %-52s\n" "Use a Certbot certificate"
        echo
        read -p "👉 Enter choice [1]: " cert_choice
        cert_choice=${cert_choice:-1}
    fi

    case "$cert_choice" in
        1)
            if $has_existing_cert; then
                echo -e "${C_GREEN}✅ Reusing the existing shared certificate.${C_RESET}"
                return 0
            fi
            local common_name
            read -p "👉 Enter the certificate Common Name / SNI label [$preferred_host]: " common_name
            common_name=${common_name:-$preferred_host}
            generate_self_signed_edge_cert "$common_name"
            ;;
        2)
            if $has_existing_cert; then
                local common_name
                read -p "👉 Enter the certificate Common Name / SNI label [$preferred_host]: " common_name
                common_name=${common_name:-$preferred_host}
                generate_self_signed_edge_cert "$common_name"
            else
                local default_domain=""
                local domain_name
                local email
                if ! _is_valid_ipv4 "$preferred_host"; then
                    default_domain="$preferred_host"
                fi
                if [[ -n "$default_domain" ]]; then
                    read -p "👉 Enter your domain name [$default_domain]: " domain_name
                    domain_name=${domain_name:-$default_domain}
                else
                    read -p "👉 Enter your domain name (e.g. vpn.example.com): " domain_name
                fi
                if [[ -z "$domain_name" ]]; then
                    echo -e "${C_RED}❌ Domain name cannot be empty.${C_RESET}"
                    return 1
                fi
                if _is_valid_ipv4 "$domain_name"; then
                    echo -e "${C_RED}❌ Certbot requires a real domain name, not a raw IP address.${C_RESET}"
                    return 1
                fi
                read -p "👉 Enter your email for Let's Encrypt: " email
                if [[ -z "$email" ]]; then
                    echo -e "${C_RED}❌ Email cannot be empty.${C_RESET}"
                    return 1
                fi
                obtain_certbot_edge_cert "$domain_name" "$email"
            fi
            ;;
        3)
            if ! $has_existing_cert; then
                echo -e "${C_RED}❌ Invalid option.${C_RESET}"
                return 1
            fi
            local default_domain=""
            local domain_name
            local email
            if [[ -n "$EDGE_DOMAIN" ]] && ! _is_valid_ipv4 "$EDGE_DOMAIN"; then
                default_domain="$EDGE_DOMAIN"
            fi
            if [[ -z "$default_domain" ]] && ! _is_valid_ipv4 "$preferred_host"; then
                default_domain="$preferred_host"
            fi
            if [[ -n "$default_domain" ]]; then
                read -p "👉 Enter your domain name [$default_domain]: " domain_name
                domain_name=${domain_name:-$default_domain}
            else
                read -p "👉 Enter your domain name (e.g. vpn.example.com): " domain_name
            fi
            if [[ -z "$domain_name" ]]; then
                echo -e "${C_RED}❌ Domain name cannot be empty.${C_RESET}"
                return 1
            fi
            if _is_valid_ipv4 "$domain_name"; then
                echo -e "${C_RED}❌ Certbot requires a real domain name, not a raw IP address.${C_RESET}"
                return 1
            fi
            read -p "👉 Enter your email for Let's Encrypt [${EDGE_EMAIL}]: " email
            email=${email:-$EDGE_EMAIL}
            if [[ -z "$email" ]]; then
                echo -e "${C_RED}❌ Email cannot be empty.${C_RESET}"
                return 1
            fi
            obtain_certbot_edge_cert "$domain_name" "$email"
            ;;
        *)
            echo -e "${C_RED}❌ Invalid option.${C_RESET}"
            return 1
            ;;
    esac
}

write_internal_nginx_config() {
    local server_name="$1"
    [[ -z "$server_name" ]] && server_name="_"
    mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
    cat > "$NGINX_CONFIG_FILE" <<EOF
server {
    listen 127.0.0.1:${NGINX_INTERNAL_HTTP_PORT} default_server;
    listen 127.0.0.1:${NGINX_INTERNAL_TLS_PORT} ssl http2 default_server;
    server_tokens off;
    server_name ${server_name};

    ssl_certificate ${SSL_CERT_CHAIN_FILE};
    ssl_certificate_key ${SSL_CERT_KEY_FILE};
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!eNULL:!MD5:!DES:!RC4:!ADH:!SSLv3:!EXP:!PSK:!DSS;
    resolver 1.1.1.1 8.8.8.8 ipv6=off valid=300s;

    location ~ ^/(?<fwdport>\d+)/(?<fwdpath>.*)$ {
        client_max_body_size 0;
        client_body_timeout 1d;
        grpc_read_timeout 1d;
        grpc_socket_keepalive on;
        proxy_read_timeout 1d;
        proxy_http_version 1.1;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_socket_keepalive on;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        if (\$content_type ~* "GRPC") { grpc_pass grpc://127.0.0.1:\$fwdport\$is_args\$args; break; }
        proxy_pass http://127.0.0.1:\$fwdport\$is_args\$args;
        break;
    }

    location / {
        proxy_read_timeout 3600s;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_socket_keepalive on;
        tcp_nodelay on;
        tcp_nopush off;
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
    ln -sf "$NGINX_CONFIG_FILE" /etc/nginx/sites-enabled/default
}

write_haproxy_edge_config() {
    mkdir -p /etc/haproxy
    cat > "$HAPROXY_CONFIG" <<EOF
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    tcp
    option  tcplog
    option  dontlognull
    timeout connect 5s
    timeout client  24h
    timeout server  24h

# ====================================================================
# TIER 1: PORT ${EDGE_PUBLIC_HTTP_PORT} (Cleartext Payloads & Raw SSH)
# ====================================================================
frontend port_80_edge
    bind *:${EDGE_PUBLIC_HTTP_PORT}
    mode tcp
    tcp-request inspect-delay 2s

    acl is_ssh payload(0,7) -m bin 5353482d322e30

    tcp-request content accept if is_ssh
    tcp-request content accept if HTTP

    use_backend direct_ssh if is_ssh
    default_backend nginx_cleartext

# ====================================================================
# TIER 1: PORT ${EDGE_PUBLIC_TLS_PORT} (TLS v2ray, SSL Payloads, Raw SSH)
# ====================================================================
frontend port_443_edge
    bind *:${EDGE_PUBLIC_TLS_PORT}
    mode tcp
    tcp-request inspect-delay 2s

    acl is_ssh payload(0,7) -m bin 5353482d322e30
    acl is_tls req.ssl_hello_type 1
    acl has_web_alpn req.ssl_alpn -m sub h2 http/1.1

    tcp-request content accept if is_ssh
    tcp-request content accept if HTTP
    tcp-request content accept if is_tls

    use_backend direct_ssh if is_ssh
    use_backend nginx_cleartext if HTTP
    use_backend nginx_tls if is_tls has_web_alpn
    default_backend loopback_ssl_terminator

# ====================================================================
# TIER 2: INTERNAL DECRYPTOR (Only for Any-SNI SSH-TLS)
# ====================================================================
frontend internal_decryptor
    bind 127.0.0.1:${HAPROXY_INTERNAL_DECRYPT_PORT} ssl crt ${SSL_CERT_FILE}
    mode tcp
    tcp-request inspect-delay 2s

    acl is_ssh payload(0,7) -m bin 5353482d322e30
    tcp-request content accept if is_ssh
    tcp-request content accept if HTTP

    use_backend direct_ssh if is_ssh
    default_backend nginx_cleartext

# ====================================================================
# DESTINATION BACKENDS (Clean handoffs, no proxy headers)
# ====================================================================
backend direct_ssh
    mode tcp
    server ssh_server 127.0.0.1:22

backend nginx_cleartext
    mode tcp
    server nginx_8880 127.0.0.1:${NGINX_INTERNAL_HTTP_PORT}

backend nginx_tls
    mode tcp
    server nginx_8443 127.0.0.1:${NGINX_INTERNAL_TLS_PORT}

backend loopback_ssl_terminator
    mode tcp
    server haproxy_ssl 127.0.0.1:${HAPROXY_INTERNAL_DECRYPT_PORT}
EOF
}

save_edge_ports_info() {
    cat > "$NGINX_PORTS_FILE" <<EOF
EDGE_HTTP_PORT="${EDGE_PUBLIC_HTTP_PORT}"
EDGE_TLS_PORT="${EDGE_PUBLIC_TLS_PORT}"
HTTP_PORTS="${NGINX_INTERNAL_HTTP_PORT}"
TLS_PORTS="${NGINX_INTERNAL_TLS_PORT}"
EOF
}

configure_edge_stack() {
    local server_name="$1"
    [[ -z "$server_name" ]] && server_name="_"

    backup_edge_configs

    echo -e "\n${C_BLUE}📝 Writing internal Nginx config (127.0.0.1:${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT})...${C_RESET}"
    write_internal_nginx_config "$server_name"

    echo -e "${C_BLUE}📝 Writing HAProxy edge config (${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT})...${C_RESET}"
    write_haproxy_edge_config

    echo -e "\n${C_BLUE}🧪 Validating Nginx configuration...${C_RESET}"
    if ! nginx -t >/dev/null 2>&1; then
        echo -e "${C_RED}❌ Nginx configuration validation failed.${C_RESET}"
        nginx -t
        return 1
    fi

    echo -e "${C_BLUE}🧪 Validating HAProxy configuration...${C_RESET}"
    if ! haproxy -c -f "$HAPROXY_CONFIG" >/dev/null 2>&1; then
        echo -e "${C_RED}❌ HAProxy configuration validation failed.${C_RESET}"
        haproxy -c -f "$HAPROXY_CONFIG"
        return 1
    fi

    systemctl daemon-reload
    systemctl enable nginx >/dev/null 2>&1
    systemctl enable haproxy >/dev/null 2>&1

    echo -e "\n${C_BLUE}▶️ Restarting internal Nginx...${C_RESET}"
    systemctl restart nginx || {
        echo -e "${C_RED}❌ Nginx failed to restart.${C_RESET}"
        systemctl status nginx --no-pager
        return 1
    }

    echo -e "${C_BLUE}▶️ Restarting HAProxy edge...${C_RESET}"
    systemctl restart haproxy || {
        echo -e "${C_RED}❌ HAProxy failed to restart.${C_RESET}"
        systemctl status haproxy --no-pager
        return 1
    }

    sleep 2
    if ! systemctl is-active --quiet nginx; then
        echo -e "${C_RED}❌ Nginx is not active after restart.${C_RESET}"
        systemctl status nginx --no-pager
        return 1
    fi
    if ! systemctl is-active --quiet haproxy; then
        echo -e "${C_RED}❌ HAProxy is not active after restart.${C_RESET}"
        systemctl status haproxy --no-pager
        return 1
    fi

    save_edge_ports_info
    return 0
}

install_ssl_tunnel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing HAProxy Edge Stack (80/443 -> 8880/8443) ---${C_RESET}"
    echo -e "\n${C_CYAN}This installer will configure:${C_RESET}"
    echo -e "   • HAProxy on ${C_WHITE}${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT}${C_RESET}"
    echo -e "   • Internal Nginx on ${C_WHITE}${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}${C_RESET}"
    echo -e "   • Loopback SSL decryptor on ${C_WHITE}${HAPROXY_INTERNAL_DECRYPT_PORT}${C_RESET}"

    if [ -f "$HAPROXY_CONFIG" ] || [ -f "$NGINX_CONFIG_FILE" ]; then
        echo -e "\n${C_YELLOW}⚠️ Existing HAProxy/Nginx configs will be replaced with the Mohammad Ahmad VPN Manager edge layout.${C_RESET}"
        read -p "👉 Continue with the replacement? (y/n): " confirm_replace
        if [[ "$confirm_replace" != "y" && "$confirm_replace" != "Y" ]]; then
            echo -e "${C_RED}❌ Installation cancelled.${C_RESET}"
            return
        fi
    fi

    mkdir -p "$DB_DIR" "$SSL_CERT_DIR"

    ensure_edge_stack_packages || return

    systemctl stop haproxy >/dev/null 2>&1
    systemctl stop nginx >/dev/null 2>&1
    sleep 1

    check_and_free_ports \
        "$EDGE_PUBLIC_HTTP_PORT" \
        "$EDGE_PUBLIC_TLS_PORT" \
        "$NGINX_INTERNAL_HTTP_PORT" \
        "$NGINX_INTERNAL_TLS_PORT" \
        "$HAPROXY_INTERNAL_DECRYPT_PORT" || return

    check_and_open_firewall_port "$EDGE_PUBLIC_HTTP_PORT" tcp || return
    check_and_open_firewall_port "$EDGE_PUBLIC_TLS_PORT" tcp || return

    select_edge_certificate || return

    load_edge_cert_info
    local server_name="${EDGE_DOMAIN:-$(detect_preferred_host)}"
    [[ -z "$server_name" ]] && server_name="_"

    configure_edge_stack "$server_name" || return

    echo -e "\n${C_GREEN}✅ SUCCESS: HAProxy edge stack is active.${C_RESET}"
    echo -e "   • Public edge ports: ${C_YELLOW}${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT}${C_RESET}"
    echo -e "   • Internal Nginx ports: ${C_YELLOW}${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}${C_RESET}"
    echo -e "   • Shared certificate: ${C_YELLOW}${EDGE_CERT_MODE:-unknown}${C_RESET}"
}

uninstall_ssl_tunnel() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling HAProxy Edge Stack ---${C_RESET}"
    if ! command -v haproxy &> /dev/null; then
        echo -e "${C_YELLOW}ℹ️ HAProxy is not installed, skipping service removal.${C_RESET}"
    else
        echo -e "${C_GREEN}🛑 Stopping and disabling HAProxy...${C_RESET}"
        systemctl stop haproxy >/dev/null 2>&1
        systemctl disable haproxy >/dev/null 2>&1
    fi

    if [ -f "$HAPROXY_CONFIG" ]; then
        cat > "$HAPROXY_CONFIG" <<EOF
global
    log /dev/log local0
    log /dev/log local1 notice

defaults
    log     global
EOF
    fi

    local delete_cert="n"
    if [[ "$UNINSTALL_MODE" == "silent" ]]; then
        delete_cert="y"
    elif [ -f "$SSL_CERT_FILE" ] || [ -f "$SSL_CERT_CHAIN_FILE" ] || [ -f "$SSL_CERT_KEY_FILE" ]; then
        if systemctl is-active --quiet nginx; then
            echo -e "${C_YELLOW}⚠️ The shared certificate is also used by the internal Nginx proxy.${C_RESET}"
        fi
        read -p "👉 Delete the shared TLS certificate too? (y/n): " delete_cert
    fi

    if [[ "$delete_cert" == "y" || "$delete_cert" == "Y" ]]; then
        if systemctl is-active --quiet nginx; then
            echo -e "${C_GREEN}🛑 Stopping Nginx because the shared certificate is being removed...${C_RESET}"
            systemctl stop nginx >/dev/null 2>&1
        fi
        rm -f "$SSL_CERT_FILE" "$SSL_CERT_CHAIN_FILE" "$SSL_CERT_KEY_FILE" "$EDGE_CERT_INFO_FILE"
        rm -f "$NGINX_PORTS_FILE"
        echo -e "${C_GREEN}🗑️ Shared certificate files removed.${C_RESET}"
    fi

    echo -e "${C_GREEN}✅ HAProxy edge stack has been removed.${C_RESET}"
    if systemctl is-active --quiet nginx; then
        echo -e "${C_DIM}The internal Nginx proxy is still installed on ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"
    fi
}

show_dnstt_details() {
    if [ -f "$DNSTT_CONFIG_FILE" ]; then
        source "$DNSTT_CONFIG_FILE"
        echo -e "\n${C_GREEN}=====================================================${C_RESET}"
        echo -e "${C_GREEN}            📡 DNSTT Connection Details             ${C_RESET}"
        echo -e "${C_GREEN}=====================================================${C_RESET}"
        echo -e "\n${C_WHITE}Your connection details:${C_RESET}"
        echo -e "  - ${C_CYAN}Tunnel Domain:${C_RESET} ${C_YELLOW}$TUNNEL_DOMAIN${C_RESET}"
        echo -e "  - ${C_CYAN}Public Key:${C_RESET}    ${C_YELLOW}$PUBLIC_KEY${C_RESET}"
        if [[ -n "$FORWARD_DESC" ]]; then
            echo -e "  - ${C_CYAN}Forwarding To:${C_RESET} ${C_YELLOW}$FORWARD_DESC${C_RESET}"
        else
            echo -e "  - ${C_CYAN}Forwarding To:${C_RESET} ${C_YELLOW}Unknown (config_missing)${C_RESET}"
        fi
        if [[ -n "$MTU_VALUE" ]]; then
            echo -e "  - ${C_CYAN}MTU Value:${C_RESET}     ${C_YELLOW}$MTU_VALUE${C_RESET}"
        fi
        if [[ "$DNSTT_RECORDS_MANAGED" == "false" && -n "$NS_DOMAIN" ]]; then
             echo -e "  - ${C_CYAN}NS Record:${C_RESET}     ${C_YELLOW}$NS_DOMAIN${C_RESET}"
        fi
        
        if [[ "$FORWARD_DESC" == *"V2Ray"* ]]; then
             echo -e "  - ${C_CYAN}Action Required:${C_RESET} ${C_YELLOW}Ensure a V2Ray service (vless/vmess/trojan) listens on port 8787 (no TLS)${C_RESET}"
        elif [[ "$FORWARD_DESC" == *"SSH"* ]]; then
             echo -e "  - ${C_CYAN}Action Required:${C_RESET} ${C_YELLOW}Ensure your SSH client is configured to use the DNS tunnel.${C_RESET}"
        fi
        
        echo -e "\n${C_DIM}Use these details in your client configuration.${C_RESET}"
    else
        echo -e "\n${C_YELLOW}ℹ️ DNSTT configuration file not found. Details are unavailable.${C_RESET}"
    fi
}

install_dnstt() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📡 DNSTT (DNS Tunnel) Management ---${C_RESET}"
    if [ -f "$DNSTT_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ DNSTT is already installed.${C_RESET}"
        show_dnstt_details
        return
    fi
    
    # --- FIX: Force release of Port 53 / Disable systemd-resolved ---
    echo -e "${C_GREEN}⚙️ Forcing release of Port 53 (stopping systemd-resolved)...${C_RESET}"
    systemctl stop systemd-resolved >/dev/null 2>&1
    systemctl disable systemd-resolved >/dev/null 2>&1
    # Mask it so it never starts again on reboot
    systemctl mask systemd-resolved >/dev/null 2>&1
    chattr -i /etc/resolv.conf &>/dev/null
    rm -f /etc/resolv.conf
    printf 'nameserver 8.8.8.8\nnameserver 8.8.4.4\n' > /etc/resolv.conf
    chattr +i /etc/resolv.conf
    # ----------------------------------------------------------------
    
    echo -e "\n${C_BLUE}🔎 Checking if port 53 (UDP) is available...${C_RESET}"
    if ss -lunp | grep -q ':53\s'; then
        local _port53_pid
        _port53_pid=$(ss -lunp | grep ':53\s' | grep -oP 'pid=\K[0-9]+' | head -n1)
        if [[ -n "$_port53_pid" && $(ps -p "$_port53_pid" -o comm= 2>/dev/null) == "systemd-resolve" ]]; then
            echo -e "${C_YELLOW}⚠️ Warning: Port 53 is in use by 'systemd-resolved'.${C_RESET}"
            echo -e "${C_YELLOW}This is the system's DNS stub resolver. It must be disabled to run DNSTT.${C_RESET}"
            read -p "👉 Allow the script to automatically disable it and reconfigure DNS? (y/n): " resolve_confirm
            if [[ "$resolve_confirm" == "y" || "$resolve_confirm" == "Y" ]]; then
                echo -e "${C_GREEN}⚙️ Stopping and disabling systemd-resolved to free port 53...${C_RESET}"
                systemctl stop systemd-resolved
                systemctl disable systemd-resolved
                chattr -i /etc/resolv.conf &>/dev/null
                rm -f /etc/resolv.conf
                echo "nameserver 8.8.8.8" > /etc/resolv.conf
                chattr +i /etc/resolv.conf
                echo -e "${C_GREEN}✅ Port 53 has been freed and DNS set to 8.8.8.8.${C_RESET}"
            else
                echo -e "${C_RED}❌ Cannot proceed without freeing port 53. Aborting.${C_RESET}"
                return
            fi
        else
            check_and_free_ports "53" || return
        fi
    else
        echo -e "${C_GREEN}✅ Port 53 (UDP) is free to use.${C_RESET}"
    fi

    check_and_open_firewall_port 53 udp || return



    local forward_port=""
    local forward_desc=""
    echo -e "\n${C_BLUE}Please choose where DNSTT should forward traffic:${C_RESET}"
    echo -e "  ${C_GREEN}[ 1]${C_RESET} ➡️ Forward to local SSH service (port 22)"
    echo -e "  ${C_GREEN}[ 2]${C_RESET} ➡️ Forward to local V2Ray backend (port 8787)"
    read -p "👉 Enter your choice [2]: " fwd_choice
    fwd_choice=${fwd_choice:-2}
    if [[ "$fwd_choice" == "1" ]]; then
        forward_port="22"
        forward_desc="SSH (port 22)"
        echo -e "${C_GREEN}ℹ️ DNSTT will forward to SSH on 127.0.0.1:22.${C_RESET}"
        

        
    elif [[ "$fwd_choice" == "2" ]]; then
        forward_port="8787"
        forward_desc="V2Ray (port 8787)"
        echo -e "${C_GREEN}ℹ️ DNSTT will forward to V2Ray on 127.0.0.1:8787.${C_RESET}"
    else
        echo -e "${C_RED}❌ Invalid choice. Aborting.${C_RESET}"
        return
    fi
    local FORWARD_TARGET="127.0.0.1:$forward_port"
    
    local NS_DOMAIN=""
    local TUNNEL_DOMAIN=""
    local DNSTT_RECORDS_MANAGED="true"
    local NS_SUBDOMAIN=""
    local TUNNEL_SUBDOMAIN=""
    local HAS_IPV6="false"

    read -p "👉 Auto-generate DNS records or use custom ones? (auto/custom) [auto]: " dns_choice
    dns_choice=${dns_choice:-auto}

    if [[ "$dns_choice" == "custom" ]]; then
        DNSTT_RECORDS_MANAGED="false"
        read -p "👉 Enter your full nameserver domain (e.g., ns1.yourdomain.com): " NS_DOMAIN
        if [[ -z "$NS_DOMAIN" ]]; then echo -e "\n${C_RED}❌ Nameserver domain cannot be empty. Aborting.${C_RESET}"; return; fi
        read -p "👉 Enter your full tunnel domain (e.g., tun.yourdomain.com): " TUNNEL_DOMAIN
        if [[ -z "$TUNNEL_DOMAIN" ]]; then echo -e "\n${C_RED}❌ Tunnel domain cannot be empty. Aborting.${C_RESET}"; return; fi
    else
        echo -e "\n${C_BLUE}⚙️ Configuring DNS records for DNSTT...${C_RESET}"
        local SERVER_IPV4
        SERVER_IPV4=$(curl -s -4 icanhazip.com)
        if ! _is_valid_ipv4 "$SERVER_IPV4"; then
            echo -e "\n${C_RED}❌ Error: Could not retrieve a valid public IPv4 address from icanhazip.com.${C_RESET}"
            echo -e "${C_YELLOW}ℹ️ Please check your server's network connection and DNS resolver settings.${C_RESET}"
            echo -e "   Output received: '$SERVER_IPV4'"
            return 1
        fi
        
        local SERVER_IPV6
        SERVER_IPV6=$(curl -s -6 icanhazip.com --max-time 5)
        
        local _active_desec_token="$DESEC_TOKEN"
        local _active_desec_domain="$DESEC_DOMAIN"
        local _desec_retry="true"

        while [[ "$_desec_retry" == "true" ]]; do
            _desec_retry="false"

            local RANDOM_STR
            RANDOM_STR=$(tr -dc a-z0-9 < /dev/urandom | head -c 6)
            NS_SUBDOMAIN="ns-$RANDOM_STR"
            TUNNEL_SUBDOMAIN="tun-$RANDOM_STR"
            NS_DOMAIN="$NS_SUBDOMAIN.$_active_desec_domain"
            TUNNEL_DOMAIN="$TUNNEL_SUBDOMAIN.$_active_desec_domain"

            local API_DATA
            API_DATA=$(printf '[{"subname": "%s", "type": "A", "ttl": 3600, "records": ["%s"]}, {"subname": "%s", "type": "NS", "ttl": 3600, "records": ["%s."]}]' \
                "$NS_SUBDOMAIN" "$SERVER_IPV4" "$TUNNEL_SUBDOMAIN" "$NS_DOMAIN")

            if [[ -n "$SERVER_IPV6" ]]; then
                local aaaa_record
                aaaa_record=$(printf ',{"subname": "%s", "type": "AAAA", "ttl": 3600, "records": ["%s"]}' "$NS_SUBDOMAIN" "$SERVER_IPV6")
                API_DATA="${API_DATA%?}${aaaa_record}]"
                HAS_IPV6="true"
            fi

            local CREATE_RESPONSE
            CREATE_RESPONSE=$(curl -s -w "%{http_code}" -X POST "https://desec.io/api/v1/domains/$_active_desec_domain/rrsets/" \
                -H "Authorization: Token $_active_desec_token" -H "Content-Type: application/json" \
                --data "$API_DATA")

            local HTTP_CODE=${CREATE_RESPONSE: -3}
            local RESPONSE_BODY=${CREATE_RESPONSE:0:${#CREATE_RESPONSE}-3}

            if [[ "$HTTP_CODE" -ne 201 ]]; then
                echo -e "${C_RED}❌ Failed to create DNSTT records. API returned HTTP $HTTP_CODE.${C_RESET}"
                if echo "$RESPONSE_BODY" | jq . > /dev/null 2>&1; then
                    echo "$RESPONSE_BODY" | jq
                else
                    echo -e "${C_YELLOW}Response: $RESPONSE_BODY${C_RESET}"
                fi

                if [[ "$HTTP_CODE" == "401" || "$HTTP_CODE" == "403" ]]; then
                    echo -e "\n${C_YELLOW}⚠️ The built-in deSEC API token for '$_active_desec_domain' is being rejected (unauthorized).${C_RESET}"
                    echo -e "${C_YELLOW}   This is a credential for a shared account this script ships with — it may have been revoked or expired, and there is no way for this script to restore access to someone else's deSEC account.${C_RESET}"
                    echo -e "\n${C_BLUE}What would you like to do?${C_RESET}"
                    echo -e "  ${C_GREEN}[1]${C_RESET} Enter your own deSEC token + domain (free account at https://desec.io)"
                    echo -e "  ${C_GREEN}[2]${C_RESET} Switch to fully custom mode (you manage NS delegation yourself, no API used)"
                    echo -e "  ${C_GREEN}[3]${C_RESET} Abort"
                    read -p "👉 Enter your choice [3]: " _desec_fallback_choice
                    case "$_desec_fallback_choice" in
                        1)
                            read -p "👉 Enter your deSEC domain (must already be added to your deSEC account): " _active_desec_domain
                            read -p "👉 Enter your deSEC API token: " _active_desec_token
                            if [[ -z "$_active_desec_domain" || -z "$_active_desec_token" ]]; then
                                echo -e "\n${C_RED}❌ Domain and token cannot be empty. Aborting.${C_RESET}"
                                return 1
                            fi
                            _desec_retry="true"
                            continue
                            ;;
                        2)
                            DNSTT_RECORDS_MANAGED="false"
                            echo -e "\n${C_BLUE}You'll need to manually point NS/A records at this server. See show_dnstt_details after install for the values to use.${C_RESET}"
                            read -p "👉 Enter your full nameserver domain (e.g., ns1.yourdomain.com): " NS_DOMAIN
                            if [[ -z "$NS_DOMAIN" ]]; then echo -e "\n${C_RED}❌ Nameserver domain cannot be empty. Aborting.${C_RESET}"; return 1; fi
                            read -p "👉 Enter your full tunnel domain (e.g., tun.yourdomain.com): " TUNNEL_DOMAIN
                            if [[ -z "$TUNNEL_DOMAIN" ]]; then echo -e "\n${C_RED}❌ Tunnel domain cannot be empty. Aborting.${C_RESET}"; return 1; fi
                            ;;
                        *)
                            echo -e "\n${C_RED}❌ Aborting.${C_RESET}"
                            return 1
                            ;;
                    esac
                else
                    return 1
                fi
            fi
        done
    fi
    
    read -p "👉 Enter MTU value (e.g., 512, 1200) or press [Enter] for default: " mtu_value
    local mtu_string=""
    if [[ "$mtu_value" =~ ^[0-9]+$ ]]; then
        mtu_string=" -mtu $mtu_value"
        echo -e "${C_GREEN}ℹ️ Using MTU: $mtu_value${C_RESET}"
    else
        mtu_value=""
        echo -e "${C_YELLOW}ℹ️ Using default MTU.${C_RESET}"
    fi

    echo -e "\n${C_BLUE}📥 Downloading pre-compiled DNSTT server binary from GitHub...${C_RESET}"
    local arch
    arch=$(uname -m)
    local gh_asset=""
    if [[ "$arch" == "x86_64" ]]; then
        gh_asset="dnstt-server-linux-amd64"
        echo -e "${C_BLUE}ℹ️ Detected x86_64 (amd64) architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        gh_asset="dnstt-server-linux-arm64"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Unsupported architecture: $arch. Cannot install DNSTT.${C_RESET}"
        return
    fi

    local gh_repo="net2share/dnstt"
    local gh_tag="latest"
    local binary_url="https://github.com/$gh_repo/releases/download/$gh_tag/$gh_asset"
    local checksums_url="https://github.com/$gh_repo/releases/download/$gh_tag/checksums.sha256"

    local _dl_ok="false"
    for _attempt in 1 2 3; do
        if curl -fsSL --retry 2 --connect-timeout 10 "$binary_url" -o "$DNSTT_BINARY"; then
            if file "$DNSTT_BINARY" 2>/dev/null | grep -q "ELF"; then
                _dl_ok="true"
                break
            else
                echo -e "${C_YELLOW}⚠️ Downloaded file is not a valid binary (attempt $_attempt/3), retrying...${C_RESET}"
                rm -f "$DNSTT_BINARY"
            fi
        else
            echo -e "${C_YELLOW}⚠️ Download attempt $_attempt/3 failed, retrying...${C_RESET}"
        fi
        sleep 2
    done
    if [[ "$_dl_ok" != "true" ]]; then
        echo -e "\n${C_RED}❌ Failed to download a valid DNSTT binary from GitHub ($gh_repo).${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Check that this server can reach github.com over HTTPS (outbound firewall / DNS).${C_RESET}"
        rm -f "$DNSTT_BINARY"
        return 1
    fi

    echo -e "${C_BLUE}🔐 Verifying checksum...${C_RESET}"
    local _expected_sum _actual_sum
    _expected_sum=$(curl -fsSL --connect-timeout 10 "$checksums_url" 2>/dev/null | grep "$gh_asset\$" | awk '{print $1}')
    _actual_sum=$(sha256sum "$DNSTT_BINARY" | awk '{print $1}')
    if [[ -n "$_expected_sum" && "$_expected_sum" != "$_actual_sum" ]]; then
        echo -e "\n${C_RED}❌ Checksum mismatch for $gh_asset. Aborting for safety.${C_RESET}"
        echo -e "${C_YELLOW}   expected: $_expected_sum${C_RESET}"
        echo -e "${C_YELLOW}   got:      $_actual_sum${C_RESET}"
        rm -f "$DNSTT_BINARY"
        return 1
    elif [[ -z "$_expected_sum" ]]; then
        echo -e "${C_YELLOW}⚠️ Could not fetch checksums.sha256 to verify — proceeding without verification.${C_RESET}"
    else
        echo -e "${C_GREEN}✅ Checksum verified.${C_RESET}"
    fi
    chmod +x "$DNSTT_BINARY"

    echo -e "${C_BLUE}🔐 Generating cryptographic keys...${C_RESET}"
    mkdir -p "$DNSTT_KEYS_DIR"
    "$DNSTT_BINARY" -gen-key -privkey-file "$DNSTT_KEYS_DIR/server.key" -pubkey-file "$DNSTT_KEYS_DIR/server.pub"
    if [[ ! -f "$DNSTT_KEYS_DIR/server.key" ]]; then echo -e "${C_RED}❌ Failed to generate DNSTT keys.${C_RESET}"; return; fi
    
    local PUBLIC_KEY
    PUBLIC_KEY=$(cat "$DNSTT_KEYS_DIR/server.pub")
    
    echo -e "\n${C_BLUE}📝 Creating systemd service...${C_RESET}"
    cat > "$DNSTT_SERVICE_FILE" <<-EOF
[Unit]
Description=DNSTT (DNS Tunnel) Server for $forward_desc
After=network-online.target
Wants=network-online.target
Conflicts=systemd-resolved.service
[Service]
Type=simple
User=root
ExecStartPre=/bin/bash -c 'systemctl stop systemd-resolved 2>/dev/null; systemctl mask systemd-resolved 2>/dev/null; chattr -i /etc/resolv.conf 2>/dev/null; printf "nameserver 8.8.8.8\\nnameserver 8.8.4.4\\n" > /etc/resolv.conf; chattr +i /etc/resolv.conf; sleep 1'
ExecStart=$DNSTT_BINARY -udp :53$mtu_string -privkey-file $DNSTT_KEYS_DIR/server.key $TUNNEL_DOMAIN $FORWARD_TARGET
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
    echo -e "\n${C_BLUE}💾 Saving configuration and starting service...${C_RESET}"
    cat > "$DNSTT_CONFIG_FILE" <<-EOF
NS_SUBDOMAIN="$NS_SUBDOMAIN"
TUNNEL_SUBDOMAIN="$TUNNEL_SUBDOMAIN"
NS_DOMAIN="$NS_DOMAIN"
TUNNEL_DOMAIN="$TUNNEL_DOMAIN"
PUBLIC_KEY="$PUBLIC_KEY"
FORWARD_DESC="$forward_desc"
DNSTT_RECORDS_MANAGED="$DNSTT_RECORDS_MANAGED"
HAS_IPV6="$HAS_IPV6"
MTU_VALUE="$mtu_value"
DESEC_DOMAIN_USED="${_active_desec_domain:-$DESEC_DOMAIN}"
DESEC_TOKEN_USED="${_active_desec_token:-$DESEC_TOKEN}"
EOF
    systemctl daemon-reload
    systemctl enable dnstt.service
    systemctl start dnstt.service
    sleep 2
    if systemctl is-active --quiet dnstt.service; then
        echo -e "\n${C_GREEN}✅ SUCCESS: DNSTT has been installed and started!${C_RESET}"
        show_dnstt_details
    else
        echo -e "\n${C_RED}❌ ERROR: DNSTT service failed to start.${C_RESET}"
        journalctl -u dnstt.service -n 15 --no-pager
    fi
}

uninstall_dnstt() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling DNSTT ---${C_RESET}"
    if [ ! -f "$DNSTT_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ DNSTT does not appear to be installed, skipping.${C_RESET}"
        return
    fi
    local confirm="y"
    if [[ "$UNINSTALL_MODE" != "silent" ]]; then
        read -p "👉 Are you sure you want to uninstall DNSTT? This will delete DNS records if they were auto-generated. (y/n): " confirm
    fi
    if [[ "$confirm" != "y" ]]; then
        echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
        return
    fi
    echo -e "${C_BLUE}🛑 Stopping and disabling DNSTT service...${C_RESET}"
    systemctl stop dnstt.service > /dev/null 2>&1
    systemctl disable dnstt.service > /dev/null 2>&1
    if [ -f "$DNSTT_CONFIG_FILE" ]; then
        source "$DNSTT_CONFIG_FILE"
        local _del_domain="${DESEC_DOMAIN_USED:-$DESEC_DOMAIN}"
        local _del_token="${DESEC_TOKEN_USED:-$DESEC_TOKEN}"
        if [[ "$DNSTT_RECORDS_MANAGED" == "true" ]]; then
            echo -e "${C_BLUE}🗑️ Removing auto-generated DNS records...${C_RESET}"
            curl -s -X DELETE "https://desec.io/api/v1/domains/$_del_domain/rrsets/$TUNNEL_SUBDOMAIN/NS/" \
                 -H "Authorization: Token $_del_token" > /dev/null
            curl -s -X DELETE "https://desec.io/api/v1/domains/$_del_domain/rrsets/$NS_SUBDOMAIN/A/" \
                 -H "Authorization: Token $_del_token" > /dev/null
            if [[ "$HAS_IPV6" == "true" ]]; then
                curl -s -X DELETE "https://desec.io/api/v1/domains/$_del_domain/rrsets/$NS_SUBDOMAIN/AAAA/" \
                     -H "Authorization: Token $_del_token" > /dev/null
            fi
            echo -e "${C_GREEN}✅ DNS records have been removed.${C_RESET}"
        else
            echo -e "${C_YELLOW}⚠️ DNS records were manually configured. Please delete them from your DNS provider.${C_RESET}"
        fi
    fi
    echo -e "${C_BLUE}🗑️ Removing service files and binaries...${C_RESET}"
    rm -f "$DNSTT_SERVICE_FILE"
    rm -f "$DNSTT_BINARY"
    rm -rf "$DNSTT_KEYS_DIR"
    rm -f "$DNSTT_CONFIG_FILE"
    systemctl daemon-reload
    
    echo -e "${C_YELLOW}ℹ️ Restoring system DNS resolver...${C_RESET}"
    chattr -i /etc/resolv.conf &>/dev/null
    systemctl unmask systemd-resolved &>/dev/null
    systemctl enable systemd-resolved &>/dev/null
    systemctl start systemd-resolved &>/dev/null

    echo -e "\n${C_GREEN}✅ DNSTT has been successfully uninstalled.${C_RESET}"
}

install_falcon_proxy() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🦅 Installing Falcon Proxy (Websockets/Socks) ---${C_RESET}"
    
    if [ -f "$FALCONPROXY_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ Falcon Proxy is already installed.${C_RESET}"
        if [ -f "$FALCONPROXY_CONFIG_FILE" ]; then
            source "$FALCONPROXY_CONFIG_FILE"
            echo -e "   It is configured to run on port(s): ${C_YELLOW}$PORTS${C_RESET}"
            echo -e "   Installed Version: ${C_YELLOW}${INSTALLED_VERSION:-Unknown}${C_RESET}"
        fi
        read -p "👉 Do you want to reinstall/update? (y/n): " confirm_reinstall
        if [[ "$confirm_reinstall" != "y" ]]; then return; fi
    fi

    echo -e "\n${C_BLUE}🌐 Fetching available versions from GitHub...${C_RESET}"
    local releases_json=$(curl -s "https://api.github.com/repos/FirewallFalconsLabs/FirewallFalcon-Manager/releases")
    if [[ -z "$releases_json" || "$releases_json" == "[]" ]]; then
        echo -e "${C_RED}❌ Error: Could not fetch releases. Check internet or API limits.${C_RESET}"
        return
    fi

    # Extract tag names
    mapfile -t versions < <(echo "$releases_json" | jq -r '.[].tag_name')
    
    if [ ${#versions[@]} -eq 0 ]; then
        echo -e "${C_RED}❌ No releases found in the repository.${C_RESET}"
        return
    fi

    echo -e "\n${C_CYAN}Select a version to install:${C_RESET}"
    for i in "${!versions[@]}"; do
        printf "  ${C_GREEN}[%2d]${C_RESET} %s\n" "$((i+1))" "${versions[$i]}"
    done
    echo -e "  ${C_RED} [ 0]${C_RESET} ↩️ Cancel"
    
    local choice
    while true; do
        if ! read -r -p "👉 Enter version number [1]: " choice; then
            echo
            return
        fi
        choice=${choice:-1}
        if [[ "$choice" == "0" ]]; then return; fi
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -le "${#versions[@]}" ]; then
            SELECTED_VERSION="${versions[$((choice-1))]}"
            break
        else
            echo -e "${C_RED}❌ Invalid selection.${C_RESET}"
        fi
    done

    local ports
    read -p "👉 Enter port(s) for Falcon Proxy (e.g., 8080 or 8080 8888) [8080]: " ports
    ports=${ports:-8080}

    local port_array=($ports)
    for port in "${port_array[@]}"; do
        if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
            echo -e "\n${C_RED}❌ Invalid port number: $port. Aborting.${C_RESET}"
            return
        fi
        check_and_free_ports "$port" || return
        check_and_open_firewall_port "$port" tcp || return
    done

    echo -e "\n${C_GREEN}⚙️ Detecting system architecture...${C_RESET}"
    local arch=$(uname -m)
    local binary_name=""
    if [[ "$arch" == "x86_64" ]]; then
        binary_name="falconproxy"
        echo -e "${C_BLUE}ℹ️ Detected x86_64 (amd64) architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        binary_name="falconproxyarm"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Unsupported architecture: $arch. Cannot install Falcon Proxy.${C_RESET}"
        return
    fi
    
    # Construct download URL based on selected version
    local download_url="https://github.com/FirewallFalconsLabs/FirewallFalcon-Manager/releases/download/$SELECTED_VERSION/$binary_name"

    echo -e "\n${C_GREEN}📥 Downloading Falcon Proxy $SELECTED_VERSION ($binary_name)...${C_RESET}"
    wget -q --show-progress -O "$FALCONPROXY_BINARY" "$download_url"
    if [ $? -ne 0 ]; then
        echo -e "\n${C_RED}❌ Failed to download the binary. Please ensure version $SELECTED_VERSION has asset '$binary_name'.${C_RESET}"
        return
    fi
    chmod +x "$FALCONPROXY_BINARY"

    echo -e "\n${C_GREEN}📝 Creating systemd service file...${C_RESET}"
    cat > "$FALCONPROXY_SERVICE_FILE" <<EOF
[Unit]
Description=Falcon Proxy ($SELECTED_VERSION)
After=network.target

[Service]
User=root
Type=simple
ExecStart=$FALCONPROXY_BINARY -p $ports
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF

    echo -e "\n${C_GREEN}💾 Saving configuration...${C_RESET}"
    cat > "$FALCONPROXY_CONFIG_FILE" <<EOF
PORTS="$ports"
INSTALLED_VERSION="$SELECTED_VERSION"
EOF

    echo -e "\n${C_GREEN}▶️ Enabling and starting Falcon Proxy service...${C_RESET}"
    systemctl daemon-reload
    systemctl enable falconproxy.service
    systemctl restart falconproxy.service
    sleep 2
    
    if systemctl is-active --quiet falconproxy; then
        echo -e "\n${C_GREEN}✅ SUCCESS: Falcon Proxy $SELECTED_VERSION is installed and active.${C_RESET}"
        echo -e "   Listening on port(s): ${C_YELLOW}$ports${C_RESET}"
    else
        echo -e "\n${C_RED}❌ ERROR: Falcon Proxy service failed to start.${C_RESET}"
        echo -e "${C_YELLOW}ℹ️ Displaying last 15 lines of the service log for diagnostics:${C_RESET}"
        journalctl -u falconproxy.service -n 15 --no-pager
    fi
}

uninstall_falcon_proxy() {
    echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling Falcon Proxy ---${C_RESET}"
    if [ ! -f "$FALCONPROXY_SERVICE_FILE" ]; then
        echo -e "${C_YELLOW}ℹ️ Falcon Proxy is not installed, skipping.${C_RESET}"
        return
    fi
    echo -e "${C_GREEN}🛑 Stopping and disabling Falcon Proxy service...${C_RESET}"
    systemctl stop falconproxy.service >/dev/null 2>&1
    systemctl disable falconproxy.service >/dev/null 2>&1
    echo -e "${C_GREEN}🗑️ Removing service file...${C_RESET}"
    rm -f "$FALCONPROXY_SERVICE_FILE"
    systemctl daemon-reload
    echo -e "${C_GREEN}🗑️ Removing binary and config files...${C_RESET}"
    rm -f "$FALCONPROXY_BINARY"
    rm -f "$FALCONPROXY_CONFIG_FILE"
    echo -e "${C_GREEN}✅ Falcon Proxy has been uninstalled successfully.${C_RESET}"
}

# --- ZiVPN Installation Logic ---
install_zivpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Installing ZiVPN (UDP/VPN) ---${C_RESET}"
    
    if [ -f "$ZIVPN_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ ZiVPN is already installed.${C_RESET}"
        return
    fi

    if [ ! -f "$BADVPN_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}⚠️ ZiVPN requires the badvpn (udpgw) backend to provide internet access.${C_RESET}"
        echo -e "${C_GREEN}📦 Automatically installing badvpn backend...${C_RESET}"
        sleep 2
        install_badvpn
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Resuming ZiVPN Installation ---${C_RESET}"
    fi

    check_and_free_ports 5667 || return
    check_and_open_firewall_port 5667 udp || return
    check_and_open_firewall_port_range "6000:19999" udp || return

    echo -e "\n${C_GREEN}⚙️ Checking system architecture...${C_RESET}"
    local arch=$(uname -m)
    local zivpn_url=""
    
    if [[ "$arch" == "x86_64" ]]; then
        zivpn_url="https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-amd64"
        echo -e "${C_BLUE}ℹ️ Detected AMD64/x86_64 architecture.${C_RESET}"
    elif [[ "$arch" == "aarch64" ]]; then
        zivpn_url="https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-arm64"
        echo -e "${C_BLUE}ℹ️ Detected ARM64 architecture.${C_RESET}"
    elif [[ "$arch" == "armv7l" || "$arch" == "arm" ]]; then
         zivpn_url="https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-arm"
         echo -e "${C_BLUE}ℹ️ Detected ARM architecture.${C_RESET}"
    else
        echo -e "${C_RED}❌ Unsupported architecture: $arch${C_RESET}"
        return
    fi

    echo -e "\n${C_GREEN}📦 Downloading ZiVPN binary...${C_RESET}"
    if ! wget -q --show-progress -O "$ZIVPN_BIN" "$zivpn_url"; then
        echo -e "${C_RED}❌ Download failed. Check internet connection.${C_RESET}"
        return
    fi
    chmod +x "$ZIVPN_BIN"

    echo -e "\n${C_GREEN}⚙️ Configuring ZIVPN...${C_RESET}"
    mkdir -p "$ZIVPN_DIR"
    
    # Generate Certificates
    echo -e "${C_BLUE}🔐 Generating self-signed certificates...${C_RESET}"
    if ! command -v openssl &>/dev/null; then
        ff_pkg_install openssl >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to install openssl for ZiVPN certificate generation.${C_RESET}"
            return
        }
    fi
    
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=US/ST=California/L=Los Angeles/O=Example Corp/OU=IT Department/CN=zivpn" \
        -keyout "$ZIVPN_KEY_FILE" -out "$ZIVPN_CERT_FILE" 2>/dev/null

    if [ ! -f "$ZIVPN_CERT_FILE" ]; then
        echo -e "${C_RED}❌ Failed to generate certificates.${C_RESET}"
        return
    fi

    # System Tuning
    echo -e "${C_BLUE}🔧 Tuning system network parameters...${C_RESET}"
    sysctl -w net.core.rmem_max=16777216 >/dev/null
    sysctl -w net.core.wmem_max=16777216 >/dev/null

    # Create Service
    echo -e "${C_BLUE}📝 Creating systemd service file...${C_RESET}"
    cat <<EOF > "$ZIVPN_SERVICE_FILE"
[Unit]
Description=zivpn VPN Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$ZIVPN_DIR
ExecStart=$ZIVPN_BIN server -c $ZIVPN_CONFIG_FILE
Restart=always
RestartSec=3
Environment=ZIVPN_LOG_LEVEL=info
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

    # Configure Passwords
    echo -e "\n${C_YELLOW}🔑 ZiVPN Password Setup${C_RESET}"
    read -p "👉 Enter passwords separated by commas (e.g., user1,user2) [Default: 'zi']: " input_config
    
    if [ -n "$input_config" ]; then
        IFS=',' read -r -a config_array <<< "$input_config"
        # Ensure array format for JSON
        json_passwords=$(printf '"%s",' "${config_array[@]}")
        json_passwords="[${json_passwords%,}]"
    else
        json_passwords='["zi"]'
    fi

    # Create Config File
    cat <<EOF > "$ZIVPN_CONFIG_FILE"
{
  "listen": ":5667",
   "cert": "$ZIVPN_CERT_FILE",
   "key": "$ZIVPN_KEY_FILE",
   "obfs":"zivpn",
   "auth": {
    "mode": "passwords", 
    "config": $json_passwords
  }
}
EOF

    echo -e "\n${C_GREEN}🚀 Starting ZiVPN Service...${C_RESET}"
    systemctl daemon-reload
    systemctl enable zivpn.service
    systemctl start zivpn.service

    # Port Forwarding / Firewall
    echo -e "${C_BLUE}🔥 Configuring Firewall Rules (Redirecting 6000-19999 -> 5667)...${C_RESET}"
    
    # Determine primary interface
    local iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
    
    if [ -n "$iface" ]; then
        iptables -t nat -C PREROUTING -i "$iface" -p udp --dport 6000:19999 -j DNAT --to-destination :5667 2>/dev/null || \
            iptables -t nat -A PREROUTING -i "$iface" -p udp --dport 6000:19999 -j DNAT --to-destination :5667
        # Note: IPTables rules are not persistent by default without iptables-persistent package
    else
        echo -e "${C_YELLOW}⚠️ Could not detect default interface for IPTables redirection.${C_RESET}"
    fi

    # Cleanup
    rm -f zi.sh zi2.sh 2>/dev/null

    if systemctl is-active --quiet zivpn.service; then
        echo -e "\n${C_GREEN}✅ ZiVPN Installed Successfully!${C_RESET}"
        echo -e "   - UDP Port: 5667 (Direct)"
        echo -e "   - UDP Ports: 6000-19999 (Forwarded)"
    else
        echo -e "\n${C_RED}❌ ZiVPN Service failed to start. Check logs: journalctl -u zivpn.service${C_RESET}"
    fi
}

uninstall_zivpn() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🗑️ Uninstall ZiVPN ---${C_RESET}"
    
    if [ ! -f "$ZIVPN_SERVICE_FILE" ] && [ ! -f "$ZIVPN_BIN" ]; then
        echo -e "\n${C_YELLOW}ℹ️ ZiVPN does not appear to be installed.${C_RESET}"
        return
    fi

    read -p "👉 Are you sure you want to uninstall ZiVPN? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then echo -e "${C_YELLOW}Cancelled.${C_RESET}"; return; fi

    echo -e "\n${C_BLUE}🛑 Stopping services...${C_RESET}"
    systemctl stop zivpn.service 2>/dev/null
    systemctl disable zivpn.service 2>/dev/null

    local iface
    iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
    if [ -n "$iface" ]; then
        iptables -t nat -D PREROUTING -i "$iface" -p udp --dport 6000:19999 -j DNAT --to-destination :5667 2>/dev/null || true
    fi
    
    echo -e "${C_BLUE}🗑️ Removing files...${C_RESET}"
    rm -f "$ZIVPN_SERVICE_FILE"
    rm -rf "$ZIVPN_DIR"
    rm -f "$ZIVPN_BIN"
    
    systemctl daemon-reload
    
    # Clean cache (from original uninstall script logic)
    echo -e "${C_BLUE}🧹 Cleaning memory cache...${C_RESET}"
    sync; echo 3 > /proc/sys/vm/drop_caches

    echo -e "\n${C_GREEN}✅ ZiVPN Uninstalled Successfully.${C_RESET}"
}

purge_nginx() {
    local mode="$1"
    if [[ "$mode" != "silent" ]]; then
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🔥 Purge Internal Nginx Proxy ---${C_RESET}"
        if ! command -v nginx &> /dev/null; then
            rm -f "$NGINX_PORTS_FILE"
            echo -e "\n${C_YELLOW}ℹ️ Nginx is not installed. Nothing to do.${C_RESET}"
            return
        fi
        echo -e "\n${C_YELLOW}⚠️ This removes the internal Nginx proxy on ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"
        if systemctl is-active --quiet haproxy; then
            echo -e "${C_YELLOW}⚠️ HAProxy will stay installed, but web payload routing from ${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT} will stop until you reinstall the stack.${C_RESET}"
        fi
        read -p "👉 Continue and purge Nginx? (y/n): " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
            return
        fi
    fi
    echo -e "\n${C_BLUE}🛑 Stopping Nginx service...${C_RESET}"
    systemctl stop nginx >/dev/null 2>&1
    systemctl disable nginx >/dev/null 2>&1
    echo -e "\n${C_BLUE}🗑️ Purging Nginx packages...${C_RESET}"
    ff_pkg_purge nginx nginx-common >/dev/null 2>&1
    ff_pkg_autoremove
    echo -e "\n${C_BLUE}🗑️ Removing leftover files...${C_RESET}"
    rm -f /etc/ssl/certs/nginx-selfsigned.pem
    rm -f /etc/ssl/private/nginx-selfsigned.key
    rm -rf /etc/nginx
    rm -f "${NGINX_CONFIG_FILE}.bak"
    rm -f "${NGINX_CONFIG_FILE}.bak.certbot"
    rm -f "${NGINX_CONFIG_FILE}.bak.selfsigned"
    rm -f "${NGINX_CONFIG_FILE}.bak.firewallfalcon"
    rm -f "$NGINX_PORTS_FILE"
    if [[ "$mode" != "silent" ]]; then
        echo -e "\n${C_GREEN}✅ Internal Nginx proxy purged. Shared Mohammad Ahmad VPN Manager certificates were kept.${C_RESET}"
    fi
}

install_nginx_proxy() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Reconfiguring Internal Nginx Proxy (8880/8443) ---${C_RESET}"
    echo -e "\n${C_CYAN}This keeps HAProxy on ${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT} and rewrites the internal Nginx proxy on ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"

    if [ ! -s "$SSL_CERT_FILE" ] || [ ! -s "$SSL_CERT_CHAIN_FILE" ] || [ ! -s "$SSL_CERT_KEY_FILE" ]; then
        echo -e "\n${C_YELLOW}⚠️ No shared Mohammad Ahmad VPN Manager certificate was found.${C_RESET}"
        echo -e "${C_DIM}Running the full HAProxy edge installer so the certificate and both services stay aligned.${C_RESET}"
        install_ssl_tunnel
        return
    fi

    mkdir -p "$DB_DIR" "$SSL_CERT_DIR"
    ensure_edge_stack_packages || return

    systemctl stop haproxy >/dev/null 2>&1
    systemctl stop nginx >/dev/null 2>&1
    sleep 1

    check_and_free_ports \
        "$EDGE_PUBLIC_HTTP_PORT" \
        "$EDGE_PUBLIC_TLS_PORT" \
        "$NGINX_INTERNAL_HTTP_PORT" \
        "$NGINX_INTERNAL_TLS_PORT" \
        "$HAPROXY_INTERNAL_DECRYPT_PORT" || return

    check_and_open_firewall_port "$EDGE_PUBLIC_HTTP_PORT" tcp || return
    check_and_open_firewall_port "$EDGE_PUBLIC_TLS_PORT" tcp || return

    load_edge_cert_info
    local server_name="${EDGE_DOMAIN:-$(detect_preferred_host)}"
    [[ -z "$server_name" ]] && server_name="_"

    configure_edge_stack "$server_name" || return

    echo -e "\n${C_GREEN}✅ Internal Nginx proxy reconfigured successfully.${C_RESET}"
    echo -e "   • Public HAProxy edge: ${C_YELLOW}${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT}${C_RESET}"
    echo -e "   • Internal Nginx: ${C_YELLOW}${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}${C_RESET}"
}

request_certbot_ssl() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔒 Shared Certbot Certificate (HAProxy + Nginx) ---${C_RESET}"
    echo -e "\n${C_DIM}This will replace the shared certificate used by HAProxy on ${EDGE_PUBLIC_TLS_PORT} and internal Nginx on ${NGINX_INTERNAL_TLS_PORT}.${C_RESET}"

    mkdir -p "$DB_DIR" "$SSL_CERT_DIR"
    ensure_edge_stack_packages || return
    load_edge_cert_info

    local preferred_host
    local default_domain=""
    local domain_name
    local email

    preferred_host=$(detect_preferred_host)
    if [[ -n "$EDGE_DOMAIN" ]] && ! _is_valid_ipv4 "$EDGE_DOMAIN"; then
        default_domain="$EDGE_DOMAIN"
    elif [[ -n "$preferred_host" ]] && ! _is_valid_ipv4 "$preferred_host"; then
        default_domain="$preferred_host"
    fi

    if [[ -n "$default_domain" ]]; then
        read -p "👉 Enter your domain name [$default_domain]: " domain_name
        domain_name=${domain_name:-$default_domain}
    else
        read -p "👉 Enter your domain name (e.g. vpn.example.com): " domain_name
    fi
    if [[ -z "$domain_name" ]]; then
        echo -e "\n${C_RED}❌ Domain name cannot be empty.${C_RESET}"
        return
    fi
    if _is_valid_ipv4 "$domain_name"; then
        echo -e "\n${C_RED}❌ Certbot requires a real domain name, not a raw IP address.${C_RESET}"
        return
    fi

    read -p "👉 Enter your email for Let's Encrypt [${EDGE_EMAIL}]: " email
    email=${email:-$EDGE_EMAIL}
    if [[ -z "$email" ]]; then
        echo -e "\n${C_RED}❌ Email address cannot be empty.${C_RESET}"
        return
    fi

    check_and_open_firewall_port "$EDGE_PUBLIC_HTTP_PORT" tcp || return
    check_and_open_firewall_port "$EDGE_PUBLIC_TLS_PORT" tcp || return

    obtain_certbot_edge_cert "$domain_name" "$email" || return
    configure_edge_stack "$domain_name" || return

    echo -e "\n${C_GREEN}✅ Shared Certbot certificate applied successfully.${C_RESET}"
    echo -e "   • Domain: ${C_YELLOW}${domain_name}${C_RESET}"
    echo -e "   • Public edge: ${C_YELLOW}${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT}${C_RESET}"
}

nginx_proxy_menu() {
    while true; do
    show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🌐 Internal Nginx Proxy Management ---${C_RESET}"

    local nginx_status="${C_STATUS_I}Inactive${C_RESET}"
    local haproxy_status="${C_STATUS_I}Inactive${C_RESET}"
    if systemctl is-active --quiet nginx; then
        nginx_status="${C_STATUS_A}Active${C_RESET}"
    fi
    if systemctl is-active --quiet haproxy; then
        haproxy_status="${C_STATUS_A}Active${C_RESET}"
    fi

    load_edge_cert_info
    local cert_info="${EDGE_CERT_MODE:-Not configured}"
    if [[ -n "$EDGE_DOMAIN" ]]; then
        cert_info="${cert_info} - ${EDGE_DOMAIN}"
    fi

    echo -e "\n${C_WHITE}Nginx:${C_RESET} ${nginx_status}"
    echo -e "${C_WHITE}HAProxy:${C_RESET} ${haproxy_status}"
    echo -e "${C_DIM}Public Edge: ${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT} | Internal Nginx: ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}${C_RESET}"
    echo -e "${C_DIM}Shared Certificate: ${cert_info}${C_RESET}"

    echo -e "\n${C_BOLD}Select an action:${C_RESET}\n"
    
    if systemctl is-active --quiet nginx; then
         printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🛑 Stop Nginx Service"
         printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔄 Restart HAProxy + Nginx Stack"
         printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "⚙️ Re-install/Re-configure Edge Stack"
         printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "🔒 Switch/Renew Shared SSL (Certbot)"
         printf "  ${C_CHOICE}[ 5]${C_RESET} %-40s\n" "🔥 Uninstall/Purge Nginx"
    else
         printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "▶️ Start Nginx Service"
         printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "⚙️ Install/Configure Edge Stack"
         printf "  ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "🔒 Switch/Renew Shared SSL (Certbot)"
         printf "  ${C_CHOICE}[ 5]${C_RESET} %-40s\n" "🔥 Uninstall/Purge Nginx"
    fi

    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
        echo
        return
    fi
    
    case $choice in
        1) 
            if systemctl is-active --quiet nginx; then
                echo -e "\n${C_BLUE}🛑 Stopping Nginx...${C_RESET}"
                systemctl stop nginx
                echo -e "${C_GREEN}✅ Nginx stopped.${C_RESET}"
                if systemctl is-active --quiet haproxy; then
                    echo -e "${C_YELLOW}⚠️ HAProxy is still running, but web traffic that depends on internal Nginx will not work until Nginx starts again.${C_RESET}"
                fi
            else
                echo -e "\n${C_BLUE}▶️ Starting Nginx...${C_RESET}"
                systemctl start nginx
                if systemctl is-active --quiet nginx; then
                    echo -e "${C_GREEN}✅ Nginx started.${C_RESET}"
                else
                    echo -e "${C_RED}❌ Failed to start Nginx.${C_RESET}"
                fi
            fi
            press_enter
            ;;
        2)
            echo -e "\n${C_BLUE}🔄 Restarting Nginx and HAProxy...${C_RESET}"
            local restart_ok=true
            systemctl restart nginx || restart_ok=false
            if command -v haproxy &> /dev/null; then
                systemctl restart haproxy || restart_ok=false
            else
                restart_ok=false
            fi
            if $restart_ok && systemctl is-active --quiet nginx && systemctl is-active --quiet haproxy; then
                echo -e "${C_GREEN}✅ HAProxy + Nginx stack restarted.${C_RESET}"
            else
                echo -e "${C_RED}❌ One or more services failed to restart.${C_RESET}"
            fi
            press_enter
            ;;
        3) 
             install_nginx_proxy; press_enter
             ;;
        4)
             request_certbot_ssl; press_enter
             ;;
        5)
             purge_nginx; press_enter
             ;;
        0) return ;;
        *) invalid_option ;;
    esac
    done
}

install_panel_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 💻 Install X-UI / 3X-UI Panel ---${C_RESET}"
    echo -e "\n${C_CYAN}Select which panel to install:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-45s %s\n" "🚀 3X-UI Panel (MHSanaei)" "${C_STATUS_A}⭐ Default${C_RESET}"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-45s %s\n" "📦 X-UI Panel (alireza0)" ""
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ❌ Cancel"
    echo
    read -p "👉 Select panel [1]: " panel_choice
    panel_choice=${panel_choice:-1}
    case $panel_choice in
        1) install_3xui_panel ;;
        2) install_xui_panel ;;
        0) echo -e "\n${C_YELLOW}❌ Installation cancelled.${C_RESET}" ;;
        *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" ;;
    esac
}

install_3xui_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚀 Install 3X-UI Panel ---${C_RESET}"
    echo -e "\nThis will download and run the official installation script for 3X-UI (MHSanaei)."
    echo -e "Choose an installation option:\n"
    printf "  ${C_GREEN}[ 1]${C_RESET} %-40s\n" "Install the latest version of 3X-UI"
    printf "  ${C_GREEN}[ 2]${C_RESET} %-40s\n" "Install a specific version of 3X-UI"
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ❌ Cancel Installation"
    echo
    read -p "👉 Select an option: " choice
    case $choice in
        1)
            echo -e "\n${C_BLUE}⚙️ Installing the latest version...${C_RESET}"
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
            ;;
        2)
            read -p "👉 Enter the version to install (e.g., 2.4.5): " version
            if [[ -z "$version" ]]; then
                echo -e "\n${C_RED}❌ Version number cannot be empty.${C_RESET}"
                return
            fi
            echo -e "\n${C_BLUE}⚙️ Installing version ${C_YELLOW}$version...${C_RESET}"
            bash <(curl -Ls "https://raw.githubusercontent.com/mhsanaei/3x-ui/v$version/install.sh") "v$version"
            ;;
        0)
            echo -e "\n${C_YELLOW}❌ Installation cancelled.${C_RESET}"
            ;;
        *)
            echo -e "\n${C_RED}❌ Invalid option.${C_RESET}"
            ;;
    esac
}

install_xui_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📦 Install X-UI Panel (Legacy) ---${C_RESET}"
    echo -e "\nThis will download and run the installation script for X-UI (alireza0)."
    echo -e "Choose an installation option:\n"
    printf "  ${C_GREEN}[ 1]${C_RESET} %-40s\n" "Install the latest version of X-UI"
    printf "  ${C_GREEN}[ 2]${C_RESET} %-40s\n" "Install a specific version of X-UI"
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ❌ Cancel Installation"
    echo
    read -p "👉 Select an option: " choice
    case $choice in
        1)
            echo -e "\n${C_BLUE}⚙️ Installing the latest version...${C_RESET}"
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            ;;
        2)
            read -p "👉 Enter the version to install (e.g., 1.8.0): " version
            if [[ -z "$version" ]]; then
                echo -e "\n${C_RED}❌ Version number cannot be empty.${C_RESET}"
                return
            fi
            echo -e "\n${C_BLUE}⚙️ Installing version ${C_YELLOW}$version...${C_RESET}"
            VERSION=$version bash <(curl -Ls "https://raw.githubusercontent.com/alireza0/x-ui/$version/install.sh") "$version"
            ;;
        0)
            echo -e "\n${C_YELLOW}❌ Installation cancelled.${C_RESET}"
            ;;
        *)
            echo -e "\n${C_RED}❌ Invalid option.${C_RESET}"
            ;;
    esac
}

uninstall_xui_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🗑️ Uninstall X-UI / 3X-UI Panel ---${C_RESET}"
    if ! command -v x-ui &> /dev/null; then
        echo -e "\n${C_YELLOW}ℹ️ No X-UI/3X-UI panel appears to be installed.${C_RESET}"
        return
    fi
    read -p "👉 Are you sure you want to thoroughly uninstall X-UI/3X-UI? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        echo -e "\n${C_BLUE}⚙️ Running the default uninstaller first...${C_RESET}"
        x-ui uninstall >/dev/null 2>&1
        echo -e "\n${C_BLUE}🧹 Performing a full cleanup to ensure complete removal...${C_RESET}"
        echo " - Stopping and disabling x-ui service..."
        systemctl stop x-ui >/dev/null 2>&1
        systemctl disable x-ui >/dev/null 2>&1
        echo " - Removing x-ui files and directories..."
        rm -f /etc/systemd/system/x-ui.service
        rm -f /usr/local/bin/x-ui
        rm -rf /usr/local/x-ui/
        rm -rf /etc/x-ui/
        echo " - Reloading systemd daemon..."
        systemctl daemon-reload
        echo -e "\n${C_GREEN}✅ X-UI/3X-UI has been thoroughly uninstalled.${C_RESET}"
    else
        echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
    fi
}

refresh_ssh_session_cache() {
    local now db_mtime
    printf -v now '%(%s)T' -1
    db_mtime=$(stat -c %Y "$DB_FILE" 2>/dev/null || echo 0)

    if (( SSH_SESSION_CACHE_TS > 0 && now - SSH_SESSION_CACHE_TS < SSH_SESSION_CACHE_TTL && db_mtime == SSH_SESSION_CACHE_DB_MTIME )); then
        return
    fi

    SSH_SESSION_COUNTS=()
    SSH_SESSION_PIDS=()
    SSH_SESSION_TOTAL=0
    SSH_SESSION_CACHE_DB_MTIME=$db_mtime

    if [[ ! -s "$DB_FILE" ]]; then
        SSH_SESSION_CACHE_TS=$now
        return
    fi

    local -A managed_user_lookup=()
    local -A uid_user_lookup=()
    local -A session_pids=()
    local -A loginuid_pids=()
    local managed_user system_user system_uid ssh_pid ssh_owner candidate_user login_uid

    while IFS=: read -r managed_user _rest; do
        [[ -n "$managed_user" && "$managed_user" != \#* ]] && managed_user_lookup["$managed_user"]=1
    done < "$DB_FILE"

    while IFS=: read -r system_user _ system_uid _rest; do
        [[ -n "$system_user" && "$system_uid" =~ ^[0-9]+$ ]] && uid_user_lookup["$system_uid"]="$system_user"
    done < /etc/passwd

    while read -r ssh_pid ssh_owner; do
        [[ "$ssh_pid" =~ ^[0-9]+$ ]] || continue

        # Method 1: process owner matches a managed user directly
        if [[ -n "$ssh_owner" && "$ssh_owner" != "root" && "$ssh_owner" != "sshd" && -n "${managed_user_lookup[$ssh_owner]+x}" ]]; then
            session_pids["$ssh_owner"]+="$ssh_pid "
        fi
    done < <(ps -C sshd,sshd-session -o pid=,user= 2>/dev/null)

    # Method 2: kernel loginuid with comm/PPid validation (more robust — matches limiter logic)
    local p pid_dir pid_num comm ppid_val session_user
    for p in /proc/[0-9]*/loginuid; do
        [[ -f "$p" ]] || continue
        login_uid=""
        read -r login_uid < "$p" || login_uid=""
        [[ "$login_uid" =~ ^[0-9]+$ && "$login_uid" != "4294967295" ]] || continue

        candidate_user="${uid_user_lookup[$login_uid]}"
        [[ -n "$candidate_user" && -n "${managed_user_lookup[$candidate_user]+x}" ]] || continue

        pid_dir=$(dirname "$p")
        pid_num=$(basename "$pid_dir")
        comm=""
        read -r comm < "$pid_dir/comm" 2>/dev/null || comm=""
        [[ "$comm" == "sshd" || "$comm" == "sshd-session" ]] || continue

        # Filter out the master sshd process (PPid=1)
        ppid_val=""
        while read -r key value; do
            [[ "$key" == "PPid:" ]] && { ppid_val="$value"; break; }
        done < "$pid_dir/status" 2>/dev/null
        [[ "$ppid_val" == "1" ]] && continue

        loginuid_pids["$candidate_user"]+="$pid_num "
    done

    local user pid
    for user in "${!managed_user_lookup[@]}"; do
        # CRITICAL: unset before declare to reset per-user (bash declare is function-scoped)
        unset unique_pids
        local -A unique_pids=()

        # Use ONLY ps-based session_pids for accurate counting.
        # loginuid_pids can double-count (root-owned sshd has user's loginuid on Ubuntu 24)
        for pid in ${session_pids[$user]}; do
            [[ "$pid" =~ ^[0-9]+$ ]] && unique_pids["$pid"]=1
        done

        SSH_SESSION_COUNTS["$user"]=${#unique_pids[@]}
        if (( ${#unique_pids[@]} > 0 )); then
            for pid in "${!unique_pids[@]}"; do
                SSH_SESSION_PIDS["$user"]+="$pid "
            done
            SSH_SESSION_TOTAL=$((SSH_SESSION_TOTAL + ${#unique_pids[@]}))
        fi
    done

    SSH_SESSION_CACHE_TS=$now
}

count_managed_online_sessions() {
    refresh_ssh_session_cache
    echo "$SSH_SESSION_TOTAL"
}

invalidate_banner_cache() {
    BANNER_CACHE_TS=0
    SSH_SESSION_CACHE_TS=0
}

refresh_banner_cache() {
    local now
    printf -v now '%(%s)T' -1
    if (( BANNER_CACHE_TS > 0 && now - BANNER_CACHE_TS < BANNER_CACHE_TTL )); then
        return
    fi

    if [[ -z "$BANNER_CACHE_OS_NAME" ]]; then
        BANNER_CACHE_OS_NAME=$(grep -oP 'PRETTY_NAME="\K[^"]+' /etc/os-release 2>/dev/null || echo "Linux")
    fi
    BANNER_CACHE_UP_TIME=$(uptime -p 2>/dev/null | sed 's/up //' || echo "unknown")
    BANNER_CACHE_RAM_USAGE=$(free -m | awk '/^Mem:/{if($2>0){printf "%.2f", $3*100/$2}else{print "0.00"}}')
    BANNER_CACHE_CPU_LOAD=$(awk '{print $1}' /proc/loadavg 2>/dev/null)
    if [[ -s "$DB_FILE" ]]; then
        BANNER_CACHE_TOTAL_USERS=0
        while IFS=: read -r _u _rest; do
            [[ -n "$_u" && "$_u" != \#* ]] && (( BANNER_CACHE_TOTAL_USERS++ ))
        done < "$DB_FILE"
    else
        BANNER_CACHE_TOTAL_USERS=0
    fi
    BANNER_CACHE_ONLINE_USERS=$(count_managed_online_sessions)
    BANNER_CACHE_TS=$now
}

show_banner() {
    refresh_banner_cache
    [[ -t 1 ]] && clear
    echo
    echo -e "${C_TITLE}   Mohammad Ahmad VPN Manager Manager ${C_RESET}${C_DIM}| v4.0.0 Premium Edition${C_RESET}"
    echo -e "${C_BLUE}   ─────────────────────────────────────────────────────────${C_RESET}"
    printf "   ${C_GRAY}%-10s${C_RESET} %-20s ${C_GRAY}|${C_RESET} %s\n" "OS" "$BANNER_CACHE_OS_NAME" "Uptime: $BANNER_CACHE_UP_TIME"
    printf "   ${C_GRAY}%-10s${C_RESET} %-20s ${C_GRAY}|${C_RESET} %s\n" "Memory" "${BANNER_CACHE_RAM_USAGE}% Used" "Online Sessions: ${C_WHITE}${BANNER_CACHE_ONLINE_USERS}${C_RESET}"
    printf "   ${C_GRAY}%-10s${C_RESET} %-20s ${C_GRAY}|${C_RESET} %s\n" "Users" "${BANNER_CACHE_TOTAL_USERS} Managed Accounts" "Sys Load (1m): ${C_GREEN}${BANNER_CACHE_CPU_LOAD}${C_RESET}"
    echo -e "${C_BLUE}   ─────────────────────────────────────────────────────────${C_RESET}"
}

protocol_menu() {
    while true; do
        show_banner
        local badvpn_status; if systemctl is-active --quiet badvpn; then badvpn_status="${C_STATUS_A}(Active)${C_RESET}"; else badvpn_status="${C_STATUS_I}(Inactive)${C_RESET}"; fi
        local udp_custom_status; if systemctl is-active --quiet udp-custom; then udp_custom_status="${C_STATUS_A}(Active)${C_RESET}"; else udp_custom_status="${C_STATUS_I}(Inactive)${C_RESET}"; fi
        local zivpn_status; if systemctl is-active --quiet zivpn.service; then zivpn_status="${C_STATUS_A}(Active)${C_RESET}"; else zivpn_status="${C_STATUS_I}(Inactive)${C_RESET}"; fi
        
        local ssl_tunnel_text="HAProxy Edge Stack (80/443)"
        local ssl_tunnel_status="${C_STATUS_I}(Inactive)${C_RESET}"
        if systemctl is-active --quiet haproxy; then
            ssl_tunnel_status="${C_STATUS_A}(Active)${C_RESET}"
        fi
        
        local dnstt_status; if systemctl is-active --quiet dnstt.service; then dnstt_status="${C_STATUS_A}(Active)${C_RESET}"; else dnstt_status="${C_STATUS_I}(Inactive)${C_RESET}"; fi
        
        local falconproxy_status="${C_STATUS_I}(Inactive)${C_RESET}"
        local falconproxy_ports=""
        if systemctl is-active --quiet falconproxy; then
            if [ -f "$FALCONPROXY_CONFIG_FILE" ]; then source "$FALCONPROXY_CONFIG_FILE"; fi
            falconproxy_ports=" ($PORTS)"
            falconproxy_status="${C_STATUS_A}(Active - ${INSTALLED_VERSION:-latest})${C_RESET}"
        fi

        local nginx_status; if systemctl is-active --quiet nginx; then nginx_status="${C_STATUS_A}(Active)${C_RESET}"; else nginx_status="${C_STATUS_I}(Inactive)${C_RESET}"; fi
        local xui_status; if command -v x-ui &> /dev/null; then xui_status="${C_STATUS_A}(Installed)${C_RESET}"; else xui_status="${C_STATUS_I}(Not Installed)${C_RESET}"; fi  # 3X-UI uses same 'x-ui' binary name
        
        echo -e "\n   ${C_TITLE}══════════════[ ${C_BOLD}🔌 PROTOCOL & PANEL MANAGEMENT ${C_RESET}${C_TITLE}]══════════════${C_RESET}"
        echo -e "     ${C_ACCENT}--- TUNNELLING PROTOCOLS---${C_RESET}"
        printf "     ${C_CHOICE}[ 1]${C_RESET} %-45s %s\n" "🚀 Install badvpn (UDP 7300)" "$badvpn_status"
        printf "     ${C_CHOICE}[ 2]${C_RESET} %-45s\n" "🗑️ Uninstall badvpn"
        printf "     ${C_CHOICE}[ 3]${C_RESET} %-45s %s\n" "🚀 Install udp-custom" "$udp_custom_status"
        printf "     ${C_CHOICE}[ 4]${C_RESET} %-45s\n" "🗑️ Uninstall udp-custom"
        printf "     ${C_CHOICE}[ 5]${C_RESET} %-45s %s\n" "🔒 Install ${ssl_tunnel_text}" "$ssl_tunnel_status"
        printf "     ${C_CHOICE}[ 6]${C_RESET} %-45s\n" "🗑️ Uninstall HAProxy Edge Stack"
        printf "     ${C_CHOICE}[ 7]${C_RESET} %-45s %s\n" "📡 Install/View DNSTT (Port 53)" "$dnstt_status"
        printf "     ${C_CHOICE}[ 8]${C_RESET} %-45s\n" "🗑️ Uninstall DNSTT"
        printf "     ${C_CHOICE}[ 9]${C_RESET} %-45s %s\n" "🦅 Install Falcon Proxy (Select Version)" "$falconproxy_status"
        printf "     ${C_CHOICE}[10]${C_RESET} %-45s\n" "🗑️ Uninstall Falcon Proxy"
        printf "     ${C_CHOICE}[11]${C_RESET} %-45s %s\n" "🌐 Install/Manage Internal Nginx (8880/8443)" "$nginx_status"
        printf "     ${C_CHOICE}[14]${C_RESET} %-45s %s\n" "🛡️ Install ZiVPN (UDP 5667)" "$zivpn_status"
        printf "     ${C_CHOICE}[15]${C_RESET} %-45s\n" "🗑️ Uninstall ZiVPN"
        
        echo -e "     ${C_ACCENT}--- 💻 MANAGEMENT PANELS ---${C_RESET}"
        printf "     ${C_CHOICE}[12]${C_RESET} %-45s %s\n" "💻 Install X-UI / 3X-UI Panel" "$xui_status"
        printf "     ${C_CHOICE}[13]${C_RESET} %-45s\n" "🗑️ Uninstall X-UI / 3X-UI Panel"
        
        echo -e "   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
            echo
            return
        fi
        case $choice in
            1) install_badvpn; press_enter ;; 2) uninstall_badvpn; press_enter ;;
            3) install_udp_custom; press_enter ;; 4) uninstall_udp_custom; press_enter ;;
            5) install_ssl_tunnel; press_enter ;; 6) uninstall_ssl_tunnel; press_enter ;;
            7) install_dnstt; press_enter ;; 8) uninstall_dnstt; press_enter ;;
            9) install_falcon_proxy; press_enter ;; 10) uninstall_falcon_proxy; press_enter ;;
            11) nginx_proxy_menu ;;
            12) install_panel_menu; press_enter ;; 13) uninstall_xui_panel; press_enter ;;
            14) install_zivpn; press_enter ;; 15) uninstall_zivpn; press_enter ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}


# ====================================================================
# --- Web Control Panel Functions ---
# ====================================================================

install_web_panel() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🌐 Installing Web Control Panel ---${C_RESET}"
    
    if [ -f "$PANEL_SERVICE_FILE" ]; then
        echo -e "\n${C_YELLOW}ℹ️ Web Panel is already installed.${C_RESET}"
        show_panel_credentials
        return
    fi
    
    # Check Python 3
    if ! command -v python3 &>/dev/null; then
        echo -e "${C_RED}❌ Python 3 is required but not installed.${C_RESET}"
        echo -e "${C_YELLOW}Installing python3...${C_RESET}"
        ff_pkg_install python3 || { echo -e "${C_RED}❌ Failed to install python3.${C_RESET}"; return; }
    fi
    
    echo -e "${C_BLUE}🔎 Checking if port $PANEL_PORT is available...${C_RESET}"
    check_and_free_ports "$PANEL_PORT" || return
    check_and_open_firewall_port "$PANEL_PORT" tcp || return
    
    # Generate random credentials and secret URL path
    local panel_user
    panel_user=$(tr -dc 'a-z' < /dev/urandom | head -c 4)$(tr -dc '0-9' < /dev/urandom | head -c 4)
    local panel_pass
    panel_pass=$(tr -dc 'A-Za-z0-9@#$' < /dev/urandom | head -c 16)
    local panel_pass_hash
    panel_pass_hash=$(echo -n "$panel_pass" | sha256sum | awk '{print $1}')
    local panel_secret
    panel_secret="panel_$(tr -dc 'a-z0-9' < /dev/urandom | head -c 8)"
    
    echo -e "${C_BLUE}📥 Installing panel files...${C_RESET}"
    mkdir -p "$PANEL_HTML_DIR"

    # Write backend (bundled locally — no external download needed)
    cat > "$PANEL_SCRIPT" << '__NG_PANEL_PY_EOF__'
#!/usr/bin/env python3
import os
import sys
import json
import time
import subprocess
import secrets
import hashlib
import threading
import re
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
from http import cookies
from urllib.parse import urlparse, parse_qs
from datetime import datetime, timedelta

# --- CONSTANTS ---
DB_FILE = "/etc/firewallfalcon/users.db"
RESELLERS_DB = "/etc/firewallfalcon/resellers.db"
BW_DIR = "/etc/firewallfalcon/bandwidth"
PANEL_CONF = "/etc/firewallfalcon/panel.conf"
PANEL_HTML = "/etc/firewallfalcon/panel/index.html"
FF_USERS_GROUP = "firewallfalcon-users"
PORT = 44380

# --- GLOBAL STATE ---
SESSION_FILE = "/etc/firewallfalcon/sessions.json"
sessions = {}  # token -> {"username": str, "role": "admin"|"reseller", "created_at": float}

def load_sessions():
    global sessions
    try:
        if os.path.exists(SESSION_FILE):
            with open(SESSION_FILE, "r") as f:
                sessions = json.load(f)
    except Exception:
        sessions = {}

def save_sessions():
    try:
        os.makedirs(os.path.dirname(SESSION_FILE), exist_ok=True)
        with open(SESSION_FILE, "w") as f:
            json.dump(sessions, f)
    except Exception:
        pass

load_sessions()
db_lock = threading.Lock()

PROTOCOLS = [
    {"name": "OpenSSH", "service": "sshd", "service_alt": "ssh", "check_file": None, "port": "22"},
    {"name": "BadVPN (UDPGW)", "service": "badvpn", "check_file": "/etc/systemd/system/badvpn.service", "port": "7300"},
    {"name": "UDP Custom", "service": "udp-custom", "check_file": "/etc/systemd/system/udp-custom.service", "port": "36712"},
    {"name": "HAProxy Edge", "service": "haproxy", "check_file": "/etc/haproxy/haproxy.cfg", "port": "80/443"},
    {"name": "Nginx Proxy", "service": "nginx", "check_file": "/etc/nginx/sites-available/default", "port": "8880/8443"},
    {"name": "DNSTT (SlowDNS)", "service": "dnstt", "check_file": "/etc/systemd/system/dnstt.service", "port": "53"},
    {"name": "Falcon Proxy", "service": "falconproxy", "check_file": "/etc/systemd/system/falconproxy.service", "port": "8080"},
    {"name": "ZiVPN", "service": "zivpn", "check_file": "/etc/systemd/system/zivpn.service", "port": "5667"},
    {"name": "X-UI / 3X-UI", "service": "x-ui", "check_file": "/etc/systemd/system/x-ui.service", "port": "2053"},
]

# --- UTILS ---
def run_cmd(cmd_args, ignore_errors=False):
    try:
        if isinstance(cmd_args, str):
            res = subprocess.run(cmd_args, shell=True, capture_output=True, text=True, timeout=10)
        else:
            res = subprocess.run(cmd_args, capture_output=True, text=True, timeout=10)
        if not ignore_errors and res.returncode != 0:
            print(f"Command error: {cmd_args} -> {res.stderr}", file=sys.stderr)
        return res.returncode, res.stdout.strip(), res.stderr.strip()
    except Exception as e:
        print(f"Exception running command {cmd_args}: {e}", file=sys.stderr)
        return -1, "", str(e)

def force_delete_system_user(username):
    """Kill all processes and force-delete a Linux system user."""
    import time as _time
    # Kill all processes owned by this user
    run_cmd(["pkill", "-9", "-u", username], ignore_errors=True)
    run_cmd(["killall", "-u", username, "-9"], ignore_errors=True)
    _time.sleep(0.5)
    # Force delete with retry
    code, _, _ = run_cmd(["userdel", "-rf", username], ignore_errors=True)
    if code != 0:
        # Retry after killing harder
        run_cmd(["pkill", "-9", "-u", username], ignore_errors=True)
        _time.sleep(1)
        run_cmd(["userdel", "-rf", username], ignore_errors=True)

# --- USERS DB ---
def parse_db_line(line):
    parts = line.strip().split(":")
    if len(parts) < 5:
        return None
    user = {
        "username": parts[0],
        "password": parts[1],
        "expire_date": parts[2],
        "conn_limit": int(parts[3]) if parts[3].isdigit() else 1,
        "bandwidth_gb": float(parts[4]),
        "daily_bandwidth_gb": 0.0,
        "account_type": "",
        "owner": "admin"
    }
    if len(parts) > 5:
        try:
            user["daily_bandwidth_gb"] = float(parts[5])
        except ValueError:
            user["daily_bandwidth_gb"] = 0.0
    if len(parts) > 6:
        user["account_type"] = parts[6]
    if len(parts) > 7:
        user["owner"] = parts[7] if parts[7] else "admin"
    return user

def read_db():
    users = []
    if not os.path.exists(DB_FILE):
        return users
    with open(DB_FILE, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            u = parse_db_line(line)
            if u:
                users.append(u)
    return users

def _fmt_bw(v):
    """Format bandwidth: 0.0 -> '0', 3.5 -> '3.5', 10.0 -> '10'"""
    f = float(v)
    return str(int(f)) if f == int(f) else str(f)

def format_db_line(u):
    bw = _fmt_bw(u.get('bandwidth_gb', 0))
    dbw = _fmt_bw(u.get('daily_bandwidth_gb', 0))
    owner = u.get('owner', 'admin')
    return f"{u['username']}:{u['password']}:{u['expire_date']}:{u['conn_limit']}:{bw}:{dbw}:{u.get('account_type','web')}:{owner}\n"

# --- RESELLERS DB ---
def parse_reseller_line(line):
    parts = line.strip().split(":")
    if len(parts) < 5:
        return None
    return {
        "username": parts[0],
        "password": parts[1],
        "expire_date": parts[2],
        "max_users": int(parts[3]) if parts[3].isdigit() else 10,
        "enabled": parts[4] == "1"
    }

def read_resellers():
    resellers = []
    if not os.path.exists(RESELLERS_DB):
        return resellers
    with open(RESELLERS_DB, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            r = parse_reseller_line(line)
            if r:
                resellers.append(r)
    return resellers

def format_reseller_line(r):
    enabled = "1" if r.get("enabled", True) else "0"
    return f"{r['username']}:{r['password']}:{r['expire_date']}:{r['max_users']}:{enabled}\n"

def write_resellers(resellers):
    os.makedirs(os.path.dirname(RESELLERS_DB), exist_ok=True)
    with open(RESELLERS_DB, "w") as f:
        for r in resellers:
            f.write(format_reseller_line(r))

# --- ONLINE SESSIONS ---
def get_online_sessions(target_user=None):
    managed_users = set(u["username"] for u in read_db())
    if target_user and target_user not in managed_users:
        return 0
    
    user_pids = {}
    try:
        code, out, _ = run_cmd(["ps", "-C", "sshd,sshd-session", "-o", "pid=,user="], ignore_errors=True)
        if code == 0 and out:
            for line in out.strip().splitlines():
                parts = line.split()
                if len(parts) != 2:
                    continue
                pid, owner = parts
                if owner in ("root", "sshd", ""):
                    continue
                if owner not in managed_users:
                    continue
                if target_user and owner != target_user:
                    continue
                if owner not in user_pids:
                    user_pids[owner] = set()
                user_pids[owner].add(pid)
    except Exception as e:
        print(f"Error checking online sessions: {e}", file=sys.stderr)
        
    if target_user:
        return len(user_pids.get(target_user, set()))
    else:
        return sum(len(pids) for pids in user_pids.values())

def get_online_sessions_for_users(usernames):
    """Get online session counts for a set of usernames efficiently (single ps call)."""
    user_pids = {}
    try:
        code, out, _ = run_cmd(["ps", "-C", "sshd,sshd-session", "-o", "pid=,user="], ignore_errors=True)
        if code == 0 and out:
            for line in out.strip().splitlines():
                parts = line.split()
                if len(parts) != 2:
                    continue
                pid, owner = parts
                if owner in ("root", "sshd", ""):
                    continue
                if owner not in usernames:
                    continue
                if owner not in user_pids:
                    user_pids[owner] = set()
                user_pids[owner].add(pid)
    except Exception as e:
        print(f"Error checking online sessions: {e}", file=sys.stderr)
    return user_pids

def read_file_int(path, default=0):
    try:
        if os.path.exists(path):
            with open(path, "r") as f:
                return int(f.read().strip())
    except Exception:
        pass
    return default

def refresh_ssh_banner_config():
    """Refresh dynamic SSH banner sshd config when banners are enabled."""
    if not os.path.exists("/etc/firewallfalcon/banners_enabled"):
        return
    sshd_ff_config = "/etc/ssh/sshd_config.d/firewallfalcon-banners.conf"
    banner_dir = "/etc/firewallfalcon/banners"
    os.makedirs(banner_dir, exist_ok=True)
    
    lines = ["# Mohammad Ahmad VPN Manager - Dynamic per-user SSH banners\n"]
    users = read_db()
    for u in users:
        un = u["username"]
        lines.append(f"Match User {un}\n")
        lines.append(f"    Banner {banner_dir}/{un}.txt\n")
    
    new_content = "".join(lines)
    
    # Only update if changed
    old_content = ""
    if os.path.exists(sshd_ff_config):
        try:
            with open(sshd_ff_config, "r") as f:
                old_content = f.read()
        except:
            pass
    
    if new_content != old_content:
        try:
            with open(sshd_ff_config, "w") as f:
                f.write(new_content)
            # Ensure Include directive exists
            try:
                with open("/etc/ssh/sshd_config", "r") as f:
                    sshd_content = f.read()
                if "Include /etc/ssh/sshd_config.d/" not in sshd_content:
                    with open("/etc/ssh/sshd_config", "a") as f:
                        f.write("\nInclude /etc/ssh/sshd_config.d/*.conf\n")
            except:
                pass
            run_cmd("systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null", ignore_errors=True)
        except Exception as e:
            print(f"Error refreshing SSH banner config: {e}", file=sys.stderr)

# --- PANEL CREDS ---
def get_panel_creds():
    creds = {"PANEL_USER": "", "PANEL_PASS_HASH": "", "PANEL_PASS_PLAIN": "", "PANEL_SECRET": "", "PANEL_NAME": "Mohammad Ahmad VPN Manager", "PANEL_LOGO": "⚡"}
    if os.path.exists(PANEL_CONF):
        with open(PANEL_CONF, "r") as f:
            for line in f:
                line = line.strip()
                if "=" in line:
                    k, v = line.split("=", 1)
                    v = v.strip().strip('"').strip("'")
                    if k in creds:
                        creds[k] = v
    return creds

def write_panel_creds(user, pass_plain, secret=None, panel_name=None, panel_logo=None):
    creds = get_panel_creds()
    creds["PANEL_USER"] = user
    creds["PANEL_PASS_PLAIN"] = pass_plain
    creds["PANEL_PASS_HASH"] = hashlib.sha256(pass_plain.encode()).hexdigest()
    if secret is not None:
        creds["PANEL_SECRET"] = secret.strip().lstrip('/')
    if panel_name is not None:
        creds["PANEL_NAME"] = panel_name.strip() or "Mohammad Ahmad VPN Manager"
    if panel_logo is not None:
        creds["PANEL_LOGO"] = panel_logo.strip() or "⚡"
    
    os.makedirs(os.path.dirname(PANEL_CONF), exist_ok=True)
    with open(PANEL_CONF, "w") as f:
        for k, v in creds.items():
            f.write(f"{k}={v}\n")

# --- SESSION ---
def cleanup_sessions():
    now = time.time()
    expired = [t for t, s in sessions.items() if now - s["created_at"] > 86400]
    for t in expired:
        del sessions[t]
    if expired:
        save_sessions()

def generate_password(length=8):
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return "".join(secrets.choice(chars) for _ in range(length))

def calculate_expire_date(days):
    return (datetime.now() + timedelta(days=days)).strftime("%Y-%m-%d")

def check_session(headers):
    """Returns session info dict or None if not authenticated."""
    cleanup_sessions()
    if "Cookie" in headers:
        C = cookies.SimpleCookie(headers["Cookie"])
        if "session" in C:
            token = C["session"].value
            if token in sessions:
                return sessions[token]
    return None

# --- HTTP HANDLER ---
class PanelAPIHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass  # Suppress default logging

    def send_json(self, status, data, extra_headers=None):
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        if extra_headers:
            for k, v in extra_headers.items():
                self.send_header(k, v)
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

    def _get_session(self):
        """Helper: returns session dict or sends 401 and returns None."""
        s = check_session(self.headers)
        if not s:
            self.send_json(401, {"error": "Unauthorized"})
        return s

    def _require_admin(self, session):
        """Helper: returns True if admin, else sends 403 and returns False."""
        if session.get("role") != "admin":
            self.send_json(403, {"error": "Admin access required"})
            return False
        return True

    def do_GET(self):
        try:
            parsed_path = urlparse(self.path)
            raw_path = parsed_path.path.strip()
            creds = get_panel_creds()
            secret = creds.get("PANEL_SECRET", "").strip().lstrip('/')
            
            # Check secret path matching for HTML serving
            is_html_request = False
            if not secret:
                if raw_path in ("/", "/index.html"):
                    is_html_request = True
            else:
                valid_paths = (f"/{secret}", f"/{secret}/", f"/{secret}/index.html")
                if raw_path in valid_paths:
                    is_html_request = True

            if is_html_request:
                if os.path.exists(PANEL_HTML):
                    with open(PANEL_HTML, "rb") as f:
                        content = f.read()
                    self.send_response(200)
                    self.send_header('Content-Type', 'text/html')
                    self.end_headers()
                    self.wfile.write(content)
                else:
                    self.send_response(404)
                    self.end_headers()
                    self.wfile.write(b"HTML not found")
                return

            # Clean API path if prefixed with secret
            api_path = raw_path
            if secret and api_path.startswith(f"/{secret}/api/"):
                api_path = api_path[len(secret) + 1:]
            
            if not api_path.startswith("/api/"):
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Not Found")
                return

            # Public endpoint: branding (no auth required)
            if api_path == "/api/branding":
                creds = get_panel_creds()
                self.send_json(200, {
                    "panel_name": creds.get("PANEL_NAME", "Mohammad Ahmad VPN Manager"),
                    "panel_logo": creds.get("PANEL_LOGO", "\u26a1"),
                    "has_custom_logo": os.path.exists("/etc/firewallfalcon/panel/logo.png") and creds.get("PANEL_LOGO") == "custom"
                })
                return

            # Serve custom logo image (public, no auth)
            logo_path = "/etc/firewallfalcon/panel/logo.png"
            if api_path == "/api/logo.png":
                if os.path.exists(logo_path):
                    with open(logo_path, "rb") as f:
                        img_data = f.read()
                    self.send_response(200)
                    self.send_header('Content-Type', 'image/png')
                    self.send_header('Cache-Control', 'public, max-age=3600')
                    self.end_headers()
                    self.wfile.write(img_data)
                else:
                    self.send_response(404)
                    self.end_headers()
                    self.wfile.write(b"No custom logo")
                return

            session = self._get_session()
            if not session:
                return

            if api_path == "/api/me":
                self.handle_get_me(session)
            elif api_path == "/api/dashboard":
                self.handle_get_dashboard(session)
            elif api_path == "/api/users":
                self.handle_get_users(session)
            elif api_path == "/api/protocols":
                if not self._require_admin(session):
                    return
                self.handle_get_protocols()
            elif api_path == "/api/settings":
                if not self._require_admin(session):
                    return
                self.handle_get_settings()
            elif api_path == "/api/resellers":
                if not self._require_admin(session):
                    return
                self.handle_get_resellers()
            else:
                self.send_json(404, {"error": "Not Found"})
        except Exception as e:
            print(f"Error handling GET {self.path}: {e}", file=sys.stderr)
            self.send_json(500, {"error": str(e)})

    def do_POST(self):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        
        content_length = int(self.headers.get('Content-Length', 0))
        
        # Handle logo upload BEFORE reading body as JSON (binary upload)
        if path == "/api/logo/upload":
            session = self._get_session()
            if not session:
                return
            if not self._require_admin(session):
                return
            raw_data = self.rfile.read(content_length) if content_length > 0 else b''
            self.handle_logo_upload(raw_data)
            return
        
        post_data = self.rfile.read(content_length)
        try:
            body = json.loads(post_data.decode('utf-8')) if post_data else {}
        except json.JSONDecodeError:
            body = {}

        if path == "/api/login":
            self.handle_login(body)
            return

        session = self._get_session()
        if not session:
            return

        if path == "/api/logout":
            self.handle_logout()
        elif path == "/api/logo/delete":
            if not self._require_admin(session):
                return
            self.handle_logo_delete()
        elif path == "/api/users":
            self.handle_post_users(body, session)
        elif path == "/api/users/bulk":
            self.handle_post_users_bulk(body, session)
        elif path == "/api/users/trial":
            self.handle_post_trial_user(body, session)
        elif path.startswith("/api/users/") and path.endswith("/lock"):
            user = path.split("/")[3]
            self.handle_user_action(user, "lock", session=session)
        elif path.startswith("/api/users/") and path.endswith("/unlock"):
            user = path.split("/")[3]
            self.handle_user_action(user, "unlock", session=session)
        elif path.startswith("/api/users/") and path.endswith("/renew"):
            user = path.split("/")[3]
            self.handle_user_action(user, "renew", body=body, session=session)
        elif path.startswith("/api/users/") and path.endswith("/reset-bandwidth"):
            user = path.split("/")[3]
            self.handle_user_action(user, "reset-bandwidth", session=session)
        elif path.startswith("/api/protocols/") and path.endswith("/restart"):
            if not self._require_admin(session):
                return
            service = path.split("/")[3]
            self.handle_protocol_restart(service)
        elif path == "/api/resellers":
            if not self._require_admin(session):
                return
            self.handle_post_reseller(body)
        elif path == "/api/system/reboot":
            if not self._require_admin(session):
                return
            self.handle_system_reboot()
        elif path.startswith("/api/resellers/") and path.endswith("/toggle"):
            if not self._require_admin(session):
                return
            reseller_name = path.split("/")[3]
            self.handle_toggle_reseller(reseller_name)
        else:
            self.send_json(404, {"error": "Not Found"})

    def do_PUT(self):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        
        session = self._get_session()
        if not session:
            return

        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)
        try:
            body = json.loads(post_data.decode('utf-8')) if post_data else {}
        except json.JSONDecodeError:
            body = {}

        if path.startswith("/api/users/"):
            user = path.split("/")[3]
            self.handle_put_user(user, body, session)
        elif path == "/api/settings":
            if not self._require_admin(session):
                return
            self.handle_put_settings(body)
        elif path.startswith("/api/resellers/"):
            if not self._require_admin(session):
                return
            reseller_name = path.split("/")[3]
            self.handle_put_reseller(reseller_name, body)
        else:
            self.send_json(404, {"error": "Not Found"})

    def do_DELETE(self):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        
        session = self._get_session()
        if not session:
            return

        if path.startswith("/api/resellers/"):
            if not self._require_admin(session):
                return
            reseller_name = path.split("/")[3]
            # Check query params for delete_users flag
            qs = parse_qs(urlparse(self.path).query)
            delete_users = qs.get("delete_users", ["0"])[0] == "1"
            self.handle_delete_reseller(reseller_name, delete_users)
        elif path.startswith("/api/users/"):
            user = path.split("/")[3]
            self.handle_delete_user(user, session)
        else:
            self.send_json(404, {"error": "Not Found"})

    # --- OWNERSHIP CHECK ---
    def _check_user_ownership(self, username, session):
        """Check if the session owner can manage this user. Returns True if allowed."""
        if session.get("role") == "admin":
            return True
        # Reseller can only manage their own users
        users = read_db()
        user = next((u for u in users if u["username"] == username), None)
        if not user:
            return False
        return user.get("owner", "admin") == session.get("username")

    # --- HANDLERS ---
    def handle_login(self, body):
        user = body.get("username", "")
        pwd = body.get("password", "")
        pwd_hash = hashlib.sha256(pwd.encode()).hexdigest()
        
        # Check admin credentials first
        creds = get_panel_creds()
        if user == creds.get("PANEL_USER") and pwd_hash == creds.get("PANEL_PASS_HASH"):
            token = secrets.token_hex(32)
            sessions[token] = {"username": user, "role": "admin", "created_at": time.time()}
            save_sessions()
            cookie_str = f"session={token}; Path=/; HttpOnly; Max-Age=86400"
            self.send_json(200, {"success": True, "role": "admin"}, {"Set-Cookie": cookie_str})
            return

        # Check reseller credentials
        resellers = read_resellers()
        for r in resellers:
            if r["username"] == user and r["password"] == pwd:
                if not r["enabled"]:
                    return self.send_json(401, {"error": "Account is disabled"})
                # Check reseller expiry
                try:
                    exp = datetime.strptime(r["expire_date"], "%Y-%m-%d")
                    if exp < datetime.now():
                        return self.send_json(401, {"error": "Account has expired"})
                except ValueError:
                    pass
                token = secrets.token_hex(32)
                sessions[token] = {"username": user, "role": "reseller", "created_at": time.time()}
                save_sessions()
                cookie_str = f"session={token}; Path=/; HttpOnly; Max-Age=86400"
                self.send_json(200, {"success": True, "role": "reseller"}, {"Set-Cookie": cookie_str})
                return

        self.send_json(401, {"error": "Invalid credentials"})

    def handle_logout(self):
        if "Cookie" in self.headers:
            C = cookies.SimpleCookie(self.headers["Cookie"])
            if "session" in C:
                token = C["session"].value
                if token in sessions:
                    del sessions[token]
                    save_sessions()
        cookie_str = f"session=; Path=/; HttpOnly; Max-Age=0"
        self.send_json(200, {"success": True}, {"Set-Cookie": cookie_str})

    def handle_get_me(self, session):
        creds = get_panel_creds()
        data = {
            "role": session.get("role", "admin"),
            "username": session.get("username", ""),
            "panel_name": creds.get("PANEL_NAME", "Mohammad Ahmad VPN Manager"),
            "panel_logo": creds.get("PANEL_LOGO", "⚡"),
            "has_custom_logo": os.path.exists("/etc/firewallfalcon/panel/logo.png") and creds.get("PANEL_LOGO") == "custom"
        }
        if session.get("role") == "reseller":
            resellers = read_resellers()
            r = next((x for x in resellers if x["username"] == session["username"]), None)
            if r:
                data["expire_date"] = r["expire_date"]
                data["max_users"] = r["max_users"]
                users = read_db()
                owned = [u for u in users if u.get("owner") == session["username"]]
                data["created_users"] = len(owned)
        self.send_json(200, data)

    def handle_get_dashboard(self, session):
        users = read_db()

        if session.get("role") == "reseller":
            # Reseller sees only their stats
            owned_users = [u for u in users if u.get("owner") == session["username"]]
            owned_usernames = set(u["username"] for u in owned_users)
            online_pids = get_online_sessions_for_users(owned_usernames)
            online_total = sum(len(pids) for pids in online_pids.values())
            
            resellers = read_resellers()
            r = next((x for x in resellers if x["username"] == session["username"]), None)
            max_users = r["max_users"] if r else 0
            expire_date = r["expire_date"] if r else "N/A"

            self.send_json(200, {
                "user_count": len(owned_users),
                "online_sessions": online_total,
                "protocols": [],
                "reseller_info": {
                    "max_users": max_users,
                    "created_users": len(owned_users),
                    "expire_date": expire_date
                }
            })
            return

        # --- ADMIN BRANCH ---
        _, ip, _ = run_cmd("curl -s -4 --max-time 3 icanhazip.com")
        
        os_name = "Unknown OS"
        try:
            with open("/etc/os-release") as f:
                for line in f:
                    if line.startswith("PRETTY_NAME="):
                        os_name = line.split("=")[1].strip().strip('"')
                        break
        except Exception:
            pass

        _, uptime_str, _ = run_cmd("uptime -p")
        if uptime_str.startswith("up "):
            uptime_str = uptime_str[3:]

        ram_total = 0
        ram_available = 0
        try:
            with open("/proc/meminfo") as f:
                for line in f:
                    if line.startswith("MemTotal:"):
                        ram_total = int(line.split()[1]) // 1024
                    elif line.startswith("MemAvailable:"):
                        ram_available = int(line.split()[1]) // 1024
        except Exception:
            pass
        ram_used = ram_total - ram_available if ram_total > 0 else 0
        ram_percent = round((ram_used / ram_total) * 100, 1) if ram_total > 0 else 0.0

        cpu_load = 0.0
        try:
            with open("/proc/loadavg") as f:
                cpu_load = float(f.read().split()[0])
        except Exception:
            pass

        # Admin sees everything
        online_sessions = get_online_sessions()
        procs = self.get_protocols_status()
        self.send_json(200, {
            "server_ip": ip,
            "os_name": os_name,
            "uptime": uptime_str,
            "ram_percent": ram_percent,
            "ram_used_mb": ram_used,
            "ram_total_mb": ram_total,
            "cpu_load_1m": cpu_load,
            "user_count": len(users),
            "online_sessions": online_sessions,
            "protocols": procs
        })

    def get_protocols_status(self):
        procs = []
        for p in PROTOCOLS:
            installed = False
            if p["check_file"] is None:
                installed = True
            else:
                installed = os.path.exists(p["check_file"])
                
            running = False
            if installed:
                code, _, _ = run_cmd(["systemctl", "is-active", p["service"]])
                if code == 0:
                    running = True
                elif "service_alt" in p:
                    code2, _, _ = run_cmd(["systemctl", "is-active", p["service_alt"]])
                    if code2 == 0:
                        running = True
                        
            procs.append({
                "name": p["name"],
                "service": p["service"],
                "installed": installed,
                "running": running,
                "port": p["port"]
            })
        return procs

    def handle_get_users(self, session):
        users = read_db()
        
        # Scope by role
        if session.get("role") == "reseller":
            users = [u for u in users if u.get("owner") == session["username"]]

        # Efficient batch online session lookup
        all_usernames = set(u["username"] for u in users)
        online_pids = get_online_sessions_for_users(all_usernames)

        result = []
        for u in users:
            un = u["username"]
            total_bw = read_file_int(f"{BW_DIR}/{un}.usage")
            daily_bw = read_file_int(f"{BW_DIR}/{un}.daily_usage")
            
            code, out, _ = run_cmd(["passwd", "-S", un])
            is_locked = False
            if code == 0 and len(out.split()) >= 2:
                is_locked = (out.split()[1] == "L")
                
            code2, _, _ = run_cmd(["id", un])
            exists_on_system = (code2 == 0)
            
            is_expired = False
            try:
                if u["expire_date"] != "Never" and u["expire_date"]:
                    exp_date = datetime.strptime(u["expire_date"], "%Y-%m-%d")
                    is_expired = exp_date < datetime.now()
            except ValueError:
                pass
            
            online_count = len(online_pids.get(un, set()))
            
            u_ext = dict(u)
            u_ext["total_used_bytes"] = total_bw
            u_ext["daily_used_bytes"] = daily_bw
            u_ext["is_locked"] = is_locked
            u_ext["is_expired"] = is_expired
            u_ext["is_online"] = online_count > 0
            u_ext["online_sessions"] = online_count
            u_ext["exists_on_system"] = exists_on_system
            
            result.append(u_ext)
            
        self.send_json(200, {"users": result})

    def _create_user(self, un, pwd, days, conn, bw, dbw, acct_type="web", owner="admin"):
        if not re.match(r'^[a-zA-Z0-9_]{3,32}$', un):
            raise ValueError("Invalid username")
            
        if any(u["username"] == un for u in read_db()):
            raise ValueError("User already exists in DB")
            
        code, _, _ = run_cmd(["id", un])
        if code == 0:
            raise ValueError("User already exists on system")

        run_cmd(["useradd", "-m", "-s", "/usr/sbin/nologin", un])
        run_cmd(["usermod", "-aG", FF_USERS_GROUP, un], ignore_errors=True)
        run_cmd(f"echo '{un}:{pwd}' | chpasswd")
        
        exp_date_str = calculate_expire_date(days)
        run_cmd(["chage", "-E", exp_date_str, un])
        
        new_u = {
            "username": un,
            "password": pwd,
            "expire_date": exp_date_str,
            "conn_limit": conn,
            "bandwidth_gb": bw,
            "daily_bandwidth_gb": dbw,
            "account_type": acct_type,
            "owner": owner
        }
        
        with db_lock:
            os.makedirs(os.path.dirname(DB_FILE), exist_ok=True)
            with open(DB_FILE, "a") as f:
                f.write(format_db_line(new_u))
        
        # Initialize bandwidth usage files to prevent immediate locking
        os.makedirs(BW_DIR, exist_ok=True)
        with open(f"{BW_DIR}/{un}.usage", "w") as f:
            f.write("0")
        with open(f"{BW_DIR}/{un}.daily_usage", "w") as f:
            f.write("0")
                
        refresh_ssh_banner_config()
        return new_u

    def handle_post_users(self, body, session):
        try:
            owner = session.get("username", "admin") if session.get("role") == "reseller" else "admin"

            # Reseller quota check
            if session.get("role") == "reseller":
                resellers = read_resellers()
                r = next((x for x in resellers if x["username"] == session["username"]), None)
                if not r:
                    return self.send_json(403, {"error": "Reseller account not found"})
                users = read_db()
                owned = [u for u in users if u.get("owner") == session["username"]]
                if len(owned) >= r["max_users"]:
                    return self.send_json(403, {"error": f"User limit reached ({r['max_users']})"})

            un = body.get("username", "")
            pwd = body.get("password", "") or generate_password()
            days = int(body.get("days", 30))
            conn = int(body.get("conn_limit", 1))
            bw = float(body.get("bandwidth_gb", 0))
            dbw = float(body.get("daily_bandwidth_gb", 0))
            
            new_u = self._create_user(un, pwd, days, conn, bw, dbw, owner=owner)
            self.send_json(200, new_u)
        except Exception as e:
            self.send_json(400, {"error": str(e)})

    def handle_post_users_bulk(self, body, session):
        try:
            owner = session.get("username", "admin") if session.get("role") == "reseller" else "admin"
            
            # Reseller quota check
            remaining_quota = float('inf')
            if session.get("role") == "reseller":
                resellers = read_resellers()
                r = next((x for x in resellers if x["username"] == session["username"]), None)
                if not r:
                    return self.send_json(403, {"error": "Reseller account not found"})
                users = read_db()
                owned = [u for u in users if u.get("owner") == session["username"]]
                remaining_quota = r["max_users"] - len(owned)
                if remaining_quota <= 0:
                    return self.send_json(403, {"error": f"User limit reached ({r['max_users']})"})

            prefix = body.get("prefix", "user")
            count = min(int(body.get("count", 1)), int(remaining_quota))
            days = int(body.get("days", 30))
            conn = int(body.get("conn_limit", 1))
            bw = float(body.get("bandwidth_gb", 0))
            dbw = float(body.get("daily_bandwidth_gb", 0))
            
            created = []
            existing_users = set(u["username"] for u in read_db())
            
            idx = 1
            for _ in range(count):
                while f"{prefix}{idx}" in existing_users:
                    idx += 1
                un = f"{prefix}{idx}"
                pwd = generate_password()
                
                try:
                    u = self._create_user(un, pwd, days, conn, bw, dbw, "bulk", owner=owner)
                    created.append(u)
                    existing_users.add(un)
                except Exception as e:
                    pass # skip failures in bulk
                idx += 1
                
            self.send_json(200, {"users": created})
        except Exception as e:
            self.send_json(400, {"error": str(e)})

    def handle_post_trial_user(self, body, session):
        try:
            owner = session.get("username", "admin") if session.get("role") == "reseller" else "admin"

            # Reseller quota check
            if session.get("role") == "reseller":
                resellers = read_resellers()
                r = next((x for x in resellers if x["username"] == session["username"]), None)
                if not r:
                    return self.send_json(403, {"error": "Reseller account not found"})
                users = read_db()
                owned = [u for u in users if u.get("owner") == session["username"]]
                if len(owned) >= r["max_users"]:
                    return self.send_json(403, {"error": f"User limit reached ({r['max_users']})"})

            un = body.get("username", "")
            if not un:
                import random, string
                un = "trial_" + "".join(random.choices(string.ascii_lowercase + string.digits, k=5))
            pwd = body.get("password", "") or generate_password()
            hours = int(body.get("hours", 1))
            conn = int(body.get("conn_limit", 1))
            bw = float(body.get("bandwidth_gb", 0))
            
            # Calculate days for expiry
            if hours >= 24:
                days = hours // 24
            else:
                days = 1  # At least 1 day for chage, at job does real cleanup
            
            new_u = self._create_user(un, pwd, days, conn, bw, 0, acct_type="trial", owner=owner)
            
            # Schedule auto-cleanup via 'at' daemon
            cleanup_script = "/usr/local/bin/firewallfalcon-trial-cleanup.sh"
            if os.path.exists(cleanup_script):
                run_cmd(f"echo '{cleanup_script} {un}' | at now + {hours} hours", ignore_errors=True)
            
            # Calculate expiry timestamp for display
            from datetime import datetime, timedelta
            expiry_time = (datetime.now() + timedelta(hours=hours)).strftime("%Y-%m-%d %H:%M:%S")
            new_u["expiry_time"] = expiry_time
            new_u["hours"] = hours
            
            self.send_json(200, new_u)
        except Exception as e:
            self.send_json(400, {"error": str(e)})

    def handle_put_user(self, username, body, session):
        if not self._check_user_ownership(username, session):
            return self.send_json(403, {"error": "Access denied"})

        with db_lock:
            users = read_db()
            idx = next((i for i, u in enumerate(users) if u["username"] == username), -1)
            if idx == -1:
                return self.send_json(404, {"error": "User not found"})
                
            u = users[idx]
            
            if "password" in body:
                u["password"] = body["password"]
                run_cmd(f"echo '{username}:{u['password']}' | chpasswd")
                
            if "days" in body:
                u["expire_date"] = calculate_expire_date(int(body["days"]))
                run_cmd(["chage", "-E", u["expire_date"], username])
                
            if "conn_limit" in body:
                u["conn_limit"] = int(body["conn_limit"])
                
            if "bandwidth_gb" in body:
                u["bandwidth_gb"] = float(body["bandwidth_gb"])
                
            if "daily_bandwidth_gb" in body:
                u["daily_bandwidth_gb"] = float(body["daily_bandwidth_gb"])

            lines = []
            with open(DB_FILE, "r") as f:
                lines = f.readlines()
                
            with open(DB_FILE, "w") as f:
                for line in lines:
                    if line.startswith(f"{username}:"):
                        f.write(format_db_line(u))
                    else:
                        f.write(line)
                        
            self.send_json(200, u)

    def handle_delete_user(self, username, session):
        if not self._check_user_ownership(username, session):
            return self.send_json(403, {"error": "Access denied"})

        force_delete_system_user(username)
        
        with db_lock:
            lines = []
            if os.path.exists(DB_FILE):
                with open(DB_FILE, "r") as f:
                    lines = f.readlines()
                with open(DB_FILE, "w") as f:
                    for line in lines:
                        if not line.startswith(f"{username}:"):
                            f.write(line)
                            
        run_cmd(f"rm -f {BW_DIR}/{username}.*", ignore_errors=True)
        run_cmd(f"rm -f /etc/firewallfalcon/banners/{username}.txt", ignore_errors=True)
        refresh_ssh_banner_config()
        
        self.send_json(200, {"success": True})

    def handle_user_action(self, username, action, body=None, session=None):
        if not self._check_user_ownership(username, session):
            return self.send_json(403, {"error": "Access denied"})

        if action == "lock":
            run_cmd(["usermod", "-L", username])
            run_cmd(["killall", "-u", username, "-9"], ignore_errors=True)
            self.send_json(200, {"success": True})
            
        elif action == "unlock":
            run_cmd(["usermod", "-U", username])
            run_cmd(f"rm -f {BW_DIR}/{username}.conn_locked", ignore_errors=True)
            run_cmd(f"rm -f {BW_DIR}/{username}.daily_locked", ignore_errors=True)
            self.send_json(200, {"success": True})
            
        elif action == "renew":
            days = int(body.get("days", 30)) if body else 30
            with db_lock:
                users = read_db()
                u = next((x for x in users if x["username"] == username), None)
                if not u:
                    return self.send_json(404, {"error": "User not found"})
                u["expire_date"] = calculate_expire_date(days)
                run_cmd(["chage", "-E", u["expire_date"], username])
                
                lines = []
                with open(DB_FILE, "r") as f:
                    lines = f.readlines()
                with open(DB_FILE, "w") as f:
                    for line in lines:
                        if line.startswith(f"{username}:"):
                            f.write(format_db_line(u))
                        else:
                            f.write(line)
            self.send_json(200, {"success": True, "expire_date": u["expire_date"]})
            
        elif action == "reset-bandwidth":
            os.makedirs(BW_DIR, exist_ok=True)
            with open(f"{BW_DIR}/{username}.usage", "w") as f:
                f.write("0")
            with open(f"{BW_DIR}/{username}.daily_usage", "w") as f:
                f.write("0")
            run_cmd(f"rm -f {BW_DIR}/{username}.conn_locked", ignore_errors=True)
            run_cmd(f"rm -f {BW_DIR}/{username}.daily_locked", ignore_errors=True)
            run_cmd(["usermod", "-U", username])
            self.send_json(200, {"success": True})
            
        else:
            self.send_json(400, {"error": "Unknown action"})

    def handle_get_protocols(self):
        self.send_json(200, self.get_protocols_status())

    def handle_protocol_restart(self, service):
        code, out, err = run_cmd(["systemctl", "restart", service])
        if code == 0:
            self.send_json(200, {"success": True})
        else:
            self.send_json(500, {"success": False, "error": err})

    def handle_system_reboot(self):
        self.send_json(200, {"success": True, "message": "Rebooting system..."})
        # Schedule reboot in background so we can return response first
        threading.Timer(2.0, lambda: subprocess.run(["reboot"])).start()

    def handle_logo_upload(self, raw_data):
        try:
            if len(raw_data) > 2097152:  # 2MB max
                return self.send_json(400, {"error": "File too large (max 2MB)"})
            if len(raw_data) == 0:
                return self.send_json(400, {"error": "No file data"})
            
            logo_path = "/etc/firewallfalcon/panel/logo.png"
            os.makedirs(os.path.dirname(logo_path), exist_ok=True)
            with open(logo_path, "wb") as f:
                f.write(raw_data)
            
            # Set PANEL_LOGO to 'custom' to signal frontend to use image
            creds = get_panel_creds()
            creds["PANEL_LOGO"] = "custom"
            os.makedirs(os.path.dirname(PANEL_CONF), exist_ok=True)
            with open(PANEL_CONF, "w") as f:
                for k, v in creds.items():
                    f.write(f"{k}={v}\n")
            
            self.send_json(200, {"success": True, "panel_logo": "custom"})
        except Exception as e:
            self.send_json(500, {"error": str(e)})

    def handle_logo_delete(self):
        logo_path = "/etc/firewallfalcon/panel/logo.png"
        try:
            if os.path.exists(logo_path):
                os.remove(logo_path)
            creds = get_panel_creds()
            creds["PANEL_LOGO"] = "⚡"
            os.makedirs(os.path.dirname(PANEL_CONF), exist_ok=True)
            with open(PANEL_CONF, "w") as f:
                for k, v in creds.items():
                    f.write(f"{k}={v}\n")
            self.send_json(200, {"success": True, "panel_logo": "⚡"})
        except Exception as e:
            self.send_json(500, {"error": str(e)})

    def handle_get_settings(self):
        creds = get_panel_creds()
        self.send_json(200, {
            "username": creds.get("PANEL_USER", ""),
            "secret": creds.get("PANEL_SECRET", ""),
            "panel_name": creds.get("PANEL_NAME", "Mohammad Ahmad VPN Manager"),
            "panel_logo": creds.get("PANEL_LOGO", "⚡"),
            "has_custom_logo": os.path.exists("/etc/firewallfalcon/panel/logo.png") and creds.get("PANEL_LOGO") == "custom"
        })

    def handle_put_settings(self, body):
        creds = get_panel_creds()
        curr_pwd = body.get("current_password", "")
        new_user = body.get("new_username", "").strip() or creds.get("PANEL_USER", "")
        new_pwd = body.get("new_password", "").strip() or creds.get("PANEL_PASS_PLAIN", "")
        new_secret = body.get("new_secret", "").strip().lstrip('/')
        new_name = body.get("panel_name", "").strip()
        new_logo = body.get("panel_logo", "").strip()
        
        curr_hash = hashlib.sha256(curr_pwd.encode()).hexdigest()
        if curr_hash != creds.get("PANEL_PASS_HASH"):
            return self.send_json(401, {"error": "Invalid current password"})
            
        write_panel_creds(new_user, new_pwd, secret=new_secret, panel_name=new_name or None, panel_logo=new_logo or None)
        self.send_json(200, {"success": True, "secret": new_secret, "panel_name": new_name or creds.get("PANEL_NAME", "Mohammad Ahmad VPN Manager"), "panel_logo": new_logo or creds.get("PANEL_LOGO", "⚡")})

    # --- RESELLER HANDLERS (admin only) ---
    def handle_get_resellers(self):
        resellers = read_resellers()
        users = read_db()
        result = []
        for r in resellers:
            owned = [u for u in users if u.get("owner") == r["username"]]
            is_expired = False
            try:
                exp = datetime.strptime(r["expire_date"], "%Y-%m-%d")
                is_expired = exp < datetime.now()
            except ValueError:
                pass
            result.append({
                "username": r["username"],
                "password": r["password"],
                "expire_date": r["expire_date"],
                "max_users": r["max_users"],
                "created_users": len(owned),
                "enabled": r["enabled"],
                "is_expired": is_expired
            })
        self.send_json(200, {"resellers": result})

    def handle_post_reseller(self, body):
        try:
            un = body.get("username", "").strip()
            pwd = body.get("password", "") or generate_password()
            days = int(body.get("days", 30))
            max_users = int(body.get("max_users", 10))

            if not re.match(r'^[a-zA-Z0-9_]{3,32}$', un):
                return self.send_json(400, {"error": "Invalid username (3-32 chars, alphanumeric + underscore)"})

            # Check conflicts with admin username
            creds = get_panel_creds()
            if un == creds.get("PANEL_USER"):
                return self.send_json(400, {"error": "Username conflicts with admin"})

            resellers = read_resellers()
            if any(r["username"] == un for r in resellers):
                return self.send_json(400, {"error": "Reseller already exists"})

            new_r = {
                "username": un,
                "password": pwd,
                "expire_date": calculate_expire_date(days),
                "max_users": max_users,
                "enabled": True
            }
            resellers.append(new_r)
            write_resellers(resellers)
            self.send_json(200, new_r)
        except Exception as e:
            self.send_json(400, {"error": str(e)})

    def handle_put_reseller(self, username, body):
        resellers = read_resellers()
        idx = next((i for i, r in enumerate(resellers) if r["username"] == username), -1)
        if idx == -1:
            return self.send_json(404, {"error": "Reseller not found"})

        r = resellers[idx]
        if "password" in body and body["password"]:
            r["password"] = body["password"]
        if "days" in body:
            r["expire_date"] = calculate_expire_date(int(body["days"]))
        if "max_users" in body:
            r["max_users"] = int(body["max_users"])

        resellers[idx] = r
        write_resellers(resellers)
        self.send_json(200, r)

    def handle_toggle_reseller(self, username):
        resellers = read_resellers()
        idx = next((i for i, r in enumerate(resellers) if r["username"] == username), -1)
        if idx == -1:
            return self.send_json(404, {"error": "Reseller not found"})

        resellers[idx]["enabled"] = not resellers[idx]["enabled"]
        write_resellers(resellers)
        self.send_json(200, {"success": True, "enabled": resellers[idx]["enabled"]})

    def handle_delete_reseller(self, username, delete_users=False):
        resellers = read_resellers()
        idx = next((i for i, r in enumerate(resellers) if r["username"] == username), -1)
        if idx == -1:
            return self.send_json(404, {"error": "Reseller not found"})

        if delete_users:
            users = read_db()
            owned = [u for u in users if u.get("owner") == username]
            for u in owned:
                un = u["username"]
                force_delete_system_user(un)
                run_cmd(f"rm -f {BW_DIR}/{un}.*", ignore_errors=True)
                run_cmd(f"rm -f /etc/firewallfalcon/banners/{un}.txt", ignore_errors=True)
            
            with db_lock:
                if os.path.exists(DB_FILE):
                    with open(DB_FILE, "r") as f:
                        lines = f.readlines()
                    owned_names = set(u["username"] for u in owned)
                    with open(DB_FILE, "w") as f:
                        for line in lines:
                            parts = line.strip().split(":")
                            if parts and parts[0] not in owned_names:
                                f.write(line)

        del resellers[idx]
        write_resellers(resellers)

        # Invalidate reseller's sessions
        tokens_to_remove = [t for t, s in sessions.items() if s.get("username") == username and s.get("role") == "reseller"]
        for t in tokens_to_remove:
            del sessions[t]
        if tokens_to_remove:
            save_sessions()

        self.send_json(200, {"success": True})

def main():
    os.makedirs(os.path.dirname(DB_FILE), exist_ok=True)
    server_address = ('0.0.0.0', PORT)
    httpd = ThreadingHTTPServer(server_address, PanelAPIHandler)
    print(f"Starting server on port {PORT}...", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print("Server stopped.")

if __name__ == '__main__':
    main()

__NG_PANEL_PY_EOF__
    if [ ! -s "$PANEL_SCRIPT" ]; then
        echo -e "${C_RED}❌ Failed to write panel backend.${C_RESET}"
        return
    fi
    chmod +x "$PANEL_SCRIPT"

    # Write frontend (bundled locally — no external download needed)
    cat > "$PANEL_HTML_FILE" << '__NG_PANEL_HTML_EOF__'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Relay Deck</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<style>
:root{
  --bg:#090d12;--surface:#101720;--surface-2:#161f2b;
  --line:rgba(148,178,196,.14);--line-strong:rgba(148,178,196,.26);
  --accent:#45e8c4;--accent-soft:rgba(69,232,196,.14);
  --accent-2:#7c8cff;--accent-2-soft:rgba(124,140,255,.14);
  --warn:#ffb454;--warn-soft:rgba(255,180,84,.14);
  --danger:#ff5e7a;--danger-soft:rgba(255,94,122,.14);
  --text:#e7eef2;--text-dim:#8b9aa6;--text-faint:#526172;
  --r-lg:18px;--r-md:12px;--r-sm:8px;
  --disp:'Space Grotesk',sans-serif;--body:'Inter',sans-serif;--mono:'IBM Plex Mono',monospace;
  --sb:env(safe-area-inset-bottom,0px);
}
*{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;}
body{background:var(--bg);color:var(--text);font-family:var(--body);min-height:100dvh;-webkit-tap-highlight-color:transparent;
  background-image:radial-gradient(ellipse 700px 420px at 12% -6%, rgba(69,232,196,.10), transparent 60%),radial-gradient(ellipse 600px 380px at 100% 8%, rgba(124,140,255,.09), transparent 60%);
  background-attachment:fixed;}
::-webkit-scrollbar{width:5px;height:5px;}
::-webkit-scrollbar-thumb{background:var(--line-strong);border-radius:4px;}
.hidden{display:none!important;}
.mono{font-family:var(--mono);}

.pulse-rail{position:relative;width:100%;height:34px;overflow:hidden;border-radius:999px;background:var(--surface);border:1px solid var(--line);}
.pulse-rail svg{position:absolute;inset:0;width:100%;height:100%;}
.pulse-rail .pr-line{fill:none;stroke:var(--accent);stroke-width:1.6;stroke-linecap:round;filter:drop-shadow(0 0 6px rgba(69,232,196,.55));stroke-dasharray:6 5;animation:prflow 5.5s linear infinite;}
.pulse-rail.warn .pr-line{stroke:var(--warn);filter:drop-shadow(0 0 6px rgba(255,180,84,.5));}
.pulse-rail.danger .pr-line{stroke:var(--danger);filter:drop-shadow(0 0 6px rgba(255,94,122,.5));}
@keyframes prflow{to{stroke-dashoffset:-110;}}
@media(prefers-reduced-motion:reduce){.pulse-rail .pr-line{animation:none;}}

#login-screen{min-height:100dvh;display:flex;align-items:center;justify-content:center;padding:1.5rem;position:relative;overflow:hidden;}
#login-screen::before{content:'';position:absolute;width:520px;height:520px;border-radius:50%;border:1px solid var(--line);top:-180px;right:-160px;}
#login-screen::after{content:'';position:absolute;width:360px;height:360px;border-radius:50%;border:1px solid var(--line);bottom:-140px;left:-120px;}
.login-card{width:100%;max-width:380px;background:var(--surface);border:1px solid var(--line);border-radius:var(--r-lg);padding:2.25rem 1.9rem;position:relative;z-index:2;box-shadow:0 30px 80px rgba(0,0,0,.5);}
.brand-mark{width:42px;height:42px;border-radius:11px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;margin-bottom:1.1rem;box-shadow:0 8px 24px rgba(69,232,196,.25);overflow:hidden;}
.brand-mark img{width:100%;height:100%;object-fit:contain;}
.brand-mark svg{width:22px;height:22px;}
.login-card h1{font-family:var(--disp);font-size:1.35rem;font-weight:700;letter-spacing:-.01em;}
.login-card p{color:var(--text-dim);font-size:.82rem;margin-top:.25rem;margin-bottom:1.75rem;}
.field{display:flex;flex-direction:column;gap:.4rem;margin-bottom:1rem;}
.field label{font-size:.68rem;font-weight:600;text-transform:uppercase;letter-spacing:.09em;color:var(--text-faint);}
.field input,.field select{width:100%;padding:.72rem .85rem;background:var(--bg);border:1px solid var(--line);border-radius:var(--r-sm);color:var(--text);font-size:.9rem;font-family:var(--body);outline:none;transition:border-color .15s,box-shadow .15s;}
.field input:focus,.field select:focus{border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft);}
.field-row{display:flex;gap:.4rem;}
.field-row input{flex:1;}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:.45rem;padding:.72rem 1.1rem;border-radius:var(--r-sm);font-size:.84rem;font-weight:600;font-family:var(--body);cursor:pointer;border:1px solid transparent;transition:transform .12s,filter .15s,background .15s;}
.btn:active{transform:scale(.97);}
.btn:disabled{opacity:.6;cursor:default;}
.btn-primary{background:linear-gradient(135deg,var(--accent),#2fd1ac);color:#04140f;width:100%;box-shadow:0 10px 26px rgba(69,232,196,.22);}
.btn-primary:hover{filter:brightness(1.06);}
.btn-ghost{background:transparent;border-color:var(--line);color:var(--text);}
.btn-ghost:hover{border-color:var(--line-strong);background:rgba(255,255,255,.02);}
.btn-danger-ghost{background:var(--danger-soft);border-color:rgba(255,94,122,.3);color:#ffb0be;}
.btn-danger-ghost:hover{background:rgba(255,94,122,.22);}
.btn-sm{padding:.5rem .75rem;font-size:.76rem;}

#app{display:none;min-height:100dvh;}
.rail{width:236px;background:var(--surface);border-right:1px solid var(--line);position:fixed;top:0;bottom:0;left:0;display:flex;flex-direction:column;z-index:50;}
.rail-head{display:flex;align-items:center;gap:.6rem;padding:1.3rem 1.2rem;border-bottom:1px solid var(--line);}
.rail-head .brand-mark{margin:0;width:34px;height:34px;border-radius:9px;}
.rail-head span{font-family:var(--disp);font-weight:700;font-size:.98rem;letter-spacing:-.01em;}
.rail-nav{padding:1rem .7rem;display:flex;flex-direction:column;gap:.15rem;flex:1;overflow-y:auto;}
.rail-item{display:flex;align-items:center;gap:.7rem;padding:.62rem .8rem;border-radius:var(--r-sm);color:var(--text-dim);font-size:.85rem;font-weight:600;cursor:pointer;transition:background .14s,color .14s;position:relative;}
.rail-item .ic{width:18px;height:18px;flex-shrink:0;}
.rail-item:hover{background:rgba(255,255,255,.03);color:var(--text);}
.rail-item.active{color:var(--accent);background:var(--accent-soft);}
.rail-item.active::before{content:'';position:absolute;left:-.7rem;top:50%;transform:translateY(-50%);width:3px;height:18px;border-radius:3px;background:var(--accent);box-shadow:0 0 8px rgba(69,232,196,.6);}
.rail-foot{padding:1rem .9rem;border-top:1px solid var(--line);display:flex;flex-direction:column;gap:.6rem;}
.who{font-size:.72rem;color:var(--text-faint);}
.who b{color:var(--text-dim);font-weight:600;}
.topbar{display:none;}
.bottombar{display:none;}
.main{margin-left:236px;padding:2rem 2.25rem 3rem;max-width:1180px;}
.page-head{display:flex;align-items:flex-end;justify-content:space-between;gap:1rem;flex-wrap:wrap;margin-bottom:1.1rem;}
.page-head h1{font-family:var(--disp);font-size:1.5rem;font-weight:700;letter-spacing:-.01em;}
.page-head p{color:var(--text-dim);font-size:.82rem;margin-top:.15rem;}
.head-actions{display:flex;gap:.55rem;flex-wrap:wrap;}
.section{margin-top:1.5rem;}
.section-title{font-family:var(--disp);font-size:.92rem;font-weight:700;margin-bottom:.85rem;color:var(--text);}
.stat-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:.85rem;margin-top:1.35rem;}
.stat-card{background:var(--surface);border:1px solid var(--line);border-radius:var(--r-md);padding:1.05rem 1.1rem;opacity:0;transform:translateY(10px);animation:riseIn .5s ease forwards;}
.stat-card:nth-child(1){animation-delay:.02s;}
.stat-card:nth-child(2){animation-delay:.09s;}
.stat-card:nth-child(3){animation-delay:.16s;}
.stat-card:nth-child(4){animation-delay:.23s;}
@keyframes riseIn{to{opacity:1;transform:translateY(0);}}
@media(prefers-reduced-motion:reduce){.stat-card{animation:none;opacity:1;transform:none;}}
.stat-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:.5rem;}
.stat-label{font-size:.66rem;font-weight:700;text-transform:uppercase;letter-spacing:.09em;color:var(--text-faint);}
.stat-value{font-family:var(--disp);font-size:1.5rem;font-weight:700;margin-bottom:.15rem;}
.stat-sub{font-size:.72rem;color:var(--text-dim);}
.ring{position:relative;width:34px;height:34px;flex-shrink:0;}
.ring svg{transform:rotate(-90deg);width:100%;height:100%;}
.ring circle{fill:none;stroke-width:3;}
.ring .track{stroke:var(--line);}
.ring .val{stroke:var(--accent);stroke-linecap:round;transition:stroke-dashoffset .6s ease;}
.ring.warn .val{stroke:var(--warn);}
.ring.danger .val{stroke:var(--danger);}
.ring .rlabel{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;font-size:.56rem;font-family:var(--mono);color:var(--text-dim);}
.badge{display:inline-flex;align-items:center;gap:.35rem;padding:.28rem .6rem;border-radius:999px;font-size:.63rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;font-family:var(--mono);white-space:nowrap;}
.badge::before{content:'';width:6px;height:6px;border-radius:50%;background:currentColor;box-shadow:0 0 6px currentColor;}
.badge.on{background:var(--accent-soft);color:var(--accent);}
.badge.off{background:rgba(255,255,255,.05);color:var(--text-faint);}
.badge.warn{background:var(--warn-soft);color:var(--warn);}
.badge.danger{background:var(--danger-soft);color:var(--danger);}
.badge.b2{background:var(--accent-2-soft);color:var(--accent-2);}
.deck{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:.8rem;}
.card{background:var(--surface);border:1px solid var(--line);border-radius:var(--r-md);padding:1.05rem 1.1rem;transition:border-color .15s,transform .15s;}
.card:hover{border-color:var(--line-strong);transform:translateY(-2px);}
.card-row{display:flex;align-items:center;justify-content:space-between;gap:.6rem;}
.acct-list{display:flex;flex-direction:column;gap:.6rem;}
.acct{background:var(--surface);border:1px solid var(--line);border-radius:var(--r-md);padding:.95rem 1.05rem;display:grid;grid-template-columns:34px 1.2fr 1fr 1fr 1fr auto auto;align-items:center;gap:1rem;transition:border-color .15s;}
.acct:hover{border-color:var(--line-strong);}
.acct-name{font-family:var(--mono);font-weight:600;font-size:.9rem;color:var(--text);}
.acct-meta{font-size:.65rem;color:var(--text-faint);text-transform:uppercase;letter-spacing:.06em;margin-bottom:.15rem;}
.acct-val{font-size:.82rem;color:var(--text-dim);font-family:var(--mono);}
.acct-actions{display:flex;gap:.35rem;flex-wrap:wrap;}
.iconbtn{width:32px;height:32px;border-radius:var(--r-sm);border:1px solid var(--line);background:transparent;color:var(--text-dim);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .13s;flex-shrink:0;}
.iconbtn:hover{border-color:var(--accent);color:var(--accent);background:var(--accent-soft);}
.iconbtn.dz:hover{border-color:var(--danger);color:var(--danger);background:var(--danger-soft);}
.eye{cursor:pointer;opacity:.55;font-size:.7rem;}
.searchbar{position:relative;max-width:340px;}
.searchbar input{width:100%;padding:.68rem .9rem .68rem 2.3rem;background:var(--surface);border:1px solid var(--line);border-radius:var(--r-md);color:var(--text);font-size:.85rem;outline:none;transition:border-color .15s;}
.searchbar input:focus{border-color:var(--accent);}
.searchbar svg{position:absolute;left:.75rem;top:50%;transform:translateY(-50%);width:15px;height:15px;color:var(--text-faint);}
.modal-veil{position:fixed;inset:0;background:rgba(4,6,9,.7);backdrop-filter:blur(6px);display:flex;align-items:center;justify-content:center;padding:1rem;z-index:200;opacity:0;pointer-events:none;transition:opacity .18s;}
.modal-veil.active{opacity:1;pointer-events:auto;}
.modal{width:100%;max-width:440px;background:var(--surface);border:1px solid var(--line);border-radius:var(--r-lg);padding:1.6rem;transform:translateY(10px) scale(.98);transition:transform .2s cubic-bezier(.2,1,.3,1);max-height:88dvh;overflow-y:auto;}
.modal-veil.active .modal{transform:translateY(0) scale(1);}
.modal-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:1.2rem;}
.modal-head h3{font-family:var(--disp);font-size:1.05rem;font-weight:700;}
.grid-2{display:grid;grid-template-columns:1fr 1fr;gap:.7rem;}
.modal-actions{display:flex;gap:.6rem;margin-top:1.3rem;}
.modal-actions .btn{flex:1;}
.note{font-size:.72rem;color:var(--text-faint);margin-top:.25rem;}
.quota-note{padding:.55rem .8rem;background:var(--accent-soft);border:1px solid rgba(69,232,196,.3);border-radius:var(--r-sm);font-size:.72rem;color:var(--accent);margin-bottom:.9rem;}
.toasts{position:fixed;top:1rem;left:50%;transform:translateX(-50%);z-index:400;display:flex;flex-direction:column;gap:.5rem;width:92%;max-width:360px;}
.toast{background:var(--surface);border:1px solid var(--line);border-left:3px solid var(--accent);border-radius:var(--r-sm);padding:.7rem .9rem;font-size:.82rem;font-weight:500;box-shadow:0 12px 30px rgba(0,0,0,.4);animation:toastIn .25s cubic-bezier(.2,1,.3,1);}
.toast.err{border-left-color:var(--danger);}
@keyframes toastIn{from{opacity:0;transform:translateY(-8px);}to{opacity:1;transform:translateY(0);}}
.tab-panel{display:none;}
.tab-panel.active{display:block;animation:fadeIn .35s ease;}
@keyframes fadeIn{from{opacity:0;}to{opacity:1;}}
.sysbar{display:flex;gap:1.4rem;flex-wrap:wrap;padding:.9rem 1.1rem;margin-top:1rem;}
.syschip{display:flex;flex-direction:column;gap:.1rem;}
.syschip label{font-size:.6rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--text-faint);font-family:var(--mono);}
.syschip span{font-size:.84rem;color:var(--text);font-weight:600;}
.spin{animation:spin 1s linear infinite;}
@keyframes spin{to{transform:rotate(360deg);}}

@media(max-width:860px){
  .rail{display:none;}
  .main{margin-left:0;padding:3.6rem 1rem calc(4.6rem + var(--sb));}
  .topbar{display:flex;position:fixed;top:0;left:0;right:0;height:54px;background:rgba(9,13,18,.92);backdrop-filter:blur(14px);border-bottom:1px solid var(--line);align-items:center;justify-content:space-between;padding:0 1rem;z-index:90;}
  .topbar .brand-mark{width:26px;height:26px;border-radius:7px;margin:0;}
  .topbar-left{display:flex;align-items:center;gap:.55rem;}
  .topbar-left span{font-family:var(--disp);font-weight:700;font-size:.86rem;}
  .bottombar{display:flex;position:fixed;bottom:0;left:0;right:0;background:rgba(9,13,18,.95);backdrop-filter:blur(14px);border-top:1px solid var(--line);z-index:90;padding:.4rem .2rem calc(.4rem + var(--sb));justify-content:space-around;}
  .bb-item{display:flex;flex-direction:column;align-items:center;gap:.2rem;padding:.3rem .5rem;color:var(--text-faint);cursor:pointer;}
  .bb-item .ic{width:19px;height:19px;}
  .bb-item span{font-size:.56rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;}
  .bb-item.active{color:var(--accent);}
  .stat-grid{grid-template-columns:1fr 1fr;}
  .acct{grid-template-columns:1fr;gap:.55rem;align-items:flex-start;}
  .acct-actions{justify-content:flex-start;}
  .grid-2{grid-template-columns:1fr;}
}
</style>
</head>
<body>

<div class="toasts" id="toasts"></div>

<!-- ===================== LOGIN ===================== -->
<div id="login-screen">
  <div class="login-card">
    <div class="brand-mark" id="login-logo"><svg viewBox="0 0 24 24" fill="none" stroke="#04140f" stroke-width="2.4" stroke-linecap="round"><path d="M3 12h4l2-7 4 14 2-7h6"/></svg></div>
    <h1 id="login-name">Relay Deck</h1>
    <p>Sign in to manage tunnels, accounts &amp; resellers</p>
    <form id="login-form">
      <div class="field"><label>Username</label><input id="li-user" type="text" required autocomplete="username"></div>
      <div class="field"><label>Password</label><input id="li-pass" type="password" required autocomplete="current-password"></div>
      <button type="submit" class="btn btn-primary" id="li-btn">Sign in</button>
    </form>
  </div>
</div>

<!-- ===================== APP ===================== -->
<div id="app">

  <div class="topbar">
    <div class="topbar-left">
      <div class="brand-mark" id="top-logo"><svg viewBox="0 0 24 24" fill="none" stroke="#04140f" stroke-width="2.6" stroke-linecap="round"><path d="M3 12h4l2-7 4 14 2-7h6"/></svg></div>
      <span id="top-name">Relay Deck</span>
    </div>
    <button class="iconbtn" onclick="doLogout()" title="Log out">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>
    </button>
  </div>

  <aside class="rail">
    <div class="rail-head">
      <div class="brand-mark" id="rail-logo"><svg viewBox="0 0 24 24" fill="none" stroke="#04140f" stroke-width="2.6" stroke-linecap="round"><path d="M3 12h4l2-7 4 14 2-7h6"/></svg></div>
      <span id="rail-name">Relay Deck</span>
    </div>
    <nav class="rail-nav">
      <div class="rail-item active" data-tab="dashboard"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9" rx="1.5"/><rect x="14" y="3" width="7" height="5" rx="1.5"/><rect x="14" y="12" width="7" height="9" rx="1.5"/><rect x="3" y="16" width="7" height="5" rx="1.5"/></svg>Dashboard</div>
      <div class="rail-item" data-tab="accounts"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>Accounts</div>
      <div class="rail-item ao" data-tab="resellers"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>Resellers</div>
      <div class="rail-item ao" data-tab="services"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="2"/><path d="M12 2v4M12 18v4M4.9 4.9l2.8 2.8M16.3 16.3l2.8 2.8M2 12h4M18 12h4M4.9 19.1l2.8-2.8M16.3 7.7l2.8-2.8"/></svg>Services</div>
      <div class="rail-item ao" data-tab="settings"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>Settings</div>
    </nav>
    <div class="rail-foot">
      <div class="who" id="rail-role">Signed in</div>
      <button class="btn btn-ghost btn-sm" onclick="doLogout()">Log out</button>
    </div>
  </aside>

  <main class="main">

    <!-- DASHBOARD -->
    <section class="tab-panel active" id="tab-dashboard">
      <div class="page-head">
        <div><h1>Dashboard</h1><p>Live relay activity on this node</p></div>
        <div class="head-actions ao"><button class="btn btn-ghost btn-sm" onclick="sysReboot()">Reboot node</button></div>
      </div>

      <div class="pulse-rail" id="pulse-rail-1">
        <svg viewBox="0 0 400 34" preserveAspectRatio="none">
          <path class="pr-line" d="M0,17 L20,17 L28,6 L36,28 L44,17 L70,17 L78,10 L86,24 L94,17 L130,17 L138,4 L146,30 L154,17 L190,17 L198,12 L206,22 L214,17 L250,17 L258,7 L266,27 L274,17 L310,17 L318,11 L326,23 L334,17 L370,17 L378,15 L386,19 L400,17"/>
        </svg>
      </div>

      <div class="quota-note ao hidden" id="reseller-quota-note"></div>

      <div class="stat-grid">
        <div class="stat-card"><div class="stat-top"><span class="stat-label">Accounts</span></div><div class="stat-value" id="s-accounts">--</div><div class="stat-sub" id="s-accounts-sub">managed</div></div>
        <div class="stat-card"><div class="stat-top"><span class="stat-label">Online now</span></div><div class="stat-value" id="s-online">--</div><div class="stat-sub">active sessions</div></div>
        <div class="stat-card ao"><div class="stat-top"><span class="stat-label">Memory</span></div><div class="stat-value" id="s-ram">--</div><div class="stat-sub" id="s-ram-sub">-- / -- MB</div></div>
        <div class="stat-card ao"><div class="stat-top"><span class="stat-label">Load (1m)</span></div><div class="stat-value" id="s-load">--</div><div class="stat-sub">system load average</div></div>
      </div>

      <div class="card sysbar ao" id="sysbar">
        <div class="syschip"><label>IP</label><span id="sys-ip">--</span></div>
        <div class="syschip"><label>OS</label><span id="sys-os">--</span></div>
        <div class="syschip"><label>Uptime</label><span id="sys-up">--</span></div>
      </div>

      <div class="section ao" id="dash-services-wrap">
        <div class="section-title">Services</div>
        <div class="deck" id="dash-services"></div>
      </div>
    </section>

    <!-- ACCOUNTS -->
    <section class="tab-panel" id="tab-accounts">
      <div class="page-head">
        <div><h1>Accounts</h1><p>Tunnel accounts on this node</p></div>
        <div class="head-actions">
          <button class="btn btn-ghost btn-sm" onclick="openM('m-bulk')">Bulk</button>
          <button class="btn btn-ghost btn-sm" onclick="openM('m-trial')">Trial</button>
          <button class="btn btn-primary btn-sm" onclick="openM('m-new')">New account</button>
        </div>
      </div>
      <div class="searchbar" style="margin-bottom:1.1rem;">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg>
        <input type="text" id="acct-search" placeholder="Search accounts…" oninput="renderAccounts()">
      </div>
      <div class="acct-list" id="acct-list"></div>
    </section>

    <!-- RESELLERS -->
    <section class="tab-panel" id="tab-resellers">
      <div class="page-head">
        <div><h1>Resellers</h1><p>Sub-accounts with their own quota</p></div>
        <div class="head-actions"><button class="btn btn-primary btn-sm" onclick="openM('m-reseller-new')">New reseller</button></div>
      </div>
      <div class="deck" id="reseller-deck"></div>
    </section>

    <!-- SERVICES -->
    <section class="tab-panel" id="tab-services">
      <div class="page-head"><div><h1>Services</h1><p>Protocol daemons running on this node</p></div></div>
      <div class="deck" id="services-deck"></div>
    </section>

    <!-- SETTINGS -->
    <section class="tab-panel" id="tab-settings">
      <div class="page-head"><div><h1>Settings</h1><p>Panel identity &amp; access</p></div></div>
      <div class="card" style="max-width:480px;">
        <h3 style="font-size:.82rem;font-weight:700;color:var(--accent-2);margin-bottom:1rem;text-transform:uppercase;letter-spacing:.06em;">Branding</h3>
        <div class="grid-2"><div class="field"><label>Panel name</label><input type="text" id="s-name" placeholder="Relay Deck"></div><div class="field"><label>Logo emoji</label><input type="text" id="s-emoji" maxlength="4" placeholder="⚡"></div></div>
        <div class="field">
          <label>Or upload a logo image (PNG, max 2MB)</label>
          <div style="display:flex;gap:.5rem;align-items:center;flex-wrap:wrap;margin-top:.2rem;">
            <input type="file" id="s-logofile" accept="image/png" style="font-size:.78rem;color:var(--text-dim);">
            <button type="button" class="btn btn-ghost btn-sm" onclick="uploadLogo()">Upload</button>
            <button type="button" class="btn btn-danger-ghost btn-sm hidden" id="s-logo-del" onclick="deleteLogo()">Remove</button>
          </div>
          <div class="hidden" id="s-logo-preview" style="margin-top:.5rem;"><img id="s-logo-img" src="" style="max-height:44px;border-radius:8px;border:1px solid var(--line);"></div>
        </div>
        <div style="height:1px;background:var(--line);margin:1.1rem 0;"></div>
        <h3 style="font-size:.82rem;font-weight:700;color:var(--accent-2);margin-bottom:1rem;text-transform:uppercase;letter-spacing:.06em;">Credentials</h3>
        <div class="field"><label>Current username</label><input type="text" id="s-cuser" disabled style="opacity:.5;"></div>
        <div class="field"><label>Current password (required to save)</label><input type="password" id="s-cpass"></div>
        <div class="grid-2"><div class="field"><label>New username</label><input type="text" id="s-nuser" placeholder="Keep current"></div><div class="field"><label>New password</label><input type="password" id="s-npass" placeholder="Keep current"></div></div>
        <div style="height:1px;background:var(--line);margin:1.1rem 0;"></div>
        <h3 style="font-size:.82rem;font-weight:700;color:var(--accent-2);margin-bottom:1rem;text-transform:uppercase;letter-spacing:.06em;">Access</h3>
        <div class="field"><label>Secret URL path</label><input type="text" id="s-secret" placeholder="e.g. relay-9f2"><div class="note">URL: <span class="mono" id="s-url" style="color:var(--accent);">--</span></div></div>
        <button class="btn btn-primary" onclick="saveSettings()">Save changes</button>
      </div>
    </section>

  </main>

  <nav class="bottombar">
    <div class="bb-item active" data-tab="dashboard"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9" rx="1.5"/><rect x="14" y="3" width="7" height="5" rx="1.5"/><rect x="14" y="12" width="7" height="9" rx="1.5"/><rect x="3" y="16" width="7" height="5" rx="1.5"/></svg><span>Deck</span></div>
    <div class="bb-item" data-tab="accounts"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg><span>Accounts</span></div>
    <div class="bb-item ao" data-tab="resellers"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg><span>Resellers</span></div>
    <div class="bb-item ao" data-tab="services"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="2"/><path d="M12 2v4M12 18v4M4.9 4.9l2.8 2.8M16.3 16.3l2.8 2.8"/></svg><span>Services</span></div>
    <div class="bb-item ao" data-tab="settings"><svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82"/></svg><span>Settings</span></div>
  </nav>
</div>

<!-- ===================== MODALS ===================== -->
<div class="modal-veil" id="m-new">
  <div class="modal"><div class="modal-head"><h3>New account</h3><button class="iconbtn" onclick="closeM('m-new')">✕</button></div>
  <form id="f-new">
    <div class="field"><label>Username</label><input type="text" id="cn-user" required pattern="[a-zA-Z0-9_]+"></div>
    <div class="field"><label>Password</label><div class="field-row"><input type="text" id="cn-pass"><button type="button" class="btn btn-ghost btn-sm" onclick="genPass('cn-pass')">Gen</button></div><div class="note">Leave blank to auto-generate</div></div>
    <div class="grid-2"><div class="field"><label>Days</label><input type="number" id="cn-days" value="30" min="1" required></div><div class="field"><label>Devices</label><input type="number" id="cn-conn" value="1" min="1" required></div></div>
    <div class="grid-2"><div class="field"><label>Total BW (GB, 0=∞)</label><input type="number" step=".1" id="cn-bw" value="0" min="0"></div><div class="field"><label>Daily BW (GB, 0=∞)</label><input type="number" step=".1" id="cn-dbw" value="0" min="0"></div></div>
    <div class="modal-actions"><button type="button" class="btn btn-ghost" onclick="closeM('m-new')">Cancel</button><button type="submit" class="btn btn-primary">Create</button></div>
  </form></div>
</div>

<div class="modal-veil" id="m-edit">
  <div class="modal"><div class="modal-head"><h3>Edit account</h3><button class="iconbtn" onclick="closeM('m-edit')">✕</button></div>
  <form id="f-edit">
    <input type="hidden" id="ce-user">
    <div class="field"><label>Username</label><input type="text" id="ce-user-disp" disabled style="opacity:.5;"></div>
    <div class="field"><label>New password</label><div class="field-row"><input type="text" id="ce-pass" placeholder="Unchanged"><button type="button" class="btn btn-ghost btn-sm" onclick="genPass('ce-pass')">Gen</button></div></div>
    <div class="grid-2"><div class="field"><label>Renew (days)</label><input type="number" id="ce-days" placeholder="Keep current" min="1"></div><div class="field"><label>Devices</label><input type="number" id="ce-conn" min="1" required></div></div>
    <div class="grid-2"><div class="field"><label>Total BW (GB)</label><input type="number" step=".1" id="ce-bw" min="0"></div><div class="field"><label>Daily BW (GB)</label><input type="number" step=".1" id="ce-dbw" min="0"></div></div>
    <div class="modal-actions"><button type="button" class="btn btn-ghost" onclick="closeM('m-edit')">Cancel</button><button type="submit" class="btn btn-primary">Save</button></div>
  </form></div>
</div>

<div class="modal-veil" id="m-bulk">
  <div class="modal"><div class="modal-head"><h3>Bulk create</h3><button class="iconbtn" onclick="closeM('m-bulk')">✕</button></div>
  <form id="f-bulk">
    <div class="grid-2"><div class="field"><label>Prefix</label><input type="text" id="bk-prefix" value="user" required></div><div class="field"><label>Count</label><input type="number" id="bk-count" value="5" min="1" max="50" required></div></div>
    <div class="grid-2"><div class="field"><label>Days</label><input type="number" id="bk-days" value="30" min="1" required></div><div class="field"><label>Devices</label><input type="number" id="bk-conn" value="1" min="1" required></div></div>
    <div class="grid-2"><div class="field"><label>Total BW (GB)</label><input type="number" step=".1" id="bk-bw" value="0" min="0"></div><div class="field"><label>Daily BW (GB)</label><input type="number" step=".1" id="bk-dbw" value="0" min="0"></div></div>
    <div class="modal-actions"><button type="button" class="btn btn-ghost" onclick="closeM('m-bulk')">Cancel</button><button type="submit" class="btn btn-primary">Create batch</button></div>
  </form></div>
</div>

<div class="modal-veil" id="m-trial">
  <div class="modal"><div class="modal-head"><h3>Trial account</h3><button class="iconbtn" onclick="closeM('m-trial')">✕</button></div>
  <form id="f-trial">
    <div class="field"><label>Username (optional)</label><input type="text" id="tr-user" placeholder="Auto-generated"></div>
    <div class="field"><label>Password</label><div class="field-row"><input type="text" id="tr-pass" placeholder="Auto-generated"><button type="button" class="btn btn-ghost btn-sm" onclick="genPass('tr-pass')">Gen</button></div></div>
    <div class="field"><label>Duration</label><select id="tr-hours"><option value="1">1 hour</option><option value="2">2 hours</option><option value="3">3 hours</option><option value="6">6 hours</option><option value="12">12 hours</option><option value="24">1 day</option><option value="72">3 days</option></select></div>
    <div class="grid-2"><div class="field"><label>Devices</label><input type="number" id="tr-conn" value="1" min="1" required></div><div class="field"><label>BW (GB, 0=∞)</label><input type="number" step=".1" id="tr-bw" value="0" min="0"></div></div>
    <div class="modal-actions"><button type="button" class="btn btn-ghost" onclick="closeM('m-trial')">Cancel</button><button type="submit" class="btn btn-primary">Create trial</button></div>
  </form></div>
</div>

<div class="modal-veil" id="m-reseller-new">
  <div class="modal"><div class="modal-head"><h3>New reseller</h3><button class="iconbtn" onclick="closeM('m-reseller-new')">✕</button></div>
  <form id="f-reseller-new">
    <div class="field"><label>Username</label><input type="text" id="rn-user" required pattern="[a-zA-Z0-9_]+"></div>
    <div class="field"><label>Password</label><div class="field-row"><input type="text" id="rn-pass" required><button type="button" class="btn btn-ghost btn-sm" onclick="genPass('rn-pass')">Gen</button></div></div>
    <div class="grid-2"><div class="field"><label>Days</label><input type="number" id="rn-days" value="30" min="1" required></div><div class="field"><label>Max users</label><input type="number" id="rn-max" value="10" min="1" required></div></div>
    <div class="modal-actions"><button type="button" class="btn btn-ghost" onclick="closeM('m-reseller-new')">Cancel</button><button type="submit" class="btn btn-primary">Create</button></div>
  </form></div>
</div>

<div class="modal-veil" id="m-reseller-edit">
  <div class="modal"><div class="modal-head"><h3>Edit reseller</h3><button class="iconbtn" onclick="closeM('m-reseller-edit')">✕</button></div>
  <form id="f-reseller-edit">
    <input type="hidden" id="re-user">
    <div class="field"><label>Username</label><input type="text" id="re-user-disp" disabled style="opacity:.5;"></div>
    <div class="field"><label>New password</label><div class="field-row"><input type="text" id="re-pass" placeholder="Unchanged"><button type="button" class="btn btn-ghost btn-sm" onclick="genPass('re-pass')">Gen</button></div></div>
    <div class="grid-2"><div class="field"><label>Extend (days)</label><input type="number" id="re-days" placeholder="Keep current" min="1"></div><div class="field"><label>Max users</label><input type="number" id="re-max" min="1" required></div></div>
    <div class="modal-actions"><button type="button" class="btn btn-ghost" onclick="closeM('m-reseller-edit')">Cancel</button><button type="submit" class="btn btn-primary">Save</button></div>
  </form></div>
</div>

<script>
/* ================= state ================= */
let ROLE='admin', ME='', USERS=[], RESELLERS=[];

/* ================= api ================= */
async function api(method, path, body){
  const opts={method, credentials:'same-origin', headers:{}};
  if(body){opts.headers['Content-Type']='application/json';opts.body=JSON.stringify(body);}
  const r=await fetch(path,opts);
  if(r.status===401 && path!=='/api/login'){ showLogin(); throw new Error('Session expired'); }
  const d=await r.json();
  if(!r.ok) throw new Error(d.error||'Request failed');
  return d;
}
function toast(msg,kind){
  const box=document.getElementById('toasts');
  const t=document.createElement('div');
  t.className='toast'+(kind==='err'?' err':'');
  t.textContent=msg;
  box.appendChild(t);
  setTimeout(()=>t.remove(),3000);
}
const E=s=>String(s??'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
function fmtBytes(b){if(!b)return'0 MB';const g=b/1073741824;return g>=1?g.toFixed(1)+'G':(b/1048576).toFixed(0)+' MB';}
function daysLeft(exp){
  if(!exp||exp==='Never')return'';
  const ms=new Date(exp+'T23:59:59')-new Date();
  const d=Math.ceil(ms/86400000);
  if(d<0)return `<span style="color:var(--danger);font-size:.68rem;">${Math.abs(d)}d ago</span>`;
  if(d<=7)return `<span style="color:var(--warn);font-size:.68rem;">${d}d left</span>`;
  return `<span style="color:var(--text-faint);font-size:.68rem;">${d}d left</span>`;
}

/* ================= branding ================= */
function applyBrand(name,logo,hasCustom){
  const n = name || 'Relay Deck';
  document.title = n;
  ['login-name','top-name','rail-name'].forEach(id=>{const e=document.getElementById(id); if(e) e.textContent=n;});
  const isImg = logo==='custom' && hasCustom;
  ['login-logo','top-logo','rail-logo'].forEach(id=>{
    const e=document.getElementById(id); if(!e) return;
    if(isImg){ e.innerHTML=`<img src="/api/logo.png?t=${Date.now()}">`; }
    else{ e.innerHTML=`<span style="font-size:1.1em;">${E(logo||'⚡')}</span>`; }
  });
}
async function loadBranding(){
  try{ const r=await fetch('/api/branding'); if(r.ok){ const d=await r.json(); applyBrand(d.panel_name,d.panel_logo,d.has_custom_logo); } }catch(e){}
}

/* ================= auth ================= */
function showLogin(){
  document.getElementById('app').style.display='none';
  document.getElementById('login-screen').style.display='flex';
}
async function showApp(){
  document.getElementById('login-screen').style.display='none';
  document.getElementById('app').style.display='block';
  applyRole();
  switchTab('dashboard');
}
function applyRole(){
  const isAdmin = ROLE==='admin';
  document.querySelectorAll('.ao').forEach(e=> e.classList.toggle('hidden', !isAdmin));
  document.getElementById('rail-role').textContent = isAdmin ? 'Administrator' : ('Reseller · '+ME);
}
document.getElementById('login-form').addEventListener('submit', async e=>{
  e.preventDefault();
  const btn=document.getElementById('li-btn'); btn.disabled=true; btn.textContent='Signing in…';
  try{
    await api('POST','/api/login',{username:document.getElementById('li-user').value,password:document.getElementById('li-pass').value});
    const me=await api('GET','/api/me');
    ROLE=me.role; ME=me.username;
    applyBrand(me.panel_name,me.panel_logo,me.has_custom_logo);
    toast('Welcome back','ok');
    showApp();
  }catch(err){ toast(err.message,'err'); }
  finally{ btn.disabled=false; btn.textContent='Sign in'; }
});
async function doLogout(){ try{ await api('POST','/api/logout'); }catch(e){} showLogin(); }
async function initAuth(){
  await loadBranding();
  try{
    const me=await api('GET','/api/me');
    ROLE=me.role; ME=me.username;
    applyBrand(me.panel_name,me.panel_logo,me.has_custom_logo);
    showApp();
  }catch(e){ showLogin(); }
}
document.addEventListener('DOMContentLoaded', initAuth);

/* ================= tabs ================= */
function switchTab(t){
  document.querySelectorAll('.tab-panel').forEach(p=>p.classList.toggle('active',p.id==='tab-'+t));
  document.querySelectorAll('.rail-item,.bb-item').forEach(i=>i.classList.toggle('active',i.dataset.tab===t));
  localStorage.setItem('rd-tab',t);
  if(t==='dashboard') loadDashboard();
  else if(t==='accounts') loadAccounts();
  else if(t==='resellers') loadResellers();
  else if(t==='services') loadServices('services-deck');
  else if(t==='settings') loadSettings();
}
document.querySelectorAll('.rail-item,.bb-item').forEach(i=>i.addEventListener('click',()=>switchTab(i.dataset.tab)));

let poll;
function startPoll(){
  if(poll) clearInterval(poll);
  poll=setInterval(()=>{
    if(document.getElementById('app').style.display==='none') return;
    const t=localStorage.getItem('rd-tab')||'dashboard';
    if(t==='dashboard') loadDashboard(true);
    else if(t==='accounts') loadAccounts(true);
    else if(t==='resellers') loadResellers(true);
  },6000);
}
startPoll();

/* ================= dashboard ================= */
function setPulseState(pct){
  const rail=document.getElementById('pulse-rail-1');
  rail.classList.remove('warn','danger');
  if(pct>=90) rail.classList.add('danger');
  else if(pct>=70) rail.classList.add('warn');
}
async function loadDashboard(silent){
  try{
    const d=await api('GET','/api/dashboard');
    document.getElementById('s-accounts').textContent=d.user_count ?? '--';
    document.getElementById('s-online').textContent=d.online_sessions ?? '--';
    if(d.ram_percent!==undefined){
      document.getElementById('s-ram').textContent=d.ram_percent+'%';
      document.getElementById('s-ram-sub').textContent=`${d.ram_used_mb} / ${d.ram_total_mb} MB`;
      document.getElementById('s-load').textContent=d.cpu_load_1m;
      document.getElementById('sys-ip').textContent=d.server_ip||'--';
      document.getElementById('sys-os').textContent=d.os_name||'--';
      document.getElementById('sys-up').textContent=d.uptime||'--';
      setPulseState(d.ram_percent);
      document.getElementById('s-accounts-sub').textContent='managed on this node';
    }
    if(d.reseller_info){
      const box=document.getElementById('reseller-quota-note');
      box.classList.remove('hidden');
      box.textContent=`Quota: ${d.reseller_info.created_users}/${d.reseller_info.max_users} accounts · expires ${d.reseller_info.expire_date}`;
      document.getElementById('s-accounts-sub').textContent='your accounts';
    }
    if(d.protocols && d.protocols.length) renderServices(d.protocols,'dash-services');
  }catch(e){ if(!silent) toast(e.message,'err'); }
}

/* ================= accounts ================= */
async function loadAccounts(silent){
  try{ const d=await api('GET','/api/users'); USERS=d.users||[]; renderAccounts(); }
  catch(e){ if(!silent) toast(e.message,'err'); }
}
function statusOf(u){
  if(u.is_expired) return 'danger';
  if(u.is_locked) return 'off';
  return 'on';
}
function ringHtml(u){
  let pct=0, tone='';
  if(u.bandwidth_gb>0){ pct=Math.min(100,Math.round((u.total_used_bytes/ (u.bandwidth_gb*1073741824))*100)); }
  else if(u.daily_bandwidth_gb>0){ pct=Math.min(100,Math.round((u.daily_used_bytes/ (u.daily_bandwidth_gb*1073741824))*100)); }
  else { pct = u.online_sessions>0 ? 100 : 0; }
  if(pct>=90) tone='danger'; else if(pct>=70) tone='warn';
  const r=13,c=2*Math.PI*r,off=c-(pct/100)*c;
  return `<div class="ring ${tone}"><svg viewBox="0 0 32 32"><circle class="track" cx="16" cy="16" r="${r}"/><circle class="val" cx="16" cy="16" r="${r}" stroke-dasharray="${c}" stroke-dashoffset="${off}"/></svg><div class="rlabel">${u.online_sessions}/${u.conn_limit}</div></div>`;
}
function badgeHtml(u){
  if(u.is_expired) return `<span class="badge danger">Expired</span>`;
  if(u.is_locked) return `<span class="badge off">Locked</span>`;
  if(u.is_online) return `<span class="badge on">Online</span>`;
  return `<span class="badge b2">Active</span>`;
}
function renderAccounts(){
  const q=(document.getElementById('acct-search').value||'').toLowerCase();
  const list=document.getElementById('acct-list');
  const rows=USERS.filter(u=>u.username.toLowerCase().includes(q));
  if(!rows.length){ list.innerHTML=`<div class="card" style="text-align:center;color:var(--text-faint);">No accounts found.</div>`; return; }
  list.innerHTML=rows.map(u=>{
    const bw = u.bandwidth_gb>0 ? `${fmtBytes(u.total_used_bytes)}/${u.bandwidth_gb}G` : `${fmtBytes(u.total_used_bytes)}/∞`;
    const owner = ROLE==='admin' ? `<span class="badge ${u.owner==='admin'?'b2':'warn'}" style="margin-left:.3rem;">${E(u.owner||'admin')}</span>` : '';
    return `<div class="acct">
      ${ringHtml(u)}
      <div><div class="acct-meta">User</div><div class="acct-name">${E(u.username)}</div></div>
      <div><div class="acct-meta">Expires</div><div class="acct-val">${E(u.expire_date)}</div>${daysLeft(u.expire_date)}</div>
      <div><div class="acct-meta">Sessions</div><div class="acct-val">${u.online_sessions}/${u.conn_limit}</div></div>
      <div><div class="acct-meta">Bandwidth</div><div class="acct-val">${bw}</div></div>
      <div>${badgeHtml(u)}${owner}</div>
      <div class="acct-actions">
        <button class="iconbtn" title="Renew" onclick="renewUser('${E(u.username)}')"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-3-6.7"/><path d="M21 3v6h-6"/></svg></button>
        <button class="iconbtn" title="Edit" onclick="openEditUser('${E(u.username)}')"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg></button>
        ${u.is_locked?
          `<button class="iconbtn" title="Unlock" onclick="lockUser('${E(u.username)}',false)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="10" rx="2"/><path d="M7 11V7a5 5 0 0 1 9.4-2.5"/></svg></button>`:
          `<button class="iconbtn" title="Lock" onclick="lockUser('${E(u.username)}',true)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="10" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></button>`}
        <button class="iconbtn dz" title="Delete" onclick="deleteUser('${E(u.username)}')"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg></button>
      </div>
    </div>`;
  }).join('');
}
async function lockUser(u,lock){
  try{ await api('POST',`/api/users/${u}/${lock?'lock':'unlock'}`); toast(lock?'Locked':'Unlocked','ok'); loadAccounts(); }
  catch(e){ toast(e.message,'err'); }
}
async function deleteUser(u){
  if(!confirm(`Delete account "${u}"? This cannot be undone.`)) return;
  try{ await api('DELETE',`/api/users/${u}`); toast('Deleted','ok'); loadAccounts(); }
  catch(e){ toast(e.message,'err'); }
}
async function renewUser(u){
  const days=prompt(`Renew "${u}" — extend by how many days?`,'30');
  if(!days || isNaN(days)) return;
  try{ await api('POST',`/api/users/${u}/renew`,{days:+days}); toast('Renewed','ok'); loadAccounts(); }
  catch(e){ toast(e.message,'err'); }
}
function openEditUser(u){
  const rec=USERS.find(x=>x.username===u); if(!rec) return;
  document.getElementById('ce-user').value=u;
  document.getElementById('ce-user-disp').value=u;
  document.getElementById('ce-pass').value='';
  document.getElementById('ce-days').value='';
  document.getElementById('ce-conn').value=rec.conn_limit;
  document.getElementById('ce-bw').value=rec.bandwidth_gb;
  document.getElementById('ce-dbw').value=rec.daily_bandwidth_gb;
  openM('m-edit');
}

/* ================= resellers ================= */
async function loadResellers(silent){
  try{ const d=await api('GET','/api/resellers'); RESELLERS=d.resellers||[]; renderResellers(); }
  catch(e){ if(!silent) toast(e.message,'err'); }
}
function renderResellers(){
  const el=document.getElementById('reseller-deck');
  if(!RESELLERS.length){ el.innerHTML=`<div class="card" style="text-align:center;color:var(--text-faint);">No resellers yet.</div>`; return; }
  el.innerHTML=RESELLERS.map(r=>{
    const status = r.is_expired ? `<span class="badge danger">Expired</span>` : !r.enabled ? `<span class="badge off">Disabled</span>` : `<span class="badge on">Active</span>`;
    return `<div class="card">
      <div class="card-row"><span class="acct-name">${E(r.username)}</span>${status}</div>
      <div style="display:flex;gap:1.3rem;margin-top:.7rem;">
        <div><div class="acct-meta">Quota</div><div class="acct-val">${r.created_users}/${r.max_users}</div></div>
        <div><div class="acct-meta">Expires</div><div class="acct-val">${E(r.expire_date)}</div>${daysLeft(r.expire_date)}</div>
      </div>
      <div style="display:flex;gap:.4rem;margin-top:.9rem;">
        <button class="btn btn-ghost btn-sm" style="flex:1;" onclick="openEditReseller('${E(r.username)}')">Edit</button>
        <button class="btn btn-ghost btn-sm" style="flex:1;" onclick="toggleReseller('${E(r.username)}')">${r.enabled?'Disable':'Enable'}</button>
        <button class="btn btn-danger-ghost btn-sm" style="flex:1;" onclick="deleteReseller('${E(r.username)}',${r.created_users})">Delete</button>
      </div>
    </div>`;
  }).join('');
}
async function toggleReseller(u){
  try{ const r=await api('POST',`/api/resellers/${u}/toggle`); toast(r.enabled?'Enabled':'Disabled','ok'); loadResellers(); }
  catch(e){ toast(e.message,'err'); }
}
async function deleteReseller(u,n){
  let delUsers=false;
  if(n>0) delUsers=confirm(`This reseller owns ${n} account(s). Also delete those accounts?`);
  if(!confirm(`Delete reseller "${u}"?`)) return;
  try{ await api('DELETE',`/api/resellers/${u}?delete_users=${delUsers?'1':'0'}`); toast('Deleted','ok'); loadResellers(); }
  catch(e){ toast(e.message,'err'); }
}
function openEditReseller(u){
  const rec=RESELLERS.find(x=>x.username===u); if(!rec) return;
  document.getElementById('re-user').value=u;
  document.getElementById('re-user-disp').value=u;
  document.getElementById('re-pass').value='';
  document.getElementById('re-days').value='';
  document.getElementById('re-max').value=rec.max_users;
  openM('m-reseller-edit');
}

/* ================= services ================= */
async function loadServices(target){
  try{ const d=await api('GET','/api/protocols'); renderServices(d,target); }
  catch(e){ toast(e.message,'err'); }
}
function renderServices(list,target){
  const el=document.getElementById(target); if(!el) return;
  el.innerHTML=list.map(s=>`
    <div class="card">
      <div class="card-row">
        <div><div style="font-weight:600;font-size:.9rem;">${E(s.name)}</div><div class="mono" style="font-size:.72rem;color:var(--text-faint);margin-top:.2rem;">Port ${E(s.port)}</div></div>
        ${!s.installed?`<span class="badge off">N/A</span>`:s.running?`<span class="badge on">Running</span>`:`<span class="badge danger">Stopped</span>`}
      </div>
      ${s.installed?`<button class="btn btn-ghost btn-sm" style="width:100%;margin-top:.8rem;" onclick="restartService('${s.service}')">Restart</button>`:''}
    </div>`).join('');
}
async function restartService(svc){
  try{ await api('POST',`/api/protocols/${svc}/restart`); toast('Restarted','ok'); loadServices('services-deck'); }
  catch(e){ toast(e.message,'err'); }
}

/* ================= settings ================= */
async function loadSettings(){
  try{
    const d=await api('GET','/api/settings');
    document.getElementById('s-cuser').value=d.username||'';
    document.getElementById('s-secret').value=d.secret||'';
    document.getElementById('s-name').value=d.panel_name||'Relay Deck';
    document.getElementById('s-emoji').value=(d.panel_logo==='custom')?'':(d.panel_logo||'⚡');
    updateSettingsUrl(d.secret||'');
    if(d.has_custom_logo){
      document.getElementById('s-logo-preview').classList.remove('hidden');
      document.getElementById('s-logo-img').src='/api/logo.png?t='+Date.now();
      document.getElementById('s-logo-del').classList.remove('hidden');
    }else{
      document.getElementById('s-logo-preview').classList.add('hidden');
      document.getElementById('s-logo-del').classList.add('hidden');
    }
  }catch(e){ toast(e.message,'err'); }
}
document.getElementById('s-secret').addEventListener('input',e=>updateSettingsUrl(e.target.value));
function updateSettingsUrl(secret){
  const p=(secret||'').trim().replace(/^\/+/,'');
  document.getElementById('s-url').textContent = p ? `${location.origin}/${p}` : `${location.origin}/`;
}
async function saveSettings(){
  try{
    const body={
      current_password:document.getElementById('s-cpass').value,
      new_username:document.getElementById('s-nuser').value,
      new_password:document.getElementById('s-npass').value,
      new_secret:document.getElementById('s-secret').value,
      panel_name:document.getElementById('s-name').value,
      panel_logo:document.getElementById('s-emoji').value
    };
    const r=await api('PUT','/api/settings',body);
    applyBrand(r.panel_name,r.panel_logo,false);
    toast('Settings saved','ok');
    document.getElementById('s-cpass').value='';
    if(r.secret){ const u=`${location.origin}/${r.secret}`; alert('Panel moved to a new URL:\n'+u); location.href=u; }
  }catch(e){ toast(e.message,'err'); }
}
async function uploadLogo(){
  const f=document.getElementById('s-logofile').files[0];
  if(!f){ toast('Choose a PNG file first','err'); return; }
  if(f.size>2097152){ toast('Max size is 2MB','err'); return; }
  if(!f.type.includes('png')){ toast('PNG only','err'); return; }
  try{
    const r=await fetch('/api/logo/upload',{method:'POST',credentials:'same-origin',body:f});
    const d=await r.json();
    if(!r.ok) throw new Error(d.error||'Upload failed');
    toast('Logo uploaded','ok');
    applyBrand(document.getElementById('s-name').value,'custom',true);
    loadSettings();
  }catch(e){ toast(e.message,'err'); }
}
async function deleteLogo(){
  if(!confirm('Remove the custom logo image?')) return;
  try{ const d=await api('POST','/api/logo/delete'); toast('Logo removed','ok'); applyBrand(document.getElementById('s-name').value,d.panel_logo,false); loadSettings(); }
  catch(e){ toast(e.message,'err'); }
}
async function sysReboot(){
  if(!confirm('Reboot the server? All sessions will drop briefly.')) return;
  try{ await api('POST','/api/system/reboot'); toast('Rebooting…','ok'); setTimeout(showLogin,2500); }
  catch(e){ toast(e.message,'err'); }
}

/* ================= modals & forms ================= */
function openM(id){ document.getElementById(id).classList.add('active'); }
function closeM(id){ document.getElementById(id).classList.remove('active'); }
function genPass(id){
  const c='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let r=''; for(let i=0;i<10;i++) r+=c[Math.floor(Math.random()*c.length)];
  document.getElementById(id).value=r;
}

document.getElementById('f-new').addEventListener('submit', async e=>{
  e.preventDefault();
  try{
    await api('POST','/api/users',{
      username:document.getElementById('cn-user').value,
      password:document.getElementById('cn-pass').value,
      days:+document.getElementById('cn-days').value,
      conn_limit:+document.getElementById('cn-conn').value,
      bandwidth_gb:+(document.getElementById('cn-bw').value||0),
      daily_bandwidth_gb:+(document.getElementById('cn-dbw').value||0)
    });
    toast('Account created','ok'); closeM('m-new'); e.target.reset(); document.getElementById('cn-days').value=30; document.getElementById('cn-conn').value=1; loadAccounts();
  }catch(err){ toast(err.message,'err'); }
});

document.getElementById('f-edit').addEventListener('submit', async e=>{
  e.preventDefault();
  const u=document.getElementById('ce-user').value;
  const body={conn_limit:+document.getElementById('ce-conn').value,bandwidth_gb:+(document.getElementById('ce-bw').value||0),daily_bandwidth_gb:+(document.getElementById('ce-dbw').value||0)};
  const pw=document.getElementById('ce-pass').value; if(pw) body.password=pw;
  const days=document.getElementById('ce-days').value; if(days) body.days=+days;
  try{ await api('PUT',`/api/users/${u}`,body); toast('Updated','ok'); closeM('m-edit'); loadAccounts(); }
  catch(err){ toast(err.message,'err'); }
});

document.getElementById('f-bulk').addEventListener('submit', async e=>{
  e.preventDefault();
  try{
    const r=await api('POST','/api/users/bulk',{
      prefix:document.getElementById('bk-prefix').value,
      count:+document.getElementById('bk-count').value,
      days:+document.getElementById('bk-days').value,
      conn_limit:+document.getElementById('bk-conn').value,
      bandwidth_gb:+(document.getElementById('bk-bw').value||0),
      daily_bandwidth_gb:+(document.getElementById('bk-dbw').value||0)
    });
    toast(`${r.users?r.users.length:0} accounts created`,'ok'); closeM('m-bulk'); loadAccounts();
  }catch(err){ toast(err.message,'err'); }
});

document.getElementById('f-trial').addEventListener('submit', async e=>{
  e.preventDefault();
  try{
    const r=await api('POST','/api/users/trial',{
      username:document.getElementById('tr-user').value,
      password:document.getElementById('tr-pass').value,
      hours:+document.getElementById('tr-hours').value,
      conn_limit:+document.getElementById('tr-conn').value,
      bandwidth_gb:+(document.getElementById('tr-bw').value||0)
    });
    toast(`Trial "${r.username}" created — expires ${r.expiry_time}`,'ok'); closeM('m-trial'); loadAccounts();
  }catch(err){ toast(err.message,'err'); }
});

document.getElementById('f-reseller-new').addEventListener('submit', async e=>{
  e.preventDefault();
  try{
    await api('POST','/api/resellers',{
      username:document.getElementById('rn-user').value,
      password:document.getElementById('rn-pass').value,
      days:+document.getElementById('rn-days').value,
      max_users:+document.getElementById('rn-max').value
    });
    toast('Reseller created','ok'); closeM('m-reseller-new'); loadResellers();
  }catch(err){ toast(err.message,'err'); }
});

document.getElementById('f-reseller-edit').addEventListener('submit', async e=>{
  e.preventDefault();
  const u=document.getElementById('re-user').value;
  const body={max_users:+document.getElementById('re-max').value};
  const pw=document.getElementById('re-pass').value; if(pw) body.password=pw;
  const days=document.getElementById('re-days').value; if(days) body.days=+days;
  try{ await api('PUT',`/api/resellers/${u}`,body); toast('Updated','ok'); closeM('m-reseller-edit'); loadResellers(); }
  catch(err){ toast(err.message,'err'); }
});
</script>
</body>
</html>
__NG_PANEL_HTML_EOF__
    if [ ! -s "$PANEL_HTML_FILE" ]; then
        echo -e "${C_RED}❌ Failed to write panel frontend.${C_RESET}"
        return
    fi
    
    # Save credentials
    cat > "$PANEL_CONF" <<-PEOF
PANEL_USER="$panel_user"
PANEL_PASS_HASH="$panel_pass_hash"
PANEL_PASS_PLAIN="$panel_pass"
PANEL_SECRET="$panel_secret"
PEOF
    chmod 600 "$PANEL_CONF"
    
    # Create systemd service
    cat > "$PANEL_SERVICE_FILE" <<-SEOF
[Unit]
Description=Mohammad Ahmad VPN Manager Web Control Panel
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/python3 $PANEL_SCRIPT
Restart=always
RestartSec=5
Nice=10
MemoryHigh=64M
MemoryMax=96M
Environment=PANEL_PORT=$PANEL_PORT

[Install]
WantedBy=multi-user.target
SEOF
    
    systemctl daemon-reload
    systemctl enable firewallfalcon-panel &>/dev/null
    systemctl start firewallfalcon-panel &>/dev/null
    sleep 2
    
    if systemctl is-active --quiet firewallfalcon-panel; then
        local server_ip
        server_ip=$(curl -s -4 --max-time 3 icanhazip.com 2>/dev/null || echo "YOUR_SERVER_IP")
        
        clear; show_banner
        echo -e "${C_GREEN}=====================================================${C_RESET}"
        echo -e "${C_GREEN}     ✅ Web Control Panel Installed Successfully!     ${C_RESET}"
        echo -e "${C_GREEN}=====================================================${C_RESET}"
        echo -e "\n${C_CYAN}  🌐 Panel URL:${C_RESET}    ${C_YELLOW}http://${server_ip}:${PANEL_PORT}/${panel_secret}${C_RESET}"
        echo -e "${C_CYAN}  👤 Username:${C_RESET}     ${C_YELLOW}${panel_user}${C_RESET}"
        echo -e "${C_CYAN}  🔑 Password:${C_RESET}     ${C_YELLOW}${panel_pass}${C_RESET}"
        echo -e "${C_CYAN}  🔐 Secret Path:${C_RESET}   ${C_YELLOW}/${panel_secret}${C_RESET}"
        echo -e "\n${C_DIM}  Save these credentials! You can view them later from option [21] > [3].${C_RESET}"
    else
        echo -e "\n${C_RED}❌ Panel service failed to start. Checking logs:${C_RESET}"
        journalctl -u firewallfalcon-panel -n 15 --no-pager
    fi
}

uninstall_web_panel() {
    if [ ! -f "$PANEL_SERVICE_FILE" ]; then
        if [[ "$UNINSTALL_MODE" != "silent" ]]; then
            echo -e "${C_YELLOW}ℹ️ Web Panel is not installed.${C_RESET}"
        fi
        return
    fi
    
    if [[ "$UNINSTALL_MODE" != "silent" ]]; then
        echo -e "\n${C_BOLD}${C_PURPLE}--- 🗑️ Uninstalling Web Control Panel ---${C_RESET}"
        read -p "👉 Are you sure you want to uninstall the Web Panel? (y/n): " confirm
        if [[ "$confirm" != "y" ]]; then
            echo -e "\n${C_YELLOW}❌ Uninstallation cancelled.${C_RESET}"
            return
        fi
    fi
    
    echo -e "${C_BLUE}🛑 Stopping and removing Web Panel service...${C_RESET}"
    systemctl stop firewallfalcon-panel &>/dev/null
    systemctl disable firewallfalcon-panel &>/dev/null
    rm -f "$PANEL_SERVICE_FILE"
    rm -f "$PANEL_SCRIPT"
    rm -rf "$PANEL_HTML_DIR"
    rm -f "$PANEL_CONF"
    systemctl daemon-reload
    
    echo -e "${C_GREEN}✅ Web Panel has been uninstalled.${C_RESET}"
}

show_panel_credentials() {
    if [ ! -f "$PANEL_CONF" ]; then
        echo -e "\n${C_YELLOW}ℹ️ Web Panel is not installed.${C_RESET}"
        return
    fi
    
    source "$PANEL_CONF"
    local server_ip secret_suffix
    server_ip=$(curl -s -4 --max-time 3 icanhazip.com 2>/dev/null || echo "YOUR_SERVER_IP")
    secret_suffix=""
    if [[ -n "$PANEL_SECRET" ]]; then
        secret_suffix="/${PANEL_SECRET}"
    fi
    
    echo -e "\n${C_GREEN}=====================================================${C_RESET}"
    echo -e "${C_GREEN}         🌐 Web Panel Credentials                    ${C_RESET}"
    echo -e "${C_GREEN}=====================================================${C_RESET}"
    echo -e "\n${C_CYAN}  🌐 Panel URL:${C_RESET}    ${C_YELLOW}http://${server_ip}:${PANEL_PORT}${secret_suffix}${C_RESET}"
    echo -e "${C_CYAN}  👤 Username:${C_RESET}     ${C_YELLOW}${PANEL_USER}${C_RESET}"
    echo -e "${C_CYAN}  🔑 Password:${C_RESET}     ${C_YELLOW}${PANEL_PASS_PLAIN}${C_RESET}"
    if [[ -n "$PANEL_SECRET" ]]; then
        echo -e "${C_CYAN}  🔐 Secret Path:${C_RESET}   ${C_YELLOW}/${PANEL_SECRET}${C_RESET}"
    fi
    
    if systemctl is-active --quiet firewallfalcon-panel 2>/dev/null; then
        echo -e "\n${C_CYAN}  📡 Status:${C_RESET}       ${C_GREEN}🟢 Running${C_RESET}"
    else
        echo -e "\n${C_CYAN}  📡 Status:${C_RESET}       ${C_RED}🔴 Stopped${C_RESET}"
    fi
}

change_panel_credentials() {
    if [ ! -f "$PANEL_CONF" ]; then
        echo -e "\n${C_YELLOW}ℹ️ Web Panel is not installed.${C_RESET}"
        return
    fi
    
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔑 Change Web Panel Credentials & Secret Path ---${C_RESET}"
    show_panel_credentials
    
    echo ""
    read -p "👉 Enter new username (or press Enter to keep current): " new_user
    read -p "🔑 Enter new password (or press Enter to auto-generate): " new_pass
    read -p "🔐 Enter new secret URL path (e.g., secret123, or press Enter to keep): " new_secret
    
    source "$PANEL_CONF"
    
    if [[ -z "$new_user" ]]; then
        new_user="$PANEL_USER"
    fi
    if [[ -z "$new_pass" ]]; then
        new_pass=$(tr -dc 'A-Za-z0-9@#$' < /dev/urandom | head -c 16)
        echo -e "${C_GREEN}🔑 Auto-generated password: ${C_YELLOW}$new_pass${C_RESET}"
    fi
    if [[ -z "$new_secret" ]]; then
        new_secret="${PANEL_SECRET:-panel_$(tr -dc 'a-z0-9' < /dev/urandom | head -c 8)}"
    fi
    new_secret=$(echo "$new_secret" | sed 's/^\///')
    
    local new_hash
    new_hash=$(echo -n "$new_pass" | sha256sum | awk '{print $1}')
    
    cat > "$PANEL_CONF" <<-PEOF
PANEL_USER="$new_user"
PANEL_PASS_HASH="$new_hash"
PANEL_PASS_PLAIN="$new_pass"
PANEL_SECRET="$new_secret"
PEOF
    chmod 600 "$PANEL_CONF"
    
    systemctl restart firewallfalcon-panel &>/dev/null
    echo -e "\n${C_GREEN}✅ Panel credentials & secret path updated!${C_RESET}"
    echo -e "  ${C_CYAN}👤 Username:${C_RESET}    ${C_YELLOW}$new_user${C_RESET}"
    echo -e "  ${C_CYAN}🔑 Password:${C_RESET}    ${C_YELLOW}$new_pass${C_RESET}"
    echo -e "  ${C_CYAN}🔐 Secret Path:${C_RESET}  ${C_YELLOW}/$new_secret${C_RESET}"
}

web_panel_menu() {
    while true; do
        clear; show_banner
        echo -e "${C_BOLD}${C_PURPLE}--- 🌐 Web Control Panel ---${C_RESET}\n"
        
        if [ -f "$PANEL_SERVICE_FILE" ]; then
            if systemctl is-active --quiet firewallfalcon-panel 2>/dev/null; then
                echo -e "  ${C_DIM}Status: ${C_GREEN}🟢 Installed & Running${C_RESET}\n"
            else
                echo -e "  ${C_DIM}Status: ${C_RED}🔴 Installed but Stopped${C_RESET}\n"
            fi
        else
            echo -e "  ${C_DIM}Status: ${C_YELLOW}⚪ Not Installed${C_RESET}\n"
        fi
        
        printf "  ${C_GREEN}[ 1]${C_RESET} %-35s\n" "🚀 Install Web Panel"
        printf "  ${C_GREEN}[ 2]${C_RESET} %-35s\n" "🗑️  Uninstall Web Panel"
        printf "  ${C_GREEN}[ 3]${C_RESET} %-35s\n" "🔑 Show Panel Credentials"
        printf "  ${C_GREEN}[ 4]${C_RESET} %-35s\n" "🔄 Change Panel Credentials"
        printf "  ${C_GREEN}[ 5]${C_RESET} %-35s\n" "🔃 Restart Panel Service"
        echo -e "\n  ${C_RED}[ 0]${C_RESET} ↩️  Back to Main Menu"
        echo
        
        read -r -p "👉 Enter your choice: " panel_choice
        case $panel_choice in
            1) install_web_panel; press_enter ;;
            2) uninstall_web_panel; press_enter ;;
            3) show_panel_credentials; press_enter ;;
            4) change_panel_credentials; press_enter ;;
            5)
                if [ -f "$PANEL_SERVICE_FILE" ]; then
                    systemctl restart firewallfalcon-panel &>/dev/null
                    sleep 1
                    if systemctl is-active --quiet firewallfalcon-panel; then
                        echo -e "\n${C_GREEN}✅ Web Panel service restarted successfully.${C_RESET}"
                    else
                        echo -e "\n${C_RED}❌ Failed to restart. Checking logs:${C_RESET}"
                        journalctl -u firewallfalcon-panel -n 10 --no-pager
                    fi
                else
                    echo -e "\n${C_YELLOW}ℹ️ Web Panel is not installed.${C_RESET}"
                fi
                press_enter
                ;;
            0) return ;;
            *) invalid_option ;;
        esac
    done
}

uninstall_script() {
    clear; show_banner
    echo -e "${C_RED}=====================================================${C_RESET}"
    echo -e "${C_RED}       🔥 DANGER: UNINSTALL SCRIPT & ALL DATA 🔥      ${C_RESET}"
    echo -e "${C_RED}=====================================================${C_RESET}"
    echo -e "${C_YELLOW}This will PERMANENTLY remove this script and all its components, including:"
    echo -e " - The main command ($(command -v menu))"
    echo -e " - All configuration and user data ($DB_DIR)"
    echo -e " - The active limiter service ($LIMITER_SERVICE)"
    echo -e " - All installed services (badvpn, udp-custom, HAProxy Edge Stack, Nginx, DNSTT)"
    echo -e "\n${C_RED}This action is irreversible.${C_RESET}"
    echo ""
    read -p "👉 Type 'yes' to confirm and proceed with uninstallation: " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo -e "\n${C_GREEN}✅ Uninstallation cancelled.${C_RESET}"
        return
    fi
    local -a removable_users=()
    local remove_users_confirm
    local remove_users_on_uninstall=false
    mapfile -t removable_users < <(get_firewallfalcon_known_users)
    if [[ ${#removable_users[@]} -gt 0 ]]; then
        echo -e "\n${C_YELLOW}Mohammad Ahmad VPN Manager SSH users detected on this VPS:${C_RESET} ${removable_users[*]}"
        read -p "👉 Do you also want to permanently delete these SSH users before uninstalling? (y/n): " remove_users_confirm
        if [[ "$remove_users_confirm" == "y" || "$remove_users_confirm" == "Y" ]]; then
            remove_users_on_uninstall=true
        fi
    fi
    export UNINSTALL_MODE="silent"
    echo -e "\n${C_BLUE}--- 💥 Starting Uninstallation 💥 ---${C_RESET}"
    
    if [[ "$remove_users_on_uninstall" == "true" ]]; then
        echo -e "\n${C_BLUE}🗑️ Removing Mohammad Ahmad VPN Manager SSH users before uninstall...${C_RESET}"
        delete_firewallfalcon_user_accounts "${removable_users[@]}"
    fi
    
    echo -e "\n${C_BLUE}🗑️ Removing active limiter service...${C_RESET}"
    systemctl stop firewallfalcon-limiter &>/dev/null
    systemctl disable firewallfalcon-limiter &>/dev/null
    rm -f "$LIMITER_SERVICE"
    rm -f "$LIMITER_SCRIPT"
    
    echo -e "\n${C_BLUE}🗑️ Removing bandwidth monitoring service...${C_RESET}"
    systemctl stop firewallfalcon-bandwidth &>/dev/null
    systemctl disable firewallfalcon-bandwidth &>/dev/null
    rm -f "$BANDWIDTH_SERVICE"
    rm -f "$BANDWIDTH_SCRIPT"
    rm -rf "$LEGACY_BANDWIDTH_DIR"
    rm -f "$TRIAL_CLEANUP_SCRIPT"
    
    echo -e "\n${C_BLUE}\ud83d\uddd1\ufe0f Removing SSH login banner...${C_RESET}"
    rm -f "$LOGIN_INFO_SCRIPT"
    rm -f "$SSHD_FF_CONFIG"
    systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
    
    chattr -i /etc/resolv.conf &>/dev/null

    purge_nginx "silent"
    uninstall_dnstt
    uninstall_badvpn
    uninstall_udp_custom
    uninstall_ssl_tunnel
    uninstall_falcon_proxy
    uninstall_zivpn
    uninstall_web_panel
    delete_dns_record
    
    echo -e "\n${C_BLUE}🔄 Reloading systemd daemon...${C_RESET}"
    systemctl daemon-reload
    
    echo -e "\n${C_BLUE}🗑️ Removing script and configuration files...${C_RESET}"
    rm -rf "$BADVPN_BUILD_DIR"
    rm -rf "$UDP_CUSTOM_DIR"
    rm -rf "$DB_DIR"
    rm -f "$(command -v menu)"
    
    echo -e "\n${C_GREEN}=============================================${C_RESET}"
    echo -e "${C_GREEN}      Script has been successfully uninstalled.     ${C_RESET}"
    echo -e "${C_GREEN}=============================================${C_RESET}"
    echo -e "\nAll associated files and services have been removed."
    echo "The 'menu' command will no longer work."
    exit 0
}

# --- NEW FEATURES ---

create_trial_account() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- ⏱️ Create Trial/Test Account ---${C_RESET}"
    
    # Ensure 'at' daemon is available
    if ! command -v at &>/dev/null; then
        echo -e "${C_YELLOW}⚠️ 'at' command not found. Installing...${C_RESET}"
        ff_pkg_install at >/dev/null 2>&1 || {
            echo -e "${C_RED}❌ Failed to install 'at'. Cannot schedule auto-expiry.${C_RESET}"
            return
        }
        systemctl enable atd &>/dev/null
        systemctl start atd &>/dev/null
    fi
    
    # Ensure atd is running
    if ! systemctl is-active --quiet atd; then
        systemctl start atd &>/dev/null
    fi
    
    echo -e "\n${C_CYAN}Select trial duration:${C_RESET}\n"
    printf "  ${C_GREEN}[ 1]${C_RESET} ⏱️  1 Hour\n"
    printf "  ${C_GREEN}[ 2]${C_RESET} ⏱️  2 Hours\n"
    printf "  ${C_GREEN}[ 3]${C_RESET} ⏱️  3 Hours\n"
    printf "  ${C_GREEN}[ 4]${C_RESET} ⏱️  6 Hours\n"
    printf "  ${C_GREEN}[ 5]${C_RESET} ⏱️  12 Hours\n"
    printf "  ${C_GREEN}[ 6]${C_RESET} 📅  1 Day\n"
    printf "  ${C_GREEN}[ 7]${C_RESET} 📅  3 Days\n"
    printf "  ${C_GREEN}[ 8]${C_RESET} ⚙️  Custom (enter hours)\n"
    echo -e "\n  ${C_RED}[ 0]${C_RESET} ↩️ Cancel"
    echo
    read -p "👉 Select duration: " dur_choice
    
    local duration_hours=0
    local duration_label=""
    case $dur_choice in
        1) duration_hours=1;   duration_label="1 Hour" ;;
        2) duration_hours=2;   duration_label="2 Hours" ;;
        3) duration_hours=3;   duration_label="3 Hours" ;;
        4) duration_hours=6;   duration_label="6 Hours" ;;
        5) duration_hours=12;  duration_label="12 Hours" ;;
        6) duration_hours=24;  duration_label="1 Day" ;;
        7) duration_hours=72;  duration_label="3 Days" ;;
        8) read -p "👉 Enter custom duration in hours: " custom_hours
           if ! [[ "$custom_hours" =~ ^[0-9]+$ ]] || [[ "$custom_hours" -lt 1 ]]; then
               echo -e "\n${C_RED}❌ Invalid number of hours.${C_RESET}"; return
           fi
           duration_hours=$custom_hours
           duration_label="$custom_hours Hours"
           ;;
        0) echo -e "\n${C_YELLOW}❌ Cancelled.${C_RESET}"; return ;;
        *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}"; return ;;
    esac
    
    # Username
    local rand_suffix=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 5)
    local default_username="trial_${rand_suffix}"
    read -p "👤 Username [${default_username}]: " username
    username=${username:-$default_username}
    
    if id "$username" &>/dev/null || grep -q "^$username:" "$DB_FILE"; then
        echo -e "\n${C_RED}❌ Error: User '$username' already exists.${C_RESET}"; return
    fi
    
    # Password
    local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
    read -p "🔑 Password [${password}]: " custom_pass
    password=${custom_pass:-$password}
    
    # Connection limit
    read -p "📶 Connection limit [1]: " limit
    limit=${limit:-1}
    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    # Bandwidth limit
    read -p "📦 Bandwidth limit in GB (0 = unlimited) [0]: " bandwidth_gb
    bandwidth_gb=${bandwidth_gb:-0}
    if ! [[ "$bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    # Calculate expiry
    local expire_date
    if [[ "$duration_hours" -ge 24 ]]; then
        local days=$((duration_hours / 24))
        expire_date=$(date -d "+$days days" +%Y-%m-%d)
    else
        # For sub-day durations, set expiry to tomorrow to be safe (at job does the real cleanup)
        expire_date=$(date -d "+1 day" +%Y-%m-%d)
    fi
    local expiry_timestamp
    expiry_timestamp=$(date -d "+${duration_hours} hours" '+%Y-%m-%d %H:%M:%S')
    
    # Create the system user
    ensure_firewallfalcon_system_group
    useradd -m -s /usr/sbin/nologin "$username"
    usermod -aG "$FF_USERS_GROUP" "$username" 2>/dev/null
    echo "$username:$password" | chpasswd
    chage -E "$expire_date" "$username"
    echo "$username:$password:$expire_date:$limit:$bandwidth_gb:trial" >> "$DB_FILE"
    
    # Schedule auto-cleanup via 'at'
    echo "$TRIAL_CLEANUP_SCRIPT $username" | at now + ${duration_hours} hours 2>/dev/null
    
    local bw_display="Unlimited"
    if [[ "$bandwidth_gb" != "0" ]]; then bw_display="${bandwidth_gb} GB"; fi
    
    clear; show_banner
    echo -e "${C_GREEN}✅ Trial account created successfully!${C_RESET}\n"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "  ⏱️  ${C_BOLD}TRIAL ACCOUNT${C_RESET}"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "  - 👤 Username:          ${C_YELLOW}$username${C_RESET}"
    echo -e "  - 🔑 Password:          ${C_YELLOW}$password${C_RESET}"
    echo -e "  - ⏱️ Duration:          ${C_CYAN}$duration_label${C_RESET}"
    echo -e "  - 🕐 Auto-expires at:   ${C_RED}$expiry_timestamp${C_RESET}"
    echo -e "  - 📶 Connection Limit:  ${C_YELLOW}$limit${C_RESET}"
    echo -e "  - 📦 Bandwidth Limit:   ${C_YELLOW}$bw_display${C_RESET}"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "\n${C_DIM}The account will be automatically deleted when the trial expires.${C_RESET}"
    
    # Auto-ask for config generation
    echo
    read -p "👉 Generate client config for this trial user? (y/n): " gen_conf
    if [[ "$gen_conf" == "y" || "$gen_conf" == "Y" ]]; then
        generate_client_config "$username" "$password"
    fi
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

view_user_bandwidth() {
    _select_user_interface "--- 📊 View User Bandwidth ---"
    local u=$SELECTED_USER
    if [[ "$u" == "NO_USERS" || -z "$u" ]]; then return; fi
    
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📊 Bandwidth Details: ${C_YELLOW}$u${C_PURPLE} ---${C_RESET}\n"
    
    local line; line=$(grep "^$u:" "$DB_FILE")
    local _u _p _e _l bandwidth_gb
    IFS=: read -r _u _p _e _l bandwidth_gb _ <<< "$line"
    [[ -z "$bandwidth_gb" ]] && bandwidth_gb="0"
    
    local used_bytes=0
    if [[ -f "$BANDWIDTH_DIR/${u}.usage" ]]; then
        read -r used_bytes < "$BANDWIDTH_DIR/${u}.usage" 2>/dev/null || used_bytes=0
        [[ -z "$used_bytes" ]] && used_bytes=0
    fi
    
    local used_mb; used_mb=$(awk "BEGIN {printf \"%.2f\", $used_bytes / 1048576}")
    local used_gb; used_gb=$(awk "BEGIN {printf \"%.3f\", $used_bytes / 1073741824}")
    
    echo -e "  ${C_CYAN}Data Used:${C_RESET}        ${C_WHITE}${used_gb} GB${C_RESET} (${used_mb} MB)"
    
    if [[ "$bandwidth_gb" == "0" ]]; then
        echo -e "  ${C_CYAN}Bandwidth Limit:${C_RESET}  ${C_GREEN}Unlimited${C_RESET}"
        echo -e "  ${C_CYAN}Status:${C_RESET}           ${C_GREEN}No quota restrictions${C_RESET}"
    else
        local quota_bytes; quota_bytes=$(awk "BEGIN {printf \"%.0f\", $bandwidth_gb * 1073741824}")
        local percentage; percentage=$(awk "BEGIN {printf \"%.1f\", ($used_bytes / $quota_bytes) * 100}")
        local remaining_bytes; remaining_bytes=$((quota_bytes - used_bytes))
        if [[ "$remaining_bytes" -lt 0 ]]; then remaining_bytes=0; fi
        local remaining_gb; remaining_gb=$(awk "BEGIN {printf \"%.3f\", $remaining_bytes / 1073741824}")
        
        echo -e "  ${C_CYAN}Bandwidth Limit:${C_RESET}  ${C_YELLOW}${bandwidth_gb} GB${C_RESET}"
        echo -e "  ${C_CYAN}Remaining:${C_RESET}        ${C_WHITE}${remaining_gb} GB${C_RESET}"
        echo -e "  ${C_CYAN}Usage:${C_RESET}            ${C_WHITE}${percentage}%${C_RESET}"
        
        # Progress bar
        local bar_width=30
        local filled; filled=$(awk "BEGIN {printf \"%.0f\", ($percentage / 100) * $bar_width}")
        if [[ "$filled" -gt "$bar_width" ]]; then filled=$bar_width; fi
        local empty=$((bar_width - filled))
        local bar_color="$C_GREEN"
        if (( $(awk "BEGIN {print ($percentage > 80)}" ) )); then bar_color="$C_RED"
        elif (( $(awk "BEGIN {print ($percentage > 50)}" ) )); then bar_color="$C_YELLOW"
        fi
        printf "  ${C_CYAN}Progress:${C_RESET}         ${bar_color}["
        for ((i=0; i<filled; i++)); do printf "█"; done
        for ((i=0; i<empty; i++)); do printf "░"; done
        printf "]${C_RESET} ${percentage}%%\n"
        
        if [[ "$used_bytes" -ge "$quota_bytes" ]]; then
            echo -e "\n  ${C_RED}⚠️ USER HAS EXCEEDED BANDWIDTH QUOTA — ACCOUNT LOCKED${C_RESET}"
        fi
    fi
}

bulk_create_users() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 👥 Bulk Create Users ---${C_RESET}"
    
    read -p "👉 Enter username prefix (e.g., 'user'): " prefix
    if [[ -z "$prefix" ]]; then echo -e "\n${C_RED}❌ Prefix cannot be empty.${C_RESET}"; return; fi
    
    read -p "🔢 How many users to create? " count
    if ! [[ "$count" =~ ^[0-9]+$ ]] || [[ "$count" -lt 1 ]] || [[ "$count" -gt 100 ]]; then
        echo -e "\n${C_RED}❌ Invalid count (1-100).${C_RESET}"; return
    fi
    
    read -p "🗓️ Account duration (in days) [30]: " days
    days=${days:-30}
    if ! [[ "$days" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    read -p "📶 Connection limit per user [1]: " limit
    limit=${limit:-1}
    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    read -p "📦 Bandwidth limit in GB per user (0 = unlimited) [0]: " bandwidth_gb
    bandwidth_gb=${bandwidth_gb:-0}
    if ! [[ "$bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    read -p "📦 DAILY bandwidth limit in GB per user (0 = unlimited) [0]: " daily_bandwidth_gb
    daily_bandwidth_gb=${daily_bandwidth_gb:-0}
    if ! [[ "$daily_bandwidth_gb" =~ ^[0-9]+\.?[0-9]*$ ]]; then echo -e "\n${C_RED}❌ Invalid number.${C_RESET}"; return; fi
    
    local expire_date
    expire_date=$(date -d "+$days days" +%Y-%m-%d)
    local bw_display="Unlimited"; [[ "$bandwidth_gb" != "0" ]] && bw_display="${bandwidth_gb} GB"
    local daily_bw_display="Unlimited"; [[ "$daily_bandwidth_gb" != "0" ]] && daily_bw_display="${daily_bandwidth_gb} GB/day"
    ensure_firewallfalcon_system_group
    
    echo -e "\n${C_BLUE}⚙️ Creating $count users with prefix '${prefix}'...${C_RESET}\n"
    echo -e "${C_YELLOW}================================================================${C_RESET}"
    printf "${C_BOLD}${C_WHITE}%-20s | %-15s | %-12s${C_RESET}\n" "USERNAME" "PASSWORD" "EXPIRES"
    echo -e "${C_YELLOW}----------------------------------------------------------------${C_RESET}"
    
    local created=0
    for ((i=1; i<=count; i++)); do
        local username="${prefix}${i}"
        if id "$username" &>/dev/null || grep -q "^$username:" "$DB_FILE"; then
            echo -e "${C_RED}  ⚠️ Skipping '$username' — already exists${C_RESET}"
            continue
        fi
        local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
        useradd -m -s /usr/sbin/nologin "$username"
        usermod -aG "$FF_USERS_GROUP" "$username" 2>/dev/null
        echo "$username:$password" | chpasswd
        chage -E "$expire_date" "$username"
        echo "$username:$password:$expire_date:$limit:$bandwidth_gb:$daily_bandwidth_gb:bulk" >> "$DB_FILE"
        printf "  ${C_GREEN}%-20s${C_RESET} | ${C_YELLOW}%-15s${C_RESET} | ${C_CYAN}%-12s${C_RESET}\n" "$username" "$password" "$expire_date"
        created=$((created + 1))
    done
    
    echo -e "${C_YELLOW}================================================================${C_RESET}"
    echo -e "\n${C_GREEN}✅ Created $created users. Conn Limit: ${limit} | Total BW: ${bw_display} | Daily BW: ${daily_bw_display}${C_RESET}"
    
    invalidate_banner_cache
    refresh_dynamic_banner_routing_if_enabled
}

generate_client_config() {
    local user=$1
    local pass=$2
    
    local host_ip=$(curl -s -4 icanhazip.com)
    local host_domain
    host_domain=$(detect_preferred_host)
    [[ -z "$host_domain" ]] && host_domain="$host_ip"

    echo -e "\n${C_BOLD}${C_PURPLE}--- 📱 Client Connection Configuration ---${C_RESET}"
    echo -e "${C_CYAN}Copy the details below to your clipboard:${C_RESET}\n"

    echo -e "${C_YELLOW}========================================${C_RESET}"
    echo -e "👤 ${C_BOLD}User Details${C_RESET}"
    echo -e "   • Username: ${C_WHITE}$user${C_RESET}"
    echo -e "   • Password: ${C_WHITE}$pass${C_RESET}"
    echo -e "   • Host/IP : ${C_WHITE}$host_domain${C_RESET}"
    echo -e "${C_YELLOW}========================================${C_RESET}"
    
    # 1. SSH Direct
    echo -e "\n🔹 ${C_BOLD}SSH Direct${C_RESET}:"
    echo -e "   • Host: $host_domain"
    echo -e "   • Port: 22"
    echo -e "   • payload: (Standard SSH)"

    # 2. HAProxy edge stack
    if systemctl is-active --quiet haproxy; then
        echo -e "\n🔹 ${C_BOLD}HAProxy Edge Stack${C_RESET}:"
        echo -e "   • Host: $host_domain"
        echo -e "   • Port 80: HTTP payloads / raw SSH"
        echo -e "   • Port 443: TLS / SNI / SSL payloads"
        echo -e "   • Internal handoff: Nginx ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}"
        echo -e "   • SNI (BugHost): $host_domain (or your preferred SNI)"
    elif systemctl is-active --quiet nginx; then
        echo -e "\n🔹 ${C_BOLD}Internal Nginx Proxy${C_RESET}:"
        echo -e "   • Internal only: ${NGINX_INTERNAL_HTTP_PORT}/${NGINX_INTERNAL_TLS_PORT}"
        echo -e "   • Public clients should connect through HAProxy on ${EDGE_PUBLIC_HTTP_PORT}/${EDGE_PUBLIC_TLS_PORT}"
    fi

    # 3. UDP Custom
    if systemctl is-active --quiet udp-custom; then
        echo -e "\n🔹 ${C_BOLD}UDP Custom${C_RESET}:"
        echo -e "   • IP: $host_ip (Must use numeric IP)"
        echo -e "   • Port: 1-65535 (Exclude 53, 5300)"
        echo -e "   • Obfs: (None/Plain)"
    fi

    # 4. DNSTT
    if systemctl is-active --quiet dnstt; then
        if [ -f "$DNSTT_CONFIG_FILE" ]; then
            source "$DNSTT_CONFIG_FILE"
            echo -e "\n🔹 ${C_BOLD}DNSTT (SlowDNS)${C_RESET}:"
            echo -e "   • Nameserver: $TUNNEL_DOMAIN"
            echo -e "   • PubKey: $PUBLIC_KEY"
            echo -e "   • DNS IP: 1.1.1.1 / 8.8.8.8"
        fi
    fi
    
    # 5. ZiVPN
    if systemctl is-active --quiet zivpn; then
        echo -e "\n🔹 ${C_BOLD}ZiVPN${C_RESET}:"
        echo -e "   • UDP Port: 5667"
        echo -e "   • Forwarded Ports: 6000-19999"
    fi
    
    echo -e "${C_YELLOW}========================================${C_RESET}"

}

client_config_menu() {
    _select_user_interface "--- 📱 Generate Client Config ---"
    local u=$SELECTED_USER
    if [[ "$u" == "NO_USERS" || -z "$u" ]]; then return; fi
    
    # We need to find the password. It's in the DB.
    local pass=$(grep "^$u:" "$DB_FILE" | cut -d: -f2)
    generate_client_config "$u" "$pass"
}

format_rate_from_kbps() {
    local kbps=${1:-0}
    if (( kbps >= 1024 )); then
        printf "%d.%02d MB/s" $((kbps / 1024)) $((((kbps % 1024) * 100) / 1024))
    else
        printf "%d KB/s" "$kbps"
    fi
}

# Lightweight Bash Monitor (No vnStat required)
simple_live_monitor() {
    local iface=$1
    local rx_file="/sys/class/net/$iface/statistics/rx_bytes"
    local tx_file="/sys/class/net/$iface/statistics/tx_bytes"
    local interval=2
    local stop_monitor=0
    local rx1 tx1 rx2 tx2 rx_diff tx_diff rx_kbs tx_kbs rx_fmt tx_fmt

    if [[ -z "$iface" || ! -r "$rx_file" || ! -r "$tx_file" ]]; then
        echo -e "\n${C_RED}❌ Could not read interface statistics for '${iface:-unknown}'.${C_RESET}"
        return
    fi

    echo -e "\n${C_BLUE}⚡ Starting Lightweight Traffic Monitor for $iface...${C_RESET}"
    echo -e "${C_DIM}Press [Ctrl+C] to stop.${C_RESET}\n"

    read -r rx1 < "$rx_file"
    read -r tx1 < "$tx_file"

    printf "%-15s | %-15s\n" "⬇️ Download" "⬆️ Upload"
    echo "-----------------------------------"

    trap 'stop_monitor=1' INT TERM
    while (( ! stop_monitor )); do
        sleep "$interval"
        read -r rx2 < "$rx_file" || break
        read -r tx2 < "$tx_file" || break

        rx_diff=$((rx2 - rx1))
        tx_diff=$((tx2 - tx1))
        (( rx_diff < 0 )) && rx_diff=0
        (( tx_diff < 0 )) && tx_diff=0

        rx_kbs=$((rx_diff / 1024 / interval))
        tx_kbs=$((tx_diff / 1024 / interval))
        rx_fmt=$(format_rate_from_kbps "$rx_kbs")
        tx_fmt=$(format_rate_from_kbps "$tx_kbs")

        printf "\r%-15s | %-15s" "$rx_fmt" "$tx_fmt"

        rx1=$rx2
        tx1=$tx2
    done
    trap - INT TERM
    echo
}

traffic_monitor_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 📈 Network Traffic Monitor ---${C_RESET}"
    
    # Find active interface
    local iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
    
    echo -e "\nInterface: ${C_CYAN}${iface}${C_RESET}"
    
    echo -e "\n${C_BOLD}Select a monitoring option:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "⚡ Live Monitor ${C_DIM}(Lightweight, No Install)${C_RESET}"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "📊 View Total Traffic Since Boot"
    printf "  ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "📅 Daily/Monthly Logs ${C_DIM}(Requires vnStat)${C_RESET}"
    
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Enter choice: " t_choice
    case $t_choice in
        1) 
           simple_live_monitor "$iface"
           ;;
        2)
            local rx_total=$(cat /sys/class/net/$iface/statistics/rx_bytes)
            local tx_total=$(cat /sys/class/net/$iface/statistics/tx_bytes)
            local rx_mb=$((rx_total / 1024 / 1024))
            local tx_mb=$((tx_total / 1024 / 1024))
            echo -e "\n${C_BLUE}📊 Total Traffic (Since Boot):${C_RESET}"
            echo -e "   ⬇️ Download: ${C_WHITE}${rx_mb} MB${C_RESET}"
            echo -e "   ⬆️ Upload:   ${C_WHITE}${tx_mb} MB${C_RESET}"
            press_enter
            ;;
        3) 
           # vnStat Logic
           if ! command -v vnstat &> /dev/null; then
               echo -e "\n${C_YELLOW}⚠️ vnStat is not installed.${C_RESET}"
               echo -e "   This tool provides persistent history (Daily/Monthly reports)."
               echo -e "   It is lightweight but requires installation."
               read -p "👉 Install vnStat now? (y/n): " confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                     echo -e "\n${C_BLUE}📦 Installing vnStat...${C_RESET}"
                     ff_pkg_install vnstat >/dev/null 2>&1 || {
                         echo -e "${C_RED}❌ Failed to install vnStat.${C_RESET}"
                         sleep 1
                         return
                     }
                     systemctl enable vnstat >/dev/null 2>&1
                     systemctl restart vnstat >/dev/null 2>&1
                    local default_iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
                    vnstat --add -i "$default_iface" >/dev/null 2>&1
                    echo -e "${C_GREEN}✅ Installed.${C_RESET}"
                    sleep 1
               else
                    return
               fi
           fi
           echo
           vnstat -i "$iface"
           echo -e "\n${C_DIM}Run 'vnstat -d' or 'vnstat -m' manually for specific views.${C_RESET}"
           press_enter
           ;;
        *) return ;;
    esac
}

torrent_block_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🚫 Torrent Blocking (Anti-Torrent) ---${C_RESET}"
    
    # Check status
    local torrent_status="${C_STATUS_I}Disabled${C_RESET}"
    if iptables -L FORWARD | grep -q "ipp2p"; then
         torrent_status="${C_STATUS_A}Enabled${C_RESET}"
    elif iptables -L OUTPUT | grep -q "BitTorrent"; then
         # Fallback check for string matching
         torrent_status="${C_STATUS_A}Enabled${C_RESET}"
    fi
    
    echo -e "\n${C_WHITE}Current Status: ${torrent_status}${C_RESET}"
    echo -e "${C_DIM}This feature uses iptables string matching to block common torrent keywords.${C_RESET}"
    
    echo -e "\n${C_BOLD}Select an action:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🔒 Enable Torrent Blocking"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "🔓 Disable Torrent Blocking"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Enter choice: " b_choice
    
    case $b_choice in
        1)
            echo -e "\n${C_BLUE}🛡️ Applying Anti-Torrent rules...${C_RESET}"
            # Clean old rules first to avoid duplicates
            _flush_torrent_rules
            
            # Block Common Torrent Ports/Keywords
            # String matching using iptables extension
            iptables -A FORWARD -m string --string "BitTorrent" --algo bm -j DROP
            iptables -A FORWARD -m string --string "BitTorrent protocol" --algo bm -j DROP
            iptables -A FORWARD -m string --string "peer_id=" --algo bm -j DROP
            iptables -A FORWARD -m string --string ".torrent" --algo bm -j DROP
            iptables -A FORWARD -m string --string "announce.php?passkey=" --algo bm -j DROP
            iptables -A FORWARD -m string --string "torrent" --algo bm -j DROP
            iptables -A FORWARD -m string --string "info_hash" --algo bm -j DROP
            iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
            iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
            
            # Same for OUTPUT to be safe
            iptables -A OUTPUT -m string --string "BitTorrent" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "BitTorrent protocol" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "peer_id=" --algo bm -j DROP
            iptables -A OUTPUT -m string --string ".torrent" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "announce.php?passkey=" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "torrent" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "info_hash" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "get_peers" --algo bm -j DROP
            iptables -A OUTPUT -m string --string "find_node" --algo bm -j DROP
            
            # Attempt to save if iptables-persistent exists
            if ff_pkg_is_installed iptables-persistent &>/dev/null; then
                netfilter-persistent save &>/dev/null
            fi
            
            echo -e "${C_GREEN}✅ Torrent Blocking Enabled.${C_RESET}"
            press_enter
            ;;
        2)
            echo -e "\n${C_BLUE}🔓 Removing Anti-Torrent rules...${C_RESET}"
            _flush_torrent_rules
            if ff_pkg_is_installed iptables-persistent &>/dev/null; then
                netfilter-persistent save &>/dev/null
            fi
            echo -e "${C_GREEN}✅ Torrent Blocking Disabled.${C_RESET}"
            press_enter
            ;;
        *) return ;;
    esac
}

_flush_torrent_rules() {
    # Helper to remove rules containing specific strings
    # This is a bit brute-force but effective for this script's scope
    iptables -D FORWARD -m string --string "BitTorrent" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "BitTorrent protocol" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "peer_id=" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string ".torrent" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "announce.php?passkey=" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "torrent" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "info_hash" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "get_peers" --algo bm -j DROP 2>/dev/null
    iptables -D FORWARD -m string --string "find_node" --algo bm -j DROP 2>/dev/null

    iptables -D OUTPUT -m string --string "BitTorrent" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "BitTorrent protocol" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "peer_id=" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string ".torrent" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "announce.php?passkey=" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "torrent" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "info_hash" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "get_peers" --algo bm -j DROP 2>/dev/null
    iptables -D OUTPUT -m string --string "find_node" --algo bm -j DROP 2>/dev/null
}

ssh_banner_menu() {
    while true; do
        show_banner
        local banner_mode
        local banner_status
        banner_mode=$(get_ssh_banner_mode)
        case "$banner_mode" in
            dynamic) banner_status="${C_STATUS_A}Dynamic${C_RESET}" ;;
            static) banner_status="${C_STATUS_A}Static${C_RESET}" ;;
            *) banner_status="${C_STATUS_I}Disabled${C_RESET}" ;;
        esac

        echo -e "\n   ${C_TITLE}═════════════════[ ${C_BOLD}🎨 SSH BANNER MODE: ${banner_status} ${C_RESET}${C_TITLE}]═════════════════${C_RESET}"
        echo -e "${C_DIM}Static mode uses 'Banner $SSH_BANNER_FILE'. Dynamic mode shows per-user account info.${C_RESET}"
        printf "     ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "✨ Enable Dynamic Account Banner"
        printf "     ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "📋 Paste or Replace Static Banner"
        printf "     ${C_CHOICE}[ 3]${C_RESET} %-40s\n" "👁️ View Current Static Banner"
        printf "     ${C_CHOICE}[ 4]${C_RESET} %-40s\n" "📝 Preview Dynamic Banner"
        printf "     ${C_DANGER}[ 5]${C_RESET} %-40s\n" "🗑️ Disable All SSH Banners"
        echo -e "   ${C_DIM}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${C_RESET}"
        echo -e "     ${C_WARN}[ 0]${C_RESET} ↩️ Return"
        echo
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
            echo
            return
        fi
        case $choice in
            1)
                if setup_ssh_login_info; then
                    echo -e "\n${C_GREEN}✅ Dynamic account banner enabled.${C_RESET}"
                    echo -e "${C_DIM}Users will now see their account info banner instead of the static banner.${C_RESET}"
                fi
                press_enter
                ;;
            2) set_ssh_banner_paste ;;
            3) view_ssh_banner ;;
            4) preview_dynamic_ssh_banner ;;
            5) remove_ssh_banner ;;
            0) return ;;
            *) echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" && sleep 1 ;;
        esac
    done
}

auto_reboot_menu() {
    clear; show_banner
    echo -e "${C_BOLD}${C_PURPLE}--- 🔄 Auto-Reboot Management ---${C_RESET}"
    
    # Check status
    local cron_check=$(crontab -l 2>/dev/null | grep "systemctl reboot")
    local status="${C_STATUS_I}Disabled${C_RESET}"
    if [[ -n "$cron_check" ]]; then
        status="${C_STATUS_A}Active (Midnight)${C_RESET}"
    fi
    
    echo -e "\n${C_WHITE}Current Status: ${status}${C_RESET}"
    
    echo -e "\n${C_BOLD}Select an action:${C_RESET}\n"
    printf "  ${C_CHOICE}[ 1]${C_RESET} %-40s\n" "🕐 Enable Daily Reboot (00:00 midnight)"
    printf "  ${C_CHOICE}[ 2]${C_RESET} %-40s\n" "❌ Disable Auto-Reboot"
    echo -e "\n  ${C_WARN}[ 0]${C_RESET} ↩️ Return"
    echo
    read -p "👉 Enter choice: " r_choice
    
    case $r_choice in
        1)
            # Remove existing to prevent duplicates
            (crontab -l 2>/dev/null | grep -v "systemctl reboot") | crontab -
            # Add new job
            (crontab -l 2>/dev/null; echo "0 0 * * * systemctl reboot") | crontab -
            echo -e "\n${C_GREEN}✅ Auto-reboot scheduled for every day at 00:00.${C_RESET}"
            press_enter
            ;;
        2)
            (crontab -l 2>/dev/null | grep -v "systemctl reboot") | crontab -
            echo -e "\n${C_GREEN}✅ Auto-reboot disabled.${C_RESET}"
            press_enter
            ;;
        *) return ;;
    esac
}


press_enter() {
    echo -e "\nPress ${C_YELLOW}[Enter]${C_RESET} to return to the menu..." && read -r || true
}
invalid_option() {
    echo -e "\n${C_RED}❌ Invalid option.${C_RESET}" && sleep 1
}

main_menu() {
    while true; do
        export UNINSTALL_MODE="interactive"
        show_banner
        
        echo
        echo -e "   ${C_TITLE}═══════════════════[ ${C_BOLD}👤 USER MANAGEMENT ${C_RESET}${C_TITLE}]═══════════════════${C_RESET}"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "1" "✨ Create New User" "2" "🗑️  Delete User"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "3" "🔄 Renew User Account" "4" "🔒 Lock User Account"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "5" "🔓 Unlock User Account" "6" "✏️  Edit User Details"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "7" "📋 List Managed Users" "8" "📱 Generate Client Config"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "9" "⏱️  Create Trial Account" "10" "📊 View User Bandwidth"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "11" "👥 Bulk Create Users"
        
        echo
        echo -e "   ${C_TITLE}══════════════[ ${C_BOLD}🌐 VPN & PROTOCOLS ${C_RESET}${C_TITLE}]═══════════════${C_RESET}"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "12" "🔌 Protocol Manager" "13" "📈 Traffic Monitor (Lite)"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "14" "🚫 Block Torrent (Anti-P2P)"

        echo
        echo -e "   ${C_TITLE}══════════════[ ${C_BOLD}⚙️ SYSTEM SETTINGS ${C_RESET}${C_TITLE}]═══════════════${C_RESET}"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "15" "🌐 Free Domain (deSEC)" "16" "🎨 SSH Banner Config"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "17" "🔄 Auto-Reboot Task" "18" "💾 Backup User Data"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "19" "📥 Restore User Data" "20" "🧹 Cleanup Expired Users"
        printf "     ${C_CHOICE}[%2s]${C_RESET} %-28s\n" "21" "🌐 Web Control Panel"

        echo
        echo -e "   ${C_DANGER}═══════════════════[ ${C_BOLD}🔥 DANGER ZONE ${C_RESET}${C_DANGER}]═══════════════════${C_RESET}"
        echo -e "     ${C_DANGER}[99]${C_RESET} Uninstall Script             ${C_WARN}[ 0]${C_RESET} Exit"
        echo
        if ! read -r -p "$(echo -e ${C_PROMPT}"👉 Select an option: "${C_RESET})" choice; then
            echo
            exit 0
        fi
        case $choice in
            1) create_user; press_enter ;;
            2) delete_user; press_enter ;;
            3) renew_user; press_enter ;;
            4) lock_user; press_enter ;;
            5) unlock_user; press_enter ;;
            6) edit_user; press_enter ;;
            7) list_users; press_enter ;;
            8) client_config_menu; press_enter ;;
            9) create_trial_account; press_enter ;;
            10) view_user_bandwidth; press_enter ;;
            11) bulk_create_users; press_enter ;;
            
            12) protocol_menu ;;
            13) traffic_monitor_menu ;;
            14) torrent_block_menu ;;
            
            15) dns_menu; press_enter ;;
            16) ssh_banner_menu ;;
            17) auto_reboot_menu ;;
            18) backup_user_data; press_enter ;;
            19) restore_user_data; press_enter ;;
            20) cleanup_expired; press_enter ;;
            21) web_panel_menu ;;
            
            99) uninstall_script ;;
            0) exit 0 ;;
            *) invalid_option ;;
        esac
    done
}

if [[ "$1" == "--install-setup" ]]; then
    initial_setup
    exit 0
fi

require_interactive_terminal
sync_runtime_components_if_needed
main_menu

__NG_MENU_SH_EOF__

if [ ! -s "$INSTALL_PATH" ]; then
    err "Failed to write $INSTALL_PATH"
    exit 1
fi
chmod +x "$INSTALL_PATH"
ok "Manager installed"

# --- Create the 'menu' shortcut command ---
ln -sf "$INSTALL_PATH" "$SHORTCUT_PATH"
ok "Shortcut command created: menu"

# --- Run first-time setup (creates dirs, group, limiter/bandwidth services, etc.) ---
info "Running first-time setup..."
"$INSTALL_PATH" --install-setup

echo ""
echo -e "${c_bold}============================================================${c_reset}"
echo -e "${c_bold} Mohammad Ahmad VPN Manager Manager installed successfully${c_reset}"
echo -e "${c_bold}============================================================${c_reset}"
echo -e "  Run it anytime with:  ${c_cyan}menu${c_reset}"
echo -e "  (or the full path:    ${c_cyan}$INSTALL_PATH${c_reset})"
echo ""
echo -e "  ${c_yellow}From the main menu, option [21] installs the web control panel.${c_reset}"
echo -e "${c_bold}============================================================${c_reset}"
echo ""

# --- Launch the menu now ---
exec "$INSTALL_PATH"
