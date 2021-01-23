# csc258-project
csc258-project
## overview
In this project, I implemented the popular mobile game Doodle Jump using MIPS assembly. If you don't have access to physical computers with MIPS processors, you can test the implementation in a simulated environment within MARS, i.e., a simulated bitmap display and a simulated
keyboard input.
## How to Play
The goal of this game is to see how high the Doodler can get by jumping up from platform to platform. The camera follows the Doodler as it jumps to higher platforms, with new platforms appearing at the top of the screen. The game ends if
the Doodler misses the platforms and lands on the bottom edge of the screen.
### Game Controls
There are two buttons used to control the Doodler while in midair:
* The "j" key makes the Doodler
move to the left,
* The "k" key makes the Doodler
move to the right.
This project will use the Keyboard and
MMIO Simulator to take in these
keyboard inputs.
When no key is pressed, the Doodler
falls straight down until it hits a platform or the bottom of the screen. If it hits a
platform, the Doodler bounces up high into the air, but if the Doodler hits the
bottom of the screen, the game ends.
## Using MARS
1. If you haven’t downloaded it already, get MARS v4.5 at http://courses.missouristate.edu/kenvollmar/mars/download.htm.
2. Download doodlejump.s and open it in MARS
3. Set up display: Tools > Bitmap display
  * Set parameters like unit width & height (8) and base address for display.
Click “Connect to MIPS” once these are set.
4. Set up keyboard: Tools > Keyboard and Display MMIO Simulator
  * Click “Connect to MIPS”
5. Run > Go (to start the run)
6. Input the character j or k in Keyboard area (bottom white box) in Keyboard and
Display MMIO Simulator window  
  
  
  

