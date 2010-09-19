;;; -*- mode: lisp; package: lisp -*-
;;;
;;; fixpack/type-of.l
;;;

(in-package :lisp)

;;;
;;; Function type-of returns `structure' for structure object, instead of
;;; structure name.
;;;
;;;     (defstruct fred)
;;;     => #<structure-definition: fred>
;;;     
;;;     (type-of (make-fred))
;;;     ;; should be fred
;;;     => structure
;;;

(defconstant +original-type-of+ #'type-of)

(defun type-of (object)
  (let ((type (funcall +original-type-of+ object)))
    (if (eq type 'structure)
      (si:*structure-definition-name
       (si:*structure-definition object))
      type)))

;;; fixpack/type-of.l ends here.
