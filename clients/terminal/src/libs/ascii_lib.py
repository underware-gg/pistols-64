import platform    # Used by clear_screen
import subprocess  # Used by clear_screen

# System independent clear screen function
# https://stackoverflow.com/questions/18937058/#42877403
def clear_screen():
  # print('\033[2J') # One possible method to clear the screen
  command = "cls" if platform.system().lower()=="windows" else "clear"
  return subprocess.call(command) == 0
