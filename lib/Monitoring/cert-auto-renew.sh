source "${SCRIPT_DIR}/../lib/utils.sh"  # .. : go one directory up

WEB_SERVER="nginx" # default web server
CERTBOT_FLAGS="--quiet" #certbot runs silently
DRY_RUN=false
PRE_HOOK=""  # cmd to run before cert renewal
POST_HOOK="" # cmd to run after cert renewal


# ===========================================================================
# basename $0 : removes path - shows only script name
# ===========================================================================

usage(){
        cat<<EOF
Usage: $(basename "$0") [options]

Run 'certbot renew' and reload the web server only when at least one
certificate was actually renewed.

Options:
  --web-server NAME   Web server to reload after renewal  (default: nginx)
                      Supported: nginx, apache2, haproxy
  --pre-hook CMD      Command to run before certbot renew
  --post-hook CMD     Command to run after a successful renewal
  --dry-run           Pass --dry-run to certbot; do not reload server
  -h, --help          Show this help message

Examples:
  $(basename "$0")
  $(basename "$0") --web-server apache2
  $(basename "$0") --dry-run
EOF
}

while [[ $# -gt 0 ]]; do   # $# : no. of args specified while running script
        case "$1" in     # $1 : current arg
                --web-server)    WEB_SERVER="$2";   shift 2 ;;
                --pre-hook)      PRE_HOOK="$2";     shift 2 ;;
                --post-hook)     POST_HOOK="$2";    shift 2 ;;
                --dry-run)       DRY_RUN=true; CERTBOT_FLAGS="${CERTBOT_FLAGS} --dry-run"; shift ;;
                -h|--help)       usage; exit 0;;
                *) log_error "Unknown option: $1"; usage; exit 1;;
        esac
done

check_dependency certbot

case "$WEB_SERVER" in
        nginx|apache|haproxy) ;;
        *) log_error "Unsupported web server: '${WEB_SERVER}'. Use nginx, apache, or haproxy"; exit 1 ;;
esac

[[ -n "$PRE_HOOK" ]] && { log_info "Running pre-hook ${PRE_HOOK}"; eval "$PRE_HOOK"; }

# shellcheck disable=SC2086
RENEW_OUTPUT=$(certbot renew ${CERTBOT_FLAGS} 2>&1) || {
        log_error "certbot renew failed."
        echo "$RENEW_OUTPUT" >&2
        exit 2
}

echo "$RENEW_OUTPUT"

if echo "$RENEW_OUTPUT" | grep -q "Congratulations, all renewals succeeded"; then
        log_info "Certificate(s) renewed. Reloading ${WEB_SERVER}..."
        if [[ "$DRY_RUN" == "false" ]]; then
                systemctl reload "$WEB_SERVER" || service "$WEB_SERVER" reload || log_warn "Could not reload ${WEB_SERVER}."
        fi

        [[ -n "$POST_HOOK" ]] && { log_info "Running post-hook: ${POST_Hook}"; eval "$POST_HOOK" ; }

        log_info "Renewal complete."
elif echo "$RENEW_OUTPUT" | grep -q "No renewals were attempted"; then
        log_info "No certificates are due for renewal."
else
        log_warn "Unexpected certbot output - check the log above."
fi

exit 0

