## Reece Williams - Feb 24 2023
# Get all aqua CW20 holders before a 12bn mint attack
# https://www.mintscan.io/juno/txs/4338A591B461DCA7ADA2B138D10955EA51F47A5A32BCDDEC3D659425B9FA7898

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

# switch to files current dir
cd "$(dirname "$0")"

# check if .env file exists, if not exit
if [ ! -f ".env" ]; then
    echo "ERROR: .env file not found, please create one with 'cp .env.example .env'. Then edit to your liking."
    exit 1
fi

# load env vars from .env file
# export $(grep -v '^#' .env | xargs)

CW20_CONTRACT="juno1hnftys64ectjfynm6qjk9my8jd3f6l9dq9utcd3dy8ehwrsx9q4q7n9uxt"
LIMIT="500"
REST_NODE="https://api.juno.strange.love:443"

# make dir CW20s if not already made
mkdir -p CW20s

HEIGHT=7131467
next_pag_key=""

urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

# Loop through until we dont have any more pages
while true; do
    # get a random UUID for this file
    UUID=$(uuidgen) && FILENAME="CW20s/cw20-$UUID.json"

    # check if next_pag_key is empty
    if [[ -z $next_pag_key ]]; then
        echo "no key = 1st run"        
        curl -X GET "$REST_NODE/cosmwasm/wasm/v1/contract/$CW20_CONTRACT/state?pagination.limit=$LIMIT" -H  "accept: application/json" -H "x-cosmos-block-height: $HEIGHT" > $FILENAME
    else
        echo "Running with page key: $next_pag_key"
        URL_CODE=$(urlencode $next_pag_key)        
        curl -X GET "$REST_NODE/cosmwasm/wasm/v1/contract/$CW20_CONTRACT/state?pagination.key=$URL_CODE&pagination.limit=$LIMIT" -H  "accept: application/json" -H "x-cosmos-block-height: $HEIGHT" > $FILENAME        
    fi

    # echo "Getting all keys from $FILENAME"
    next_pag_key=`jq -r '.pagination.next_key' $FILENAME`
    # if next_pag_key if null, then we are done
    if [[ $next_pag_key == "null" ]]; then
        echo "No more pages, Finished!"
        break
    fi
done

echo "Please run script2.py now to convert the CW20s folder files -> balances.json"