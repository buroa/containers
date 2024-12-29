#!/usr/bin/env bash

# Copy the binary and rename so the move is atomic
install_cni() {
    src="$1"
    bin_name="$(basename $src)"
    dst="${CNI_DIR}/bin/$bin_name"

    if [ ! -f "$dst" ]; then
        tmp_dst="${CNI_DIR}/bin/.$bin_name.new"
        echo "Installing $bin_name to $dst ..."
        cp $src $tmp_dst && \
        mv $tmp_dst $dst && \
        echo "Wrote $dst"
    fi
}

# Install all the CNI plugins
for plugin in /plugins/*; do
    install_cni $plugin || true
done
