(in-package :stumpwm)

(defun ublt/sort-windows (windows)
  "Sort windows by group and window number."
  (stable-sort (sort windows #'< :key #'window-number)
               #'< :key (lambda (w) (group-number (window-group w)))))

(defun ublt/next-in-ring (item list)
  "Return the next item after @var{item} in @var{list}.
If none found, return the first item in @var{list}."
  (or (second (member item list))
      (first list)))

(defun ublt/get-app-windows (&optional (window (current-window)))
  (let* ((class (window-class window))
         ;; (windows (group-windows (current-group)))
         (windows (mapcan (lambda (s) (screen-windows s)) *screen-list*)))
    (remove-if-not (lambda (w)
                     (string-equal (window-class w) class))
                   windows)))

(defun ublt/get-next-app-window (&optional (window (current-window)))
  (ublt/next-in-ring window (ublt/sort-windows
                             (ublt/get-app-windows window))))

(defun ublt/run-or-raise (cmd props &optional (all-groups *run-or-raise-all-groups*)
                                      (all-screens *run-or-raise-all-screens*))
  "Like `run-or-raise', with quality-of-life improvements.

- If the current window doesn't match, switch to the most-recently-used matching window.
- If the current window matches, cycle to the next matching window, like `run-or-raise'.

In other words, either switch to an app, or cycle among an app's windows."
  (let* ((current (current-window))
         (screens (if all-screens
                      *screen-list*
                      (list (current-screen))))
         (windows (if all-groups
                      (mapcan (lambda (s) (screen-windows s)) screens)
                      (group-windows (current-group))))
         (matches (remove-if-not (lambda (w)
                                   (apply 'window-matches-properties-p w props))
                                 windows))
         (match (first matches)))
    (if match
        (if (equalp match current)
            (let* ((sorted-matches (ublt/sort-windows matches)))
              (focus-all (ublt/next-in-ring match sorted-matches)))
            (focus-all match))
        (run-shell-command cmd))))

(defcommand ublt/other-app () ()
  "Switch to the 2nd most-recently-used app.
An 'app' is defined as the collection of windows with the same `:class'."
  (let* ((current (current-window))
         (class (window-class current))
         (windows (group-windows (current-group)))
         (matches (remove-if
                   (lambda (w) (string-equal (window-class w) class))
                   windows))
         (next (first matches)))
    (when next
      (focus-all next))))

(defcommand ublt/next-app-window () ()
  (when-let ((next (ublt/get-next-app-window)))
    (focus-all next)))

(defcommand firefox () ()
  (ublt/run-or-raise "firefox" '(:class "firefox")))

(defcommand konsole () ()
  (ublt/run-or-raise "konsole" '(:class "konsole")))

(defcommand kitty () ()
  (ublt/run-or-raise "kitty" '(:class "kitty")))

(defcommand slack () ()
  (ublt/run-or-raise "slack" '(:class "slack")))

(defcommand discord () ()
  (ublt/run-or-raise "discord" '(:class "discord")))

(defcommand intellij () ()
  (ublt/run-or-raise "intellij-idea-ultimate" '(:class "jetbrains-idea")))

(defcommand code () ()
  (ublt/run-or-raise "code" '(:class "Code")))

(defcommand zed () ()
  (ublt/run-or-raise "~/.local/bin/zed-editor" '(:class "dev.zed.Zed")))

;; (defcommand cursor () ()
;;   (ublt/run-or-raise "~/.local/bin/Cursor.AppImage --no-sandbox" '(:class "Cursor")))



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
 ;; "F10" "goland"
 "F10" "intellij"
 ;; "s-F10" "code"
 "s-F10" "cursor"
 ;; "F11" "slack"
 ;; "s-F11" "discord"
 ;; "s-`" "pull-hidden-other"
 ;; "s-`" "other-window"
 "s-`" "ublt/next-app-window"
 "s-M-u" "only"
 ;; XXX: Somehow keyd maps M-s-u to this even though I only mapped M-u?
 "s-Delete" "only"
 "s-M-Right" "hsplit 1/3"
 "s-TAB" "ublt/other-app")

(ublt/define-keys
 *root-map*
 "|" "hsplit 1/2"
 "s-Left" "move-window left"
 "s-Right" "move-window right"
 "s-Up" "move-window up"
 "s-Down" "move-window down"
 "s-d" "echo-date"
 "d"   "echo-date"
 "s-g" "gother"
 "g"   "gother"
 "s-x" "colon"
 "x"   "colon"

 "f"   "firefox"
 "s-f" "firefox"
 "C-f" "firefox"
 "e"   "emacs"
 "s-e" "emacs"
 "C-e" "emacs"
 "i"   "intellij"
 "s-i" "intellij"
 "C-i" "intellij"
 "c"   "code"
 "s-c" "code"
 "C-c" "code"
 "z"   "zed"
 "s-z" "zed"
 "C-z" "zed"
 "t"   "kitty"
 "s-t" "kitty"
 "C-t" "kitty")



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
