WS='wss://passet-hub-paseo.ibp.network'
# WS='wss://paseo-rpc.dwellir.com'

addr=$(jq -r '.ss58PublicKey' ~/.address.json)

# fetch account data
RAW=$(npx --yes @polkadot/api-cli --ws $WS \
          query.system.account "$addr" --output json 2>/dev/null)

# Extract free balance value
FREE_PLANCK=$(echo "$RAW" | jq -r '.account.data.free | gsub(","; "")')
BAL=$(awk "BEGIN {printf \"%.10f\", $FREE_PLANCK/1e10}")

# Rich text
GREEN='\033[1;32m'
RESET='\033[0m'

# Output message
echo -e "Balance: ${GREEN}$BAL PAS${RESET}"