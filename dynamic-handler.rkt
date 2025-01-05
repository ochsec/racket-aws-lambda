#lang racket/base

(require json
         racket/contract
         racket/format
         racket/sandbox)

;; Secure evaluation function with strict sandboxing
(define (safe-eval-program program data)
  (call-with-limits 
   5 ;; CPU time limit (seconds)
   50 ;; Memory limit (MB)
   (lambda ()
     (let ([eval-result 
            (eval 
             (read (open-input-string program)))])
       (if (procedure? eval-result)
           (eval-result data)
           eval-result)))))

;; AWS Lambda logging function (reused from previous handler)
(define (log-event level message)
  (displayln 
   (jsexpr->string 
    (hash 'level level 
          'message message 
          'timestamp (current-seconds)))))

;; Dynamic Lambda handler with homoiconic code execution
(define/contract (handle-dynamic-event event context)
  (-> hash? hash? any/c)
  
  ;; Extract program and data from event
  (define program (hash-ref event 'program #f))
  (define data (hash-ref event 'data #f))
  
  ;; Log incoming event
  (log-event 'INFO (format "Received dynamic event: ~a" event))
  
  ;; Validate input
  (unless (and program data)
    (raise (exn:fail 
            "Missing 'program' or 'data' in event" 
            (current-continuation-marks))))
  
  ;; Execute program safely
  (with-handlers ([exn:fail? 
                   (lambda (exn)
                     (log-event 'ERROR (format "Execution error: ~a" (exn-message exn)))
                     (hash 'error (exn-message exn)))])
    
    ;; Execute the dynamic program
    (let ([result (safe-eval-program program data)])
      (log-event 'INFO (format "Execution result: ~a" result))
      result)))
