# Add the parent directory to sys.path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from libs import ascii_lib as ascii
import time
import random

currentFrame = 0
frameRate = 6
sleepTime = 1.0

frameWidth = 10
frameHeight = 10
frame = []

def init(w, h, fr):
  global frame
  global frameWidth
  global frameHeight
  global frameRate
  global sleepTime
  global currentFrame
  frameWidth = w
  frameHeight = h
  frameRate = fr
  sleepTime = (1.0 / frameRate)
  frame = [' ' * frameWidth for _ in range(frameHeight)]
  # clear scren
  ascii.clear_screen()
  # increase frame
  currentFrame += 1
  return currentFrame

def render():
  global frame
  for line in frame:
    print(',' + line + ',')

def wait():
  time.sleep(sleepTime)

def print_tex(tex, x, y):
  global frame
  x = int(x)
  y = int(y)
  for i, line in enumerate(tex):
    for j, char in enumerate(line):
      if char != ' ':
        frame[y + i] = frame[y + i][:x + j] + char + frame[y + i][x + j + 1:]

def do_background():
  global frame
  random.seed(112)
  for y in range(frameHeight):
    for x in range(frameWidth):
      r = random.randint(0, 100)
      if r > 98 and y > 7:
        frame[y] = frame[y][:x] + '@' + frame[y][x+1:]
      elif r > 95 and y > 6:
        frame[y] = frame[y][:x] + ',' + frame[y][x+1:]
      elif (r > 85 and y > 5) or r > 98:
        frame[y] = frame[y][:x] + '.' + frame[y][x+1:]

