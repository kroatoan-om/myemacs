;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; You shouldn't need to change anything in this block
;;
;; Prepare Emacs package handling. This is actually only needed to get
;; `use-package' in place, so we don't have to think about this ever again.
(require 'package)
(setq package-enable-at-startup nil)
;;enable melpa
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

(package-initialize)

;; Bootstrap `use-package', the one and only package that we want to install
;; manually. It will do automagic installation, delayed loading and things
;; like that for us.
;; https://www.reddit.com/r/emacs/comments/3n7fs2/what_is_the_most_conventional_way_for_writing/
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)


;; open my init file
(defun bjm/open-my-init-file ()
  "Open the user's init.el file."
  (interactive)
  (find-file (expand-file-name "~/.emacs.d/init.el"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;PACKAGE TRY
(use-package try
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Magit
(use-package magit
  :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Algunos basicos   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;;Quitar pantalla inicio
(setq
 inhibit-startup-message t
 inhibit-startup-screen t
 confirm-kill-emacs 'y-or-n-p)      ; y and n instead of yes and no when quitting
(fset 'yes-or-no-p 'y-or-n-p)      ; y and n instead of yes and no everywhere else

;;Visualizar numero de lineas
(global-linum-mode)
(setq column-number-mode t) ;; show columns in addition to rows in mode line


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Diccionario y corrector ortográfico              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Primero configuramos el diccionario para español
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "castellano")
;;Habilitar flyspell en modo texto
    (dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))

;;configuracion para no incluir ciertos bloque en la corrección
;;Block regex helper.
(defun help/block-regex (special)
  "Make an ispell skip-region alist for a SPECIAL block."
  (interactive)
  `(,(concat help/org-special-pre "BEGIN_" special)
    .
    ,(concat help/org-special-pre "END_" special)))

;;Check SPECIAL LINE definitions, ignoring their type.

(let ()
  (--each
      '(("ATTR_LATEX" nil)
        ("AUTHOR" nil)
        ("BLOG" nil)
        ("CREATOR" nil)
        ("DATE" nil)
        ("DESCRIPTION" nil)
        ("EMAIL" nil)
        ("EXCLUDE_TAGS" nil)
        ("HTML_CONTAINER" nil)
        ("HTML_DOCTYPE" nil)
        ("HTML_HEAD" nil)
        ("HTML_HEAD_EXTRA" nil)
        ("HTML_LINK_HOME" nil)
        ("HTML_LINK_UP" nil)
        ("HTML_MATHJAX" nil)
        ("INFOJS_OPT" nil)
        ("KEYWORDS" nil)
        ("LANGUAGE" nil)
        ("LATEX_CLASS" nil)
        ("LATEX_CLASS_OPTIONS" nil)
        ("LATEX_HEADER" nil)
        ("LATEX_HEADER_EXTRA" nil)
        ("NAME" t)
        ("OPTIONS" t)
        ("POSTID" nil)
        ("RESULTS" t)
        ("SELECT_TAGS" nil)
        ("STARTUP" nil)
        ("TITLE" nil))
    (add-to-list
     'ispell-skip-region-alist
     (let ((special (concat "#[+]" (car it) ":")))
       (if (cadr it)
           (cons special "$")
         (list special))))))

;;Keybidings
(global-set-key (kbd "C-x <f1>") 'ispell-buffer)
(global-set-key (kbd "C-S-<f1>") 'ispell-check-previous-highlighted-word)
(defun ispell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (ispell-goto-next-error)
  (ispell-word)
  )
(global-set-key (kbd "C-S-<f2>") 'ispell-check-next-highlighted-word)

;; flycheck para ortografia de 
(use-package flycheck
  :ensure t)


;;Auto fill para modo texto
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;;Señalar parentesis y llaves
;; (shown-paren-mode 1)
;; (setq show-paren-style 'expression)

;;THEME SKIN
;(add-to-list 'load-path              "~/.emacs.d/themes/alect-themes")
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/alect-themes")
(use-package alect-themes
  :ensure t)
(load-theme 'alect-light-alt t)

;;

;;Configurar tamaño de ventana (dafault window size)
(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 105) ; chars
              (height . 60) ; lines
              (left . 0)
              (top . 50)))
      (setq default-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 105)
              (height . 60)
              (left . 0)
              (top . 50))))
  (progn
    (setq initial-frame-alist '( (tool-bar-lines . 0)))
    (setq default-frame-alist '( (tool-bar-lines . 0)))))

;;MODIFICAR ANCHO DE COLUMNA
(setq-default fill-column 80)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :bind (("C-c l" . org-store-link))
  )

(require 'org)

;; org bullets
(use-package org-bullets
  :ensure t)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda() 'org-bullets-mode-1))

;;deshabilitar correccion en comentarios
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'org-mode-hook 'turn-on-flyspell)

;;CONFIGURACION ISPELL PARA ORGMODE 
(defun endless/org-ispell ()
  "Configure `ispell-skip-region-alist' for `org-mode'."
  (make-local-variable 'ispell-skip-region-alist)
  (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))
(add-hook 'org-mode-hook #'endless/org-ispell)

;; unset org C-c b for my use later
; (global-unset-key (kbd "C-c b"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org babel for embedded code                                       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Some initial languages we want org-babel to support
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (emacs-lisp . t)
   (latex . t)
   (shell . t)
   (gnuplot t)
   ))


(require 'ox-latex) ;; latex export

;; speed keys for quick navigation
(setq org-use-speed-commands 1)

;; description list indents
(setq org-list-description-max-indent 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; nice org latex export                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; my standard latex options
(add-to-list 'org-latex-classes
             '("asgarticle"
               "\\documentclass[a4paper,12pt,oneside]{article}
\\usepackage[main=spanish,english]{babel}%paquete para el idioma del documento. Si
%se quiere utilizar un parrafo con idioma diferente podemos utilizar
%la orden \selectlanguage{}
\\usepackage[utf8]{inputenx}
\\usepackage[T1]{fontenc}
\\usepackage{lmodern,pifont}
\\usepackage{pdflscape}
\\usepackage{caption}
\\usepackage{textcomp}
\\usepackage{graphicx}
\\usepackage[dvipsnames]{color}
\\usepackage{colortbl}
\\usepackage{longtable}
\\usepackage{hyperref}
\\hypersetup{bookmarksopen,bookmarksnumbered,bookmarksopenlevel=4,%
  linktocpage,colorlinks,urlcolor=black,citecolor=ForestGreen,linkcolor=black,filecolor=black}
\\usepackage{natbib}
%\\usepackage{amssymb}
%\\usepackage{amsmath}
\\usepackage{geometry}
\\geometry{a4paper,left=2cm,top=2cm,right=2.5cm,bottom=2cm,marginparsep=7pt, marginparwidth=.6in}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Force new page after TOC
(setq org-latex-toc-command "\\thispagestyle{empty} \\tableofcontents \\clearpage")

;; org edit latex
(use-package org-edit-latex
  :ensure t)
(require 'org-edit-latex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; latex                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package reftex
  :ensure t
  :config
  ;; So that RefTeX finds my bibliography - add yours here
  ;; CUSTOMISE - add your bibtex file here if you want
  ;; (setq reftex-default-bibliography '("/homeb/bjm/latex/style/bibtex/clusters.bib"))
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)
  )

(use-package tex-site
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  )

;; set latex as alternate input
(setq default-input-method 'TeX)

(url-copy-file "http://www.star.bris.ac.uk/bjm/emacs_tutorial.org" (expand-file-name "~/emacs_tutorial.org") 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HELM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package helm
  :diminish helm-mode
  :ensure t
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t))
    ;;replace locate with spotlight - uncomment next 2 lines on Mac
    ;;(setq locate-command "mdfind -name")
    ;;(setq helm-locate-command "mdfind -name %s %s")
  :bind (("C-x f" . helm-for-files)
         ("M-x" . helm-M-x)))

;; flx for fuzzy matching
(use-package flx)
(use-package helm-flx)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-color-mode-line flycheck org-edit-latex magit helm use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
