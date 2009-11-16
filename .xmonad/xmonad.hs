import XMonad
import XMonad.Operations
import XMonad.Actions.DwmPromote
import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Prompt             ( XPConfig(..), XPPosition(..) )
import XMonad.Prompt.Shell       ( shellPrompt )
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
 
import qualified Data.Map as M
import Data.Bits ((.|.))
import Data.Ratio
import Graphics.X11                                                                                                    
import System.IO
 
 
main = do
	  xmproc <- spawnPipe "xmobar"
          xmonad $ defaultConfig
                     { borderWidth        = 1
                     , normalBorderColor  = "grey30"
                     , focusedBorderColor = "#cfae96" 
                     , focusFollowsMouse = True
                     , workspaces         = ["1","2","3","4","5","6","7"] 
                     , terminal           = "urxvt"
                     , modMask            = mod4Mask
                     , logHook = dynamicLogWithPP $ customPP
                        { ppOutput = hPutStrLn xmproc
                        }
                     , manageHook         = myManageHook -- manageDocks
                     , layoutHook         = avoidStruts (tiled ||| Mirror tiled ||| noBorders Full)
                     }
                     where
                       tiled = Tall 1 (3%100) (1%2)
customPP :: PP
customPP = defaultPP { ppCurrent = xmobarColor "#AFAF87" "" . wrap "<" ">"
                     , ppTitle =  shorten 80
                     , ppSep =  "<fc=#AFAF87> | </fc>"
                     , ppHiddenNoWindows = xmobarColor "#AFAF87" ""
                     , ppUrgent = xmobarColor "#FFFFAF" "" . wrap "[" "]"
                     }

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

