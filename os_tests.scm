(define (factorial_process n)
  (full-copy
   `((:exp
      .
      (begin
        (if (= n 0)
            (set! :done #t)
            (begin
              (set! result (* n result))
              (set! n (- n 1))))
        result))
     (:env . ((result . 1) (n . ,n))))))

(eg
 (run (factorial_process 6))
 '((:result . 6) (result . 6) (n . 5)))

(eg
 (let ((f6 (factorial_process 6)))
   (step* (list f6))
   (get (get f6 ':env) ':result))
 720)

(eg
 (let ((f6 (factorial_process 6))
       (f5 (factorial_process 5)))
   (step* (list f6 f5))
   (list
    (get (get f6 ':env) ':result)
    (get (get f5 ':env) ':result)))
 '(720 120))
