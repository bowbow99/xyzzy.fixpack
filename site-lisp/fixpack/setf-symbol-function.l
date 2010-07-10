;;; -*- mode: lisp; package: lisp -*-
;;;
;;; fixpack/setf-symbol-function.l
;;;

;;; Code:

(in-package :lisp)

;;;
;;; (setf (symbol-function SYMBOL) NEW-FUNCTION) ���ANEW-FUNCTION �ł�
;;; �Ȃ� SYMBOL ��Ԃ��B
;;;
;;;     (setf (symbol-function 'foo) (lambda () "I'm foo"))
;;;     => foo
;;;
;;; �ύX�_:
;;; - si:*fset ������A�V�����l��Ԃ����ɓW�J�����悤�ɂ����B
;;;

(defsetf symbol-function (symbol) (new-function)
  (let (($symbol (gensym))
        ($function (gensym)))
    `(let ((,$symbol ,symbol)
           (,$function ,new-function))
       (si:*fset ,$symbol ,$function)
       ,$function)))


;;; fixpack/setf-symbol-function.l ends here.