#-quicklisp
(let ((quicklisp-init (merge-pathnames ".quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;; add Sources/ directory to quicklisp local directories
(push #P"/Users/alexeyv/Sources/" ql:*local-project-directories*)
(ql:register-local-projects)

(ql:quickload :xplogbook)

(save-lisp-and-die "xplogbook" :executable t :toplevel #'xplogbook:main)
