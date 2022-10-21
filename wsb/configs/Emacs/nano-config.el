;;; init.el --- Startup file for nano Emacs          -*- lexical-binding: t; -*-

;; Copyright (C) 2022

;; Author:  <stig@charlottendal.net>
;; Keywords: lisp,convenience

;; Bootstrap straight package installer
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install Nano Emacs repository
(straight-use-package
 '(nano-emacs :type git :host github :repo "rougier/nano-emacs"))

;; Use use-package to instal packages
(straight-use-package 'use-package)
(customize-set-variable 'straight-use-package-by-default t)

;; Use no-littering to minimize pollution
(use-package no-littering
  :config (require 'no-littering))

;; Set fonts for Nano Emacs before it is loaded.
(setq nano-font-family-monospaced "Cascadia Mono")
(setq nano-font-family-proportional "Comic Sans MS")
(setq nano-font-size 14)

;; Load required modules.
(require 'nano-base-colors)
(require 'nano-faces)
(require 'nano-theme)
(require 'nano-theme-dark)
(nano-faces)
(nano-theme)
