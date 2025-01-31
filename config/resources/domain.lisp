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
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/cases/")
  :on-path "cases"
  )

(define-resource annotation ()
  :class (s-prefix "oa:Annotation")
  :properties `((:created :datetime ,(s-prefix "dct:created"))
                (:creator :url ,(s-prefix "dct:creator"))
                (:motivated-by :url ,(s-prefix "oa:motivatedBy"))
                )
  :has-one `(
             (decision :via ,(s-prefix "oa:hasTarget")
                       :as "target")
             (authorisable-operation :via ,(s-prefix "oa:hasBody")
                                     :as "body"))
  :resource-base (s-url "http://data.lblod.info/id/annotations")
  :on-path "annotations"
  )
(define-resource review ()
  :class (s-prefix "ext:Review")
  :properties `((:created :datetime ,(s-prefix "dct:created"))
                (:creator :url ,(s-prefix "dct:creator"))
                (:approved :boolean ,(s-prefix "ext:approved"))
                )
  :resource-base (s-url "http://data.lblod.info/id/reviews")
  :on-path "reviews"
  )

(define-resource authorisable-operation ()
  :class (s-prefix "ext:AuthorisableOperation")
  :properties `((:description :string ,(s-prefix "dct:description"))
                )
  :has-one `((review :via ,(s-prefix "ext:hasReview")
                    :as "review"))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/authorisable-operation")
  :on-path "authorisable-operations"
  )
(define-resource plan ()
  :class (s-prefix "oe:Plan")
  :properties `((:identifier :string ,(s-prefix "dct:identifier")))
  :has-many `((designation-object :via ,(s-prefix "ext:hasPlan")
                                  :inverse t
                                  :as "designation-objects"))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/plans/")
  :on-path "plans"
  )

(define-resource designation-object ()
  :class (s-prefix "oe:Aanduidingsobject")
  :properties `(
                (:full-address :string ,(s-prefix "locn:fullAddress"))
                (:admin-unit-name :string ,(s-prefix "adres:Gemeentenaam"))
                (:name :string ,(s-prefix "sdo:name"))
                (:keywords :string ,(s-prefix "sdo:keyword")))
  :has-one `(
             (identifier :via ,(s-prefix "adms:identifier")
                          :as "identifier"))
  :has-many `((decision :via ,(s-prefix "eli:cites")
                        :inverse t
                        :as "decisions")
              (plan :via ,(s-prefix "ext:hasPlan")
                    :as "plans"))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/designation-objects/")
  :on-path "designation-objects"
  )

(define-resource decision ()
  :class (s-prefix "oe:Besluit")
  :properties `((:publication-date :datetime ,(s-prefix "dct:issued"))
                (:legal-implications :string ,(s-prefix "oe:rechtsgevolgen"))
                ;; (:actions-requiring-permission ,)
                (:identifier :string ,(s-prefix "dct:identifier")))
  :has-many `((designation-object :via ,(s-prefix "eli:cites")
                                   :as "designation-objects")
              (remote-file :via ,(s-prefix "ext:file")
                           :as "files")
              (annotation :via ,(s-prefix "oa:hasTarget")
                          :inverse t
                          :as "annotations"))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/decisions/")
  :on-path "decisions"
  )

(define-resource remote-file ()
  :class (s-prefix "nfo:RemoteDataObject")
  :properties `((:filename      :string     ,(s-prefix "nfo:fileName"))
                (:format        :string     ,(s-prefix "dct:format"))
                (:size          :integer    ,(s-prefix "nfo:fileSize"))
                (:url      :url   ,(s-prefix "nie:url")))
  :features `(include-uri)
  :resource-base (s-url "http://data.nove.eu/remote-files/")
  :on-path "remote-files")

(define-resource postal-item ()
  :class (s-prefix "oe:Poststuk")
  :properties `((:body :string ,(s-prefix "rdf:value")))
  :features '(include-uri)
  :resource-base (s-url "http://data.lblod.info/id/postal-items/")
  :on-path "postal-items"
  )

(define-resource identifier ()
  :class (s-prefix "adms:Identifier")
  :properties `((:identifier :string ,(s-prefix "skos:notation")))
  :resource-base (s-url "http://data.lblod.info/id/identifiers/")
  :features '(include-uri)
  :on-path "identifiers")


;; reading in the domain.json
;; (read-domain-file "domain.json")
