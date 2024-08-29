# Add the parent directory to sys.path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from libs import render
from libs import utils
import random

frameRate = 4
currentFrame = 0

playerX = 15
playerY = 3

def walk_cycle():
  return [
    [
      r'   o   ',
      r'  /|\  ',
      r'  / \  ',
    ],[
      r'  \o/  ',
      r'   |   ',
      r'  / \  ',
    ]
  ]

def draw_animation():
  global playerX
  global playerY

  # get texture
  tex = walk_cycle()[currentFrame % len(walk_cycle())]
  render.print_tex(tex, playerX, playerY)

  # move randomly
  playerX = (playerX + random.randint(-1, 1))
  playerY = (playerY + random.randint(-1, 1))
  playerX = utils.clamp(playerX, 0, render.frameWidth - len(tex[0]))
  playerY = utils.clamp(playerY, 0, render.frameHeight - len(tex))


# Infinite loop. Use CTR-C to stop
while True:   
  currentFrame = render.init(65, 10, frameRate)
  #-------------------------
  #
  draw_animation()
  #
  #-------------------------
  render.render()
  render.wait()




