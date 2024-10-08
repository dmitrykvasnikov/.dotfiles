(setq custom-file "~/.emacs.d/custom.el")
(package-initialize)

;; loading theme
(load-theme 'modus-vivendi)
;; enable plugins
(which-key-mode)
(vertico-mode)

;; loading custom file
(load-file custom-file)
