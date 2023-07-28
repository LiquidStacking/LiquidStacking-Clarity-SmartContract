
;; title: StackedSTX
;; version: 
;; summary:
;; description:
;; This contract accepts STX and returns stSTX in return
;; current contract is a MockStackingPool contract which was influenced by EIP4626
;; https://eips.ethereum.org/EIPS/eip-4626



;; traits
(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)


;; errors
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; token definitions
;; 
(define-fungible-token mock-stacked-stx)


;; constants
;;

;; data vars
;;
(define-data-var token-uri (string-utf8 256) u"https://liquidstacking.xyz/")
(define-data-var contract-owner principal tx-sender) ;; msg.sender as contract-owner
(define-data-var ratio uint u870000) ;; 0.87 mil ratio
(define-data-var mil uint u1000000) ;; 


;; data maps
;;
(define-map approved-contracts principal bool)


;; public functions
;;
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (try! (ft-transfer? mock-stacked-stx amount sender recipient))
        (match memo to-print (print to-print) 0x)
        (ok true)
    )
)


(define-public (stack (amount uint)) 
    (begin
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))  ;; transfer stacks to address(this)
        (mint (/ (* amount (var-get ratio)) u1000000) tx-sender) ;; mint stSTX to tx-sender as much as amount * ratio / mil
   )
) 

(define-public (unstack (amount uint)) 
    (let ((caller tx-sender))
    (begin
        (try! (ft-transfer? mock-stacked-stx amount tx-sender (as-contract tx-sender)))
        (as-contract (stx-transfer? (/ (* amount (var-get mil)) (var-get ratio)) tx-sender caller))
    )
    )
)

                                            
(define-public (changeRatio (newRatio uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (ok (var-set ratio newRatio))
  )
)


;; read only functions
;;
(define-read-only (get-name)
    (ok "Mock-Stacked-STX")
)

(define-read-only (get-symbol)
    (ok "stSTX")
)

(define-read-only (get-ratio)
  (ok (var-get ratio)))

(define-read-only (get-decimals)
    (ok u6)
)

(define-read-only (get-balance (who principal))
    (ok (ft-get-balance mock-stacked-stx who))
)

(define-read-only (get-total-supply)
    (ok (ft-get-supply mock-stacked-stx))
)

(define-read-only (get-token-uri)
    (ok (some (var-get token-uri)))
)




;; private functions
;;

(define-private (mint (amount uint) (recipient principal))
    (begin
        (ft-mint? mock-stacked-stx amount recipient)
    )
)


