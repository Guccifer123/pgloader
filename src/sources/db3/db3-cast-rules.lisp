;;;
;;; Tools to handle MySQL data type casting rules
;;;

(in-package :pgloader.source.db3)

;;;
;;; The default DB3 Type Casting Rules
;;;
(defparameter *db3-default-cast-rules*
  `((:source (:type "C")
     :target (:type "text")
     :using pgloader.transforms::db3-trim-string)

    (:source (:type "N")
     :target (:type "numeric")
     :using pgloader.transforms::db3-numeric-to-pgsql-numeric)

    (:source (:type "L")
     :target (:type "boolean")
     :using pgloader.transforms::logical-to-boolean)

    (:source (:type "D")
     :target (:type "date")
     :using pgloader.transforms::db3-date-to-pgsql-date)

    (:source (:type "M")
     :target (:type "text")
     :using pgloader.transforms::db3-trim-string))
  "Data Type Casting rules to migrate from DB3 to PostgreSQL")

(defstruct (db3-field
	     (:constructor make-db3-field (name type length)))
  name type length default (nullable t) extra)

(defmethod cast ((field db3-field) &key table)
  "Return the PostgreSQL type definition given the DB3 one."
  (let ((table-name (table-name table)))
    (with-slots (name type length default nullable extra) field
      (apply-casting-rules table-name name type type default nullable extra))))
