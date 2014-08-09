(defparameter *xplane-logbook-path* "/Users/alexeyv/Library/Application Support/Steam/SteamApps/common/X-Plane 10/Output/logbooks/")

(defparameter *xplane-logbook-name* "X-Plane Pilot.txt")

(defun read-lines (stream)
  ;; check if not nil
  (when stream
    ;; if the argument is a pathname, open it as a stream and call again
    (if (typep stream 'pathname)
        (with-open-file (real-stream stream)
          (read-lines real-stream))
        ;; otherwise determine type and create a stream if it is a string
        (let ((in 
               (ctypecase stream
                 (string (make-string-input-stream stream))
                 (stream stream))))
          ;; internal iteration function to make tail-recursive call
          (labels ((read-lines-iter (lines)
                     (let ((l (read-line in nil 'eof)))
                       (if (eq l 'eof)
                           (reverse lines)
                           (read-lines-iter (cons l lines))))))
            (read-lines-iter nil))))))

  



(with-open-file (file (merge-pathnames *xplane-logbook-path* *xplane-logbook-name*))
  (read-lines file nil))
    



