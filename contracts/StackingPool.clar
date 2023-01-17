
;; title: StackingPool
;; version:
;; summary:
;; description:

;; traits
;;

;; errors
(define-constant ERR-NOT-AUTHORIZED (err u1000))

;; token definitions
;; 

;; constants
;;

;; data vars
;;
(define-data-var contract-owner principal tx-sender) ;; msg.sender as contract-owner
(define-data-var ratio uint u870000000000000000) ;; 0.87 WAD ratio


;; data maps
;;

;; public functions
;;
(define-public (stack (amount uint)) 
    (stx-transfer? amount tx-sender (as-contract tx-sender)))  ;; transfer stacks to address(this)
                                                ;; mint stSTX to tx-sender as much as
                                                ;; amount * ratio / WAD

(define-public (changeRatio (newRatio uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (var-set ratio newRatio)
  )
)


;; read only functions
;;
(define-read-only (get-ratio)
  (var-get ratio))

;; private functions
;;

