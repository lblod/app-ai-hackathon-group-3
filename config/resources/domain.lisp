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

(define-resource plan ()
  :class (s-prefix "oe:Plan")
  :properties `((:identifier :string ,(s-prefix "dct:identifier")))
  :resource-base (s-url "http://data.lblod.info/id/plans/")
  :has-many `((designation-object :via ,(s-prefix "ext:hasPlan")
                                  :inverse t
                                  :as "designation-objects"))

  :on-path "plans"
  :features '(include-uri)
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
                (:actions-requiring-permission ,)
                (:identifier :string ,(s-prefix "dct:identifier")))
  :has-many `((designation-object :via ,(s-prefix "eli:cites")
                                   :as "designation-objects")
              (remote-file :via ,(s-prefix "ext:file")
                           :as "files"))
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
