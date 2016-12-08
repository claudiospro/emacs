;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; elpy   : sudo apt-get install ipython ipython3
;; ac-php : sudo apt-get install php5-cli cscope

(defvar myPackages '(
		     web-mode 
		     php-mode
		     ))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------
(add-hook 'mail-mode-hook '(lambda () (auto-fill-mode 1))) ;; corta las lineas largas mail
(add-hook 'text-mode-hook '(lambda () (auto-fill-mode 1))) ;; corta las lineas largas texto
;; (add-hook 'org-mode-hook '(lambda () (auto-fill-mode 1)))  ;; corta las lineas largas org-mode
;; (cua-mode t) ;; estandar: copiar / cortar / pegar
(fset 'yes-or-no-p 'y-or-n-p)  ;; Acepta 'y' o 'n' cuando pide 'yes' o 'no'
;; (global-hl-line-mode t) ;; habilita set-face-background;; 
(global-linum-mode t) ;; enable line numbers globally

(global-set-key [(C-tab)] 'bury-buffer) ;; Combinaciones de teclas CAMBIAR A BUFER
(global-set-key "\C-cg"   'goto-line)   ;; Combinaciones de teclas BUSCAR LINEA
(global-set-key "\C-x\."  'kill-this-buffer) ;;Combinaciones de teclas ELIMINAR BUFE-R
(global-unset-key "\C-z") ;; Ctrl-Z es una joda - Se va
(ido-mode -1) ;; me gusta el buffer tradicional
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


;; OCULTAR CODIGO
;; --------------------------------------
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "C-+") 'hs-show-block)
(global-set-key (kbd "C--") 'hs-hide-block)
(global-set-key (kbd "M-+") 'hs-show-all)
(global-set-key (kbd "M--") 'hs-hide-all)

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


;; WEB MODE
;; --------------------------------------
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
;;
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)


