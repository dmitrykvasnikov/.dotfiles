(setq custom-file "~/.emacs.d/custom.el")
;; Visual settings

(setq inhibit-startup-message t)

(scroll-bar-mode -1) ;; disable visible scroll-bar
(tool-bar-mode -1)   ;; disale the toolbar
(tooltip-mode -1)    ;; disable tooltips
(menu-bar-mode -1)   ;; disable menu bar
(set-fringe-mode 10)

(load-theme 'modus-vivendi)

;; editor settings
(visual-line-mode)   ;; break lines on words

;; Initialize package sourcesi
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package which-key)
(use-package vertico)

;; enable plugins
(which-key-mode)
(vertico-mode)

;; loading custom file
(load-file custom-file)
