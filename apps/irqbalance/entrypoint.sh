#!/usr/bin/env bash

echo "Starting irqbalance ..."
/usr/sbin/irqbalance --daemon

echo "Sleeping ..."
sleep infinity
