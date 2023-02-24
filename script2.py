"""
Loops over all JSON files in CW20s folder, then converts out the actual balances
"""

import base64
import json
import os

current_dir = os.path.dirname(os.path.realpath(__file__))
CW20s = os.path.join(current_dir, "CW20s")


def hex_string_to_uft8(hex_string):
    return bytearray.fromhex(hex_string).decode()


def base64_to_uft8(base64_string):
    return base64.b64decode(base64_string).decode()


balances = {}
total_balances = 0

for file in os.listdir(CW20s):
    # read the file
    with open(os.path.join(CW20s, file), "r") as f:
        data = json.load(f)

        # get models key if found
        if "models" not in data:
            continue

        modules = list(data["models"])

        for m in modules:
            key = hex_string_to_uft8(m["key"])
            if "balance" not in key:
                break

            # TODO: clean this mess up yuck
            # remove balance from the string
            address = str(
                key.replace("balance", "").replace("\u0000\u0007", "")
            )  # balancejuno1000xz25ydz8h9rwgnv30l9p0x500dvj0s9yyc9 -> juno1000xz25ydz8h9rwgnv30l9p0x500dvj0s9yyc9

            balance = int(
                base64_to_uft8(m["value"]).replace('"', "")
            )  # TODO: try catch

            # print(f'{address} - {balance}')
            if balance <= 0:
                continue

            balances[address] = balance
            total_balances += balance

# save balances to a file as JSON
with open(os.path.join(current_dir, "balances.json"), "w") as f:
    balances = {
        k: v for k, v in sorted(balances.items(), key=lambda x: x[1], reverse=True)
    }
    json.dump(balances, f, indent=2)
    print("Balances saved to balances.json. Total Value: {total_balances:.0f}")
