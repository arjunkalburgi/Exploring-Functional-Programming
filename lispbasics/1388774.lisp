;QUESTION 1
    ; This function searchs for X in in Y (list). 

    (defun xmember (X Y)
        (cond 
            ((or (atom Y) (NULL Y)) NIL) ; return nil if list is empty or not a list
            ((equal X (car Y)) T) ; return T if the first of Y == X
            (T (or (xmember X (car Y)) (xmember X (cdr Y)) )))) ; return whichever is true from recursing down both sides of list

;QUESTION 2
    ; convert nested list to straight list

    (defun flatten (x)
        (cond 
            ((atom x) x ) ;; if x is an atom 
            ((atom (car x) ) ;; if first in x is an atom 
                (append (list (car x)) (flatten (cdr x)) )
            )
            (T ;; if first in x is a list
                (append (flatten (car x)) (cdr x))
            )
        )
    )

;QUESTION 3
    ; helper functions 
        (defun newseen (orig seen)
            (append seen (list (car orig))))

        (defun iterate (orig seen)
            (cond 
                ((NULL orig) NIL) ; if there are no elements
                (T ; if the element is an atom
                    (if (xmember (car orig) seen) ;; if element has already been seen
                        (iterate (cdr orig) seen )
                        (append (list (car orig)) (iterate (cdr orig) (newseen orig seen))))))) ;; return continued iterating but with newseen

    (defun remove-duplicate (x)
        (if (atom x) x)
        (append (list (car x)) (iterate (cdr x) (list (car x)))))

;QUESTION 4
    ; (mix L1 L2) https://eclass.srv.ualberta.ca/mod/page/view.php?id=2607174
    (defun mix (L1 L2)
        (cond
            ((and (null L1) (null L2)) NIL)
            ((atom L1)  L1)
            ((atom L2)  L2)
            (T
                (append (list (car L1)) (mix L2 (cdr L1)) )
            )
        )
    )


;QUESTION 5
    ; (allsubsets L) https://eclass.srv.ualberta.ca/mod/page/view.php?id=2607174
    ; helper functions 
        (defun getlast (L)
            (cond
                ((null L) nil)
                ((null (cdr L)) (car L))
                (T 
                    (last (cdr L))
                )
            )
        )

        (defun addtocurrlist (currlist rest)
            (list (append (flatten (getlast currlist)) (list rest))) 
        )

        (defun getsubsets (currlist rest)
            (cond 
                ((and (null rest) (null currlist)) NIL) ;both null, nil
                ((null rest) currlist) ;rest is null

                ((atom currlist) (getsubsets (list currlist) rest)) ;currlist is an atom 
                ((null (cdr currlist)) ; currlist has only one element in it
                    (getsubsets 
                        (append 
                            (list currlist) ; ((1))
                            (list (append currlist (list(car rest))))) ;; ((1 2))
                        (cdr rest)
                    )    
                )

                ((atom rest) (flatten (cons currlist (list rest)))) ; rest is an atom

                (T 
                    (getsubsets 
                        (append 
                            currlist ; ((1) (1 2))
                            (addtocurrlist currlist (car rest))) ; ((1 2 3))
                        (cdr rest) ; nil
                    )
                )
            )
        )

        (defun eachsubset (L)
            (cond 
                ((null L) nil)
                ((atom L) (list L))
                ((null (cdr L)) 
                    (list L)
                )
                (T
                    (append (getsubsets (list (car L)) (cdr L)) (eachsubset (cdr L)))
                )
            )
        )

    (defun allsubsets (L)
        (append (cons nil nil) (eachsubset L))
    )


;QUESTION 6
    ; helper function 
        (defun compilelist (data rank)
            (if (null (cdr data)) ; if it's the last item
                (append rank (list (car (car data))))
                (compilelist (cdr data) (append rank (list (car (car data))))) ))

        (defun greaterThan (L1 L2)
            (> (cadr L1) (cadr L2)))

        (defun mySort (L)
            (sort L 'greaterThan))

        (defun getpageoffirstpair (L)
            (car (car L)))

        (defun getlinkoffirstpair (L)
            (car (cdr (car L))))

        (defun getcount (A L)
            ;; return the number of links to A
            (if (null (cdr L)) 
                (if (equal A (getpageoffirstpair L))
                    0
                    (if (equal A (getlinkoffirstpair L)) 
                        1
                        0 ) )
                (if (equal A (getpageoffirstpair L))
                    (getcount A (cdr L))
                    (if (equal A (getlinkoffirstpair L)) 
                        (+ 1 (getcount A (cdr L)))
                        (getcount A (cdr L)) ) ) ) )

        (defun countobjects (S L countobjs)
            (if (null (cdr S))
                (append 
                    countobjs 
                    (list (cons (car S) (list (getcount (car S) L))))) 
                (countobjects 
                    (cdr S)
                    L
                    (append 
                        countobjs 
                        (list (cons (car S) (list (getcount (car S) L)))) ))))

    (defun rank (S L)
        (compilelist (mySort (countobjects S L ()) ) ()))

    ; helper functions 
        (defun alreadyseen (x seen)
            (if (null seen)
                NIL
                (if (equal x (car seen))
                    T
                    (alreadyseen x (cdr seen)) )))
        (defun searchfor (x L seen) 
            (if (null (cdr L)) 
                (append seen (list (getlinkoffirstpair L)))
                (if (equal x (getpageoffirstpair L)) ; if we find a link from x
                    (if (alreadyseen (getlinkoffirstpair L) seen) ; if it's already stored
                        (searchfor x (cdr L) seen)
                        (searchfor x (cdr L) (append seen (list (getlinkoffirstpair L))) ) )
                    (searchfor x (cdr L) seen) )))

        (defun recursivesearch (x L total)
            (cond 
                ((null x) total)
                ((null (cdr x)) (recursivesearch (cdr x) L (searchfor (car x) L total))) ; last element in x
                (T (recursivesearch (cdr x) L (remove-duplicate (append total (searchfor (car x) L total))))) ))

    (defun reached (x L)
        (cdr (recursivesearch (list x) L (list x)))
    )
