# keychain
case "$OSTYPE" in
  linux*)
    eval `keychain --eval --agents ssh id_ed25519 id_rsa_4096`
    ;;
  darwin*)
    eval `keychain --eval --agents ssh id_ed25519 id_rsa`
    # MacTeX
    eval `/usr/libexec/path_helper -s`
    ;;
esac
