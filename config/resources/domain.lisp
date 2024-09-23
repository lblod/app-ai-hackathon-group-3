(in-package :mu-cl-resources)

(setf *include-count-in-paginated-responses* t)
(setf *supply-cache-headers-p* t)
(setf sparql:*experimental-no-application-graph-for-sudo-select-queries* t)
(setf *cache-model-properties-p* t)

(define-resource case ()
  :class (s-prefix "oe:Dossier")
  :properties `(
                (:created :datetime ,(s-prefix "dct:created")))
  :has-one `(
             (postal-item :via ,(s-prefix "oe:dos_werdOpgestartDoorPoststuk")
                          :as "started-by")
             (designation-object :via ,(s-prefix "oe:dos_handeltPrimairOver")
                                 :as "primary-subject")
             )
  :has-many `((contact-point :via ,(s-prefix "schema:contactPoint")
                             :as "contact-points"))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/cases/")
  :on-path "cases"
  )

(define-resource designation-object ()
  :class (s-prefix "oe:Aanduidingsobject")
  :properties `(
                (:full-address :string ,(s-prefix "locn:fullAddress"))
                (:admin-unit-name :string ,(s-prefix "adres:Gemeentenaam"))
                (:name :string ,(s-prefix "sdo:name"))
                (:keywords :string ,(s-prefix "sdo:keyword"))
                (:identifier :string ,(s-prefix "generiek:lokaleIndentificator")))
  :has-one `((address-representation :via ,(s-prefix "locn:address")
                                     :as "address")
             )
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/designation-objects/")
  :on-path "designation-objects"
  )

(define-resource postal-item ()
  :class (s-prefix "oe:Poststuk")
  :properties `((:body :string ,(s-prefix "rdf:value")))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/postal-items/")
  :on-path "postal-items"
  )

;; reading in the domain.json
;; (read-domain-file "domain.json")
