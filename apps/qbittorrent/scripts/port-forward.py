#!/usr/bin/env python3
import os
import sys
import time
import json
import logging
import requests


GLUETON_HOST = os.environ.get("GLUETON_HOST", "http://localhost:8000")
QB_HOST = os.environ.get("QB_HOST", "http://localhost:8080")
logger = logging.getLogger(__name__)


def update_port_forward():
    def get_gluetun_port():
        try:
            response = requests.get(f"{GLUETON_HOST}/v1/openvpn/portforwarded").json()
        except:
            logger.warning("Failed to get the port forwarded from gluetun.")
        else:
            return response.get("port")

    def get_qb_port():
        try:
            response = requests.get(f"{QB_HOST}/api/v2/app/preferences").json()
        except:
            logger.warning("Failed to get the listen port from qBittorrent.")
        else:
            return response.get("listen_port")

    def update_qb_port(port):
        try:
            payload = {"json": json.dumps({"listen_port": port})}
            response = requests.post(f"{QB_HOST}/api/v2/app/setPreferences", data=payload)
        except:
            logger.warning("Failed to update the qBittorrent listen port.")
        else:
            return response.ok

    qb_port = get_qb_port()
    if not qb_port:
        return

    gluetun_port = get_gluetun_port()
    if not gluetun_port:
        return

    if not qb_port == gluetun_port:
        success = update_qb_port(gluetun_port)
        if success:
            logger.info(f"qBittorrent listen port updated to {gluetun_port}.")
        else:
            logger.warning("Failed to update the qbittorrent listen port.")
    else:
        logger.debug("qBittorrent listen port is already up to date.")


def main():
    logging.basicConfig(
        stream=sys.stdout,
        level=logging.INFO,
        format="%(asctime)s %(levelname)s:%(message)s",
        datefmt="%I:%M:%S %p",
    )

    logger.info("Starting port forwarding...")

    while True:
        update_port_forward()
        time.sleep(15)


if __name__ == "__main__":
    main()
