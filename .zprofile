# keychain
if [[ `uname` == "Linux" ]]; then
  eval `keychain --eval --agents ssh id_ed25519 id_rsa_4096`
elif [[ `uname` == "Darwin" ]]; then
  eval `keychain --eval --agents ssh --inherit any id_ed25519 id_rsa`
else
  # do nothing
fi
