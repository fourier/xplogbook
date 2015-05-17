;;;; xplogbook.asd

(asdf:defsystem #:xplogbook
  :description "Describe xplogbook here"
  :author "Alexey Veretennikov <EMAIL-REDACTED>"
  :licence "GPL"
  :depends-on (#:split-sequence
               #:simple-date-time
               #:parse-float
               #:cl-annot)
  :serial t
  :components ((:file "package")
               (:file "xplogbook")))

