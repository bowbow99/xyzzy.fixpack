;;; -*- mode: lisp; package: system -*-
;;;
;;; fixpack/condition.l
;;;

;;; Code:

(in-package :system)


;;;
;;; Origin: http://xyzzy.s53.xrea.com/wiki/index.php?patch%2Fcondition.l
;;; define-condition の :report オプションがないとエラーになってしまう。
;;; 

(defun define-condition-helper (name parent-type body)
  (let ((slot-spec (car body))
        (options (cdr body)))
    (when (or (get name 'type-predicate)
              (get name 'type-specifier-list))
      (error "~Aは型指定子です" name))
    (let ((def (get name 'structure-definition)))
      (when (and def
                 (*structure-definition-p def)
                 (*structure-definition-read-only-p def))
        (error "~Aの再定義はできません" name)))
    (unless (subtypep parent-type 'condition)
      (error "~Aはコンディションではありません" parent-type))
    (let ((parent (get parent-type 'structure-definition))
          (doc nil)
          (report nil)
          important)
      (setq important (*structure-definition-important-p parent))
      (dolist (x (cdr body))
        (case (car x)
          (:documentation (setq doc (cadr x)))
          (:report        (setq report (cadr x)))
          (:important     (setq important (cadr x)))
          (t  (error "不正な define-condition オプションです: ~A" x))))
      (unless report
        (setq report (*structure-definition-report parent)))
      (let ((slot-desc
              (do ((i (1- (*structure-definition-nslots parent)) (1- i))
                   (slots '()))
                  ((< i 0) slots)
                (push (multiple-value-list
                       (*structure-definition-slot-description parent i))
                      slots))))
        (mapc #'(lambda (x)
                  (let (name
                        (init nil))
                    (cond ((symbolp x)
                           (setq name x))
                          ((consp x)
                           (setq name (car x))
                           (unless (symbolp name)
                             (error "不正なスロット名です: ~S" name))
                           (setq init (cadr x)))
                          (t
                           (error "不正なスロットです: ~S" name)))
                    (when (assoc name slot-desc :test #'string=)
                      (error "スロット ~A が重複しています" name))
                    (setq slot-desc
                          (nconc slot-desc
                                 (list (list (intern (symbol-name name) "keyword")
                                             init t nil))))))
              (car body))
        (let ((def (gensym)))
          `(eval-when (:compile-toplevel :load-toplevel :execute)
             (let ((,def (*make-structure-definition
                          ',name nil (get ',parent-type 'structure-definition)
                          nil nil nil ',slot-desc
                          ;,(if (or (consp report)
                          ;         (symbolp report))
                          ,(if (and (or (consp report)
                                        (symbolp report))
                                    (not (eq report nil)))
                             `#',report
                             report)
                          ,important)))
               (setf (get ',name 'structure-definition) ,def)
               (setf (get ',name 'lisp::type-documentation) ,doc))
             (define-condition-accessors ,name nil)))))))




;;; fixpack/condition.l ends here
