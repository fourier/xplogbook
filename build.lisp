(require 'asdf)
(push *default-pathname-defaults* asdf:*central-registry*) 
(load "xplogbook.lisp")
(save-lisp-and-die "xplogbook" :executable t :toplevel #'main)
