;;; init-file-creator.el --- Create a config with popular packages or common configurations.  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Free Software Foundation, Inc.

;; Author: Elijah Gabe Pérez <eg642616@gmail.com>

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package allows you create an Emacs configuration quickly on an
;; Easy Customization interface.
;;
;; The configuration created is simple to allow it to be easily
;; configurable and easy to learn.
;;
;; This allows install and configure popular packages from
;; GNU and NonGNU ELPA, configure and enable or disable built-in
;; features.

;;; Code:
(require 'cus-edit)
(require 'init-file-creator-ui)

(defvar init-creator--buffer-name "*Init file Creator*")

(defvar init-creator--description
  "\n\nWelcome to the Emacs init file creator.

This tool facilitates the creation of a basic Emacs configuration (init file).
The init file contains instructions Emacs executes upon startup,
customizing the environment to user specifications.  See Info node
‘(emacs) Init File’ for more information.

Emacs utilizes Emacs Lisp for configuration.  This tool offers an
interface to simplify the initial setup process.  It is intended as
a starting point for customization.
\n\nGetting Started:

Follow the on-screen instructions to make your selections.

Once you've completed your selections, an init file will be generated
containing the settings you've chosen.  The file will incorporate
`use-package` for managing installed packages, which is a common and
recommended approach in Emacs configuration.  This structure is designed
to facilitate learning Emacs Lisp and further customization of your
configuration.\n\n\n")

(defvar init-creator--basic-buffer-info
  (concat
   (propertize "Init Configuration Creator" 'face 'info-title-1)
   (propertize init-creator--description 'face 'variable-pitch))
  "String to insert top init creator buffer.")

(defvar-keymap init-file-creator-map
  :doc "Keymap used in the \"*Init file Creator*\" buffer."
  :full t
  :parent widget-keymap
  "SPC"     #'scroll-up-command
  "S-SPC"   #'scroll-down-command
  "DEL"     #'scroll-down-command
  ;; "C-x C-s" #'
  "q"       #'Custom-buffer-done
  "n"       #'widget-forward
  "p"       #'widget-backward)

;; TODO: set tool bar buttons.
(define-derived-mode init-file-creator-mode nil "Init file creator"
  "Major mode for create Emacs init file."
  (kill-all-local-variables)
  (buffer-disable-undo)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (custom--initialize-widget-variables)
  (use-local-map init-file-creator-map))

(defmacro init-creator--with-buffer (&rest body)
  "Execute BODY in *Init file Creator* buffer."
  `(progn
     (switch-to-buffer init-creator--buffer-name)
     (init-file-creator-mode)
     (save-excursion
       ,@body)
     (widget-setup)))

(defun create-init-file ()
  "Create an init configuration file."
  (interactive)
  (init-creator--with-buffer
   (widget-insert init-creator--basic-buffer-info)
   (widget-create 'editable-field
                  :format "Where to create init file: %v "
                  :size 50
                  (expand-file-name "~/.config/emacs/init.el"))
   (widget-insert ?\n)
   (widget-create 'push-button :tag "Create init file"
                  :help-echo "Push me for create the init file."
                  :action 'init-creator--create-init-file)
   (widget-insert ?\n)
   (custom-group--draw-horizontal-line)
   (dolist (fn init-creator--config-widgets) (funcall fn))))

(provide 'init-file-creator)
;;; init-file-creator.el ends here
