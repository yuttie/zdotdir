# keychain
if [[ `uname` == "Linux" ]]; then
  eval `keychain --eval --agents ssh id_rsa`
elif [[ `uname` == "Darwin" ]]; then
  eval `keychain --eval --agents ssh --inherit any id_rsa`
else
  # do nothing
fi
