#lang racket/base

(require json
         racket/contract)

;; Generic Lambda handler contract
(define/contract (handle-event event context)
  (-> hash? hash? any/c)
  
  ;; Log the incoming event for debugging/monitoring
  (displayln (format "Received event: ~a" event))
  
  ;; Placeholder for actual business logic
  ;; Subclasses or specific implementations should override this
  (with-handlers ([exn:fail? 
                   (lambda (exn)
                     (displayln (format "Error processing event: ~a" (exn-message exn)))
                     (hash 'error (exn-message exn)))])
    
    ;; Default behavior: return the event as-is
    event))

;; Provide the handler for external use
(provide handle-event)
