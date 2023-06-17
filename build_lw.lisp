(in-package :CL-USER)
(load-all-patches)
#-quicklisp
(let ((quicklisp-init (merge-pathnames ".quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;; add Sources/ directory to quicklisp local directories
(push #P"/Users/alexeyv/Sources/lisp" ql:*local-project-directories*)
(ql:register-local-projects)

(ql:quickload :xplogbook)
(deliver 'xplogbook:main
         "~/Sources/lisp/xplogbook/xplogbook_lw"
         5
         :interface nil
         :multiprocessing nil)

