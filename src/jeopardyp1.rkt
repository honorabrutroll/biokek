#lang racket
(require picturing-programs)
(define-struct posn (x y) #:prefab)
(require rackunit)
(define-struct model (player scores info t q) #:prefab)
;info : list of topics
(define-struct topic (paragraph questions) #:prefab)
;questions : list of questions
(define-struct question (q answers correct) #:prefab)
;answers : list of answers
(define-struct answer (data loc) #:prefab)

(define FONTCOLOR "black")
(define WINSIZE 500)
(define TEXT/LINE 30)

(define INFO (list (make-topic "Start" (list (make-question "The authors of this project are Nico Murolo, Johnny Chen, and Edward Yang. The bulk of this project was written in Racket and Python, with some shellscripting for the build system." (list (make-answer "Continue" (make-posn 200 100)) ) (make-answer "Continue" (make-posn 200 100)) )))
                                         (make-topic "Molecules" (list (make-question "Sodium and Chlorine form a type of bond known as an... (hint: selfish)" (list (make-answer "Covalent Bond" (make-posn 200 100)) (make-answer "Ionic Bond" (make-posn 400 100)) (make-answer "Hydrogen Bond" (make-posn 200 150)) (make-answer "Metallic Bond" (make-posn 400 150)) ) (make-answer "Ionic Bond" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "This type of bond allows the bonded atoms to share electron(s)." (list (make-answer "Metallic Bond" (make-posn 200 100)) (make-answer "Covalent Bond" (make-posn 400 100)) (make-answer "Ionic Bond" (make-posn 200 150)) (make-answer "Hydrogen Bond" (make-posn 400 150)) ) (make-answer "Covalent Bond" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "This allows ice to expand rather than contract when frozen." (list (make-answer "Presence of minor impurities in water" (make-posn 200 100)) (make-answer "Diffusion" (make-posn 400 100)) (make-answer "Hydrogen Bonding" (make-posn 200 150)) (make-answer "Properties of supercooled matter" (make-posn 400 150)) ) (make-answer "Hydrogen Bonding" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "The organic molecule that is known to come mainly from cows." (list (make-answer "Methane" (make-posn 200 100)) (make-answer "CO2" (make-posn 400 100)) (make-answer "Hydrogen Sulfide" (make-posn 200 150)) (make-answer "Arsenic" (make-posn 400 150)) ) (make-answer "Methane" (make-posn 200 100)) )))
                                         (make-topic "Molecules" (list (make-question "This geometric shape allows organic molecules such as Benzene to ramin extremely stable." (list (make-answer "Octoganol" (make-posn 200 100)) (make-answer "Triangular" (make-posn 400 100)) (make-answer "Hexagonal" (make-posn 200 150)) (make-answer "Pentagonal" (make-posn 400 150)) ) (make-answer "Hexagonal" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "A gas commonly used for lighter or torch fuel that has a chemical formula of C4H10" (list (make-answer "Natural Gas" (make-posn 200 100)) (make-answer "Carbon Dioxide" (make-posn 400 100)) (make-answer "Butane" (make-posn 200 150)) (make-answer "C4" (make-posn 400 150)) ) (make-answer "Butane" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "The 3 Phosphate groups attached to an adenosine allow this molecule to be an effective energy carrier" (list (make-answer "DNA" (make-posn 200 100)) (make-answer "ATP" (make-posn 400 100)) (make-answer "AMP" (make-posn 200 150)) (make-answer "ATP" (make-posn 400 150)) ) (make-answer "ATP" (make-posn 400 150)) )))
                                         ))
(define (game-over m p)
  (make-model (model-player m)
              (if (equal? 1 p)
                  (make-posn (+ 20 (posn-x (model-scores m))) (posn-y (model-scores m)))
                  (make-posn (posn-x (model-scores m)) (+ 20 (posn-y (model-scores m)))))
              (list (make-topic "" (list (make-question "Game over!"
                                                                                          `()
                                                                                          (make-answer "kek" (make-posn 50 100)))))) 0 0))

(define (start-game player)
  (make-model player (make-posn 0 0) INFO 0 0))

(define (one-word l)
  (cond [(empty? l) `()]
        [(not (equal? (first l) #\space)) (cons (first l) (one-word (rest l)))]
        [else (list)]))
(equal? (one-word (list #\h #\i #\space #\k)) (list #\h #\i))

(define (rest-word l)
  (cond [(empty? l) `()]
        [(equal? (first l) #\space) (rest l)]
        [else (rest-word (rest l))]))
(equal? (rest-word (list #\space #\k #\i)) (list #\k #\i))

(define (font-helper str cur)
  (cond [(equal? str "") `()]
        [(<= (+ 1 cur (length (one-word (string->list str)))) TEXT/LINE) (append (one-word (string->list str))
                                                                                 (list #\space)
                                                                               (font-helper (list->string (rest-word (string->list str)))
                                                                                            (+ cur (length (one-word (string->list str)))))
                                                                               )]
        [else `()]))
(equal? (list->string (font-helper "fkekl fkekl fkekl hi" 0)) "fkekl fkekl fkekl hi ")

(define (rest-font-helper str cur)
  (cond [(equal? str "") `()]
        [(>= (+ 1 cur (length (one-word (string->list str)))) TEXT/LINE) (string->list str)]
        [else (rest-font-helper (list->string (rest-word (string->list str))) (+ cur (length (one-word (string->list str)))))]))
(equal? (list->string (rest-font-helper "fkekl fkekl fkekl hi fkekl lol p kfd" 0)) "kfd")

(define (finish-fonts str)
  (cond [(equal? str "") (square 0 "solid" "black")]
        [else (above/align "left" (text (list->string (font-helper str 0)) 12 FONTCOLOR)
                     (finish-fonts (list->string (rest-font-helper str 0))))]))

(define (font str)
  (finish-fonts str))

(define (send i)
  (make-package i (if (equal? (model-player i) 1)
                      (make-model 2 (model-scores i) (model-info i) (model-t i) (model-q i))
                      (make-model 1 (model-scores i) (model-info i) (model-t i) (model-q i)))))

;string or img -> int
(define (len ans)
  (cond [(string? ans) (image-width (font ans))]
        [else (image-width ans)]))
(define (height ans)
  (cond [(string? ans) (image-height (font ans))]
        [else (image-height ans)]))

;posn mouse, answer a -> bool
(define (touching? mouse a)
  (if (and (and (<= (posn-x mouse) (+ (posn-x (answer-loc a)) (/ (len (answer-data a)) 2)))
                (>= (posn-x mouse) (- (posn-x (answer-loc a)) (/ (len (answer-data a)) 2))))
           (and (<= (posn-y mouse) (+ (posn-y (answer-loc a)) (/ (height (answer-data a)) 2)))
                (>= (posn-y mouse) (- (posn-y (answer-loc a)) (/ (height (answer-data a)) 2)))))
      true
      false))

;posn i, list of answers l -> false or answer
(define (find-clicked i l)
  (cond [(empty? l) false]
        [(touching? i (first l)) (first l)]
        [else (find-clicked i (rest l))]))

;model m -> topic
(define (current-topic m)
  (list-ref (model-info m) (model-t m)))

;model m -> question
(define (current-question m)
  (list-ref (topic-questions (current-topic m)) (model-q m)))

;info i, topic t -> info
(define (nullify-paragraph i t)
 (cond [(empty? i) (list)]
       [(equal? (first i) t) (cons (make-topic "" (topic-questions (first i))) (nullify-paragraph (rest i) t))]
       [else (cons (first i) (nullify-paragraph (rest i) t))]))

;model m -> bool
(define (next-question-new-topic? m)
  (if (equal? (length (topic-questions (current-topic m))) (+ 1 (model-q m)))
      true
      false))

;int p, topic t, question q, model m -> model
(define (award-point p t q m)
  (if (equal? p 1)
      (if (= (+ (model-t m) 1) (length (model-info m)))
          (send (game-over m p))
      (send (make-model p
                        (make-posn (+ 20 (posn-x (model-scores m))) (posn-y (model-scores m)))
                        (model-info m)
                        (if (next-question-new-topic? m)
                            (+ 1 (model-t m))
                            (model-t m))
                        (if (next-question-new-topic? m)
                            0
                            (+ (model-q m) 1)))))
      (if (= (+ (model-t m) 1) (length (model-info m)))
          (send (game-over m p))
          (send (make-model p
                        (make-posn (posn-x (model-scores m)) (+ 20 (posn-y (model-scores m))))
                        (model-info m)
                        (if (next-question-new-topic? m)
                            (+ 1 (model-t m))
                            (model-t m))
                        (if (next-question-new-topic? m)
                            0
                            (+ (model-q m) 1)))))))

(define (replace item newitem lst)
  (local [(define (repl x)
            (cond [(equal? item x) newitem]
                  [else x]))]
    (map repl lst)))

(define (remansw ans q top info)
  (replace top (make-topic (topic-paragraph top) 
                           (replace q (make-question (question-q q) 
                                                     (remove ans (question-answers q))
                                                     (question-correct q)) 
                                    (topic-questions top))) 
           info))

(define (remove-point p t q m a)
  (if (equal? p 1)
      (send (make-model p
                        (make-posn (- (posn-x (model-scores m)) 5) (posn-y (model-scores m)))
                        (remansw a (current-question m) (current-topic m) (model-info m))
                        (model-t m)
                        (model-q m)))
      (send (make-model p
                        (make-posn (posn-x (model-scores m)) (- (posn-y (model-scores m)) 5))
                        (remansw a (current-question m) (current-topic m) (model-info m))
                        (model-t m)
                        (model-q m)))))

;bool r, int p, answer a, model m -> model
(define (credit-answer r p a m)
  (if r
      (if (equal? p 1)
          (award-point 1 (current-topic m) (current-question m) m)
          (award-point 2 (current-topic m) (current-question m) m))
      (if (equal? p 1)
          (remove-point 1 (current-topic m) (current-question m) m a)
          (remove-point 2 (current-topic m) (current-question m) m a))))

;answer a, question q, int p, model m -> model
(define (check-answer a q p m)
  (cond [(equal? a (question-correct q)) (credit-answer true p a m)]
        [else (credit-answer false p a m)]))

(define (mouse-handler old x y event)
  (cond [(and (equal? event "button-down") (not (equal? "" (topic-paragraph (current-topic old)))))
         (send (make-model (model-player old)
                           (model-scores old)
                           (nullify-paragraph (model-info old) (current-topic old))
                           (model-t old)
                           (model-q old)))]
         [(equal? event "button-down") (if (not (equal?
                                                (find-clicked (make-posn x y) (question-answers (current-question old)))
                                               false))
                                          (check-answer (find-clicked (make-posn x y) (question-answers (current-question old)))
                                                        (current-question old)
                                                        (model-player old)
                                                        old)
                                          (send old))]
        [else (send old)]))

(define (receive-func model msg)
  msg)

(define (draw-scores m)
  (place-image (above (text (string-append "Player 1: " (number->string (posn-x (model-scores m)))) 12 "black")
                      (text (string-append "Player 2: " (number->string (posn-y (model-scores m)))) 12 "black"))
               (- WINSIZE (/ (image-width (above (text (string-append "Player 1: " (number->string (posn-x (model-scores m)))) 12 "black")
                                              (text (string-append "Player 2: " (number->string (posn-y (model-scores m)))) 12 "black"))) 2))
               (/ (image-height (above (text (string-append "Player 1: " (number->string (posn-x (model-scores m)))) 12 "black")
                                    (text (string-append "Player 2: " (number->string (posn-y (model-scores m)))) 12 "black"))) 2)
               (square WINSIZE "solid" (make-color 0 0 0 0))))

(define (draw-question m)
  (place-image (font (question-q (current-question m)))
               (/ (image-width (font (question-q (current-question m)))) 2)
               (/ (image-height (font (question-q (current-question m)))) 2)
               (square WINSIZE "solid" (make-color 0 0 0 0))))

(define (draw-answers l)
  (cond [(empty? l) (square WINSIZE "solid" (make-color 0 0 0 0))]
        [else (place-image (overlay (if (string? (answer-data (first l)))
                                        (font (answer-data (first l)))
                                        (answer-data (first l)))
                                    (rectangle (+ 2 (image-width (if (string? (answer-data (first l)))
                                                                     (font (answer-data (first l)))
                                                                     (answer-data (first l)))))
                                               (+ 2 (image-height (if (string? (answer-data (first l)))
                                                                      (font (answer-data (first l)))
                                                                      (answer-data (first l)))))
                                               "outline"
                                               "black"))
                           (posn-x (answer-loc (first l)))
                           (posn-y (answer-loc (first l)))
                           (draw-answers (rest l)))]))

(define (main-drawer m)
  (overlay (draw-scores m) (draw-question m) (draw-answers (question-answers (current-question m)))))

(define (draw-handler m)
  (cond [(not (equal? "" (topic-paragraph (current-topic m)))) (font (topic-paragraph (current-topic m)))]
        [else (main-drawer m)]))

(big-bang (start-game 1)
          (on-mouse mouse-handler)
          (on-receive receive-func)
          (register "127.0.0.1")
          (on-draw draw-handler 500 500))
