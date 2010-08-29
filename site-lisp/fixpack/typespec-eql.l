;;; -*- mode: lisp; package: lisp -*-
;;;
;;; fixpack/typespec-eql.l
;;;

(in-package :lisp)

;;;
;;; Original typespec eql has both deftype-definition and type-specifier-list
;;; defined, and deftype-definition is unnecessary and broken.
;;;
;;;     (si:canonicalize-type '(eql 3))
;;;     => (member (3))
;;;
(when (get 'eql 'si::deftype-definition)
  (remprop 'eql 'si::deftype-definition))

(provide "fixpack/typespec-eql")

;;; fixpack/typespec-eql.l ends here.
