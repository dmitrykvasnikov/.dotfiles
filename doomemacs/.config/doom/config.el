;; packages
;;(custom-set-variables
;;'(package-archives
;;   (quote
;;     (("gnu" . "https://elpa.gnu.org/packages/")
;;      ("melpa" . "https://melpa.org/packages/")))))
;;(package-initialize)

(setq user-full-name "Dmitry Kvasnikov"
      user-mail-address "dmitry.kvasnikov@gmail.com")

(setq doom-theme 'ef-owl)

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

(load-file "~/.config/doom/font.el")
(setq bookmark-default-file "~/.config/doom/bookmarks")
(setq bookmark-sort-flag t)
(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")

;; do not create new workspace on open Emacs
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main")
  )

;; setup clipboard
;; don't put deleted strings to X11 clipboard
(setq select-enable-clipboard nil)
;; copying and pasting selected blocks in visual mode to and from X11 clipboard
(map! "S-C-c" #'clipboard-kill-ring-save)
(map! "S-C-v" #'clipboard-yank)

;; cycle through buffers
(map! "C-{" #'bs-cycle-previous)
(map! "C-}" #'bs-cycle-next)

;; goto function definition (need to create TAGS file first)
(map! "C-g" #'evil-goto-definition)
(map! :nv "C-]" #'evil-goto-definition)

;; break lines on words
(global-visual-line-mode t)
(setq vc-follow-symlinks nil)
(setq auto-save-default nil)

;; window resize with hydra
(use-package! hydra
  :defer
  :config
  (defhydra hydra/evil-window-resize (:color red)
    "Resize window"
    ("h" evil-window-decrease-width "decrease width")
    ("j" evil-window-decrease-height "decrease height")
    ("k" evil-window-increase-height "increase height")
    ("l" evil-window-increase-width "increase width")
    ("q" nil "quit")))
(map! :leader
      :prefix ("w" . "window")
      :n "r" #'hydra/evil-window-resize/body);;

;; enable ligatures
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

;; settings for haskell
(use-package ormolu
 :hook (haskell-mode . ormolu-format-on-save-mode)
 :bind
 (:map haskell-mode-map
   ("C-c r" . ormolu-format-buffer)))
(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "ormolu"))
(custom-set-variables '(haskell-stylish-on-save t))
(setq lsp-lens-enable nil)
