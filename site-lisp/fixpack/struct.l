;;; -*- mode: lisp; package: lisp -*-
;;;
;;; fixpack/struct.l
;;;

;;; Code:

(in-package :system)

;;;
;;; defstruct �� (:print-function PRINTER) �I�v�V������ #'PRINTER �ɓW�J
;;; ���Ă���̂ŁAload ���� PRINTER ����`����Ă��Ȃ��ƃG���[�ɂȂ�B
;;;
;;;     (fmakunbound 'print-foo) ; �O�̂���
;;;     => print-foo
;;;     
;;;     (defstruct (foo (:print-function print-foo)))
;;;     ERROR: �֐�����`����Ă��܂���: print-foo
;;;
;;; �ύX�_:
;;; - *make-structure-definition �ւ̈����� #'print-function �ł͂Ȃ�
;;;   'print-function ��n���悤��
;;;
;;; ����:
;;; - ����`�Ȋ֐��V���{�����w�肵�� structure ���`���邱�Ƃ͂ł��邯�ǁA
;;;   ����`�̂܂܂��� structure �̃C���X�^���X���o�͂���ƃG���[�ɂȂ�B
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