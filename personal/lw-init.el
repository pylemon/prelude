;;; package --- lw-init.el
;;; Commentary:

;;; Code:
;;; prelude overwrote
(disable-theme 'zenburn)
(setq prelude-flyspell nil)
(setq prelude-guru nil)
(setq prelude-clean-whitespace-on-save nil)

(prelude-ensure-module-deps '(smart-mode-line color-theme-sanityinc-tomorrow))

(require 'smart-mode-line)
(add-hook 'after-init-hook 'sml/setup)

(provide 'lw-init)
;;; lw-init.el ends here
