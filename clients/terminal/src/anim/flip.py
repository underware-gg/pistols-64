# Add the parent directory to sys.path
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from libs import ascii_lib as ascii
import time

frameCount = 0
frameRate = 6

def flip():
    frames = [
        [
            "  o  ",
            " /|\ ",
            " / \ ",
        ],[
            " \ o / ",
            "   |   ",
            "  / \  ",
        ],[
            "  _ o  ",
            "   /\  ",
            "  | \  ",
        ],[
            "          ",
            "    ___\o ",
            "   /)  |  ",
        ],[
            "   __|   ",
            "     \o  ",
            "     ( \ ",
        ],[
            "    \ /  ",
            "     |   ",
            "    /o\  ",
        ],[
            "       |__ ",
            "     o/    ",
            "    / )    ",
        ],[
            "            ",
            "     o/__   ",
            "     |  (\  ",
        ],[
            "     o _  ",
            "     /\   ",
            "     / |  ",
        ],[
            "     _ o _",
            "       |  ",
            "      / \ ",
        ],[
            "       o ",
            "      /|\\",
            "      / \\",
        ],
    ]
    frame = frames[frameCount % len(frames)]
    for line in frame:
        print(line)




# MAIN CODE


# Infinite loop. Use CTR-C to stop
while True:   
    frameCount += 1
    ascii.clear_screen()
    flip()
    time.sleep(1.0 / frameRate)




