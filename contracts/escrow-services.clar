;; Escrow Contract
;; Allows a payer to lock funds until certain conditions are met, and then release them to the payee.

(define-data-var payer (optional principal) (some tx-sender)) ;; Address of the payer
(define-data-var payee (optional principal) (some tx-sender)) ;; Address of the payee
(define-data-var amount uint u0)       ;; Amount of funds locked
(define-data-var is-locked bool false) ;; Lock status

;; Allow only the payer to call specific functions
(define-read-only (is-payer)
  (is-eq tx-sender (unwrap-panic (var-get payer)))
)

;; Allow only the payee to call specific functions
(define-read-only (is-payee)
  (is-eq tx-sender (unwrap-panic (var-get payee)))
)
