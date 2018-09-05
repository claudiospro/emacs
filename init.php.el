;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages '(                     
                     haml-mode ;; childs: sass-mode
                     salt-mode ;; childs: yaml-mode     
                     smart-tabs-mode
                     neotree
                     magit
                     windsize
                     ace-window
                     flycheck
                     yasnippet
                     docker
                     
                     ;; theme
                     moe-theme
                     material-theme
                     
                     ;; langues
                     web-mode 
                     php-mode
                     sass-mode
                     yaml-mode
                     markdown-mode ;; dependency: cl-lib

                     ;; php
                     php-cs-fixer                     
                     ))

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------
(add-hook 'mail-mode-hook '(lambda () (auto-fill-mode 1))) ;; corta las lineas largas mail
(add-hook 'text-mode-hook '(lambda () (auto-fill-mode 1))) ;; corta las lineas largas texto
(add-hook 'org-mode-hook '(lambda () (auto-fill-mode 1)))  ;; corta las lineas largas org-mode
;; (cua-mode t) ;; estandar: copiar / cortar / pegar
(fset 'yes-or-no-p 'y-or-n-p)  ;; Acepta 'y' o 'n' cuando pide 'yes' o 'no'
;; (global-hl-line-mode t) ;; habilita set-face-background;; 
(global-linum-mode t) ;; enable line numbers globally

(global-set-key [(C-tab)] 'bury-buffer) ;; Combinaciones de teclas CAMBIAR A BUFER
(global-set-key "\C-cg"   'goto-line)   ;; Combinaciones de teclas BUSCAR LINEA
(global-set-key "\C-x\."  'kill-this-buffer) ;;Combinaciones de teclas ELIMINAR BUFE-R
(global-unset-key "\C-z") ;; Ctrl-Z es una joda - Se va
(ido-mode -1) ;; me gusta el buffer tradicional
(prefer-coding-system 'utf-8)
(if (not window-system)
    (menu-bar-mode -1)(menu-bar-mode t)) ;; Si estoy desde consola, no quiero barra de menú
(set-face-attribute 'default nil 
                    ;; :family "Nimbus Mono L Regular" 
                    :width 'ultra-condensed :height 130
                    )
(setq column-number-mode t) ;; Mostrar número actual de línea y columna
(if (window-system)
    (setq-default truncate-lines t)) ;; truncar linea
(setq frame-title-format "Emacs - %f") ;; título de la ventana
(setq make-backup-files nil) ;; sacar los ~
(setq inhibit-startup-message t) ;; oculta mensaje de inicio
(setq org-src-fontify-natively t)

(show-paren-mode 1)

;; ---------------------------------- sass
(require 'sass-mode)

;; ---------------------------------- yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; ---------------------------------- theme
;; (require 'moe-theme)
;; (moe-dark)
;; (moe-light)

;; (load-theme 'material t)
;; (load-theme 'material-light t)

(invert-face 'default)

;; ---------------------------------- neotree
(global-set-key [f8] 'neotree-toggle)


;; WEB MODE
;; --------------------------------------
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  )
(add-hook 'web-mode-hook  'my-web-mode-hook)

(setq web-mode-engines-alist
      '(
        ("php"    . "\\.tpl\\.")
        ("django"  . "\\.dj\\.")
        ("django"  . "\\.twig\\.")
        ("django"  . "\\.html\\'")
        )
      )


;; smart-tabs-mode
;; --------------------------------------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4) ; or any other preferred value
(setq cua-auto-tabify-rectangles nil)

(defadvice align (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))

(defadvice align-regexp (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))

(defadvice indent-relative (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))

(defadvice indent-according-to-mode (around smart-tabs activate)
  (let ((indent-tabs-mode indent-tabs-mode))
    (if (memq indent-line-function
              '(indent-relative
                indent-relative-maybe))
        (setq indent-tabs-mode nil))
    ad-do-it))

(defmacro smart-tabs-advice (function offset)
  `(progn
     (defvaralias ',offset 'tab-width)
     (defadvice ,function (around smart-tabs activate)
       (cond
        (indent-tabs-mode
         (save-excursion
           (beginning-of-line)
           (while (looking-at "\t*\\( +\\)\t+")
             (replace-match "" nil nil nil 1)))
         (setq tab-width tab-width)
         (let ((tab-width fill-column)
               (,offset fill-column)
               (wstart (window-start)))
           (unwind-protect
               (progn ad-do-it)
             (set-window-start (selected-window) wstart))))
        (t
         ad-do-it)))))

(smart-tabs-advice c-indent-line c-basic-offset)
(smart-tabs-advice c-indent-region c-basic-offset)

(smart-tabs-advice js2-indent-line js2-basic-offset)
(smart-tabs-advice cperl-indent-line cperl-indent-level)

(smart-tabs-advice py-indent-line py-indent-offset)
(smart-tabs-advice py-newline-and-indent py-indent-offset)
(smart-tabs-advice py-indent-region py-indent-offset)

(smart-tabs-advice ruby-indent-line ruby-indent-level)
(setq ruby-indent-tabs-mode t)

(smart-tabs-advice vhdl-indent-line vhdl-basic-offset)
(setq vhdl-indent-tabs-mode t)

;; flycheck
;; --------------------------------------
(add-hook 'after-init-hook #'global-flycheck-mode)

;; yasnippet
;; --------------------------------------
(yas-global-mode 1)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)


;; php-cs-fixer
;; --------------------------------------
(add-hook 'before-save-hook 'php-cs-fixer-before-save)
"
    - install (root)
      wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O php-cs-fixer
      chmod a+x php-cs-fixer
      mv php-cs-fixer /usr/local/bin/php-cs-fixer
    - update (root)
      php-cs-fixer self-update
    - usage
      php-cs-fixer /path/to/(dir|file)
"

;; OCULTAR CODIGO
;; --------------------------------------
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "C-+") 'hs-show-block)
(global-set-key (kbd "C--") 'hs-hide-block)
(global-set-key (kbd "M-+") 'hs-show-all)
(global-set-key (kbd "M--") 'hs-hide-level)

;; resize
;; --------------------------------------
(require 'windsize)
(windsize-default-keybindings)


;; ace-window
;; --------------------------------------
(global-set-key (kbd "C-x o") 'ace-window)

;; ZOOM font-size 
;; --------------------------------------
(defun sacha/increase-font-size ()
  (interactive)

  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height)))))
(defun sacha/decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
                                (face-attribute 'default :height)))))
(global-set-key (kbd "C-M-+") 'sacha/increase-font-size)
(global-set-key (kbd "C-M--") 'sacha/decrease-font-size)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (pkg-info moe-theme haml-mode yaml-mode sass-mode php-mode web-mode))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
