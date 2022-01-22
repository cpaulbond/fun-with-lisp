(defpackage fun-with-lisp/tests/main
  (:use :cl
        :fun-with-lisp
        :rove))
(in-package :fun-with-lisp/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :fun-with-lisp)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
