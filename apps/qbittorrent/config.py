#!/usr/bin/env python3
import argparse

from configparser import ConfigParser
from os import environ as env

parser = argparse.ArgumentParser()
required = parser.add_argument_group('required arguments')
required.add_argument('-o','--output', help='Configuration file name', required=True)
args = parser.parse_args()

CONFIG_FILE = args.output

c = ConfigParser()
c.optionxform = str
c.read(CONFIG_FILE)
cfg_keys = [k[4:] for k in env if k.startswith('QBT_')]

for cfg_key in cfg_keys:
    cfg = cfg_key.split('__')
    s = cfg[0]
    k = '\\'.join(cfg[1:])
    if s not in c:
        c[s] = {}
    c[s][k] = env[f'QBT_{cfg_key}']

if len(cfg_keys) > 0:
    with open(CONFIG_FILE, 'w') as f:
        c.write(f)
    print('config updated')
