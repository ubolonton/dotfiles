(in-package :stumpwm)

(set-prefix-key (kbd "s-r"))


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
