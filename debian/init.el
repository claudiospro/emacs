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
		     ivy
		     epl
		     company
		     find-file-in-project;; ivy
		     highlight-indentation
		     pyvenv
		     yasnippet
		     dash
		     pkg-info;; epl
		     ;; better-defaults
		     birds-of-paradise-plus-theme 
		     color-theme
		     color-theme-solarized ;; color-theme
		     jazz-theme
		     ein 
		     elpy ;; company / find-file-in-project / highlight-indentation / pyvenv / yasnippet
		     flycheck ;; dash / pkg-info
		     py-autopep8
		     web-mode 
		     php-mode
		     flymake-easy
		     flymake-php ;; flymake-easy
		     flymake-phpcs  ;; flymake-easy
		     php-auto-yasnippets ;; php-mode / yasnippet
		     php+-mode
		     php-boris
		     s
		     php-scratch ;; php-mode / s
		     dash
		     f ;; dash / s
		     popup
		     xcscope
		     ac-php-core ;; dash / f / php-mode  / popup / s / xcscope
		     company-php ;; ac-php-core / company
		     auto-complete ;; popup
		     ac-php ;; ac-php-core / auto-complete / yasnippet
		     haml-mode
		     sass-mode
    ))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)


;; THEME
;; -------------------------------------

;; (require 'birds-of-paradise-plus-theme)
;; (load-theme birds-of-paradise-plus t) ;; bug

;; (set-frame-parameter nil 'background-mode 'light)
;; (set-terminal-parameter nil 'background-mode 'dark)
;; (load-theme 'solarized t)

(load-theme 'jazz t)

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
		    :width 'ultra-condensed :height 130)
;; (if (window-system)
;;     (set-face-background 'hl-line "light grey"))
;; requiere: (global-hl-line-mode t)
;; util http://raebear.net/comp/emacscolors.html
;;      set-background-color
;; necesita: set-face-attribute
(setq column-number-mode t) ;; Mostrar número actual de línea y columna
(if (window-system)
    (setq-default truncate-lines t)) ;; truncar linea
(setq frame-title-format "Emacs - %f") ;; título de la ventana
(setq inhibit-startup-message t) ;; oculta mensaje de inicio
(setq make-backup-files nil) ;; sacar los ~
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

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)


;; PHP MODE
;; --------------------------------------
(global-flycheck-mode)
(ac-config-default)
(require 'flymake-php)
(add-hook 'php-mode-hook 'flymake-php-load)

(require 'flymake-phpcs)
(add-hook 'php-mode-hook 'flymake-phpcs-load)
(custom-set-variables
 '(flymake-phpcs-standard "PSR2"))

(require 'php-auto-yasnippets)


;; PYTHON CONFIGURATION
;; --------------------------------------
(elpy-enable)
;; (setq elpy-rpc-python-command "python3")
(elpy-use-ipython) ;; ipython ipython3

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


;; init.el ends here
