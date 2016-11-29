(package-initialize)
(defconst +home-dir+ "~")
(defconst +emacs-dir+ (concat +home-dir+ "/emacs"))
(defconst +emacs-profiles-dir+ (concat +emacs-dir+ "/profiles"))
(defconst +emacs-lib-dir+ (concat +emacs-dir+ "/libs"))
(defconst +emacs-conf-dir+ (concat +emacs-dir+ "/config"))
(defconst +emacs-tmp-dir+ (concat +emacs-dir+ "/tmp"))
(defconst +emacs-snippets-dir+ (concat +emacs-dir+ "/snippets"))

;; new projects will be created under this directory
(defconst +dev-dir+ (concat +home-dir+ "/src"))

(defun add-load-path (p)
  (add-to-list 'load-path (concat +emacs-dir+ "/" p)))

(defun add-lib-path (p)
  (add-to-list 'load-path (concat +emacs-lib-dir+ "/" p)))

(defun load-conf-file (f)
  (load-file (concat +emacs-conf-dir+ "/" f ".el")))

(defun load-lib-file (f)
  (load-file (concat +emacs-lib-dir+ "/" f)))

(defun load-profile (p)
  (load-file (concat +emacs-profiles-dir+ "/" p ".el")))

(defun load-customizations ()
  (let ((filename (concat +emacs-dir+ "/custom.el")))
    (if (file-readable-p filename)
        (load-file filename))))

(add-load-path "")
(add-load-path "lib")

(load-profile "default")
(load-profile "js")
;;(load-profile "coffee")
;;(load-profile "golang")
;;(load-profile "clojure")

(load-customizations)

;;(add-to-list 'command-switch-alist '("clojure" . (lambda (n) (load-profile "clojure"))))
;;(add-to-list 'command-switch-alist '("ruby" . (lambda (n) (load-profile "ruby"))))
;;(add-to-list 'command-switch-alist '("android" . (lambda (n) (load-profile "android"))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(js2-strict-inconsistent-return-warning nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(tool-bar-mode -1)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))


;;(require 'nvm)
;;(nvm-use (caar (last (nvm--installed-versions))))

(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(with-eval-after-load 'web-mode
  ;; set reasoable indentation for web-mode
  (setq web-mode-markup-indent-offset 4
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 4))
;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'after-init-hook #'global-auto-complete-mode)
;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

(defun toggle-jsx-content ()
  (interactive)
  (if (equal web-mode-content-type "javascript")
      (web-mode-set-content-type "jsx")
    (web-mode-reload)))
(global-set-key (kbd "\C-T") 'toggle-jsx-content)
(add-hook 'web-mode-hook (lambda () (tern-mode t)))

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(put 'magit-clean 'disabled nil)
