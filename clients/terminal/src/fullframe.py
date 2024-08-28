from libs import ascii_lib as ascii
from libs import render
import time
import sys
import random


frameCount = 0
frameRate = 6
sleepTime = (1.0 / frameRate)

playerX = 15
playerY = 3

def clamp(value, min_value, max_value):
  return max(min(value, max_value), min_value)


# Infinite loop. Use CTR-C to stop
while True:   
  frameCount += 1
  ascii.clear_screen()
  # animate
  render.init()
  # get texture
  tex = render.walk_cycle()[frameCount % len(render.walk_cycle())]
  render.print_tex(tex, playerX, playerY)

  # move randomly
  playerX = (playerX + random.randint(-1, 1))
  playerY = (playerY + random.randint(-1, 1))
  playerX = clamp(playerX, 0, render.frameWidth - len(tex[0]))
  playerY = clamp(playerY, 0, render.frameHeight - len(tex))

  # render
  render.render()
  # wait
  time.sleep(sleepTime)




