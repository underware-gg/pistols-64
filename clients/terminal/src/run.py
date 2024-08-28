from libs import ascii_lib as ascii
from libs import render
import subprocess
import json

frameCount = 0

def smoke():
    shift = 16
    start = frameCount % 2
    for x in range(0+start, 4+start):
        if (x%2 == 0):
            print(" "*(shift)+"(,")
        else:
            print(" "*(shift)+",)")

def tavern():
    print("     __________| |____")
    print("    /                 \\")
    print("   /   The             \\")
    print("  /   Fool & Flintlock  \\")
    print("  |            Tavern   |")
    print("  |     ____     ___    |")
    print("  |    |    |   |___|   |")
    print("__|____|____|___________|__")
    print()

def execute_sozo(function, calldata):
  try:
    command = f"sozo execute pistols64-actions {function} --calldata {calldata} --wait --receipt"
    print("] executing sozo...")
    print("] $", command)
    result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
    print("] ok!")
    output_lines = result.stdout.strip().split('\n')[2:]
    output = '\n'.join(output_lines)
    return json.loads(output)
  except subprocess.CalledProcessError as e:
    print("] error executing command: ", command)
    print("] exit code: ", e.returncode)
    print("] error output: ", e.stderr)
    return None


smoke()
tavern()
def hex(msg):
  return '0x' + msg.encode('utf-8').hex()

message = input("What's the beef? ")
name_a = input("Challenger's name: ")
name_b = input("Offender's name: ")

result = execute_sozo("create_challenge", f"{hex(name_a)},{hex(name_b)},{hex(message)}")
duel_id = result["events"][0]["data"][2]

paces_a = input(f"{name_a}'s paces to shoot: ")
dodge_a = input(f"{name_a}'s paces to dodge: ")
result = execute_sozo("move", f"{duel_id},0x1,{hex(name_a)},0x2,{paces_a},{dodge_a}")
# print(result["events"][0])

paces_b = input(f"{name_b}'s paces to shoot: ")
dodge_b = input(f"{name_b}'s paces to dodge: ")
result = execute_sozo("move", f"{duel_id},0x1,{hex(name_b)},0x1,{paces_b},{dodge_b}")
# print(result["events"][0])

