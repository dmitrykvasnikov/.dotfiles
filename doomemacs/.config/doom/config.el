(setq user-full-name "Dmitry Kvasnikov"
      user-mail-address "dmitry.kvasnikov@gmail.com")

;; themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (setq doom-theme 'ef-dream)
;; (setq doom-theme 'zerodark)
;; (setq doom-theme 'ef-autumn)
;; (setq doom-theme 'oceanic)
(setq doom-theme 'gruber-darker)
(setq-default initial-scratch-message ";; He who walks alone  ... Always walks uphill but ... Beneath his feet are the ... Broken bones of flawed men ...\n\n")
;; lsp
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(setq lsp-enable-symbol-highlighting nil)
(setq lsp-lens-enable nil)

;; Paddigns with spacious-padding plugin
;; (require 'spacious-padding)
(setq spacious-padding-mode 1)
;; These are the default values, but I keep them here for visibility.
(setq spacious-padding-widths
      '( :internal-border-width 6
         :header-line-width 4
         :mode-line-width 4
         :tab-width 4
         :right-divider-width 20
         :scroll-bar-width 6
         :fringe-width 5))

;; Read the doc string of `spacious-padding-subtle-mode-line' as it
;; is very flexible and provides several examples.
(setq spacious-padding-subtle-mode-line
      `( :mode-line-active 'default
         :mode-line-inactive vertical-border))

(spacious-padding-mode 1)

;; font, size depends on machine hostname
;; (custom-set-faces '(default ((t (:family "Iosevka Comfy" :height 110)))))
(cond ((string-equal (system-name) "imac") (custom-set-faces '(default ((t (:family "Iosevka Comfy" :height 105))))))
      ((string-equal (system-name) "asus") (custom-set-faces '(default ((t (:family "Iosevka Comfy" :height 113))))))
      ((string-equal (system-name) "air2012") (custom-set-faces '(default ((t (:family "Iosevka Comfy" :height 120))))))
      ((string-equal (system-name) "air2019") (custom-set-faces '(default ((t (:family "Iosevka Comfy" :height 115))))))
      (t (custom-set-faces '(default ((t (:family "Iosevka Comfy" :height 110))))))
      )

(setq bookmark-default-file "~/.config/doom/bookmarks")
(setq bookmark-sort-flag t)
(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")

;; do not create new workspace on open Emacs
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main")
  )

;; SPC-z to add multiple cursors
(map! :leader
      :desc "Toggle multi-cursor here"
      "z" #'+multiple-cursors/evil-mc-toggle-cursor-here ())

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
      :n "r" #'hydra/evil-window-resize/body)

;; setup Fira Code ligatures
;; (use-package fira-code-mode
;;   :hook prog-mode) ;; Enables fira-code-mode automatically for programming major modes;;
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

;; org-mode - set margin and max line width
(add-hook! 'org-mode-hook 'turn-on-auto-fill
  ;;(setq left-margin-width 2)
  (setq fill-column 125))

;; settings for haskell
;; preventing minibuffer height jumps when HLS thow errors
(setq max-mini-window-height 1)
;; show diagnositcs in popups
(setq lsp-ui-sideline-enable nil)

;; comment / uncomment with Meta-;
(global-set-key (kbd "s-;") 'comment-line)

(use-package ormolu
 :hook (haskell-mode . ormolu-format-on-save-mode)
 :bind
 (:map haskell-mode-map
   ("C-c r" . ormolu-format-buffer)))
(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "ormolu"))
(custom-set-variables '(haskell-stylish-on-save t))

(custom-set-faces!
  '(flycheck-error :underline (:color "red2" :style wave)))


;; SPC-1 - switch max height of minibuffer
(defun
     minbufferheight ()
     (interactive)
     (if (equal 1 max-mini-window-height)
         (setq max-mini-window-height nil)
         (setq max-mini-window-height 1)
      )
)

(map! :leader
      "1" #'minbufferheight)
