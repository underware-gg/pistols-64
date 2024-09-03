from duel_renderer import render_duel
from libs import ascii_lib as ascii
from libs import utils
from libs import sozo

frameCount = 0

def smoke():
    shift = 16
    start = frameCount % 2
    for x in range(0+start, 4+start):
        if (x%2 == 0):
            print(" "*(shift)+"(,")
        else:
            print(" "*(shift)+",)")

def deli():
    print("              ,Oo>     ")
    print("             (O;      ")
    print("              (o)     ")
    print("               ;o)    ")
    print("     __________| |____")
    print("    /                 \\")
    print("   /   Ye Olde         \\")
    print("  /   Shoggoth's Deli   \\")
    print("  |                     |")
    print("  |     ____     ___    |")
    print("  |    |..  |   |___|   |")
    print("__|____|____|___________|__")
    print()

# the_oruggin_trail-Output
#   pub struct Output {
#     #[key]
#     pub playerId: felt252,
#     pub text_o_vision: ByteArray,
# }
# "data": [
#   "0x55f44298c07639e35f14dd8904f32219a4f0f4ba2efbca6414e73312da5b224",
#   "0x1",
#   "0x17",
#   "0x3",
#   "0x0",
#   "0x53686f67676f74682073746172657320696e746f2074686520766f6964",
#   "0x1d"
# ]
def extract_tot_Output_from_events(events):
  for event in events:
    if event["data"][0] == "0x55f44298c07639e35f14dd8904f32219a4f0f4ba2efbca6414e73312da5b224":
      # eventId = event["data"][0]
      # keys_len = event["data"][1]
      # playerId = event["data"][2]
      # data_len = event["data"][3]
      # text_o_vision_len = event["data"][4]
      text_o_vision_words = event["data"][5:-1]
      return utils.hex_array_to_str(text_o_vision_words)
  return None


#--------------------------------------------------------
# main execution
#
if __name__ == '__main__':

  # result = sozo.sozo_execute("live_fast_die_jung", f"2,str:\"fight\",str:\"shoggoth\"")
  # output = extract_tot_Output_from_events(result["events"])
  # print(output)
  # exit()

  ascii.clear_screen()
  # smoke()
  deli()

  print("You find yourself in front of a suspicious Deli.")
  print("It has a curious, vaguely familiar name...")
  print("Is that a... tentacle coming out of the chimney?")
  answer = input(f"Do you dare to enter? (y/n): ")
  if (answer != "y" and answer != "yes"):
    print("You turn around and leave.\nSucker!")
    exit()

  print("")
  print("You enter the Deli.")
  print("There's a shadowy figure behind the counter.")
  print("A chill runs down your spine...")
  answer = input(f"You feel an impulse to speak... (y/n): ")
  if (answer != "y" and answer != "yes"):
    print("You turn around and leave.\nSucker!")
    exit()

  result = sozo.sozo_execute("live_fast_die_jung", f"2,str:\"look\",str:\"around\"")
  output = extract_tot_Output_from_events(result["events"])

  print("")
  print("The figure reveals itself...")
  print(f"\"{output} ...\"")
  print("My god! What have you done?")
  print("You are in the presence of the Shoggoth!")
  answer = input(f"Shit your pants? (yes): ")

  result = sozo.sozo_execute("live_fast_die_jung", f"2,str:\"fight\",str:\"shoggoth\"")
  output = extract_tot_Output_from_events(result["events"])
  duel_id = output.split()[-1]
  print(duel_id)

  # get the results
  # ChallengeResults
  # [ 0xce6788dee1a083c26cd2a32c69285989 0x3234323335 0x3433343334333232 0x3233343233 0x2 0x2 0x3 0x2 0x5 0x6 0x1 0x0 ]
  result = sozo.sozo_call("get_challenge_results", f"{duel_id}")
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
  result_winner = utils.hex_to_number(result[11])
  result_winner_name = result_name_a if result_winner == 1 else result_name_b if result_winner == 2 else None
  # print("winner:", result_winner, result_winner_name)
  # input("continue...")
  render_duel(result_name_a, result_name_b, result_message, result_paces_a, result_dodge_a, result_paces_b, result_dodge_b, result_winner_name)
