from libs import ascii_lib as ascii
from libs import render
from libs import utils
import sys
import time

# render settings
frameRate = 3
currentFrame = 0
currentSteps = 0
currentPaces = 0
timeline = []
animations = []

width = 80
height = 10
tex_y = 3

#-----------------------------
# Textures
#
def get_tex(anim, step=None):
  step = currentFrame if step == None else step
  return anim[step % len(anim)]

def still_a():
  return [
    [
      r'⎦ ⏺  ',
      r' \|\ ',
      r' / \ ',
    ],
  ]
def still_b():
  return [
    [
      r'  ⏺ ⎣',
      r' /|/ ',
      r' / \ ',
    ],
  ]
def walk_a():
  return [
    [
      r'⎦ ⏺  ',
      r' \|\ ',
      r' < \ ',
    ],
    [
      r'⎦ ⏺  ',
      r' \|\ ',
      r' / - ',
    ],
  ]
def walk_b():
  return [
    [
      r'  ⏺ ⎣',
      r' /|/ ',
      r' / > ',
    ],
    [
      r'  ⏺ ⎣',
      r' /|/ ',
      r' - \ ',
    ],
  ]
def shoot_a():
  return [
    [
      r' ⏺_┍━',
      r' \\  ',
      r' / \ ',
    ],
  ]
def shoot_b():
  return [
    [
      r'━┑_⏺ ',
      r'  // ',
      r' / \ ',
    ],
  ]
def dodge():
  return [
    [
      r'     ',
      r' _⏺_ ',
      r' / \ ',
    ],
  ]
def wait():
  return [
    [
      r'  ⏺  ',
      r' /|\ ',
      r' / \ ',
    ],
  ]
def death():
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
      r' *@_ ',
      r'  }  ',
      r' < > ',
    ],
    [
      r':*@ ',
      r' -O- ',
      r' \ / ',
    ],
    [
      r':.  ',
      r'`*0/ ',
      r' / - ',
    ],
    [
      r',.  ',
      r'\*., ',
      r' #\_ ',
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
def bullet_fly():
  return [
    [
      r'  -  ',
      r'     ',
      r'     ',
    ],
  ]


class Bullet:
  x = int(width / 2)
  y = tex_y
  is_a = False
  is_b = False
  flying = False
  step = 0

  def __init__(self, duelist_number):
    self.is_a = (duelist_number == 1)
    self.is_b = (duelist_number == 2)

  def start(self, start_x):
    self.x = start_x
  def stop(self):
    global frameRate
    frameRate = 3
    self.flying = False
  
  def fly(self):
    global frameRate
    frameRate = 6
    self.flying = True
    self.x = int(self.x + (1 if self.is_a else -1))
    self.step += 1

  def draw(self):
    if self.flying:
      tex = get_tex(bullet_fly(), self.step)
      render.print_tex(tex, self.x, self.y)


class Duelist:
  x = int(width / 2)
  y = tex_y
  step = 0
  stepDeath = 0
  is_a = False
  is_b = False
  anim = []

  def __init__(self, duelist_number):
    self.is_a = (duelist_number == 1)
    self.is_b = (duelist_number == 2)
    self.x += (-4 if self.is_a else 1)
    self.still()
  
  def still(self):
    self.anim = still_a() if self.is_a else still_b()
  def walk(self):
    self.anim = walk_a() if self.is_a else walk_b()
    if (not bullet_a.flying and not bullet_b.flying):
      self.x = int(self.x + (-1 if self.is_a else 1))
      self.step += 1
  def shoot(self):
    self.anim = shoot_a() if self.is_a else shoot_b()
  def dodge(self):
    self.anim = dodge()
  def wait(self):
    self.anim = wait()
  def death(self):
    self.anim = death()
    self.stepDeath += 1
    self.step = self.stepDeath

  def draw(self):
    tex = get_tex(self.anim, self.step)
    render.print_tex(tex, self.x, self.y)


duelist_a = Duelist(1)
duelist_b = Duelist(2)
bullet_a = Bullet(1)
bullet_b = Bullet(2)

#-----------------------------
# Render
#
def update():
  global timeline
  global animations
  if (len(timeline) == 0):
    exit()
  if ((currentFrame-1) % 2 == 0):
    animations = timeline.pop(0)

def animate():
  for anim in animations:
    anim()
  duelist_a.draw()
  duelist_b.draw()
  bullet_a.draw()
  bullet_b.draw()

def next_step():
  global currentSteps
  global currentPaces
  currentSteps += 1
  currentPaces = int(currentSteps / 2)

def draw_text(txt):
  fillLen = int((width-len(txt)) / 2)
  line = '-' * fillLen + txt + '-' * fillLen
  print(line)

def render_duel(name_a, name_b, message, paces_a, dodge_a, paces_b, dodge_b, name_winner):
  # print(name_a, name_b, message, paces_a, dodge_a, paces_b, dodge_b, name_winner)
  global timeline
  timeline.append([duelist_a.still, duelist_b.still])
  for p in range(1, 11):
    def get_duelist_anim(duelist, paces, dodge):
      if (p == paces):
        return duelist.shoot
      elif (p == dodge):
        return duelist.dodge
      elif (p < paces):
        return duelist.walk
      else:
        return duelist.wait
    is_shooting_a = (p == paces_a)
    is_shooting_b = (p == paces_b)
    anim_a = get_duelist_anim(duelist_a, paces_a, dodge_a)
    anim_b = get_duelist_anim(duelist_b, paces_b, dodge_b)
    anims = []
    anims.append(anim_a)
    anims.append(anim_b)
    anims.append(next_step)
    if (is_shooting_a):
      bullet_a.start(duelist_a.x - (p * 2) + 3)
      anims.append(bullet_a.fly)
    else:
      anims.append(bullet_a.stop)
    if (is_shooting_b):
      bullet_b.start(duelist_b.x + (p * 2) - 3)
      anims.append(bullet_b.fly)
    else:
      anims.append(bullet_b.stop)
    timeline.append(anims)
    # animate bullets to the end
    if (is_shooting_a or is_shooting_b):
      c = int((paces_a + paces_b - 2) / 2) + 4
      for i in range(0, c):
        anims = []
        anims.append(anim_a)
        anims.append(anim_b)
        if (is_shooting_a):
          anims.append(bullet_a.fly)
        if (is_shooting_b):
          anims.append(bullet_b.fly)
        timeline.append(anims)
      # endgame
      win_a = (name_winner == name_a)
      win_b = (name_winner == name_b)
      if (is_shooting_a and win_a) or (is_shooting_b and win_b):
        for i in range(0, 4): # death is 8 frames...
          anims = []
          anims.append(duelist_a.death if win_b else anim_a)
          anims.append(duelist_b.death if win_a else anim_b)
          anims.append(bullet_a.stop)
          anims.append(bullet_b.stop)
          timeline.append(anims)
        break

  # Infinite loop. Use CTR-C to stop
  while True:
    global currentFrame
    update()
    currentFrame = render.init(width, height, frameRate)
    # render.do_background()
    animate()
    render.render()
    draw_text(f" [ {name_a} vs. {name_b} ] ")
    draw_text(f" [ \"{message}\" ] ")
    draw_text(f" [ {currentPaces} paces... ] ")
    if (len(animations) == 0):
      draw_text(f" + # + # $ {name_winner} wins! + # + # + ")
    render.wait()


#--------------------------------------------------------
# main execution
#
if __name__ == '__main__':
  if (len(sys.argv) != 9):
    print("usage: python render_duel.py name_a name_b message paces_a dodge_a paces_b dodge_b name_winner")
    exit()
  name_a, name_b, message, paces_a, dodge_a, paces_b, dodge_b, name_winner = sys.argv[1:]
  render_duel(name_a, name_b, message, int(paces_a), int(dodge_a), int(paces_b), int(dodge_b), name_winner)
