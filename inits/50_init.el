(show-paren-mode t)
(setq show-paren-delay 0) ;表示までの秒数。初期値は0.125
(setq show-paren-style 'expression)    ;括弧内も強調
(global-auto-revert-mode 1) ; ファイルが更新されたらreloadする

;; gitの差分表示
(global-git-gutter-mode t)

;; helmを使う設定を入れる
(require 'helm-config)
(helm-mode 1)
;; コマンド検索に変更
(global-set-key (kbd "M-x") 'helm-M-x)

;; The Silver Searcher を使うための設定 silver -> ag
(require 'helm-ag)
(setq helm-ag-base-command "ag --nocolor --nogrou")
(global-set-key (kbd "C-c s") 'helm-ag)

;; ctrl-hをバックスペースとして使う。
(global-set-key "\C-h" 'delete-backward-char)

;; バッファの左側に行番号を表示する
(global-linum-mode t)
;; 表示領域のフォーマットを確保する
(setq linum-format "%d ")
(column-number-mode t); 行番号と列番号を表示する

;; 括弧のペアとかは適宜入れて欲しい
(electric-pair-mode t)

;; yanipetの設定
(require 'yasnippet)
(yas/load-directory "~/.emacs.d/snippets")
(yas-global-mode 1)
;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

;; color theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(setq custom-theme-directory "~/.emacs.d/themes")
(load-theme 'madhat2r t)

;; ediffの設定
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; 空白表示
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark))

(setq whitespace-display-mappings
      '(
        (space-mark ?\u3000 [?\u2423])
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])
        ))
(setq whitespace-trailing-regexp  "\\([ \u00A0]+\\)$")
(setq whitespace-space-regexp "\\(\u3000+\\)")
(set-face-attribute 'whitespace-trailing nil
                    :foreground "RoyalBlue4"
                    :background "RoyalBlue4"
                    :underline nil)
(set-face-attribute 'whitespace-tab nil
                    :foreground "color-247"
                    :background "color-234"
                    :underline nil)
(set-face-attribute 'whitespace-space nil
                    :foreground "gray40"
                    :background "gray20"
                    :underline nil)

;; 空白表示の設定
(global-whitespace-mode 1)
;; pathをheaderに表示させる設定
(path-headerline-mode +1)

;; auto-highlight
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)
(add-hook 'after-init-hook 'global-auto-highlight-symbol-mode)

;; git 用
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(require 'helm-git-grep) ;; Not necessary if installed by package.el
(global-set-key (kbd "C-c g") 'helm-git-grep)
;; Invoke `helm-git-grep' from isearch.
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
;; Invoke `helm-git-grep' from other helm.
(eval-after-load 'helm
  '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))
(require 'helm-etags-plus)
(global-set-key "\M-." 'helm-etags-plus-select)
;;list all visited tags
(global-set-key "\M-*" 'helm-etags-plus-history)
;;go back directly
(global-set-key "\M-," 'helm-etags-plus-history-go-back)


;; ruby用
;; rbenv
(require 'rbenv)
(global-rbenv-mode)
(setq rbenv-installation-dir "~/.rbenv")

(add-hook 'ruby-mode-hook 'robe-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))
(require 'flycheck)
(setq flycheck-check-syntax-automatically '(mode-enabled save))
(add-hook 'ruby-mode-hook 'flycheck-mode)
(require 'rubocop)
(add-hook 'ruby-mode-hook 'rubocop-mode)
(add-hook 'ruby-mode-hook
          (lambda()
            (setq tab-width 2 indent-tabs-mode nil)))
(flycheck-define-checker ruby-rubocop
   "A Ruby syntax and style checker using the RuboCop tool."
   :command ("rubocop" "--format" "emacs"
             (config-file "--config" flycheck-rubocoprc)
             source)
   :error-patterns
   ((warning line-start
             (file-name) ":" line ":" column ": " (or "C" "W") ": " (message)
             line-end)
    (error line-start
           (file-name) ":" line ":" column ": " (or "E" "F") ": " (message)
           line-end))
   :modes (ruby-mode motion-mode))
(defun set-rubocop-wrapper-hook ()
  (setq flycheck-command-wrapper-function
        (lambda (command) (append '("bundle" "exec") command)))
  )
(add-hook 'ruby-mode-hook 'set-rubocop-wrapper-hook)
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'ruby-mode-hook 'turn-on-ctags-auto-update-mode)
(defun ruby-ctags-options-hook ()
     (custom-set-variables
      '(ctags-update-other-options
        (list
         "--exclude=log"
         "--exclude=node_modules"
         "--exclude=tmp"
         "--exclude=stories"
         "--exclude=*.coffee"
         "--exclude='.git'"
         "--exclude='.github'"
         "--exclude='.storybook'"
         "--exclude='.temp'"
         "--exclude='front'"
         "--exclude='app/assets'"
         "--exclude='.svn'"
         "--exclude='SCCS'"
         "--exclude='RCS'"
         "--exclude='CVS'"
         "--exclude='EIFGEN'"
         "--exclude='.#*'"
         "--exclude='*~'")
        )
      '(ctags-update-command "ripper-tags")
      )
     )
(add-hook 'ruby-mode-hook 'ruby-ctags-options-hook)

;; magic comment 無効
(setq ruby-insert-encoding-magic-comment nil)

;; projectileの設定
(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)

(require 'helm-projectile)
(helm-projectile-on)

;; coffee用
(require 'coffee-mode)
(defun coffee-custom ()
  "coffee-mode-hook"
  (and (set (make-local-variable 'tab-width) 2)
       (set (make-local-variable 'coffee-tab-width) 2))
  )

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;; javascript用
(add-to-list 'auto-mode-alist '(".*\\.js\\'" . rjsx-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'rjsx-mode 'flow-minor-mode)
(add-hook 'rjsx-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq js-indent-level 2)
            (setq js2-strict-missing-semi-warning nil))) ;;行末のセミコロンの警告はオフ
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-flow))
(add-hook 'rjsx-mode-hook 'flycheck-mode)
;; node_modules ディレクトリを探して、その中の node_modules/.bin/eslintをflychekに使う
(defun my/use-eslint-from-node-modules ()
  "http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable"
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(require 'markdown-mode)
(defun markdown-custom ()
  (and (set (make-local-variable 'tab-width) 4))
  )
(add-hook 'markdown-mode
  '(lambda() (markdown-custom)))

;; plantUML用の設定
(setq plantuml-jar-path "/usr/local/Cellar/plantuml/1.2017.13/libexec/plantuml.jar")
