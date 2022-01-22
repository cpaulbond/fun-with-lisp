(in-package :fun-with-lisp)

(defun put (&rest args)
  "Put raw string on a terminal"
  (format *terminal-io* "~{~a~}" args)
  (finish-output *terminal-io*))

(defun esc (&rest args)
  "Escape sequence"
  (apply #'put (code-char #x1b) args))

(defun csi (&rest args)
  "Control sequence introducer"
  (apply #'esc #\[ args))

(defun sgr (&rest args)
  "Select Graphic Rendition"
  (apply #'csi (append args '("m"))))

(defun reset-screen ()
  "Clears the screen, attributes, cursor position etc."
  (esc "c"))

(defun clear-screen (&optional (mode 2))
  "Erase in display"
  ;; Defined modes:
  ;; 0 - clear from cursor to the end of the display
  ;; 1 - clear from cursor to the start of the display
  ;; 2 - clear entire display
  (csi mode "J"))

(defun clear-line (&optional (mode 2))
  "Erase in line"
  ;; Defined modes:
  ;; 0 - clear from cursor to the end of the line
  ;; 1 - clear from cursor to the start of the line
  ;; 2 - clear entire line
  (csi mode "K"))

(defun set-foreground-color (r g b)
  (sgr "38;2;" r ";" g ";" b))

(defun set-background-color (r g b)
  (sgr "48;2;" r ";" g ";" b))

(defun save-cursor-position ()
  (csi "s"))

(defun restore-cursor-position ()
  (csi "u"))

(defun set-cursor-position (row col)
  (cond ((and row col)
         (csi row ";" col "H"))
        ((not (null col))
         (csi row ";H"))
        ((not (null row))
         (csi ";" col "H"))))

(defmacro with-cursor-position ((row col) &body body)
  `(progn
     (save-cursor-position)
     (set-cursor-position ,row ,col)
     (unwind-protect (progn ,@body)
       (restore-cursor-position))))

(defun (setf cursor-visibility) (visiblep)
  (if visiblep
      (csi "?" 2 5 "h")
      (csi "?" 2 5 "l")))

