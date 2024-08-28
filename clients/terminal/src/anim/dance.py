# Add the parent directory to sys.path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from libs import ascii_lib as ascii
import time

frameCount = 0
frameRate = 6

def dance1():
  return [
    [
      r'   o   ',
      r'  /|\  ',
      r'  / \  ',
    ],[
      r'  \o/  ',
      r'   |   ',
      r'  / \  ',
    ],[
      r'   o>  ',
      r'  /|   ',
      r'  / \  ',
    ],[
      r'  _o_  ',
      r'   |   ',
      r'  > <  ',
    ],[
      r'  \o/  ',
      r'   |   ',
      r'  / \  ',
    ],[
      r'   o   ',
      r'  <|\  ',
      r'  / \  ',
    ],[
      r'  _o_  ',
      r'   |   ',
      r'  / \  ',
    ],[
      r'  \o/  ',
      r'   |   ',
      r'  / \  ',
    ],[
      r'   o   ',
      r'  /|\  ',
      r' _/ \_ ',
    ],[
      r'   o   ',
      r'  /|\  ',
      r'  > <  ',
    ],[
      r'   o   ',
      r'  /|\  ',
      r'  / \  ',
    ],
  ]



# MAIN CODE


# Infinite loop. Use CTR-C to stop
while True:   
  frameCount += 1
  ascii.clear_screen()
  # animate
  frames = dance1()
  frame = frames[frameCount % len(frames)]
  for line in frame:
    print(line)
  # wait
  time.sleep(1.0 / frameRate)




