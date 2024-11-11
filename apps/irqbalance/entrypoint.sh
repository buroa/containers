#!/usr/bin/env bash

echo "Starting irqbalance ..."
exec /usr/sbin/irqbalance "$@"

echo "Sleeping ..."
sleep infinity
