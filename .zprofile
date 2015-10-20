# keychain
if [[ `uname` == "Linux" ]]; then
  eval `keychain --eval --agents ssh id_ed25519 id_rsa_4096`
elif [[ `uname` == "Darwin" ]]; then
  eval `keychain --eval --agents ssh id_ed25519 id_rsa`
  # MacTeX
  eval `/usr/libexec/path_helper -s`
else
  # do nothing
fi
