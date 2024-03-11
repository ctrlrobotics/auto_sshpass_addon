#!/usr/bin/with-contenv bashio

set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq --raw-output '.username' $CONFIG_PATH)
PASSWORD=$(jq --raw-output '.password' $CONFIG_PATH)
HOSTNAME=$(jq --raw-output '.hostname' $CONFIG_PATH)
LOCAL_HOST=$(jq --raw-output '.local_host' $CONFIG_PATH)
LOCAL_PORT=$(jq --raw-output '.local_port' $CONFIG_PATH)
REMOTE_HOST=$(jq --raw-output '.remote_host' $CONFIG_PATH)
REMOTE_PORT=$(jq --raw-output '.remote_port' $CONFIG_PATH)

while :; do
  bashio::log.info "Attempting to connect to ${HOSTNAME} as ${USERNAME}..."
  sshpass -v \
    -p "${PASSWORD}" \
    ssh \
      -o "ServerAliveInterval 60" \
      -o "ServerAliveCountMax 2" \
      -o "ConnectTimeout 15" \
      -o "ExitOnForwardFailure yes" \
      -o "StrictHostKeyChecking no" \
      -4 -R "${REMOTE_HOST}:${REMOTE_PORT}:${LOCAL_HOST}:${LOCAL_PORT}" -N "${USERNAME}@${HOSTNAME}"

    bashio::log.info "SSH connection exieted, wait 15s before re-trying"
    sleep 15
done