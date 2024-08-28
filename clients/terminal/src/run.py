from libs import ascii_lib as ascii
from libs import utils
from render_duel import render_duel
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


def sozo_execute(function, calldata, readCall=False):
  try:
    command = f"sozo execute pistols64-actions {function} --calldata {calldata} --wait --receipt"
    print("] $", command)
    print("] executing sozo...")
    result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
    print("] ok!")
    # execute output be like:
    # > Transaction hash: 0x042e421b83aa4b01a9393eacc593d27ea21494eae04422b211dcda6635dbc431
    # > Receipt:
    # {
    # ...
    # }
    output_lines = result.stdout.strip().split('\n')[2:]
    output = '\n'.join(output_lines)
    return json.loads(output)
  except subprocess.CalledProcessError as e:
    print("] ! error executing command: ", command)
    print("] ! exit code: ", e.returncode)
    print(e.output)
    exit()
  
def sozo_call(function, calldata):
  try:
    command = f"sozo call pistols64-actions {function} --calldata {calldata}"
    print("] $", command)
    print("] calling sozo...")
    result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
    print("] ok!")
    # call output be like:
    # [ 0xce6788dee1a083c26cd2a32c69285989 0x3234323335 0x3433343334333232 0x3233343233 0x2 0x2 0x3 0x2 0x5 0x6 0x1 0x0 ]
    return result.stdout.strip('[]').split()
  except subprocess.CalledProcessError as e:
    print("] ! error executing command: ", command)
    print("] ! exit code: ", e.returncode)
    print(e.output)
    exit()


#--------------------------------------------------------
# main execution
#
if __name__ == '__main__':
  # draw the tavern
  ascii.clear_screen()
  smoke()
  tavern()

  # get challenge details
  message = input("What's the beef? ")
  name_a = input("Challenger's name: ")
  name_b = input("Offender's name: ")

  # create_challenge() and get duel_id from event data
  result = sozo_execute("create_challenge", f"{utils.str_to_hex(name_a)},{utils.str_to_hex(name_b)},{utils.str_to_hex(message)}")
  duel_id = result["events"][0]["data"][2]

  # duelist A moves...
  paces_a = input(f"{name_a}'s paces to shoot: ")
  dodge_a = input(f"{name_a}'s paces to dodge: ")
  sozo_execute("move", f"{duel_id},0x1,{utils.str_to_hex(name_a)},0x2,{paces_a},{dodge_a}")

  # duelist B moves...
  paces_b = input(f"{name_b}'s paces to shoot: ")
  dodge_b = input(f"{name_b}'s paces to dodge: ")
  sozo_execute("move", f"{duel_id},0x1,{utils.str_to_hex(name_b)},0x2,{paces_b},{dodge_b}")

  # get the results
  # ChallengeResults
  # [ 0xce6788dee1a083c26cd2a32c69285989 0x3234323335 0x3433343334333232 0x3233343233 0x2 0x2 0x3 0x2 0x5 0x6 0x1 0x0 ]
  result = sozo_call("get_challenge_results", f"{duel_id}")
  result_duel_id = utils.hex_to_number(result[0])
  result_name_a = utils.hex_to_str(result[1])
  result_name_b = utils.hex_to_str(result[2])
  result_message = utils.hex_to_str(result[3])
  # result_moves_a_len = utils.hex_to_number(result[4])
  result_paces_a = utils.hex_to_number(result[5])
  result_dodge_a = utils.hex_to_number(result[6])
  # result_moves_b_len = utils.hex_to_number(result[7])
  result_paces_b = utils.hex_to_number(result[8])
  result_dodge_b = utils.hex_to_number(result[9])
  result_finished = True if utils.hex_to_number(result[10]) == 1 else False
  result_winner = utils.hex_to_str(result[11])
  result_winner_name = result_name_a if result_winner == 1 else result_name_b if result_winner == 2 else None
  render_duel(name_a, name_b, message, result_paces_a, result_dodge_a, result_paces_b, result_dodge_b, result_winner_name)
