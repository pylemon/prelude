;;; package --- lw-init.el
;;; Commentary:

;;; Code:
;;; prelude overwrote
(disable-theme 'zenburn)
(setq prelude-guru nil)
(setq prelude-whitespace nil)
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
(add-hook 'web-mode-hook 'web-mode-hook)

(defun yas-web-mode-fix ()
  (if (string= major-mode "web-mode")
      (progn
        (web-mode-buffer-refresh)
        (indent-for-tab-command))))
(setq yas/after-exit-snippet-hook 'yas-web-mode-fix)


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

;;; disable prelude-global-mode
(define-globalized-minor-mode prelude-global-mode prelude-mode prelude-off)
(setq prelude-flyspell nil)

;;; whitespace mode will override syntax highlighting
;; (global-whitespace-mode 1)
(setq whitespace-line-column 110)

(global-hl-line-mode 0)
(global-flycheck-mode 0)

(require 'auto-complete)
(global-auto-complete-mode t)

(smartparens-global-mode 0)
(yas-global-mode 1)
(scroll-bar-mode 0)
(set-face-background hl-line-face "gray10")
(set-face-foreground hl-line-face "white")

(setq ido-enable-flex-matching t)
(setq ido-auto-merge-work-directories-length -1)

;;; sort ido filelist by mtime instead of alphabetically
(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
(defun ido-sort-mtime ()
  (setq ido-temp-list
        (sort ido-temp-list
              (lambda (a b)
                (time-less-p
                 (sixth (file-attributes (concat ido-current-directory b)))
                 (sixth (file-attributes (concat ido-current-directory a)))))))
  (ido-to-end  ;; move . files to end (again)
   (delq nil (mapcar
              (lambda (x) (and (char-equal (string-to-char x) ?.) x))
              ido-temp-list))))


;;; make google-chrome the default browser for emacs
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

;;; jedi for python mode
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; bookmark location
(setq bookmark-default-file "~/Dropbox/software_configs/bookmarks" bookmark-save-flag 1)

;;; key bindings
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-<backspace>") 'backward-kill-word)
(global-set-key (kbd "M-<backspace>") 'backward-kill-sexp)
(global-set-key (kbd "C-<left>") 'left-word)
(global-set-key (kbd "C-<right>") 'right-word)
(global-set-key (kbd "C-c q") 'join-line)
(global-set-key (kbd "C-x j") 'helm-imenu)
(global-set-key (kbd "C-x 2") 'split-window-horizontally)
(global-set-key (kbd "C-x 3") 'split-window-vertically)
(global-set-key (kbd "C-x C-x") 'helm-buffers-list)

(global-set-key (kbd "C-\\") nil)
;;; disable move window key bindings
(global-set-key (kbd "S-<down>") nil)
(global-set-key (kbd "S-<up>") nil)
(global-set-key (kbd "C-<return>") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-M-m") 'mc/mark-more-like-this-extended)
(add-hook 'python-mode-hook
          (lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

(autoload 'pylint "pylint")
(add-hook 'python-mode-hook 'pylint-add-menu-items)
(add-hook 'python-mode-hook 'pylint-add-key-bindings)

(key-chord-define-global "wq" 'whitespace-cleanup)

;;; lambda shows in one char
(require 'lambda-mode)
(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))
(add-hook 'python-mode-hook 'lambda-mode 1)
(add-hook 'emacs-lisp-mode-hook 'lambda-mode 1)


(require 'smart-mode-line)
(add-hook 'after-init-hook 'sml/setup)


(provide 'lw-init)
;;; lw-init.el ends here
