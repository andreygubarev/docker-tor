#!/bin/bash
set -eux

export TOR_CONFIG=/etc/tor/torrc

if [ -n "$TOR_BRIDGE" ]; then
    sed -i "s/UseBridges 0/UseBridges 1/" $TOR_CONFIG
    echo "Bridge $TOR_BRIDGE" >> $TOR_CONFIG
fi

if [ -n "$TOR_SERVICE" ]; then
    echo "HiddenServiceDir /var/lib/tor/hidden_service" >> $TOR_CONFIG
    TOR_SERVICE_PORT=${TOR_SERVICE%%:*}
    TOR_SERVICE_REMOTE=${TOR_SERVICE#*:}
    echo "HiddenServicePort $TOR_SERVICE_PORT $TOR_SERVICE_REMOTE" >> $TOR_CONFIG
fi

tor -f $TOR_CONFIG
