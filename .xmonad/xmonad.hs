import XMonad
import XMonad.Config.Gnome
import XMonad.Actions.Submap

import Control.Monad (liftM2)
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
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.Master (multimastered)
import XMonad.Layout.PerWorkspace

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.ManageHook

import XMonad.Actions.RotSlaves

import XMonad.Actions.CycleWindows

main :: IO ()
main = do
  -- ewmh is to play nice with tools like xdotool/wmctrl
  xmonad $ ewmh $ gnomeConfig
    { terminal = "gnome-terminal"
    , focusFollowsMouse = False
    , borderWidth = 1
    -- , keys = addPrefix (mod4Mask, xK_space) (keys gnomeConfig)
    , keys = myKeys
    -- For compatibility with some java programs
    , startupHook = setWMName "LG3D"
    , layoutHook = myLayout
    , logHook = myLog
    , manageHook = myManage XMonad.ManageHook.<+> manageHook gnomeConfig
    , modMask = mod4Mask
    , focusedBorderColor = "#00DD00" -- "#89A1F3"
    , normalBorderColor = "#0C1320"
    , workspaces = myWorkspaces
    }
    `additionalKeysP`
    [ -- ("M4-<Tab>"      , windows W.focusDown)
    -- ,
      ("M4-<Tab>"      , windows W.focusDown)
    , ("M4-S-<Tab>"    , cycleRecentWindows [xK_Super_L] xK_Tab xK_quoteleft)
    , ("M4-q"          , kill)
    , ("M4-S-`"        , spawn "gmrun")
    -- , ("M4-`"          , spawn "exe=`PATH=/home/ubolonton/bin:$PATH dmenu_path | dmenu -b -l 10 -fn '10x20' -nb '#0C1320' -nf '#505764' -sb '#131A27' -sf 'cyan' -p Run` && eval \"exec $exe\"")
    , ("M4-`"          , spawn "$HOME/bin/ublt-dmenu")
    , ("M4-<KP_Left>"  , sendMessage Shrink)
    , ("M4-<KP_Right>" , sendMessage Expand)
    , ("M4-S-<F12>"    , io (exitWith ExitSuccess))
    , ("M4-<F12>"      , spawn "xmonad --recompile && xmonad --restart")
    , ("M4-<Return>"   , dwmpromote)
    , ("M4-S-<Return>" , rotSlavesUp)
    , ("M4-S-<Space>"  , sendMessage NextLayout)
    , ("M4-<F11>"      , withFocused $ windows . W.sink)
    , ("M4-<F10>"      , sendMessage $ ToggleStrut U)
    -- , ("M4-S-1"        , viewWS (1 :: ScreenId) (1 :: WorkspaceId))
    -- , ("M4-S-1"        , OS.viewOnScreen (1 :: ScreenId) (1 :: WorkspaceId))
    -- , ("M4-`"          , gotoMenuArgs ["-b", "-l", "10", "-fn", "'10x20'", "-nb", "'#0C1320'", "-nf", "'#505764'", "-sb", "'#131A27'", "-sf", "'cyan'", "-p", "'Go To'"])
    -- , ("M4-S-`"        , bringMenuArgs ["-b", "-l", "10", "-fn", "'10x20'", "-nb", "'#0C1320'", "-nf", "'#505764'", "-sb", "'#131A27'", "-sf", "'cyan'", "-p", "Summon"])
    , ("M4-'"          , goToSelected defaultGSConfig {gs_navigate = myNavigation})
    , ("M4-S-'"        , bringSelected defaultGSConfig {gs_navigate = myNavigation})
    , ("M4-o"          , windowMenu)
    , ("<F1>"          , runOrRaise "emacs" (className =? "Emacs" <||> className =? "Emacs24")) -- FIX
    , ("<F2>"          , runOrRaise "conkeror" (className =? "Conkeror"))
    , ("<F3>"          , runOrRaise "gnome-terminal" (className =? "Gnome-terminal"))
    , ("<F12>"          , runOrRaise "firefox" (className =? "Firefox"))
    -- , ("<F10>"         , runOrRaise "pidgin" (className =? "Pidgin"))
    , ("<F11>"         , runOrRaise "skype" (className =? "Skype"))
    -- , ("<F12>"         , runOrRaise "google-chrome" (className =? "Google-chrome"))
    ]

-- Grid navigation
myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
  where navKeyMap = M.fromList [
           ((0,xK_Escape)      , cancel)
          ,((controlMask,xK_g) , cancel)
          ,((0,xK_Return)      , select)
          ,((0,xK_space)       , select)
          ,((0,xK_slash)       , substringSearch myNavigation)
          ,((0,xK_s)           , substringSearch myNavigation)
          ,((0,xK_Left)        , move (-1, 0)  >> myNavigation)
          ,((0,xK_h)           , move (-1, 0)  >> myNavigation)
          ,((0,xK_Right)       , move ( 1, 0)  >> myNavigation)
          ,((0,xK_n)           , move ( 1, 0)  >> myNavigation)
          ,((0,xK_Down)        , move ( 0, 1)  >> myNavigation)
          ,((0,xK_t)           , move ( 0, 1)  >> myNavigation)
          ,((0,xK_Up)          , move ( 0,-1)  >> myNavigation)
          ,((0,xK_c)           , move ( 0,-1)  >> myNavigation)
          ,((0,xK_g)           , move (-1,-1)  >> myNavigation)
          ,((0,xK_r)           , move ( 1,-1)  >> myNavigation)
          ,((0,xK_m)           , move (-1, 1)  >> myNavigation)
          ,((0,xK_v)           , move ( 1, 1)  >> myNavigation)
          -- ,((0,xK_space) , setPos (0,0)  >> myNavigation)
          ]
        -- The navigation handler ignores unknown key symbols
        navDefaultHandler = const myNavigation

addPrefix p ms conf =
  M.singleton p . submap $ M.mapKeys (first chopMod) (ms conf)
  where
  mod = modMask conf
  chopMod = (.&. complement mod)

myWorkspaces = ["1:emacs", "2:conkeror", "3:terminal", "4:skype", "5:firefox", "6:chrome", "7", "8", "9"]

myManage = composeAll [
    className =? "Emacs" --> doShiftAndGo "1:emacs"
  , className =? "Emacs24" --> doShiftAndGo "1:emacs"
  , className =? "Conkeror" --> doShiftAndGo "2:conkeror"
  , className =? "Gnome-terminal" --> doShiftAndGo "3:terminal"
  , className =? "Skype" --> doShift "4:skype"
  , className =? "Firefox" --> doShiftAndGo "5:firefox"
  , className =? "Google-chrome" --> doShiftAndGo "6:chrome"
  , className =? "Nautilus" --> doShift "7"
  , className =? "Thunar" --> doShift "7"
  , className =? "Qbittorrent" --> doShift "7"
  , className =? "Vlc" --> doShiftAndGo "8"
  , className =? "Update-manager" --> doShift "9"
  , className =? "Gnome-language-selector" --> doShift "9"
  , className =? "Xfce4-panel" --> doFloat
  , className =? "Gpick" --> doFloat
  , className =? "Orage" --> doFloat
  , className =? "Globaltime" --> doFloat
  , className =? "Do" --> doIgnore
  , (className =? "Nautilus" <&&> appName =? "file_properties") --> doFloat
  ]
  where doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift

myDesktop layout = avoidStrutsOn [U] (layout)

myLayout = myDesktop myWorkspaceLayout
  where
    myWorkspaceLayout = onWorkspace "4:skype" skype $
                        onWorkspaces ["1:emacs", "2:conkeror", "3:terminal"] main $
                        onWorkspaces ["5:firefox", "6:chrome"] devBrowser $
                        all
    main = Full ||| tiledTab
    devBrowser = tiledTabRot ||| tiledTab ||| Full
    all = tiledTab ||| skype ||| Full ||| tiledTabRot
           -- ||| simpleTabbed
           -- ||| (reflectHoriz $ tiled)
           -- ||| (tiled)
           -- ||| withIM (7%30) (Or (Role "buddy_list") (Role "MainWindow")) simpleTabbed
    skype = (multimastered 1 delta (8/10) $ simpleTabbed)
    tiledTabRot = Mirror tiledTab
    tiledTab = (reflectHoriz $ (multimastered nmaster delta ratio $ simpleTabbed))
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 7/10 - 1/30
    delta = 1/30

myLog = fadeInactiveLogHook fadeAmount
  where fadeAmount = 1

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ -- ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    --  Reset the layouts on the current workspace to default
      -- ((modm .|. shiftMask, xK_F9 ), setLayout $ XMonad.layoutHook conf)
      ((shiftMask .|. modm, xK_F9 ), setLayout $ XMonad.layoutHook conf)
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
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F9, xK_F10] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
