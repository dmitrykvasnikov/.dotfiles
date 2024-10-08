(setq custom-file "~/.emacs.d/custom.el")
(package-initialize)

;; enable plugins
(which-key-mode)
(vertico-mode)

;; loading custom file
(load-file custom-file)
