(in-package :fun-with-lisp)


(defconstant burning #\B)
(defconstant tree #\t)
(defconstant grass #\.)


(defun advance-forest (forest tree-prob fire-prob)
  (let* ((rows (array-dimension forest 0))
         (cols (array-dimension forest 1))
         (new-forest (make-array (list rows cols))))
    (dotimes (r rows)
      (dotimes (c cols)
        (let ((rnd (random 1.0))
              (v (aref forest r c)))
          ;; (format t "rnd ~a~%" rnd)
          (setf (aref new-forest r c)
                (cond
                  ((eq v burning) grass)
                  ((eq v grass) (if (<= rnd tree-prob) tree grass))
                  (t (if (or (> (neighbors-burning forest r c) 0) (<= rnd fire-prob)) burning tree))))
          ;; (format t "old ~a, new ~a~%" (aref forest r c) (aref new-forest r c))
          )))
    new-forest))


(defun neighbors-burning (forest row col)
  (let ((rows (array-dimension forest 0))
        (cols (array-dimension forest 1)))
    (loop for (dr dc) in '((1 1) (1 0) (1 -1) (0 1) (0 -1) (-1 1) (-1 0) (-1 -1))
          sum (progn
                (let ((r (+ row dr))
                      (c (+ col dc)))
                  (if (or (< r 0) (< c 0) (>= r rows) (>= c cols))
                      0
                      (if (eq (aref forest r c) burning) 1 0)))))))


(defun print-forest (forest)
  (dotimes (r (array-dimension forest 0))
    (dotimes (c (array-dimension forest 1))
      (princ (aref forest r c)))
    (princ #\newline)))


(defun make-forest (rows cols new-tree-probability)
  (let ((forest (make-array (list rows cols))))
    (dotimes (r rows)
      (dotimes (c cols)
        (setf (aref forest r c)
              (if (<= (random 1.0) new-tree-probability) tree grass))))
    forest))


(defun get-config (key config)
  (let ((val (assoc key config)))
    (if val
        (cdr val)
        (error (format nil "missing value for key ~a" key)))))


(defun simulate-forest-fire (config)
  (let* ((rows (get-config :rows config))
         (cols (get-config :cols config))
         (new-tree (get-config :new-tree config))
         (grow-tree (get-config :grow-tree config))
         (start-fire (get-config :start-fire config))
         (skip (get-config :skip config))
         (wait (get-config :wait config))
         (forest (make-forest rows cols new-tree)))

    (clear-screen)
    (dotimes (time (get-config :time config))
      (when (or (and (> skip 0) (= (rem time skip) 0))
                (<= skip 0))
        (set-cursor-position 0 0)
        (format t "* time ~a~%" time)
        (print-forest forest)
        (sleep wait))
      (setf forest (advance-forest forest grow-tree start-fire)))))
