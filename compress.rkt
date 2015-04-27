#lang racket
(require file/zip)
(require file/tar)
(define (delifexist f)
  (cond [(file-exists? f) (delete-file f)]
        [else empty]))
(define (winzip)
  (zip "release\\windist.zip" "dist/"))
(define (tuxgz)
  (tar-gzip "release/tuxdust.tar.gz" "dist/"))
(cond [(not (directory-exists? "release")) (make-directory "release")]
      [else (delifexist "release\\windist.zip")
	    (delifexist "release/tuxdist.tar.gz")])
(local [(define sys (system-type))]
  (cond [(equal? sys 'windows) (winzip)]
        [else (tuxgz)]))
