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

;; Response codes for protocol communication
(define-constant RESPONSE-NOT-REGISTERED (err u404))     ;; Explorer identity not found in registry
(define-constant RESPONSE-ALREADY-REGISTERED (err u409)) ;; Explorer already has passport
(define-constant RESPONSE-AGE-REQUIREMENT (err u400))    ;; Age requirement not satisfied
(define-constant RESPONSE-NAME-REQUIREMENT (err u401))   ;; Identity name requirement not met
(define-constant RESPONSE-DESTINATION-REQUIREMENT (err u402)) ;; Invalid destination format
(define-constant RESPONSE-PASSION-REQUIREMENT (err u403))     ;; Invalid passions format
(define-constant RESPONSE-HISTORY-REQUIREMENT (err u404))     ;; Invalid expedition history

;; Verification functions section
;; =============================

;; Check if an explorer has registered in the system
(define-read-only (passport-exists? (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok true)      ;; Adventurer found in registry
        (ok false)           ;; No record of this adventurer
    )
)

;; Data retrieval functions section
;; ===============================

;; Retrieve complete explorer profile data
(define-read-only (get-full-passport (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok entry)           ;; Return complete passport data
        RESPONSE-NOT-REGISTERED    ;; Explorer unknown to system
    )
)

;; Extract just the explorer's chosen name
(define-read-only (get-explorer-alias (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (get explorer-alias entry))  ;; Return only alias field
        RESPONSE-NOT-REGISTERED               ;; Explorer unknown to system
    )
)

;; Extract explorer's age information
(define-read-only (get-explorer-age (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (get age-count entry))  ;; Return only age data
        RESPONSE-NOT-REGISTERED          ;; Explorer unknown to system
    )
)

;; Extract explorer's personal interests
(define-read-only (get-explorer-passions (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (get passions entry))  ;; Return list of passions
        RESPONSE-NOT-REGISTERED         ;; Explorer unknown to system
    )
)

;; Retrieve wishlist of future expeditions
(define-read-only (get-dream-destinations (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (get dream-destinations entry))  ;; Return wishlist
        RESPONSE-NOT-REGISTERED                   ;; Explorer unknown to system
    )
)

;; Retrieve record of completed expeditions
(define-read-only (get-expedition-history (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (get expedition-history entry))  ;; Return travel log
        RESPONSE-NOT-REGISTERED                   ;; Explorer unknown to system
    )
)

;; Analytics functions section
;; =========================

;; Calculate quantity of planned expeditions
(define-read-only (count-planned-expeditions (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (len (get dream-destinations entry)))  ;; Count future plans
        RESPONSE-NOT-REGISTERED                         ;; Explorer unknown to system
    )
)

;; Calculate quantity of completed expeditions
(define-read-only (count-completed-expeditions (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok (len (get expedition-history entry)))  ;; Count past adventures
        RESPONSE-NOT-REGISTERED                         ;; Explorer unknown to system
    )
)

;; Generate comprehensive passport statistics
(define-read-only (generate-explorer-summary (explorer-id principal))
    (match (map-get? explorer-registry explorer-id)
        entry (ok {
            explorer-alias: (get explorer-alias entry),
            age-count: (get age-count entry),
            passions-count: (len (get passions entry)),
            dream-destinations-count: (len (get dream-destinations entry)),
            expedition-history-count: (len (get expedition-history entry))
        })  ;; Return compiled statistics about explorer
        RESPONSE-NOT-REGISTERED  ;; Explorer unknown to system
    )
)

;; Core passport management functions
;; ================================

;; Register new explorer in the global registry
(define-public (register-new-explorer 
    (explorer-alias (string-ascii 100))
    (age-count uint)
    (passions (list 10 (string-ascii 50)))
    (dream-destinations (list 5 (string-ascii 100)))
    (expedition-history (list 5 (string-ascii 100))))
    (let
        (
            (explorer-id tx-sender)  ;; Use blockchain identity as unique identifier
            (existing-passport (map-get? explorer-registry explorer-id))  ;; Check for existing passport
        )
        ;; Verify explorer isn't already registered
        (if (is-none existing-passport)
            (begin
                ;; Apply expedition protocol requirements
                (if (or (is-eq explorer-alias "")
                        (< age-count u18)                    ;; Minimum age requirement
                        (> age-count u120)                   ;; Maximum age boundary
                        (is-eq (len dream-destinations) u0)  ;; Must have aspirations
                        (is-eq (len passions) u0)            ;; Must have interests
                        (is-eq (len expedition-history) u0)) ;; Must have some travel experience
                    (err RESPONSE-AGE-REQUIREMENT)  ;; Failed validation process
                    (begin
                        ;; Record validated explorer data
                        (map-set explorer-registry explorer-id
                            {
                                explorer-alias: explorer-alias,
                                age-count: age-count,
                                passions: passions,
                                dream-destinations: dream-destinations,
                                expedition-history: expedition-history
                            }
                        )
                        (ok "Explorer successfully registered in global network.")  ;; Registration success
                    )
                )
            )
            (err RESPONSE-ALREADY-REGISTERED)  ;; Cannot register twice
        )
    )
)

;; Update existing explorer passport details
(define-public (update-explorer-passport
    (explorer-alias (string-ascii 100))
    (age-count uint)
    (passions (list 10 (string-ascii 50)))
    (dream-destinations (list 5 (string-ascii 100)))
    (expedition-history (list 5 (string-ascii 100))))
    (let
        (
            (explorer-id tx-sender)  ;; Use blockchain identity as unique identifier
            (existing-passport (map-get? explorer-registry explorer-id))  ;; Verify passport exists
        )
        ;; Confirm explorer has registered previously
        (if (is-some existing-passport)
            (begin
                ;; Validate all submitted passport data
                (if (or (is-eq explorer-alias "")
                        (< age-count u18)                    ;; Below minimum age threshold
                        (> age-count u120)                   ;; Exceeds maximum age threshold
                        (is-eq (len dream-destinations) u0)  ;; No future aspirations specified
                        (is-eq (len passions) u0)            ;; No interests specified
                        (is-eq (len expedition-history) u0)) ;; No travel records provided
                    (err RESPONSE-AGE-REQUIREMENT)  ;; Validation failure
                    (begin
                        ;; Apply updates to explorer passport
                        (map-set explorer-registry explorer-id
                            {
                                explorer-alias: explorer-alias,
                                age-count: age-count,
                                passions: passions,
                                dream-destinations: dream-destinations,
                                expedition-history: expedition-history
                            }
                        )
                        (ok "Explorer passport successfully updated with new journey data.")  ;; Update success
                    )
                )
            )
            (err RESPONSE-NOT-REGISTERED)  ;; Cannot update non-existent passport
        )
    )
)

