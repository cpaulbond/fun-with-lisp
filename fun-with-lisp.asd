(defsystem "fun-with-lisp"
  :version "0.1.0"
  :author "C. Paul Bond"
  :license "mit"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main")
                 (:file "terminal")
                 (:file "forest-fire"))))
  :description ""
  :in-order-to ((test-op (test-op "fun-with-lisp/tests"))))

(defsystem "fun-with-lisp/tests"
  :author "C. Paul Bond"
  :license "mit"
  :depends-on ("fun-with-lisp"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for fun-with-lisp"
  :perform (test-op (op c) (symbol-call :rove :run c)))
