#!/usr/bin/env python3
import os
import sys
import time
import json
import logging
import requests

logger = logging.getLogger(__name__)


def update_port_forward():
    gluetun_host = os.environ.get("GLUETUN_HOST", "localhost")
    gluetun_port = os.environ.get("GLUETUN_PORT", "8000")
    qb_host = os.environ.get("QB_HOST", "localhost")
    qb_port = os.environ.get("QB_PORT", "8080")

    def get_gluetun_port():
        response = requests.get(f"http://{gluetun_host}:{gluetun_port}/v1/openvpn/portforwarded").json()
        return response.get("port")

    def get_bt_port():
        response = requests.get(f"http://{qb_host}:{qb_port}/api/v2/app/preferences").json()
        return response.get("listen_port")

    def update_bt_port(port):
        payload = {"json": json.dumps({"listen_port": port})}
        response = requests.post(f"http://{qb_host}:{qb_port}/api/v2/app/setPreferences", data=payload)
        if response.ok:
            logger.info(f"Port updated to {port}.")
        else:
            logger.warning("Failed to update the listen port")

    bt_port = get_bt_port()
    gluetun_port = get_gluetun_port()

    if not bt_port == gluetun_port:
        logger.info(f"Updating port from {bt_port} to {gluetun_port}...")
        update_bt_port(gluetun_port)


def main():
    logging.basicConfig(
        stream=sys.stdout,
        level=logging.INFO,
        format="%(asctime)s %(levelname)s:%(message)s",
        datefmt="%I:%M:%S %p",
    )

    logger.info("Starting port forwarding...")

    while True:
        try:
            update_port_forward()
        except Exception as e:
            logger.exception(e)

        time.sleep(30)

if __name__ == "__main__":
    main()
