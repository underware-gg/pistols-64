# Add the parent directory to sys.path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from libs import ascii_lib as ascii
import time

frameCount = 0
frameRate = 2

def smoke():
    shift = 16
    start = frameCount % 2
    for x in range(0+start, 4+start):
        if (x%2 == 0):
            print(" "*(shift)+"(,")
        else:
            print(" "*(shift)+",)")
    # for x in range(0, 4):
    #     if (x%2 == 0):
    #         print(" "*(shift+1-start)+"(")
    #     else:
    #         print(" "*(shift+start)+")")

def house():
    print("     __________| |____")
    print("    /                 \\")
    print("   /   The             \\")
    print("  /   Fool & Flintlock  \\")
    print("  |            Tavern   |")
    print("  |     ____     ___    |")
    print("  |    |    |   |___|   |")
    print("__|____|____|___________|__")
    print()

# MAIN CODE


# Infinite loop. Use CTR-C to stop
while True:   
    frameCount += 1
    ascii.clear_screen()
    smoke()
    house()
    time.sleep(1.0 / frameRate)




