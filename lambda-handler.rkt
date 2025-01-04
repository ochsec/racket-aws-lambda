#lang racket/base

(require json
         racket/contract
         racket/format)

;; AWS Lambda logging function
(define (log-event level message)
  (displayln 
   (jsexpr->string 
    (hash 'level level 
          'message message 
          'timestamp (current-seconds)))))

;; Generic Lambda handler contract
(define/contract (handle-event event context)
  (-> hash? hash? any/c)
  
  ;; Log the incoming event in a structured format
  (log-event 'INFO (format "Received event: ~a" event))
  
  ;; Placeholder for actual business logic
  ;; Subclasses or specific implementations should override this
  (with-handlers ([exn:fail? 
                   (lambda (exn)
                     (log-event 'ERROR (format "Error processing event: ~a" (exn-message exn)))
                     (hash 'error (exn-message exn)))])
    
    ;; Default behavior: return the event as-is
    event))

;; Provide the handler for external use
(provide handle-dynamic-event)
