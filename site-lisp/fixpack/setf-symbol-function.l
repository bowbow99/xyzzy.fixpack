;;; -*- mode: lisp; package: lisp -*-
;;;
;;; fixpack/setf-symbol-function.l
;;;

;;; Code:

(in-package :lisp)

;;;
;;; (setf (symbol-function SYMBOL) NEW-FUNCTION) が、NEW-FUNCTION では
;;; なく SYMBOL を返す。
;;;
;;;     (setf (symbol-function 'foo) (lambda () "I'm foo"))
;;;     => foo
;;;
;;; 変更点:
;;; - si:*fset した後、新しい値を返す式に展開されるようにした。
;;;

(defsetf symbol-function (symbol) (new-function)
  `(progn
     (si:*fset ,symbol ,new-function)
     ,new-function))

(provide "fixpack/setf-symbol-function")

;;; fixpack/setf-symbol-function.l ends here.
