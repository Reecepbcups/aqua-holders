WYNDAQUA_CONTRACT="juno1zhe3sptqs7ajcxy725fnd6ar9mtj67rzjfmad6zldyn92n6mfj5qztqr4u"
JUNOAQUA_CONTRACT="juno1n9nylsg6jdcdjc7m5f29kycdpy9xhjgd68kh2vn8j7xztqruxy4sgwlaul"

LIMIT="10000"
REST_NODE="https://api.juno.strange.love:443"

mkdir -p Wynd

HEIGHT=7131467

# I just do 1 big query for all bonded tokens
FILENAME="Wynd/AQUAWYND.json"
curl -X GET "$REST_NODE/cosmwasm/wasm/v1/contract/$WYNDAQUA_CONTRACT/state?pagination.limit=$LIMIT" -H  "accept: application/json" -H "x-cosmos-block-height: $HEIGHT" > $FILENAME

FILENAME="Wynd/JUNOAQUA.json"
curl -X GET "$REST_NODE/cosmwasm/wasm/v1/contract/$JUNOAQUA_CONTRACT/state?pagination.limit=$LIMIT" -H  "accept: application/json" -H "x-cosmos-block-height: $HEIGHT" > $FILENAME

echo "now run wynd.py"