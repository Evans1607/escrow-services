;; Escrow Contract
;; Allows a payer to lock funds until certain conditions are met, and then release them to the payee.

(define-data-var payer (optional principal) (some tx-sender)) ;; Address of the payer
(define-data-var payee (optional principal) (some tx-sender)) ;; Address of the payee
(define-data-var amount uint u0)       ;; Amount of funds locked
(define-data-var is-locked bool false) ;; Lock status

