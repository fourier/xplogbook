(ql:quickload "split-sequence")
(ql:quickload "simple-date-time")
(ql:quickload "parse-float")

(use-package :simple-date-time)

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

(defclass xplog-entry ()
  ((tail-number :initarg :tail-number :reader tail-number)
   (date :initarg :date :reader date)
   (aircraft :initarg :aircraft :reader aircraft)
   (departure :initarg :departure :reader departure)
   (arrival :initarg :arrival :reader arrival)
   (landings :initarg :landings :reader landings)
   (flight-time :initarg :flight-time :reader flight-time)
   (night-time :initarg :night-time :reader night-time)
   (instrument-time :initarg :instrument-time :reader instrument-time)
   (cross-country-time :initarg :cross-country-time :reader cross-country-time)))

(defun make-date-from-entry (entry)
  (make-date (+ 2000 (parse-integer (subseq entry 0 2)))
             (parse-integer (subseq entry 2 4))
             (parse-integer (subseq entry 4))))

(defmethod print-object ((entry xplog-entry) out)
  (print-unreadable-object (entry out :type t)
    (format out "~a on ~a from ~a to ~a"
            (tail-number entry)
            (yyyy/mm/dd (date entry))
            (departure entry)
            (arrival entry))))

(defun create-xplog-entry-from-line (line)
  (let ((parsed (split-sequence:split-sequence #\Space line :remove-empty-subseqs t)))
    (make-instance 'xplog-entry
                   :tail-number (nth 9 parsed)
                   :date (make-date-from-entry (nth 1 parsed))
                   :aircraft (nth 10 parsed)
                   :departure (nth 2 parsed)
                   :arrival (nth 3 parsed)
                   :landings (parse-integer (nth 4 parsed))
                   :flight-time (parse-float:parse-float (nth 5 parsed))
                   :night-time (parse-float:parse-float (nth 6 parsed))
                   :instrument-time (parse-float:parse-float (nth 7 parsed))
                   :cross-country-time (parse-float:parse-float (nth 8 parsed)))))


(defun parse-xplog (filename)
  (let ((entries (butlast (cddr (read-lines (pathname filename))))))
    (mapcar 'create-xplog-entry-from-line entries)))


(defun print-stats (entries)
  (labels ((get-stats (entries-list)
           (let ((ttime (reduce #'(lambda (x y) (+ x (flight-time y))) entries-list :initial-value 0))
                 (ntime (reduce #'(lambda (x y) (+ x (night-time y))) entries-list :initial-value 0))
                 (lnds (reduce #'(lambda (x y) (+ x (landings y))) entries-list :initial-value 0)))
             (values ttime ntime lnds)))
           (print-local-stats (entries-list)
             (multiple-value-bind (ttime ntime lnds)
                 (get-stats entries-list)
               (format *standard-output* "Flight time: ~1$ hours~%" ttime)
               (format *standard-output* "Night flight time: ~1$ hours~%" ntime)
               (format *standard-output* "Number of landings: ~a~%" lnds))))
    (format *standard-output* "Total statistics ~%=======================~%")
    (print-local-stats entries)
    (let ((per-aircraft (make-hash-table :test 'equal)))
      (format *standard-output* "~%Airplanes used:~%")
      (dolist (x entries)
        (push x (gethash (aircraft x) per-aircraft)))
      (maphash #'(lambda (k v)
                   (declare (ignore v))
                   (format *standard-output* "~a~%" k))
               per-aircraft)
      (format *standard-output* "~%Statistics per airplane~%=======================~%")
      (maphash #'(lambda (k v)
                   (format *standard-output* "~%~a" k)
                   (format *standard-output* "~%-----------------------~%")
                   (print-local-stats v))
               per-aircraft))))
      
;; usage example:
;; (setf entries (parse-xplog (merge-pathnames *xplane-logbook-path* *xplane-logbook-name*)))
;; (print-stats entries)    



