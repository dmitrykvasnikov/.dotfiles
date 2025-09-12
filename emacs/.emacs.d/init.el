;;; init.el --- Initialization file for Emacs -*- lexical-binding: t -*-
;; Author: Dmitry Kvasnikov
;; Co-author: DeepSeek arvan

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
(custom-set-faces
 '(default ((t (:inherit nil :extend nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight medium :height 120 :width normal :family "VictorMono Nerd Font")))))

;; Auto-refresh buffers when files on disk change.
(global-auto-revert-mode t)

;; Macros
(defmacro append-to-list (target suffix)
  "Append SUFFIX to TARGET in place."
  `(setq ,target (append ,target ,suffix)))

;; Package initialization
(require 'package)
(setq package-check-signature nil)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/"))
      package-archive-priorities '(("melpa" . 1)))
(package-initialize)
;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;(when (not package-archive-contents)
;;  (package-refresh-contents)
;;  (package-install 'use-package))

(require 'use-package)
(require 'use-package-ensure)

;; when installing package, it will be always downloaded automatically from
;; repository if is not available
(setq use-package-always-ensure t)
(setq use-package-always-defer nil)
(setq use-package-verbose t)
(setq use-package-compute-statistics t)

;; Packages
(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package which-key
  :init
  (which-key-mode))

(use-package recentf
  :init
  (recentf-mode))

;;Keyboard mappings
(global-set-key (kbd "C-x C-r") 'recentf-open)
(global-set-key (kbd "M-o") 'other-window)

;; Delete selection
(delete-selection-mode t)

;; Files navigation
(setq vc-follow-symlinks t)		;; Follow symlinks without confirmation

;; Themes
(append-to-list load-path '("~/.emacs.d/themes"))
;; (load-theme 'ef-duo-light t)
(use-package acme-theme
  :config
  (load-theme 'acme t))

;; Keep custom settings in separate file and load them if this file exists
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Windows management
;;(setq winner-mode `t)

(windmove-default-keybindings)

;; Search setting
(setq isearch-allow-motion t)

;; Enable package manager

;; Basic Haskell mode setup
(use-package haskell-mode
  :ensure t
  :mode ("\\.hs\\'" "\\.lhs\\'" "\\.cabal\\'")
  :bind (:map haskell-mode-map
         ("C-c C-f" . apheleia-format-buffer)
         ("C-c C-o" . haskell-format-and-organize-imports)
         ("C-c C-t" . haskell-show-signature)
         ("M-." . lsp-find-definition))
  :config
  (setq haskell-indentation-layout-offset 4
        haskell-indentation-left-offset 4
        haskell-indentation-ifte-offset 4)
  
  ;; Set up .cabal files
  (add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))
  
  ;; Custom function to format and organize imports
  (defun haskell-format-and-organize-imports ()
    "Format buffer and organize imports using HLS."
    (interactive)
    (when (lsp-workspaces)
      (apheleia-format-buffer)
      (lsp-execute-code-action "Organize imports"))))

;; Company mode for completion - using built-in company-capf
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.3
        company-minimum-prefix-length 2
        company-tooltip-limit 10
        company-tooltip-align-annotations t
        company-backends '(company-capf company-dabbrev-code company-keywords company-files))
  (global-company-mode 1))

;; Flycheck for error checking
(use-package flycheck
  :ensure t
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
        flycheck-indication-mode 'right-fringe)
  (global-flycheck-mode 1))

;; Apheleia for formatting
(use-package apheleia
  :ensure t
  :config
  (setf (alist-get 'fourmolu apheleia-formatters)
        '("fourmolu" "--stdin-input-file" filepath))
  (setf (alist-get 'haskell-mode apheleia-mode-alist)
        'fourmolu)
  
  (defun haskell-enable-apheleia ()
    "Enable apheleia formatting for Haskell buffers."
    (when (executable-find "fourmolu")
      (apheleia-mode 1)))
  
  :hook (haskell-mode . haskell-enable-apheleia))

;; lsp-mode setup for Haskell
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-enable-symbol-highlighting t
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t
        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil
        lsp-headerline-breadcrumb-enable t
        lsp-auto-configure t
        lsp-completion-enable t
        lsp-lens-enable t)
  
  :config
  ;; Add Haskell to language ID configuration
  (add-to-list 'lsp-language-id-configuration '(haskell-mode . "haskell"))
  
  ;; Proper LSP client registration for Haskell
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection 
                                    (lambda () 
                                      (list "haskell-language-server-wrapper" "--lsp")))
                    :activation-fn (lsp-activate-on "haskell")
                    :priority 1
                    :server-id 'hls
                    :multi-root t
                    :initialized-fn (lambda (workspace)
                                      (with-lsp-workspace workspace
                                        (lsp--set-configuration 
                                         (lsp-configuration-section "haskell"))))))
  
  ;; Function to show signature in minibuffer
  (defun haskell-show-signature ()
    "Show type signature of function at point in minibuffer."
    (interactive)
    (when (lsp-workspaces)
      (let ((help (lsp--text-document-signature-help)))
        (when help
          (let ((signatures (lsp:signature-help-signatures help)))
            (when signatures
              (message "%s" (lsp:signature-information-label (elt signatures 0)))))))))
  
  :hook
  (haskell-mode . lsp)
  (haskell-mode . (lambda ()
                    ;; Ensure completion works with LSP
                    (setq-local company-backends '(company-capf company-dabbrev-code)))))

;; lsp-ui for enhanced UI features
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.5
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-delay 0.1
        lsp-ui-peek-enable t
        lsp-ui-imenu-enable t)
  :hook (lsp-mode . lsp-ui-mode))

;; Optional: helpful for better help buffers
(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h F" . helpful-function)))

;; Better performance settings
(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024)
      company-idle-delay 0.3
      lsp-idle-delay 0.5
      lsp-log-io nil)

;; Enable line numbers and other visual enhancements
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'hl-line-mode)

;; Customize faces for better readability
(custom-set-faces
 '(lsp-ui-doc-background ((t (:background "#2a2a2a"))))
 '(lsp-ui-sideline-current-symbol ((t (:foreground "gold" :weight bold))))
 '(company-tooltip-annotation ((t (:foreground "light gray"))))
 '(flycheck-error ((t (:underline (:color "red" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "yellow" :style wave))))))

;; Save place in files
(save-place-mode 1)

;; Enable electric-pair for automatic bracket matching
(electric-pair-mode 1)

;; Show matching parentheses
(show-paren-mode 1)

;; Enable winner-mode for window configuration undo/redo
(winner-mode 1)

;; Custom key bindings for common tasks
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

;; Function to check if HLS is available
(defun haskell-check-hls ()
  "Check if Haskell Language Server is available."
  (interactive)
  (if (executable-find "haskell-language-server-wrapper")
      (message "Haskell Language Server is available")
    (message "Haskell Language Server NOT found. Please install it.")))

;; Initialize packages
(defun ensure-packages (packages)
  "Ensure all PACKAGES are installed."
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

(ensure-packages '(haskell-mode company flycheck lsp-mode lsp-ui apheleia which-key helpful))

;; Debug function to check LSP status
(defun haskell-debug-lsp ()
  "Debug LSP status in current buffer."
  (interactive)
  (message "LSP workspaces: %s" (lsp-workspaces))
  (message "LSP enabled: %s" (lsp--buffer-workspaces))
  (message "HLS available: %s" (executable-find "haskell-language-server-wrapper"))
  (message "Company backends: %s" company-backends))

(message "Haskell development environment configured. Use M-x haskell-check-hls to verify HLS installation.")

;;; init.el ends here
