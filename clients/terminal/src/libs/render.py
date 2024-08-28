
frameWidth = 65
frameHeight = 10

frame = []

def init():
  global frame
  frame = [' ' * frameWidth for _ in range(frameHeight)]

def render():
  global frame
  for line in frame:
    print(',' + line + ',')

def print_tex(tex, x, y):
  global frame
  for i, line in enumerate(tex):
    for j, char in enumerate(line):
        if char != ' ':
            frame[y + i] = frame[y + i][:x + j] + char + frame[y + i][x + j + 1:]


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

