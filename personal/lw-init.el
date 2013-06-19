;;; package --- lw-init.el
;;; Commentary:

;;; Code:
;;; prelude overwrote
(disable-theme 'zenburn)
(setq prelude-flyspell nil)
(setq prelude-guru nil)
(setq prelude-clean-whitespace-on-save nil)

(prelude-ensure-module-deps '(smart-mode-line 
                              color-theme-sanityinc-tomorrow 
                              multiple-cursors 
                              edit-server
                              web-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . web-mode))
(setq web-mode-engines-alist
      '(("django"    . "\\.html\\'")
        ("django"    . "\\.inc\\'"))
)
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-indent-style 4)
  )
(add-hook 'web-mode-hook  'web-mode-hook)


;; kill current buffer
(defun yic-kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "M-`") 'yic-kill-current-buffer)


;;; comment or uncomment region or line
(defun comment-or-uncomment-region-or-line ()
  "Like comment-or-uncomment-region, but if there's no mark \(that means no
region\) apply comment-or-uncomment to the current line"
  (interactive)
  (if (not mark-active)
      (comment-or-uncomment-region
	(line-beginning-position) (line-end-position))
      (if (< (point) (mark))
	  (comment-or-uncomment-region (point) (mark))
	(comment-or-uncomment-region (mark) (point)))))
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)


;; highlight ipdb line in python-mode
(defun annotate-pdb ()
  (interactive)
  (highlight-lines-matching-regexp "import ipdb")
  (highlight-lines-matching-regexp "ipdb.set_trace()"))
(add-hook 'python-mode-hook 'annotate-pdb)


;;; po mode for editing po files.
(require 'po-mode)
(add-to-list 'auto-mode-alist '("\\.po$" . po-mode))


;;; enable linum-mode global
(global-linum-mode 1)
(scroll-bar-mode 0)

(global-hl-line-mode 0)
(set-face-background hl-line-face "gray10")
(set-face-foreground hl-line-face "white")

(setq ido-enable-flex-matching t)
(setq ido-auto-merge-work-directories-length -1)


;; bookmark location
(setq bookmark-default-file "~/Dropbox/software_configs/bookmarks" bookmark-save-flag 1)


;;; keybindings
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-<backspace>") 'backward-kill-word)
(global-set-key (kbd "M-<backspace>") 'backward-kill-sexp)
(global-set-key (kbd "C-c q") 'join-line)
(global-set-key (kbd "C-x 2") 'split-window-horizontally)
(global-set-key (kbd "C-x 3") 'split-window-vertically)
(global-set-key (kbd "C-x C-x") 'ido-switch-buffer)
(global-set-key (kbd "C-\\") nil)
(global-set-key (kbd "C-<return>") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-M-m") 'mc/mark-more-like-this-extended)
;; (mc/execute-command-for-all-fake-cursors mc/mark-more-like-this-extended)
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map (kbd "<returen>") 'prelude-smart-open-line)))

;;; lambda shows in one char
(require 'lambda-mode)
(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))
(add-hook 'python-mode-hook 'lambda-mode 1)
(add-hook 'emacs-lisp-mode-hook 'lambda-mode 1)


(require 'smart-mode-line)
(add-hook 'after-init-hook 'sml/setup)


(provide 'lw-init)
;;; lw-init.el ends here
