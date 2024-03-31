# qbittorrent

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                     | Default |
|--------------------------|---------|
| QBITTORRENT__BT_PORT     | `50413` |
| QBITTORRENT__PORT        | `8080`  |
| QBITTORRENT__USE_PROFILE | `false` |

## Dynamic custom environment configuration

> **WARNING:** Environment variable configuration is an *advanced* feature. YMMV

qBittorrent wants configuration to be done via the UI. Additionally, configuration changes to the config file after
application start are ignored and overwritten on application close. To combat this, a script has been written to update
the config file. This converts our environment syntax to toml syntax with no regard for valid configuration, and will
put whatever you define in the config! Please keep this in mind.

Environment variable characteristics:

* Prefix (Single underscore suffix): `QBT_`
* Section (Double underscore suffix): `Preferences__`
* Key (Double underscore for backslashes): `Connection__PortRangeMin`
* Sections and keys are case-sensitive (per qBittorrent requirements)
* Values should always be single quoted to ensure string representation

This will give you an environment variable that looks something like

```yaml
QBT_Preferences__Connection__PortRangeMin: '50000'
```

If your qBittorrent.conf is on persistent storage, Any changes made in the UI will persist on disk. That means changes
made to config options not defined in env will stay as-is, and means that changes made to env variable defined options
will be overwritten (on restart not live).
