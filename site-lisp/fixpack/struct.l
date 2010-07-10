;;; -*- mode: lisp; package: system -*-
;;;
;;; fixpack/struct.l
;;;

;;; Code:

(require "struct")

(in-package :system)

;;;
;;; defstruct の (:print-function PRINTER) オプションを #'PRINTER に展開
;;; しているので、load 時に PRINTER が定義されていないとエラーになる。
;;;
;;;     (fmakunbound 'print-foo) ; 念のため
;;;     => print-foo
;;;     
;;;     (defstruct (foo (:print-function print-foo)))
;;;     ERROR: 関数が定義されていません: print-foo
;;;
;;; 変更点:
;;; - *make-structure-definition への引数で #'print-function ではなく
;;;   'print-function を渡すように
;;;
;;; 注意:
;;; - 未定義な関数シンボルを指定して structure を定義することはできるけど、
;;;   未定義のままその structure のインスタンスを出力するとエラーになる。
;;;
(defun define-structure (name doc conc-name constructors copier predicate
                         include slots print-function)
  (let ((def (gensym)))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (let ((,def (*make-structure-definition ',name nil ,include
                                               ',constructors
                                               ,(when print-function
                                                  `',print-function)
                                               nil ',slots)))
         (setf (get ',name 'structure-definition) ,def)
         (setf (get ',name 'lisp::structure-documentation) ,doc)
         ,@(create-constructors def constructors slots)
         ,(when copier
            `(setf (symbol-function ',copier) #'*copy-structure-data))
         ,(when predicate
            `(defun ,predicate (x)
               (typep x ',name)))
         ,@(create-accessors conc-name slots)
         ,def))))

(provide "fixpack/struct")

;;; fixpack/struct.l ends here.
