from libs import ascii_lib as ascii
from libs import render
from libs import utils
import sys
import time


frameCount = 0
frameRate = 6
sleepTime = (1.0 / frameRate)

playerX = 15
playerY = 3

def render_duel(name_a, name_b, message, paces_a, dodge_a, paces_b, dodge_b, name_winner):
  print(name_a)
  print(name_b)
  print(message)
  print(paces_a)
  print(dodge_a)
  print(paces_b)
  print(dodge_b)
  print(name_winner)

  # # Infinite loop. Use CTR-C to stop
  # while True:
  #   frameCount += 1
  #   ascii.clear_screen()
  #   # animate
  #   render.init()
  #   # get texture
  #   tex = render.walk_cycle()[frameCount % len(render.walk_cycle())]
  #   render.print_tex(tex, playerX, playerY)

  #   # move randomly
  #   playerX = (playerX + random.randint(-1, 1))
  #   playerY = (playerY + random.randint(-1, 1))
  #   playerX = utils.clamp(playerX, 0, render.frameWidth - len(tex[0]))
  #   playerY = utils.clamp(playerY, 0, render.frameHeight - len(tex))

  #   # render
  #   render.render()
  #   # wait
  #   time.sleep(sleepTime)




#--------------------------------------------------------
# main execution
#
if __name__ == '__main__':
  if (len(sys.argv) != 9):
    print("usage: python render_duel.py name_a name_b message paces_a dodge_a paces_b dodge_b name_winner")
    exit()
  name_a = sys.argv[1]
  name_b = sys.argv[2]
  message = sys.argv[3]
  paces_a = sys.argv[4]
  dodge_a = sys.argv[5]
  paces_b = sys.argv[6]
  dodge_b = sys.argv[7]
  name_winner = sys.argv[8]
  render_duel(name_a, name_b, message, paces_a, dodge_a, paces_b, dodge_b, name_winner)
