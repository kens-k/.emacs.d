(package-initialize)
(require 'server)
(unless (server-running-p)
  (server-start))

;; caskの読み込み
(if (eq system-type 'gnu/linux) (require 'cask "~/.cask/cask.el"))  ; Linuxの場合
(if (eq system-type 'darwin) (require 'cask)) ; macの場合
(cask-initialize)

;;auto revert-buffer
(global-auto-revert-mode 1)

(require 'init-loader)
(init-loader-load)
;;バックアップファイル作成しない
(setq make-backup-files t)
(setq auto-save-default nil)

;; Ctrl-x p で逆向きへのウィンドウ移動
(global-set-key "\C-xp" (lambda () (interactive) (other-window -1)))

;; マジックコメント入れない
(setq ruby-insert-encording-magin-comment nil)
;;company
(require 'company)
(global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap^around t)
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)
;;company色設定
(set-face-attribute 'company-tooltip-common-selection nil
		    :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :background "steelblue")
(set-face-attribute 'company-tooltip nil
                    :background "gray40")
(set-face-attribute 'company-tooltip-common nil
                    :background "steelblue")
;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

;;neotree
(global-set-key "\C-q" 'neotree-toggle)
;; neotree ウィンドウを表示する毎に current file のあるディレクトリを表示する
(setq neo-smart-open t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ctags-update-command "ripper-tags")
 '(ctags-update-other-options
   (list "--exclude=log" "--exclude=node_modules" "--exclude=tmp" "--exclude=stories" "--exclude=*.coffee" "--exclude='.git'" "--exclude='.github'" "--exclude='.storybook'" "--exclude='.temp'" "--exclude='front'" "--exclude='app/assets'" "--exclude='.svn'" "--exclude='SCCS'" "--exclude='RCS'" "--exclude='CVS'" "--exclude='EIFGEN'" "--exclude='.#*'" "--exclude='*~'"))
 '(package-selected-packages
   '(mozc auto-complete-exuberant-ctags anything-exuberant-ctags yasnippet-snippets yaml-mode web-mode use-package smex smartparens rubocop robe rjsx-mode rbenv prodigy popwin plantuml-mode path-headerline-mode pallet package-utils nyan-mode neotree multiple-cursors markdown-mode magit madhat2r-theme init-loader idle-highlight-mode htmlize helm-projectile helm-git-grep helm-etags-plus helm-ag go-rename go-eldoc git-gutter flycheck-cask flow-minor-mode expand-region exec-path-from-shell drag-stuff ctags-update csv-mode company-go company-flow coffee-mode auto-highlight-symbol)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
