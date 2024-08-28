# Add the parent directory to sys.path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from libs import ascii_lib as ascii
import time

frameCount = 0
frameRate = 4
step = 0

def walk():
  return [
    [
      r' \⏺/ ',
      r'  |  ',
      r' < > ',
    ],
    [
      r' \@/ ',
      r'  |  ',
      r' < > ',
    ],
    [
      r' \@_ ',
      r'  }  ',
      r' < > ',
    ],
    [
      r':.@ ',
      r' -O- ',
      r' \ / ',
    ],
    [
      r':.. ',
      r' *0/ ',
      r' / - ',
    ],
    [
      r' .  ',
      r'\*., ',
      r' *\_ ',
    ],
    [
      r'.    ',
      r'  .  ',
      r'.@&_ ',
    ],
    [
      r'     ',
      r'     ',
      r'.@.┕━',
    ],
  ]



# MAIN CODE


# Infinite loop. Use CTR-C to stop
while True:   
  frameCount += 1
  ascii.clear_screen()
  # animate
  frames = walk()
  frame = frames[frameCount % len(frames)]
  step = (frameCount % (len(frames)*6))
  for line in frame:
    print(line)
  print(f'step: {step/2}')
  # wait
  time.sleep(1.0 / frameRate)




