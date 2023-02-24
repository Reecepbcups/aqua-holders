# iterates over the Wynd directory for staked LP tokens at the height before the issue

import base64
import json
import os

current_dir = os.path.dirname(os.path.realpath(__file__))
Wynd = os.path.join(current_dir, "Wynd")


def hex_string_to_uft8(hex_string):
    return bytearray.fromhex(hex_string).decode()


def base64_to_uft8(base64_string):
    return base64.b64decode(base64_string).decode()


balances = {}
total_staked = 0

for file in os.listdir(Wynd):
    # read the file
    with open(os.path.join(Wynd, file), "r") as f:
        data = json.load(f)

        modules = list(data["models"])

        for idx, m in enumerate(modules, start=1):

            try:
                key = hex_string_to_uft8(m["key"])
                value = json.loads(base64_to_uft8(m["value"]))
            except:
                # print(m["key"], m["value"])
                # exit(1)
                continue

            if "withdraw_adjustment" in key:
                continue
            elif key == "admin":
                continue

            address = (
                key.replace("\x00\x05stake\x00+", "")
                .replace("\x00\x00\x00\x00\x007_\x00", "")
                .replace("\x00\x00\x00\x00\x00\x12u\x00", "")
            )

            try:
                amt = int(dict(value).get("stake", 0))
            except:
                print("err", key, value)
                exit(1)

            if amt <= 0:
                continue
            print(f"{address} - {amt}")

            balances[address] = amt
            total_staked += amt

# save balances to a file as JSON
with open(os.path.join(current_dir, "wynd_staked.json"), "w") as f:
    balances = {
        k: v for k, v in sorted(balances.items(), key=lambda x: x[1], reverse=True)
    }
    json.dump(balances, f, indent=2)
    print(f"wynd_staked saved to wynd_staked.json. Total Staked: {total_staked:.0f}")
    # Total Staked: 590727994523
