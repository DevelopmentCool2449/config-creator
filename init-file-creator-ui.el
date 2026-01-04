;;; init-file-creator-ui.el --- The UI for `create-init-file'  -*- lexical-binding: t; -*-

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

;;; Code:
(require 'cus-edit)

;;;; Variables
(defvar init-creator--config-widgets
  '(init-creator--insert-options-widgets
    init-creator--insert-configurations-widgets)
  "List of functions which contains topic configurations to insert.")

(defvar init-creator-conf-options
  `((tool-bar . t)
    (menu-bar . t)
    (scroll-bars . t)
    (cursor . box)
    (splash-screen . t)
    (theme . modus-vivendi)
    (font . default)
    (keymaps . defaults)
    (config . minimal))
  "Alist to store which options were selected.")

;;;; Macros
(defmacro init-creator--indent-header (column &rest body)
  "Indent BODY to column COLUMN."
  (declare (indent defun))
  `(let ((start (point)))
     ,@body
     (indent-region start (point) ,column)))


;;;; Widgets.

(defun init-creator--insert-options-widgets ()
  "Widgets to insert for customize some built-in options."
  (widget-insert
   (propertize "Which of these features want to enable?\n\n" 'face 'custom-variable-tag)
   (propertize "GUI Elements\n" 'face 'custom-variable-tag)
   (propertize "By default Emacs has a few GUI elements enabled.
Some prefer to disable them.
Beginners should think twice before doing so, as these graphical user
interface offers easily accessible shortcuts.\n\n" 'face 'custom-comment-tag))

  ;; Tool Bar
  (widget-create 'checkbox
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'tool-bar init-creator-conf-options)
                                 (widget-value widget)))
                 (alist-get 'tool-bar init-creator-conf-options))
  (widget-insert " Tool bar\n")

  ;; Menu Bar
  (widget-create 'checkbox
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'menu-bar init-creator-conf-options)
                                 (widget-value widget)))
                 (alist-get 'menu-bar init-creator-conf-options))
  (widget-insert " Menu bar\n")

  ;; Scroll Bars
  (widget-create 'checkbox
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'scroll-bars init-creator-conf-options)
                                 (widget-value widget)))
                 (alist-get 'scroll-bars init-creator-conf-options))
  (widget-insert " Scroll bars\n\n")

  ;; Cursor
  (widget-insert
   (propertize "Cursor type to use: " 'face 'custom-variable-tag))
  (widget-create 'menu-choice
                 :tag "Value Menu"
                 :value (alist-get 'cursor init-creator-conf-options)
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'cursor init-creator-conf-options)
                                 (widget-value widget))
                           (setq-local cursor-type (alist-get 'cursor init-creator-conf-options)))
                 '(item :tag "Box" :value box)
                 '(item :tag "Hollow" :value hollow)
                 '(item :tag "Bar" :value bar)
                 '(item :tag "Horizontal bar" :value hbar))
  (widget-insert ?\n)

  ;; Splash Screen
  (widget-create 'checkbox
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'splash-screen init-creator-conf-options)
                                 (widget-value widget)))
                 (alist-get 'splash-screen init-creator-conf-options))
  (widget-insert " Splash Screen\n")
  (widget-insert
   (propertize "By default Emacs comes with a splash screen.
If you are sure you don't need it anymore, it can be disabled.\n\n"
               'face 'custom-comment-tag))

  ;; Theme
  (widget-insert
   (propertize "Theme to use\n" 'face 'custom-variable-tag))
  (widget-create 'radio-button-choice
                 :value (alist-get 'theme init-creator-conf-options)
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'theme init-creator-conf-options)
                                 (widget-value widget))
                           (load-theme
                            (alist-get 'theme init-creator-conf-options)
                            :no-confirm))
                 '(item :tag "Modus Vivendi (Dark)" :value modus-vivendi)
                 '(item :tag "Modus Operandi (Light)" :value modus-operandi)
                 '(item :tag "Ef Cyprus (Light)" :value ef-cyprus)
                 '(item :tag "Ef Owl (Dark)" :value ef-owl))
  (widget-insert ?\n)

  ;; Font
  (widget-insert
   (propertize "Font to use: " 'face 'custom-variable-tag))
  (widget-create 'menu-choice
                 :tag "Value Menu"
                 :value (alist-get 'font init-creator-conf-options)
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'font init-creator-conf-options)
                                 (widget-value widget)))
                 ;; FIXME: HOW TO STORE THE FONT NAME AND BUFFER-LOCAL LIVE UPDATE IT?
                 '(item :tag "Default font system" :value default)
                 '(push-button :tag "Custom font"
                               :action
                               (lambda (&rest _)
                                 (setf (alist-get 'font init-creator-conf-options)
                                       (if (fboundp 'x-select-font)
                                           (x-select-font)
                                         (mouse-select-font))))))
  (widget-insert ?\n)

  ;; Keymaps
  (widget-insert
   (propertize "Keymaps to use\n" 'face 'custom-variable-tag))
  (widget-create 'radio-button-choice
                 :entry-format "%b %v\n"
                 :value (alist-get 'keymaps init-creator-conf-options)
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'keymaps init-creator-conf-options)
                                 (widget-value widget)))
                 `(item :format "%h"
                        :doc ,(concat "Default Emacs keybindings\n"
                                      "The vanilla Emacs keybindings")
                        :value defaults)
                 `(item :format "%h"
                        :doc ,(concat "Vim Emulation Keybindings (Evil)\n"
                                      "Evil is an extensible vi layer for Emacs.\n"
                                      "It emulates the main features of Vim, and provides facilities\n"
                                      "for writing custom extensions.")
                        :value evil-mode)
                 `(item :format "%h" ; TODO: Use `standard-keys-mode'?
                        :doc ,(concat "Common Keybindings (CUA)\n"
                                      "This sets up the common keybindings used in\n"
                                      "many other applications (C-c (copy), C-v (paste), C-z (undo))")
                        :value cua-owl))
  (widget-insert ?\n))

(defun init-creator--insert-configurations-widgets ()
  "Widgets to insert for choose a pre-selected Emacs configuration."
  (widget-insert
   (propertize "Configurations:\n" 'face 'custom-variable-tag)
   (propertize "Select the type of configuration you want to use:\n\n" 'face 'variable-pitch))
  (widget-create 'radio-button-choice
                 :entry-format "%b %v\n"
                 :value (alist-get 'config init-creator-conf-options)
                 :notify (lambda (widget &rest _)
                           (setf (alist-get 'keymaps init-creator-conf-options)
                                 (widget-value widget)))
                 `(item :format "%h"
                        :doc ,(concat "Minimal\n"
                                      "A minimal configuration with few packages installed,\n"
                                      "but with good defaults out-the-box.")
                        :value minimal)
                 `(item :format "%h"
                        :doc ,(concat "Programming Environment\n"
                                      "A configuration ready for programming."
                                      "\nThis includes out-the-box support for LSP clients (Eglot),"
                                      "\nTree-sitter (if Emacs was built with support),"
                                      "\na polished completion UI (Corfu) and automatic syntax"
                                      "\nhighlighting for most programming modes.")
                        :value prog)
                 `(item :format "%h"
                        :doc ,(concat "Org-mode writing\n"
                                      "A configuration focused on org-mode for:"
                                      "\nkeeping notes, authoring documents,"
                                      "\ncomputational notebooks, literate programming,"
                                      "\nmaintaining to-do lists, planning projects, and more.")
                        :value org)
                 `(item :format "%h"
                        :doc ,(concat "Custom\n"
                                      "Select which configurations and packages to use.\n"
                                      "You must press the `Create init file' button"
                                      "\nfor start a prompt.")
                        :value custom)))

(provide 'init-file-creator-ui)
;;; init-file-creator-packages.el ends here
