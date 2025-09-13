;;; init.el --- Initialization file for Emacs -*- lexical-binding: t -*-
;; Author: Dmitry Kvasnikov

;;; Commentary:
;;Emacs Startup File --- initialization for Emacs

;;; Code:

;; UI Settings
(tool-bar-mode 0)                    ;; no tool bar
(menu-bar-mode 0)                    ;; no menu bar
;;(toggle-frame-fullscreen)            ;; start with fullscreen
(scroll-bar-mode 0)                  ;; no scrollbar
(show-paren-mode 1)                  ;; highlight matchin parenthesis
(column-number-mode 1)               ;; show column number in minibuffer
(display-line-numbers-mode 1)	     ;; display line numbers ...
(setq display-line-numbers-type 'relative)
                                     ;; ... and make it relative
(global-display-line-numbers-mode 1) ;; display line numbers
(setq inhibit-startup-message t)     ;; no splashscreen
(setq initial-scratch-message nil)   ;; no message in scratch buffer
(fset `yes-or-no-p `y-or-n-p)        ;; answer questions with y/n (instead of
				     ;; yes/no)

(set-face-attribute 'default nil
		    :font "Aporetic Sans Mono"
		    :height 120)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Auto-refresh buffers when files on disk change.
(global-auto-revert-mode t)

;; Initialize package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ensure 'use-package' is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(require 'use-package-ensure)

;; when installing package, it will be always downloaded automatically from
;; repository if is not available
(setq use-package-always-ensure t)
(setq use-package-always-defer nil)
(setq use-package-verbose t)
(setq use-package-compute-statistics t)

;; Packages installation
(use-package recentf
  :init
  (recentf-mode))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode)
  :init (vertico-mode)
  :custom
  (vertico-count 8)
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-scroll-margin 0))

(use-package orderless
  :ensure t
  :after vertico
  :custom
  (completion-category-defaults nil)
  (completion-styles '(orderless partial-completion))
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package corfu
  :ensure t
  :hook ((org-mode
          js2-mode
          css-mode
          json-mode
          html-mode
          emacs-lisp-mode
          typescript-mode) . corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-info t)
  (corfu-cycle t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.0)
  (corfu-preselect 'first)
  (corfu-preview-current 'insert)
  (corfu-completion-styles '(orderless))
  (text-mode-ispell-word-completion . nil)
  :config
  (keymap-unset corfu-map "RET")
  :bind
  (:map corfu-map
        ("TAB" . corfu-insert)
        ([tab] . corfu-insert)
        ("ESC" . corfu-quit)
        ([esc] . corfu-quit)))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package which-key
  :init
  (which-key-mode))

;; Windows navigation
(windmove-default-keybindings)

;; Icons
(use-package all-the-icons)
(use-package all-the-icons-dired)
;;(use-package treemacs-all-the-icons)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;;Keyboard mappings
(global-set-key (kbd "C-x C-r") 'recentf-open)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)
(global-set-key (kbd "C-M-s") 'window-toggle-side-windows)

;; Auto-save on change
(defun save-buffer-if-visiting-file (&optional args)
   "Save the current buffer only if it is visiting a file"
   (interactive)
   (if (and (buffer-file-name) (buffer-modified-p))
       (save-buffer args)))
(add-hook 'auto-save-hook 'save-buffer-if-visiting-file)
(setq auto-save-interval 1)

;; Install and configure themes
(use-package dracula-theme)
(use-package ef-themes)
(load-theme 'dracula t)

;; Switch between Emacs windows
(use-package ace-window
  :config
  (global-set-key (kbd "M-o") 'ace-window))

;; Delete selection
(delete-selection-mode t)

;; Files navigation
(setq vc-follow-symlinks t)		;; Follow symlinks without confirmation

;; Switch to treemacs
(defvar previous-window nil
  "Variable to store the previous window.")

(defun switch-to-treemacs ()
  "Switch to the Treemacs window."
  (interactive)
  (if (eq (selected-window) (treemacs-get-local-window))
      (when previous-window
        (select-window previous-window)
        (setq previous-window nil))
    (progn
      (setq previous-window (selected-window))
      (let ((treemacs-win (treemacs-get-local-window)))
        (when treemacs-win
          (select-window treemacs-win))))))

(global-set-key (kbd "M-t") 'switch-to-treemacs)

;; Bind the function to the key sequence "<S-f1>"
(global-set-key (kbd "<S-f1>")
                (lambda ()
                  (interactive)
                  ;; Save all buffers and kill Emacs
                  (save-buffers-kill-emacs 1)))

(eval-after-load "frame"
  '(progn
     ;; This code is evaluated after the "frame" library is loaded
     ;; It ensures that the key binding is set only after the "frame" library is available
     
     ;; Bind Shift + F12 to toggle maximization
     (global-set-key (kbd "<S-f12>") 'toggle-frame-maximized)
     ;; This line sets the key binding for Shift + F12
     ;; which toggles the maximization state of the frame
     ))

(setq default-frame-alist '((undecorated . t)))
;; Set the default frame parameters to make it undecorated (without window decorations)

(add-to-list 'default-frame-alist '(drag-internal-border . 1))
;; Add 'drag-internal-border' parameter to the default frame alist
;; This parameter sets the width (in pixels) of the internal border to 1
;; The internal border is the space between the frame content and the window edges

(add-to-list 'default-frame-alist '(internal-border-width . 5))
;; Add 'internal-border-width' parameter to the default frame alist
;; This parameter sets the width (in pixels) of the internal border to 5
;; The internal border is the space between the frame content and the window edges

;; Disable async compilation warnings
(setq comp-async-warnings nil)

;; Haskell Mode configuration
(use-package haskell-mode
  :bind (("C-M-x" . haskell-interactive-bring) ;; Bind Haskell REPL to C-M-x
         ("C-f" . ormolu-format-buffer)) ;; Bind formatting to C-f
  :config
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile)
  )

;; Install and configure ormolu
(use-package ormolu)

;; Hook to bind formatting to C-f in haskell-mode
(add-hook 'haskell-mode-hook
          (lambda ()
            (local-set-key (kbd "C-f") 'ormolu-format-buffer)
            )
          )


(use-package lsp-mode
  :hook ((css-mode
	  js2-mode
	  html-mode
	  json-mode
	  java-mode
	  typescript-mode
	  haskell-mode) . lsp-deferred)
  :commands lsp lsp-deferred
  :config
  (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
  (setq lsp-haskell-process-args-hie '("-d" "-l" "/tmp/hls.log"))
  (setq lsp-enable-snippet nil) ;; Disable snippet support
  (setq lsp-auto-configure t)
  :custom
  (lsp-log-io nil)
  (lsp-keep-workspace-alive nil)
  (lsp-semantic-tokens-enable nil)
  (lsp-session-file "~/.emacs.d/.lsp-session-v1")
  
  (lsp-enable-xref t)
  (lsp-enable-links t)
  (lsp-enable-imenu nil)
  (lsp-enable-indentation nil)
  (lsp-eldoc-enable-hover nil)
  (lsp-enable-file-watchers nil)
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-text-document-color nil)
  (lsp-enable-suggest-server-download t)

  (lsp-ui-doc-enable nil)
  (lsp-ui-sideline-delay 0)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-update-mode 'line)
  (lsp-ui-sideline-diagnostic-max-lines 20)
  
  (lsp-signature-auto-activate nil)
  (lsp-signature-render-documentation nil)

  (lsp-modeline-diagnostics-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-modeline-workspace-status-enable nil)
  
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-headerline-breadcrumb-icons-enable nil)
  (lsp-headerline-breadcrumb-enable-diagnostics nil)
  (lsp-headerline-breadcrumb-enable-symbol-numbers nil)
  
  (lsp-completion-show-kind t)
  (lsp-completion-provider :none)
  (lsp-diagnostics-provider :flycheck))

;; Install and configure lsp-haskell
(use-package lsp-haskell
  :config
  (setq lsp-haskell-server-path "haskell-language-server-wrapper")
  )

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-peek-enable t)
  (define-key lsp-ui-mode-map (kbd "M-.") #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map (kbd "M-?") #'lsp-ui-peek-find-references))


(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :custom
  (flycheck-help-echo-function nil)
  (flycheck-display-errors-delay 0.0)
  (flycheck-auto-display-errors-after-checking t))

;; Install and configure company-mode
(use-package company
  :hook (prog-mode . company-mode)
  :config
  (define-key company-active-map (kbd "<escape>") #'hide-company-tooltip)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  )

;; Function to hide company tooltip
(defun hide-company-tooltip ()
  (interactive)
  (when (company-tooltip-visible-p)
    (company-cancel))
  )

;; Function to disable beep sound
(defun disable-beep-sound ()
  (setq ring-bell-function 'ignore)
  )

;; Disable beep sound
(add-hook 'after-init-hook 'disable-beep-sound)

;; Disable pop-up errors in Haskell mode
(setq haskell-interactive-popup-errors nil)

(use-package treemacs
  :after all-the-icons
  :config
  (require 'all-the-icons)
  (treemacs-load-theme "all-the-icons")

  ;; Customize the sizes for Treemacs faces
  (custom-set-faces
   '(treemacs-directory-face ((t (:height 0.80))))
   '(treemacs-file-face ((t (:height 0.80))))
   '(treemacs-root-face ((t (:height 0.80)))))
  (treemacs-resize-icons 14)
  )

(use-package treemacs-evil
   :after treemacs evil)
;; Use the 'use-package' macro to configure the 'treemacs-evil' package
;; The ':ensure t' ensures that the package is installed if not already present
;; The ':after treemacs evil' specifies that the package should be loaded after 'treemacs' and 'evil'

(use-package treemacs-projectile
  :after treemacs projectile)
;; Use the 'use-package' macro to configure the 'treemacs-projectile' package
;; The ':ensure t' ensures that the package is installed if not already present
;; The ':after treemacs projectile' specifies that the package should be loaded after 'treemacs' and 'projectile'

;; Display Treemacs as a side window on startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (delete-other-windows)
            (treemacs)
            (treemacs-follow-mode t)))

(use-package magit
  :defer t)
;; Set C-M-s keybinding to toggle side window
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(treemacs-directory-face ((t (:height 0.8))))
 '(treemacs-file-face ((t (:height 0.8))))
 '(treemacs-root-face ((t (:height 0.8)))))

;;; init.el ends here
