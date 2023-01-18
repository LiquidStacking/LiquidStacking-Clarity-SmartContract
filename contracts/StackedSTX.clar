
;; title: StackedSTX
;; version: 
;; summary:
;; description:
;; This contract accepts STX and returns stSTX in return
;; current contract is a MockStackingPool contract which was influenced by EIP4626
;; https://eips.ethereum.org/EIPS/eip-4626



;; traits
;;
;; (impl-trait .trait-sip-010.sip-010-trait)


;; errors
(define-constant ERR-NOT-AUTHORIZED (err u1000))

;; token definitions
;; 
(define-fungible-token mock-stacked-stx)


;; constants
;;

;; data vars
;;
(define-data-var contract-owner principal tx-sender) ;; msg.sender as contract-owner
(define-data-var ratio uint u870000000000000000) ;; 0.87 WAD ratio


;; data maps
;;
(define-map approved-contracts principal bool)


;; public functions
;;
(define-public (stack (amount uint)) 
    (stx-transfer? amount tx-sender (as-contract tx-sender)))  ;; transfer stacks to address(this)
                                                ;; mint stSTX to tx-sender as much as
                                                ;; amount * ratio / WAD

(define-public (changeRatio (newRatio uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (ok (var-set ratio newRatio))
  )
)


;; read only functions
;;
(define-read-only (get-ratio)
  (var-get ratio))

;; private functions
;;

