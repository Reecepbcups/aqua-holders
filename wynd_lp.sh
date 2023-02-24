# WYND/AQUA
WYNDAQUA_CONTRACT="juno1zhe3sptqs7ajcxy725fnd6ar9mtj67rzjfmad6zldyn92n6mfj5qztqr4u"
LIMIT="10000"
REST_NODE="https://api.juno.strange.love:443"

mkdir -p Wynd

HEIGHT=7131467
next_pag_key=""

# expected one of `claims`, `staked`, `all_staked`, `total_staked`, `total_unbonding`, `total_rewards_power`, `rewards_power`, `admin`, `bonding_info`, `annualized_rewards`, `withdrawable_rewards`, `distributed_rewards`, `undistributed_rewards`, `delegated`, `distribution_data`, `withdraw_adjustment_data`: query wasm contract failed: invalid request",
# ALL_STAKED=eyJhbGxfc3Rha2VkIjp7fX0=
# view raw state for "stake" to get (address & unbonding period) from the Map

# I just do 1 big query for all bonded tokens
UUID=$(uuidgen) && FILENAME="Wynd/Wynd-$UUID.json"
curl -X GET "$REST_NODE/cosmwasm/wasm/v1/contract/$WYNDAQUA_CONTRACT/state?pagination.limit=$LIMIT" -H  "accept: application/json" -H "x-cosmos-block-height: $HEIGHT" > $FILENAME

echo "now run wynd.py"