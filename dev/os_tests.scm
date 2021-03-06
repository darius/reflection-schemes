(define (runevl process)
  (evl process (get process '(:exp)) (get process '(:context) '())))

(define (factorial-process n)
  (dict `((:env . ,(dict `((n . ,n) (:result . 1))))
          (:exp
           .
           (if (= n 0)
               (set! :done #t)
               (begin
                 (set! :result (* n :result))
                 (set! n (- n 1)))))
          (:run . ,runevl))))

(eg
 (let ((f6 (factorial-process 6)))
   (schedule f6)
   (step*)
   (get f6 '(:env :result)))
 720)

(define (even?-process)
  (dict
   `((:env . ,(dict '()))
     (:exp
      .
      (if (= n 0)
          (begin
            (set! :result #t)
            (set! :done #t))
          (if (= n 1)
              (begin
                (set! :result #f)
                (set! :done #t))
              (begin
                (set! n (- n 2))
                (run self)))))
     (:run . ,runevl))))

(define (test-even? n)
  (let ((p (even?-process)))
    (upd! p '(:env n) n)
    (upd! p '(:env self) p)
    (schedule p)
    (step*)
    (get p '(:env :result))))

(eg (test-even? 0) #t)
(eg (test-even? 1) #f)
(eg (test-even? 2) #t)
(eg (test-even? 3) #f)

(define (parity?-process b)
  (dict
   `((:env . ,(dict '()))
     (:exp
      .
      (if (= n 0)
          (begin
            (set! :result ,b)
            (set! :done #t))
          (if (= n 1)
              (begin
                (set! :result (not ,b))
                (set! :done #t))
              (begin
                (upd! other '(:env n) (- n 1))
                (run other)
                (set! :result (not (get other '(:env :result))))
                (set! :done #t)))))
     (:run . ,runevl))))

(define (test-odd? n)
  (let ((p0 (parity?-process #t))
        (p1 (parity?-process #f)))
    (upd! p1 '(:env n) n)
    (upd! p0 '(:env other) p1)
    (upd! p1 '(:env other) p0)
    (schedule p1)
    (step*)
    (get p1 '(:env :result))))

(eg (test-odd? 0) #f)
(eg (test-odd? 1) #t)
(eg_TODO (test-odd? 2) #f)
(eg_TODO (test-odd? 3) #t)
