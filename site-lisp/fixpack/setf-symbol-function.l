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
  (let (($symbol (gensym))
        ($function (gensym)))
    `(let ((,$symbol ,symbol)
           (,$function ,new-function))
       (si:*fset ,$symbol ,$function)
       ,$function)))

(provide "fixpack/setf-symbol-function")

;;; fixpack/setf-symbol-function.l ends here.
