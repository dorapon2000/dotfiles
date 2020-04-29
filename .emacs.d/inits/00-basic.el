;;;00_basic.el

;; 指定行にジャンプする
(global-set-key (kbd "C-x j") 'goto-line)
;; 行番号表示切り替え
;; http://qiita.com/takc923/items/acebbdae04994de16c6d
(require 'linum)
(global-set-key (kbd "<f6>") 'linum-mode)
(setq linum-format "%4d ")
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))
;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)
;;括弧の自動補完
(electric-pair-mode 0)
;; カーソル点滅の停止
(blink-cursor-mode 0)
;; 対応するカッコを光らせる
(show-paren-mode 1)
;; ウィンドウに収まらない時だけ括弧内を光らせる
(setq show-paren-style 'mixed)
;; 現在行を光らせる
;(global-hl-line-mode t)
;; バックアップファイルを作らない
(setq backup-inhibited t)
;; 一時的なバックアップファイルは.emacs.d/backup以下に保存する
;; create backup file in ~/.emacs.d/backup
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
	    backup-directory-alist))
;; create auto-save file in ~/.emacs.d/backup
(setq auto-save-file-name-transforms
            `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))
;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;; 置換 (対話型) query-replace
(global-set-key (kbd "C-c q") 'query-replace)
;; 置換 (非対話) replace-string
(global-set-key (kbd "C-c r") 'replace-string)
;; 行番号・桁番号をモードラインに表示する・しない設定
(line-number-mode t) ; 行番号。tなら表示、nilなら非表示
(column-number-mode t) ; 桁番号。tなら表示、nilなら非表示
;;ctrl-x u(undo) -> ctrl-z
;(global-set-key (kbd "C-z") 'advertised-undo)
;;スクロールを1行ずつ
(setq scroll-step 1)
;;color-theme
(load-theme 'misterioso t)
;;文字コード
(set-language-environment "Japanese")
;(prefer-coding-system 'utf-8-mac)
(prefer-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; cモードはlinuxのスタイル
(setq c-default-style "linux")

;;;mode名の再定義
;;;http://syohex.hatenablog.com/entry/20130131/1359646452
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (abbrev-mode . "")
    (undo-tree-mode . "")
    (anzu-mode . "")
    (helm-mode . "")
    (smooth-scroll-mode . "")
    ;; Major modes
    (lisp-interaction-mode . "Li")
    (python-mode . "Py")
    (ruby-mode   . "Rb")
    (emacs-lisp-mode . "Elsp")
    (markdown-mode . "Md")))

(require 'cl)
(defun clean-mode-line ()
  (interactive)
  (loop for cleaner in mode-line-cleaner-alist
	do (let* ((mode (car cleaner))
		  (mode-str (cdr cleaner))
		  (old-mode-str (cdr (assq mode minor-mode-alist))))
	     (when old-mode-str
	       (setcar old-mode-str mode-str))
	     ;; major mode-str
             (when (eq mode major-mode)
	       (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)
