;; Adventurer Passport - Global explorer identity and journey tracking system
;; This contract maintains adventurer preferences, wishlist destinations, and expedition records

;; Core storage mapping for all registered adventurers
(define-map explorer-registry
    principal  ;; Explorer's blockchain identifier
    {
        explorer-alias: (string-ascii 100),      ;; Public expedition name for the adventurer
        age-count: uint,                         ;; Number of years the adventurer has existed
        passions: (list 10 (string-ascii 50)),   ;; What brings joy to this explorer's journeys
        dream-destinations: (list 5 (string-ascii 100)),  ;; Lands yet to be conquered
        expedition-history: (list 5 (string-ascii 100))   ;; Chronicles of past adventures
    }
)

