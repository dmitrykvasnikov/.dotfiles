(setq custom-file "~/.emacs.d/custom.el")
;; Visual settings

(setq inhibit-startup-message t)

(scroll-bar-mode -1)                                               ;; disable visible scroll-bar
(tool-bar-mode -1)                                                 ;; disale the toolbar
(tooltip-mode -1)                                                  ;; disable tooltips
(menu-bar-mode -1)                                                 ;; disable menu bar
(set-fringe-mode 10)                                               ;; set side margins
(load-file "~/.emacs.d/font.el")
(load-theme 'modus-vivendi)

;; editor settings
(global-visual-line-mode t)                                        ;; break lines on words
(setq vc-follow-symlinks nil)                                      ;; don't prompt when open symlinks, only warning
(setq make-backup-files nil)                                       ;; don't backup files
(setq auto-save-default nil)                                       ;; don't autosave files
(global-display-line-numbers-mode)                                 ;; display line numbers ...
(setq display-line-numbers-type 'relative)                         ;; ... and make'em relative

;; Initialize package sources
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
(use-package ligature)

;; enable plugins
(which-key-mode)
(vertico-mode)
;; Enable the www ligature in every possible major mode

;; Enable ligatures in programming modes                                                           
(ligature-set-ligatures 't           '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))

(global-ligature-mode 't)

;; loading custom file
(load-file custom-file)
