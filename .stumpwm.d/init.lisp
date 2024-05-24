(in-package :stumpwm)

(defcommand firefox () ()
  (run-or-raise "firefox" '(:class "firefox")))

(defcommand konsole () ()
  (run-or-raise "konsole" '(:class "konsole")))

(defcommand kitty () ()
  (run-or-raise "kitty" '(:class "kitty")))



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
 "F5" "kitty"
 "F8" "kitty"
 "F9" "firefox")

(ublt/define-keys
 *root-map*
 "s-x" "colon"
 "x" "colon")



(setf *mouse-focus-policy* :click)

(set-module-dir (pathname-as-directory "/home/ubolonton/.stumpwm.d/stumpwm-contrib"))

(load-module "end-session")

;; sudo pkg install sbcl
(setq asdf:*central-registry*
      (append asdf:*central-registry* '("/usr/local/lib/common-lisp/system-registry/")))

;; (use-package sly)
(push #p"/home/ubolonton/.emacs.d/straight/build/sly/slynk/" asdf:*central-registry* )
(push #p"/home/ubolonton/.emacs.d/straight/build/sly/contrib/" asdf:*central-registry*)
(asdf:load-system :slynk)

(slynk:create-server :port 4004 :dont-close t)

;; sudo pkg install picom
(run-shell-command "picom --no-fading-openclose --fade-in-step=1 --fade-out-step=1 --inactive-opacity=0.99")
