#!/usr/bin/env python
__author__ = 'Edward Yang'
import random
ip = '127.0.0.1'
fileheader = """#lang racket
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

"""

def basefile(player,ip):
    return """
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
        [(equal? (first i) t) (cons (make-topic "" (topic-questions t)) (nullify-paragraph (rest i) t))]
        [else (cons t (nullify-paragraph (rest i) t))]))

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

(define (remove-point p t q m)
  (if (equal? p 1)
      (send (make-model p
                        (make-posn (- (posn-x (model-scores m)) 5) (posn-y (model-scores m)))
                        (model-info m)
                        (model-t m)
                        (model-q m)))
      (send (make-model p
                        (make-posn (posn-x (model-scores m)) (- (posn-y (model-scores m)) 5))
                        (model-info m)
                        (model-t m)
                        (model-q m)))))

;bool r, int p, answer a, model m -> model
(define (credit-answer r p a m)
  (if r
      (if (equal? p 1)
          (award-point 1 (current-topic m) (current-question m) m)
          (award-point 2 (current-topic m) (current-question m) m))
      (if (equal? p 1)
          (remove-point 1 (current-topic m) (current-question m) m)
          (remove-point 2 (current-topic m) (current-question m) m))))

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

(big-bang (start-game """ + str(player) + """)
          (on-mouse mouse-handler)
          (on-receive receive-func)
          (register """ + '"' + ip + '"' + """)
          (on-draw draw-handler 500 500))
"""

def jumble(answlist):
    random.shuffle(answlist)
    return(answlist)
def trimline(line):
    return line[0:len(line) - 1]
def makeansw(corans,answl):
    base = '(list '
    cans = ''
    answlist = jumble(answl)
    xc = 100
    yc = 100
    for x in answlist:
        curans = '(make-answer "' + x + '" (make-posn ' + str(xc) + ' ' + str(yc) + ')) '
        base += curans
        if x == corans:
            cans = curans
        if xc >= 300:
            yc += 50
        xc = (xc % 300) + 100


    base += (') ' + cans)
    return base
def convert(infolist):
    #infolist is [topic,question, correct answer, answ1 , answ2, answ3]
    anlist = makeansw(infolist[2],infolist[2:len(infolist) + 1])
    qlist = '(list (make-question "' + infolist[1] + '" ' + anlist + ')'
    top = '(make-topic "' + infolist[0] + '" ' + qlist + '))'
    return(top)
def getinfo(mdata):
    infolist = []
    while '-' in mdata:
        infolist.append(mdata[0:mdata.index("-") - 1])
        mdata = mdata[mdata.index("-") + 2:len(mdata) + 1]
    infolist.append(mdata)
    return(infolist)
def main():
    global basefile,fileheader,ip
    data = open("data.txt","r")
    topic = "Null"
    base = "(define INFO (list "
    ending = "))"
    for line in data:
        mdata = trimline(line)
        if line == "\n":
            pass
        elif "-" not in line :
            topic = mdata
        else:
            myinfo = getinfo(mdata)
            myinfo.insert(0,topic)
            base += (convert(myinfo) + """
                                         """)
    data.close()
    out1 = open("jeopardyp1.rkt","w")
    out2 = open("jeopardyp2.rkt","w")
    out1.write(fileheader + base + ending + basefile(1,ip))
    out2.write(fileheader + base + ending + basefile(2,ip))
    out1.close()
    out2.close()

main()
