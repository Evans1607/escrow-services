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

;; 1. Initialize Escrow
(define-public (initialize (new-payee principal) (new-amount uint))
  (begin
    ;; Ensure the contract has not been initialized
    (asserts! (is-eq (var-get payer) none) (err u100)) ;; Escrow already initialized
    ;; Ensure amount is greater than zero
    (asserts! (> new-amount u0) (err u110)) ;; Amount must be greater than zero
    ;; Ensure payee is not the contract itself
    (asserts! (not (is-eq new-payee (as-contract tx-sender))) (err u111)) ;; Invalid payee address
    ;; Set the payer, payee, and amount
    (var-set payer (some tx-sender))
    (var-set payee (some new-payee))
    (var-set amount new-amount)
    (var-set is-locked false)
    (ok true)
  )
)

;; 2. Deposit Funds
(define-public (deposit)
  (begin
    ;; Ensure the sender is the payer
    (asserts! (is-payer) (err u101)) ;; Only payer can deposit
    ;; Ensure the contract is not already locked
    (asserts! (not (var-get is-locked)) (err u102)) ;; Escrow already funded
    ;; Ensure the sender has sent the correct amount
    (asserts! (is-ok (stx-transfer? (var-get amount) tx-sender (as-contract tx-sender))) (err u103)) ;; Transfer failed
    ;; Lock the funds
    (var-set is-locked true)
    (ok true)
  )
)

;; 3. Release Funds to Payee
(define-public (release)
  (begin
    ;; Ensure the sender is the payer
    (asserts! (is-payer) (err u104)) ;; Only payer can release funds
    ;; Ensure the funds are locked
    (asserts! (var-get is-locked) (err u105)) ;; Escrow not funded
    ;; Transfer funds to the payee
    (asserts! (is-ok (stx-transfer? (var-get amount) (as-contract tx-sender) (unwrap-panic (var-get payee)))) (err u106)) ;; Transfer failed
    ;; Reset the contract
    (var-set payer none)
    (var-set payee none)
    (var-set amount u0)
    (var-set is-locked false)
    (ok true)
  )
)

;; 4. Cancel and Refund Payer
(define-public (cancel)
  (begin
    ;; Ensure the sender is the payer
    (asserts! (is-payer) (err u107)) ;; Only payer can cancel
    ;; Ensure the funds are locked
    (asserts! (var-get is-locked) (err u108)) ;; Escrow not funded
    ;; Transfer funds back to the payer
    (let ((transfer-result (stx-transfer? (var-get amount) (as-contract tx-sender) (unwrap-panic (var-get payer)))))
      (asserts! (is-ok transfer-result) (err u109)) ;; Refund failed
      ;; Reset the contract
      (var-set payer none)
      (var-set payee none)
      (var-set amount u0)
      (var-set is-locked false)
      (ok true))
  )
)
