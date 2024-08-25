# Profile
if [ $# -ge 1 ]; then
  export PROFILE=$1
else
  export PROFILE="dev"
fi
export DOJO_PROFILE_FILE="dojo_$PROFILE.toml"

if ! [ -x "$(command -v toml)" ]; then
  echo 'Error: toml not instlaled! Instal with: cargo install toml-cli'
  exit 1
fi

get_profile_env () {
  local ENV_NAME=$1
  local RESULT=$(toml get $DOJO_PROFILE_FILE --raw env.$ENV_NAME)
  if [[ -z "$RESULT" ]]; then
    >&2 echo "get_profile_env($ENV_NAME) not found! 👎"
  fi
  echo $RESULT
}

#-----------------
# env setup
#
export PROJECT_NAME=$(toml get $DOJO_PROFILE_FILE --raw world.name)
export WORLD_ADDRESS=$(get_profile_env "world_address")
# use $DOJO_ACCOUNT_ADDRESS else read from profile
export ACCOUNT_ADDRESS=${DOJO_ACCOUNT_ADDRESS:-$(get_profile_env "account_address")}

export MANIFEST_FILE_PATH="./manifests/$PROFILE/deployment/manifest.json"
export CLIENT_GEN_PATH="../../clients/sdk/src"
export PROFILE_GEN_PATH="$CLIENT_GEN_PATH/manifest/$PROFILE"
# use $STARKNET_RPC_URL else read from profile
export RPC_URL=${STARKNET_RPC_URL:-$(get_profile_env "rpc_url")}
