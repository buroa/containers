#Spec: {
    app:  #AcceptableAppName
    base: bool
    semantic_versioning?: bool
    channels: [...#Channels]
}

#Channels: {
    name: #AcceptableChannelName
    platforms: [...#AcceptedPlatforms]
    stable: bool
    tests: {
        enabled: bool
        type?:   =~"^(cli|web)$"
    }
}

#AcceptableAppName:           string & !="" & =~"^[a-zA-Z0-9_-]+$"
#AcceptableChannelName:       string & !="" & =~"^[a-zA-Z0-9._-]+$"
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64"
