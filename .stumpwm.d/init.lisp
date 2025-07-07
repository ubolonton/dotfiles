(in-package :stumpwm)

(defcommand firefox () ()
  (run-or-raise "firefox" '(:class "firefox")))

(defcommand konsole () ()
  (run-or-raise "konsole" '(:class "konsole")))

(defcommand kitty () ()
  (run-or-raise "kitty" '(:class "kitty")))

(defcommand discord () ()
  (run-or-raise "discord" '(:class "discord")))

(defcommand intellij () ()
  (run-or-raise "intellij-idea-ultimate" '(:class "jetbrains-idea")))



(set-prefix-key (kbd "s-space"))

(defun ublt/define-keys (key-map &rest ps)
  "Define key binding pairs for KEY-MAP."
  (let ((i 0))
    (loop while (< i (length ps))
          do (let ((src (elt ps i))
                   (dst (elt ps (1+ i))))
               (define-key key-map (kbd src) dst))
          do (setf i (+ i 2)))))

(ublt/define-keys
 *top-map*
 "F1" "emacs"
 "F2" "firefox"
 "F3" "kitty"
 "F5" "kitty"
 "F8" "kitty"
 "F9" "firefox"
 "F10" "intellij"
 "F11" "discord"
 "s-`" "pull-hidden-other"
 "s-M-u" "only"
 "s-M-Right" "hsplit 1/3"
 "s-TAB" "other-window")

(ublt/define-keys
 *root-map*
 "|" "hsplit 1/2"
 "s-Left" "move-window left"
 "s-Right" "move-window right"
 "s-Up" "move-window up"
 "s-Down" "move-window down"
 "s-d" "echo-date"
 "d" "echo-date"
 "s-g" "gother"
 "g" "gother"
 "s-x" "colon"
 "x" "colon"
 "e" "emacs"
 "s-e" "emacs"
 "t" "kitty"
 "s-t" "kitty")



(setf *mouse-focus-policy* :click)

(setf *message-window-gravity* :bottom
      *message-window-input-gravity* :bottom
      *input-window-gravity* :bottom)

(set-module-dir (pathname-as-directory (merge-pathnames ".stumpwm.d/stumpwm-contrib" (user-homedir-pathname))))

(load-module "end-session")

;; sudo pkg install sbcl
(setq asdf:*central-registry*
      (append asdf:*central-registry* '("/usr/local/lib/common-lisp/system-registry/")))

;; (use-package sly)
(push (merge-pathnames ".emacs.d/straight/build/sly/slynk/" (user-homedir-pathname)) asdf:*central-registry* )
(push (merge-pathnames ".emacs.d/straight/build/sly/contrib/" (user-homedir-pathname)) asdf:*central-registry*)
(asdf:load-system :slynk)
(slynk:create-server :port 4004 :dont-close t)

;; sudo pkg install picom
(run-shell-command "picom --no-fading-openclose --fade-in-step=1 --fade-out-step=1 --inactive-opacity=0.99")
