import XMonad
import XMonad.Config.Gnome
import XMonad.Actions.Submap

import Control.Arrow hiding ((|||))
import Data.Bits
import Data.Monoid
import qualified Data.Map as M

import qualified XMonad.StackSet as W
import XMonad.Actions.DwmPromote
import System.Exit

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Actions.WindowBringer (gotoMenuArgs, bringMenuArgs)
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowMenu
import XMonad.Actions.WindowGo

import XMonad.Config.Desktop
import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Layout.GridVariants
import XMonad.Layout.Tabbed (simpleTabbed)

import XMonad.Hooks.FadeInactive
import XMonad.ManageHook

import XMonad.Actions.RotSlaves

main :: IO ()
main = do
  xmonad $ gnomeConfig
    { terminal = "gnome-terminal"
    , focusFollowsMouse = False
    , borderWidth = 2
    -- , keys = addPrefix (mod4Mask, xK_space) (keys gnomeConfig)
    , keys = myKeys
    , layoutHook = myLayout
    , logHook = myLog
    , modMask = mod4Mask
    , focusedBorderColor = "#00DD00" -- "#89A1F3"
    , normalBorderColor = "#0C1320"
    }
    `additionalKeysP`
    [ ("M4-<Tab>"      , windows W.focusDown)
    , ("M4-S-<Tab>"    , windows W.focusUp)
    , ("M4-q"          , kill)
    , ("M4-S-a"        , spawn "gmrun")
    , ("M4-a"          , spawn "exe=`dmenu_path | dmenu -b -l 10 -fn '10x20' -nb '#0C1320' -nf '#505764' -sb '#131A27' -sf 'cyan' -p Run` && eval \"exec $exe\"")
    , ("M4-<KP_Left>"  , sendMessage Shrink)
    , ("M4-<KP_Right>" , sendMessage Expand)
    , ("M4-S-<F12>"    , io (exitWith ExitSuccess))
    , ("M4-<F12>"      , spawn "xmonad --recompile; xmonad --restart")
    , ("M4-<Return>"   , dwmpromote)
    , ("M4-S-<Return>" , rotSlavesUp)
    , ("M4-<Space>"    , sendMessage NextLayout)
    , ("M4-<F11>"      , withFocused $ windows . W.sink)
    , ("M4-`"          , gotoMenuArgs ["-b", "-l", "10", "-fn", "'10x20'", "-nb", "'#0C1320'", "-nf", "'#505764'", "-sb", "'#131A27'", "-sf", "'cyan'", "-p", "'Go To'"])
    , ("M4-S-`"        , bringMenuArgs ["-b", "-l", "10", "-fn", "'10x20'", "-nb", "'#0C1320'", "-nf", "'#505764'", "-sb", "'#131A27'", "-sf", "'cyan'", "-p", "Summon"])
    , ("M4-'"          , goToSelected defaultGSConfig {gs_navigate = myNavigation})
    , ("M4-S-'"        , bringSelected defaultGSConfig {gs_navigate = myNavigation})
    , ("M4-o"          , windowMenu)
    , ("<F1>"          , runOrRaise "emacs23" (className =? "Emacs23" <||> className =? "Emacs"))
    , ("<F2>"          , runOrRaise "conkeror" (className =? "Conkeror"))
    , ("<F3>"          , runOrRaise "gnome-terminal" (className =? "Gnome-terminal"))
    , ("<F9>"          , runOrRaise "firefox" (className =? "Firefox"))
    , ("<F10>"         , runOrRaise "google-chrome" (className =? "Google-chrome"))
    , ("<F11>"         , runOrRaise "skype" (className =? "Skype"))
    , ("<F12>"         , runOrRaise "pidgin" (className =? "Pidgin"))
    ]

-- Grid navigation
myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
  where navKeyMap = M.fromList [
           ((0,xK_Escape), cancel)
          ,((0,xK_Return), select)
          ,((0,xK_space) , select)
          ,((0,xK_slash) , substringSearch myNavigation)
          ,((0,xK_s)     , substringSearch myNavigation)
          ,((0,xK_Left)  , move (-1, 0)  >> myNavigation)
          ,((0,xK_h)     , move (-1, 0)  >> myNavigation)
          ,((0,xK_Right) , move ( 1, 0)  >> myNavigation)
          ,((0,xK_n)     , move ( 1, 0)  >> myNavigation)
          ,((0,xK_Down)  , move ( 0, 1)  >> myNavigation)
          ,((0,xK_t)     , move ( 0, 1)  >> myNavigation)
          ,((0,xK_Up)    , move ( 0,-1)  >> myNavigation)
          ,((0,xK_c)     , move ( 0,-1)  >> myNavigation)
          ,((0,xK_g)     , move (-1,-1)  >> myNavigation)
          ,((0,xK_r)     , move ( 1,-1)  >> myNavigation)
          ,((0,xK_m)     , move (-1, 1)  >> myNavigation)
          ,((0,xK_v)     , move ( 1, 1)  >> myNavigation)
          -- ,((0,xK_space) , setPos (0,0)  >> myNavigation)
          ]
        -- The navigation handler ignores unknown key symbols
        navDefaultHandler = const myNavigation

addPrefix p ms conf =
  M.singleton p . submap $ M.mapKeys (first chopMod) (ms conf)
  where
  mod = modMask conf
  chopMod = (.&. complement mod)

myLayout = desktopLayoutModifiers
           $ tiled
           ||| Mirror tiled
           ||| Full
           ||| withIM (7%30) (Or (Role "buddy_list") (Role "MainWindow")) simpleTabbed
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 7/10
    delta = 1/30

myLog = fadeInactiveLogHook fadeAmount
  where fadeAmount = 1

-- myManage = composeAll [ className =? "Skype" --> doF ]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ -- ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- -- Push window back into tiling
    -- , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- -- Increment the number of windows in the master area
    -- , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- -- Deincrement the number of windows in the master area
    -- , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_4]
        , (f, m) <- [(W.greedyView, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F9, xK_F10] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]