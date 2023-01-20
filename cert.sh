#!/bin/sh

# most os's support local even though not in posix:
#  https://stackoverflow.com/a/18600920/516433
# so we globally:
# shellcheck disable=SC2039

set -e

REPO=${REPO:-https://gitlab.mitre.org/mitre-scripts/mitre-pki}

OS_RELEASE_FILE=/etc/os-release
if [ -n "$1" ]; then
    MODE="$1"
elif [ -z "${MODE}" -a -f "${OS_RELEASE_FILE}" ]; then
    MODE="$(. /etc/os-release; echo ${ID})"
fi

url_encode () {
    local URL="$1"
    echo "$URL" | sed -e 's/ /%20/g'
}

have () { command -v $1 > /dev/null 2>&1; }
missing () { ! have $1; }

fetch_url () {
    local URL="$1"
    local TARGET="$2"
    # https://stackoverflow.com/a/677212/677201
    if have curl; then
        echo "Fetching '${URL}' using curl" >&2
        curl -sSk "${URL}" -o "${TARGET}"
    elif have wget; then
        echo "Fetching '${URL}' using wget" >&2
        wget -q --no-check-certificate "${URL}" -O "${TARGET}"
    else
        echo "No wget or curl found to fetch ${URL}!" >&2
        exit 1
    fi

    if [ ! -f "${TARGET}" ]; then
        echo "${TARGET} is missing after download attempt, couldn't download ${URL}" >&2
        exit 1
    fi
}

fetch_all_certs () {
    local FOLDER="$1"
    echo "Fetching all certs to ${FOLDER}"
    local CERT_LIST=/tmp/cert_list.txt
    fetch_url "${REPO}/raw/master/normalized/cert-list.txt" "${CERT_LIST}"

    # https://stackoverflow.com/a/1521498/677201
    while IFS="" read -r cert || [ -n "$cert" ]; do
        SAFE_NAME=$(url_encode "${cert}")
        fetch_url "${REPO}/raw/master/pem/${SAFE_NAME}" "${FOLDER}/${cert}"
    done < "${CERT_LIST}"
    rm -f "${CERT_LIST}"
}

alpine () {
    # its safe to use http for apk:
    #   https://gitlab.alpinelinux.org/alpine/infra/infra/-/issues/8087#note_45235
    # and this feature is to _enable_ https, so we temporarily disable https
    # long enough to install the package needed to instal the MITRE CA
    sed --in-place="_ORIG" \
      's/https\:\/\/dl-cdn.alpinelinux.org/http\:\/\/dl-cdn.alpinelinux.org/g' \
      /etc/apk/repositories
    if missing update-ca-certificates; then
        apk add ca-certificates
    fi
    mv /etc/apk/repositories_ORIG /etc/apk/repositories

    fetch_all_certs /usr/local/share/ca-certificates
    update-ca-certificates
}

centos () {
    fetch_url "${REPO}/raw/master/normalized/mitre-chain.txt" "/etc/pki/ca-trust/source/anchors/mitre-chain.crt"
    update-ca-trust
}

apt_distro () {
    if missing update-ca-certificates; then
        missing_pkgs="ca-certificates"
    fi
    if missing curl; then
        missing_pkgs="${missing_pkgs} curl"
    fi
    if [ -n "${missing_pkgs}" ]; then
        started_clean=$(ls -1 /var/lib/apt/lists 2>/dev/null)
        apt-get update
        apt-get install --no-install-recommends -y ${missing_pkgs}
        if [ -n "${started_clean}" ]; then
            apt-get clean
            rm -rf /var/lib/apt/lists/*
        fi
    fi
    fetch_all_certs /usr/local/share/ca-certificates
    update-ca-certificates
}

java () {
    echo "Using os_scripts's MODE=java is deprecated in favor of tool_scripts's MODE=java" >&2
    fetch_url "${REPO}/raw/master/tool_scripts/install_certs.sh" /dev/stdout | sh
}

case $MODE in
    "alpine")
        echo "Installing MITRE certs for alpine"
        alpine
        ;;
    "centos")
        echo "Installing MITRE certs for centos"
        centos
        ;;
    "fedora")
        echo "Installing MITRE certs for fedora"
        centos
        ;;
    "debian")
        echo "Installing MITRE certs for debian"
        apt_distro
        ;;
    "ubuntu")
        echo "Installing MITRE certs for ubuntu"
        apt_distro
        ;;
    "java")
        echo "Installing MITRE certs for java"
        java
        ;;
    *)
        echo "Invalid or missing mode!"
        exit 1
        ;;
esac
