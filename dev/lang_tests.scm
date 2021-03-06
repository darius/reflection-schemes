(define (top-process name exp . env)
  (dict `((:env . ,(dict env))
          (:exp . ,exp)
          (:run . ,(lambda (process) (format #t "running ~a...\n" name))))))

(define (top-eval exp . env)
  (evl (apply top-process 'top exp env) exp '()))

(eg
 (top-eval '(+ 1 2))
 3)

(eg
 (top-eval '(begin 1 2 3))
 3)

(eg
 (top-eval '(begin (set! x 3) 3))
 3)

(eg
 (top-eval
  '(begin
     (set! d (dict '((a . 1) (b . 2))))
     (upd! d '(a) 3)
     (get d '(a))))
 3)
