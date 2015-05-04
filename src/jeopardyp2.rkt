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

(define INFO (list (make-topic "Topic" (list (make-question "Question" (list (make-answer "possible answer 4" (make-posn 200 100)) (make-answer "possible answer 2" (make-posn 400 100)) (make-answer "Correct answer" (make-posn 200 150)) (make-answer "possible answer 3" (make-posn 400 150)) ) (make-answer "Correct answer" (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "Chloroplast is a structure containing chlorophyll (a special pigment). What makes chlorophyll so special?" (list (make-answer "Chlorophyll can absorb light to transform it into chemical energy." (make-posn 200 100)) (make-answer "Chlorophyll is the center of cell synthesis in a plant" (make-posn 400 100)) (make-answer "Chlorophyll fulfills all the roles of that cells would have otherwise done." (make-posn 200 150)) (make-answer "Chlorophyll can change color depending on the season" (make-posn 400 150)) ) (make-answer "Chlorophyll can absorb light to transform it into chemical energy." (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Which of these is the name of the entire process in which plants transform energy?" (list (make-answer "Photosynthesis" (make-posn 200 100)) (make-answer "Kreb Cycle" (make-posn 400 100)) (make-answer "Light Absorption" (make-posn 200 150)) (make-answer "Calvin Cycle" (make-posn 400 150)) ) (make-answer "Photosynthesis" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "In which of these processes is the ETC directly involved?" (list (make-answer "Light Reaction" (make-posn 200 100)) (make-answer "Dark Reaction" (make-posn 400 100)) (make-answer "Glycolysis" (make-posn 200 150)) (make-answer "Kreb Cycle" (make-posn 400 150)) ) (make-answer "Light Reaction" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "In which photosystem is light absorbed in photosynthesis?" (list (make-answer "Photosystem III" (make-posn 200 100)) (make-answer "Photosystems I and II" (make-posn 400 100)) (make-answer "Photosystem I" (make-posn 200 150)) (make-answer "Photosystem II" (make-posn 400 150)) ) (make-answer "Photosystems I and II" (make-posn 400 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Glycolysis is a process which converts..." (list (make-answer "glucose to maltose" (make-posn 200 100)) (make-answer "maltose to glucose" (make-posn 400 100)) (make-answer "glucose to pyruvate" (make-posn 200 150)) (make-answer "pyruvate to glucose" (make-posn 400 150)) ) (make-answer "glucose to pyruvate" (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "In which reaction (also known as a dark reaction) do plants create sugar?" (list (make-answer "Calvin Cycle" (make-posn 200 100)) (make-answer "Energy Transfer" (make-posn 400 100)) (make-answer "Citric Acid Cycle" (make-posn 200 150)) (make-answer "Glycolysis" (make-posn 400 150)) ) (make-answer "Calvin Cycle" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "In the gas exchange, which two gases are typically involved?" (list (make-answer "Nitrogen and Hydrogen" (make-posn 200 100)) (make-answer "Oxygen and CO2" (make-posn 400 100)) (make-answer "CO2 and Hydrogen" (make-posn 200 150)) (make-answer "Oxygen and Nitrogen" (make-posn 400 150)) ) (make-answer "Oxygen and CO2" (make-posn 400 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Which molecule is primarily used in cellular energy transfer?" (list (make-answer "ATP" (make-posn 200 100)) (make-answer "ADP" (make-posn 400 100)) (make-answer "Phosphates in general" (make-posn 200 150)) (make-answer "AMP" (make-posn 400 150)) ) (make-answer "ATP" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Which type of molecule is NOT used in protein synthesis?" (list (make-answer "DNA" (make-posn 200 100)) (make-answer "NA" (make-posn 400 100)) (make-answer "Fatty Acids" (make-posn 200 150)) (make-answer "Amino Acids" (make-posn 400 150)) ) (make-answer "Fatty Acids" (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "Glucose is broken down in..." (list (make-answer "Hydrolysis" (make-posn 200 100)) (make-answer "Dehydrolysis" (make-posn 400 100)) (make-answer "the Krebs Cycle" (make-posn 200 150)) (make-answer "Glucose Desynthesis" (make-posn 400 150)) ) (make-answer "the Krebs Cycle" (make-posn 200 150)) )))
                                         (make-topic "Water" (list (make-question "In diffusion across a membrane, molecules move from a" (list (make-answer "lower concentration to a higher concentration" (make-posn 200 100)) (make-answer "darker place to a ligher place" (make-posn 400 100)) (make-answer "higher concentration to a lower concentration" (make-posn 200 150)) (make-answer "lighter place to a darker place" (make-posn 400 150)) ) (make-answer "higher concentration to a lower concentration" (make-posn 200 150)) )))
                                         (make-topic "Water" (list (make-question "The indicator bromothymol blue is colorless when..." (list (make-answer "The pH is more acidic" (make-posn 200 100)) (make-answer "The pH is more basic" (make-posn 400 100)) (make-answer "bromothymol blue does not turn colorless" (make-posn 200 150)) (make-answer "The pH is close to neutral" (make-posn 400 150)) ) (make-answer "The pH is close to neutral" (make-posn 400 150)) )))
                                         (make-topic "Water" (list (make-question "The difference between pOH and pH is that..." (list (make-answer "There is an extra O in the name" (make-posn 200 100)) (make-answer "Higher numbers are acidic in pOH" (make-posn 400 100)) (make-answer "pOH measures hydroxyl group concentration while pH measures hydrogen concentrations" (make-posn 200 150)) (make-answer "All of the above" (make-posn 400 150)) ) (make-answer "All of the above" (make-posn 400 150)) )))
                                         (make-topic "Water" (list (make-question "The process of linking molecule monomers is..." (list (make-answer "a series of hydrolysis and dehydrolysis" (make-posn 200 100)) (make-answer "the force" (make-posn 400 100)) (make-answer "hydrolysis (addition of 2 hydrogens and an oxygen)" (make-posn 200 150)) (make-answer "dehydrolysis (removal of 2 hydrogens and an oxygen)" (make-posn 400 150)) ) (make-answer "dehydrolysis (removal of 2 hydrogens and an oxygen)" (make-posn 400 150)) )))
                                         (make-topic "Water" (list (make-question "Permeability is a quality of a material that measures how much liquid or gas can pass through the material. Some membranes are sem" (list (make-answer "acidity" (make-posn 200 100)) (make-answer "facilitated diffusion" (make-posn 400 100)) (make-answer "the polarity of water" (make-posn 200 150)) (make-answer "ermeable, or only allow some things in. They do this through..." (make-posn 400 150)) (make-answer "alkalinity" (make-posn 200 200)) ) (make-answer "ermeable, or only allow some things in. They do this through..." (make-posn 400 150)) )))
                                         (make-topic "Organelles" (list (make-question "In a cell, your RNA is stored in..." (list (make-answer "the vacuoles" (make-posn 200 100)) (make-answer "the ribosomes" (make-posn 400 100)) (make-answer "the nucleolus" (make-posn 200 150)) (make-answer "the cytoplasm" (make-posn 400 150)) ) (make-answer "the nucleolus" (make-posn 200 150)) )))
                                         (make-topic "Organelles" (list (make-question "What is the nucleus protected by?" (list (make-answer "The cytoplasm" (make-posn 200 100)) (make-answer "The nuclear membrane" (make-posn 400 100)) (make-answer "The nucleolus" (make-posn 200 150)) (make-answer "The cell wall" (make-posn 400 150)) ) (make-answer "The nuclear membrane" (make-posn 400 100)) )))
                                         (make-topic "Organelles" (list (make-question "The rough endoplasmic reticulum contains ribosomes, which are part of creating which macromolecule?" (list (make-answer "Lipids" (make-posn 200 100)) (make-answer "Carbohydrates" (make-posn 400 100)) (make-answer "DNA" (make-posn 200 150)) (make-answer "Proteins" (make-posn 400 150)) ) (make-answer "Proteins" (make-posn 400 150)) )))
                                         (make-topic "Organelles" (list (make-question "On the other hand, the smooth endoplasmic reticulum creates which macromolecule?" (list (make-answer "Lipids" (make-posn 200 100)) (make-answer "DNA" (make-posn 400 100)) (make-answer "Carbohydrate" (make-posn 200 150)) (make-answer "Proteins" (make-posn 400 150)) ) (make-answer "Lipids" (make-posn 200 100)) )))
                                         (make-topic "Organelles" (list (make-question "The job of a vacuole in a cell is to..." (list (make-answer "store molecules" (make-posn 200 100)) (make-answer "create vitamins" (make-posn 400 100)) (make-answer "fill up space" (make-posn 200 150)) (make-answer "release molecules" (make-posn 400 150)) ) (make-answer "store molecules" (make-posn 200 100)) )))
                                         (make-topic "Organelles" (list (make-question "What is the area in a cell not taken up by organelles called?" (list (make-answer "There is no name" (make-posn 200 100)) (make-answer "The cell's plasma" (make-posn 400 100)) (make-answer "The cytoplasm" (make-posn 200 150)) (make-answer "The gaseous area" (make-posn 400 150)) ) (make-answer "The cytoplasm" (make-posn 200 150)) )))
                                         (make-topic "Organelles" (list (make-question "What job(s) do lysosomes have in a cell?" (list (make-answer "Discarding unneeded organelles" (make-posn 200 100)) (make-answer "Breakdown of food" (make-posn 400 100)) (make-answer "Disposal of waste" (make-posn 200 150)) (make-answer "All of the above" (make-posn 400 150)) ) (make-answer "All of the above" (make-posn 400 150)) )))
                                         (make-topic "Organelles" (list (make-question "Which organelle in a cell creates the most ATP?" (list (make-answer "The rough endoplasmic reticulum" (make-posn 200 100)) (make-answer "The mitochondria" (make-posn 400 100)) (make-answer "None of these" (make-posn 200 150)) (make-answer "The smooth endoplasmic reticulum" (make-posn 400 150)) ) (make-answer "The mitochondria" (make-posn 400 100)) )))
                                         (make-topic "Organelles" (list (make-question "What protects a plant cell?" (list (make-answer "None of the above" (make-posn 200 100)) (make-answer "The cell wall" (make-posn 400 100)) (make-answer "A combination of the cell membrane and cell wall" (make-posn 200 150)) (make-answer "The cell membrane" (make-posn 400 150)) ) (make-answer "A combination of the cell membrane and cell wall" (make-posn 200 150)) )))
                                         (make-topic "Organelles" (list (make-question "An enzyme is a protein which makes certain processes happen faster." (list (make-answer "So?" (make-posn 200 100)) (make-answer "Meh" (make-posn 400 100)) (make-answer "OK? (Iunno, if you can think of something change it.)" (make-posn 200 150)) (make-answer "Cool" (make-posn 400 150)) ) (make-answer "Cool" (make-posn 400 150)) )))
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

(big-bang (start-game 2)
          (on-mouse mouse-handler)
          (on-receive receive-func)
          (register "127.0.0.1")
          (on-draw draw-handler 500 500))
