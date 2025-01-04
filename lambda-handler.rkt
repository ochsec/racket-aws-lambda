#lang racket/base

(require json)

(define (handle-event event context)
  (let* ([name (hash-ref event 'name "World")]
         [response (hash 'message (string-append "Hello, " name "!"))])
    response))

(provide handle-event)
