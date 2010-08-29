;;; -*- mode: lisp; package: lisp -*-
;;;
;;; fixpack/typespec-cons.l
;;;

(in-package :lisp)

;;;
;;; :: [CLHS: Issue CONS-TYPE-SPECIFIER Writeup]
;;;     http://www.lispworks.com/documentation/HyperSpec/Issues/iss078_w.htm
;;;
;;; Type Specifier �̕����^ (cons <typespec-car> <typespec-cdr>) ���g���Ȃ��B
;;; �I���W�i���̎������ƈ�ʂ� cons �Ƃ��Ĉ�����B
;;;
;;;     ;;; �ȉ��S�� nil �ɂȂ�̂�������
;;;     (typep '(a b c) '(cons symbol integer))
;;;     => t
;;;     
;;;     (typep '(a b c) '(cons symbol (cons symbol nil)))
;;;     => t
;;;     
;;;     (typep '(hoge fuga) '(cons (member foo bar baz)))
;;;     => t
;;;

(when (get 'cons 'si::type-predicate)
  (remprop 'cons 'si::type-predicate))

(si::defpred cons (object r)
  (and (consp object)
       (typep (car object) (car r))
       (typep (cdr object) (cdr r))))

(provide "fixpack/typespec-cons")

;;; fixpack/typespec-cons.l ends here.