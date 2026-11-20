# Longthinx gobbiefix

> **To SQUARE ENIX's Creative Studio 3:** if you would like to put any of our code or ideas from gobbiefix into
> the game, feel free to. Just credit Dellingr and Geno (us); or, if you can't credit us directly for legal reasons, a
> tongue-in-cheek thank-you to the "Beastmen Alliance" will do. (This covers Dellingr's own work; the parts from
> others named in Credits at the bottom stay under their own authors' terms.)
> 
> Notes on each fix, with code, in English and Japanese, and how to reach me:
> [Longthinx-Gobbiefix-Source-Files](https://github.com/WGINC/Longthinx-Gobbiefix-Source-Files).

```
   \'-._     .-''''''''''-.     _.-'/
    \   '-._/  .--.  .--.  \_.-'   /
     '.     | (    )(    ) |     .'
       '-.  |  '--'  '--'  |  .-'
          '-|      ||      |-'
            \  o   ||   o  /
             | o   ||   o |
              \o   ||   o/
               '--------'
```

*Pshhh... Shkohhh...*

Hullo, adventurer! Gobbie bring fixings for youuugame: a new renderer (d3d8on11, on Direct3D 12), a fastyfaster
gameloop (speedfix), and the kit that hold them together (xikit). Game run faster, smoother, and gobbie no change how
it look except where this page say so. *Pshhh...*

## Gobbie movein

1. Close the game.
2. Command Prompt **as administrator**, in this folder: `install.bat`.
   Game somewhere else? `install.bat "D:\path\to\PlayOnlineViewer"`.
3. Start the game sameway as always. Nothing else to start: game load gobbie by itself. *Shkohhh...*

Gobbie keep youuu oldthings safeykeep in the sack:
- the `d3d8.dll` that was there (dgVoodoo's) become `d3d8_before_kit.dll`;
- youuu `gobbiefix.ini` stay as it is when youuu install again (`install.bat /defaults` put gobbievalues back, and keep
  yours as `gobbiefix.ini.before_gobbiefix`);
- the other `.ini` files is gobbiepot; an older one is kept once as `NAME.ini.before_gobbiefix`.

## Gobbie moveout

`uninstall.bat` (as administrator, game closed). *Pshhh...* gobbie packystow the shinybits and put the old `d3d8.dll`
back. The `.ini` files and logs stay.

## Youknobs: gobbiefix.ini

In the PlayOnlineViewer folder. Change a value, save, start the game: gobbie sniff it every gamestart. Only these is for
youuu; the other `.ini` files is gobbiepot (gobbiefix.ini write over the few keys it own in them, every gamestart).

### frame_cap (0)
How many frames a second the game may make. **0** = no cap: game go fastzoom as it can. **10 to 1000** = gobbie hold it
to that many. Gobbie measured a 120 cap on youuu kind of Mac and it no make things smoother, so gobbie leave it off.
With a cap, `smooth_pacing` take a nap: only one of the two work at a time.

### smooth_pacing (1)
**1** = gobbie space the frames evensteady. Each frame wait until the time most frames (9 in 10) of the last 120 took, so
the speed follow the scene but the steps stay even. Measured: frames taking over twice as long as their neighbours went
from 67 to 19 a minute. **0** = each frame go the moment it is ready (more upsanddowns). *Shkohhh...*

### swap_buffers (2)
How many pictures the renderer juggle with Windows (only with `renderer=d3d12`).
- **2** (gobbiepick): fewer frames made, but nearly all reach the screen. Measured blind, same spot, 3 minutes each:
  Windows showed 94% of frames with 2 against 76% with 3, and frames held on screen for an extra refresh 15 a second
  against 23. Youuu felt no stutter with 2 and the usual judder with 3.
- **3**: the framecounter go higher (127 against 111 that day), but the extra frames get throwaway before the screen,
  and the ones left come uneven.
- **4**: allowed, never measured.

Gobbie also tested the cost: at the same framerate 2 still win, so it is not only "slower is smoother". *Pshhh...*

### mipmaps (1)
**1** = faraway textures get smaller, smoothed copies, so floors and walls in the distance no shimmersparkle. This
change how far things look (that is the point). **0** = the game's textures exactly as they is.

### anisotropy (16)
How sharp textures stay when youuu see them slantways, like a road going away from youuu. **0 to 16**, 16 sharpest.
Needs `mipmaps=1`.

### smooth_names (1)
**1** = names over heads shrink smoothyslide as things walk away. **0** = the game's own 80 little sizesteps (youuu see
names pulse bigger and smaller as people move).

### fitted_shadows (1)
**1** = the round shadows under people sized to each body. **0** = the game's own shadowsize.

### sound_retry (1)
*Shkohhh...* Youuu hear the rain stop after a while, and it no come back? The game has only so many voices (12, or what
youuu set in the registry, at most 20). When a looping sound like rain or wind lose its voice and ask for a new one while
all of them is busy, the game no wait: it throw the sound away for good, until the weather or zone start it again. Gobbie
found that in the game's own code (it happen with no gobbiefix too). **1** = gobbie keep such a sound and it ask again at
the next update, the sameway the game already does when too many sounds ask in one update, so it come back as soon as a
voice is free. Only sounds the game itself keep while youuu cannot hear them is kept; the rest go as before. **0** = the
game's way.

### sphere_shine (1)
*Pshhh...* Some metal, like Warlord Rojgnoj's gold armour, is meant to shine with a reflection. On PC the game read the
wrong corner of the reflection picture at half the PS2's strength, so the metal look dull. **1** = gobbie draw it the
PS2's way: right part of the picture, full strength. **0** = the game's dull way. (How the PS2 does it was measured by
voetre for portfix; gobbie made its own version inside gobbie's model drawing.)

### flare_fix (1)
Lamps and lanterns far away have a glow that blinkyflick behind its own lamp. *Shkohhh...* **1** = gobbie draw the glow a
tiny bit nearer to you (0.4, straight toward the camera), so it stay in front and stay right where it was on screen.
**0** = the game's blinky way. (From dagnyfix's flare fix v4.4, by Dellingr; gobbie move it with the glow's position
instead of copying its points. V0.7: the old way pushed glows sideways where the game turns or stretches them, so lights
in zones after the base game sat in the wrong place. Fixyfixed.)

### disintegrate (1)
When the Shadow Lord (and a few others) change form, on the PS2 the first body break into dark shards that tumble
away, with purple smoke and a wobbly heat haze. On the PC it just... stay whole. *Shkohhh...* **1** = gobbie make it
break, the smooth way (voetre's portfix code, copied in, MIT licence). **2** = gobbie's own way, with the flickery
body like the PS2 cutscene (needs the frame settings that come with gobbiefix: frame_step or uncap). **0** = the
game's way.

### decal_fix (1)
Circles on the ground (summoning circles, spell circles) come out squished like an egg, and grow and shrink with the
camera. *Shkohhh...* The game draw them into a little square picture first, but with the screen's shape and zoom.
**1** = gobbie give that square picture its own square view, so the circle come out round and as big as the game made
it. **0** = the game's eggy way. (dagnyfix, by Dellingr, found it; gobbie fix it where the game draw it.)

### aura_size (1024), aura_soft (1), aura_boost (0), aura_trail (0)
*Shkohhh...* The glowy auras around summons is drawn from a small picture blown up big, and its copies sit too
close on big screens, so the edges come out jaggy. **aura_size** = how big the picture is (1024; 256 the game's, 512,
2048, 4096). **aura_soft=1** = gobbie spread the copies out for youuu screen and draw the hard middle copy soft (the
trick dagnyfix use, done inside the game's own drawing, so no extra cost).

Gobbie's own extras, not in the game: **aura_boost** 0 to 5 = each notch make the aura a quarter thicker and
brighter. **aura_trail** 0 to 50 = how many afterimages trail behind a moving aura thing, each a little gap behind the one
ahead (**aura_trail_gap**, 25 = a quarter yalm; bigger = more spread out). They stay till there is that many, then the
oldest go. They follow where the thing was, not the camera, and keep their size when the camera move. Standing still,
the trail pull in to one faint one. **aura_trail_alpha** = how bright they are, in percent (100 normal).

**aura_trail_advanced** (0) = the advanced afterimage trail: each afterimage is a real 3D ghost of the body in the pose
it had there, so it look right from any camera angle (the normal ones are flat pictures, which keep the angle they were
taken from). **Warning, gobbie say: it may slow youuu game down**: every afterimage draws the whole body again, so 50 of
them is a lot of drawing. Try a few first. Each
afterimage is one more see-through picture over the screen, so a long trail cost a little speed.

### renderer (d3d12)
**d3d12** = gobbie's fastzoom renderer. If Direct3D 12 no start on a machine, it use Direct3D 11 by itself. **d3d11** =
always the olderway (try this only if d3d12 give youuu trouble).

### update_notice (1)
When the game get patched, gobbie sniffysnoop its build. If gobbie no know the new build, the game still run with the new
renderer, but speedfix and the other fixings stay in the sack (gobbie no know where things is), and **1** = a window
tell youuu to fetch a new gobbiefix. **0** = no window. *Shkohhh...*

### debug (0)
**0** = shortytidy logs. **1** = gobbie scribblywrite statistics in the logs (for helpfixing problems).
Easiest: `gobbiefix_debug.bat on` or `gobbiefix_debug.bat off` (as administrator; takes effect at next gamestart).
"on" leave a little file, `gobbiefix_debug.on`, in the gamefolder: while it is there, debug is on whatever
gobbiefix.ini say. "off" take it away.

## Logs

In the PlayOnlineViewer folder: `d3d8on11.log` (last start's is `d3d8on11_prev.log`; a crash is scribbled there with
where it happened) and `xikit.log`. Something wrong? Turn debug on, play until it happen, and send gobbie those two.

## What gobbie know, and no know

*Pshhh...*
- On a Mac with Parallels, gobbie measured with a slowmotion phone that some frames Windows show never reach the Mac's
  screen (lost after Windows hand them over). That is outside the game: gobbie cannot fixit from inside. Setting the
  Mac's screen to a fixed 60 Hz instead of ProMotion no fixit either.
- Gobbiefiles: `d3d8.dll`, `d8x.exe`, `d8x_arm64.exe` (the renderer), `xikit.dll` (the kit),
  `speedfix.dll`, and the `xikit_manifest*.txt` files (where things is in each gamebuild gobbie know, and a
  sniffprint of each place so gobbie can check it is the build gobbie know; no game code in them). An older
  gobbiefix also put `gfx_recon_ingame.dll` there: install.bat take it away, this one no need it.

## Legalstuff

Gobbie's own work is under the GNU GPL, version 3 only (`COPYING.txt` has the whole thing); FINAL FANTASY XI and everything of it belong to SQUARE ENIX, and gobbie no
belong to them. The real words is in `LICENSE.txt` (plain English, no gobbiespeak, *Shkohhh...*), and they is what count.

## Credits

Gobbie say thankyhug to all who workyfixed before gobbie:

- **Dellingr**: gobbiefix itself (the d3d8on11 renderer, the xikit kit, speedfix), speedfix_hook (speedfix's
  beginning), and dagnyfix (its flarefix, aura fix and decalfix are where flare_fix, aura_size and decal_fix come from).
- **voetre**: portfix (MIT licence). disintegrate=1 is portfix's code, copied; sphere_shine and disintegrate=2 are
  built from portfix's reading of the PS2.
- **Krauerlabs**: SpectralFix, which dagnyfix's aura fix ports; aura_soft does its two picture changes.
- **Daleterrence**: the prototype dagnyfix's decalfix grew from.
- **Geno**: helpyhand with gobbiefix's Linux side (coming soon).
- **SQUARE ENIX**: FINAL FANTASY XI, and everything of it. Gobbie no belong to them.
