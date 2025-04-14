;;; init-file-creator-packages.el --- Packages to prompt it init file creator  -*- lexical-binding: t; -*-

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

;; This file contains the packages to prompt in `create-init-file'.
;;
;; The packages stored here must be available from GNU and NonGNU ELPA
;; or be built-in.

;;; Code:
(require 'cus-edit)

;;;; Variables
(defvar init-creator--config-widgets
  '(init-creator--insert-built-in-conf-widgets)
  "List of functions which contains topic configurations to insert.")

;;;; Functions
(defmacro init-creator--indent-header (column &rest body)
  ""
  `(let ((start (point)))
     ,@body
     (indent-region start (point) ,column)))

;;;; Packages
;;; Internal configurations.
(defun init-creator--insert-built-in-conf-widgets ()
  (widget-insert (propertize "Basic configurations:" 'face 'custom-group-tag))
  (widget-insert ?\n)
  (init-creator--indent-header
   2
   ;; GUI
   (widget-insert
    (propertize "Which GUI features want to enable?\n" 'face 'custom-variable-tag))
   (widget-create 'checkbox
                  :value t
                  :action (lambda (&rest a) (print a))) ; TEMP:
   (widget-insert " Tool bar")
   (widget-insert ?\n)
   (widget-create 'checkbox
                  :value t
                  :action (lambda (&rest a) (print a))) ; TEMP:
   (widget-insert " Menu bar")
   (widget-insert ?\n)
   (widget-create 'checkbox
                  :value t
                  :action (lambda (&rest a) (print a))) ; TEMP:
   (widget-insert " Scroll bar\n")
   (widget-insert ?\n)
   ;; Cursor
   (widget-insert
    (propertize "Cursor type to use\n" 'face 'custom-variable-tag))
   ;; TODO: ...
   (widget-insert ?\n)
   ;; Theme
   (widget-insert
    (propertize "Theme to use\n" 'face 'custom-variable-tag))
   (widget-insert ?\n)
   ;; TODO: ...
   (widget-insert
    (propertize "Bind your keys\n" 'face 'custom-variable-tag))
   (widget-insert ?\n)
   ;; TODO: ...
   ))


(provide 'init-file-creator-packages)
;;; init-file-creator-packages.el ends here
