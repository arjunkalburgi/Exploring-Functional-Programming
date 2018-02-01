;QUESTION 1
    (defun xmember (X Y)
        "This function returns T if argument X is a member of the argument 
        list Y and NIL otherwise. This should also test for lists being members 
        of lists. Both the argument X and the list Y may be NIL or lists containing NIL. 

        Example
            (xmember '1 '(1)) => T
            (xmember '1 '( (1) 2 3)) => NIL
            (xmember '(1) '((1) 2 3)) => T
            (xmember nil nil) => NIL
            (xmember nil '(nil)) => T
            (xmember nil '((nil))) => NIL
            (xmember '(nil) '(1 2 3 (nil))) => T
            (xmember '(nil) '(nil)) => NIL
        "
        (cond 
            ((or (atom Y) (NULL Y)) NIL) ; return nil if list is empty or not a list
            ((equal X (car Y)) T) ; return T if the first of Y == X
            (T (or (xmember X (car Y)) (xmember X (cdr Y)) )))) ; return whichever is true from recursing down both sides of list

;QUESTION 2
    (defun flatten (x)
        "The argument x is a list with sublists nested to any depth, such that the result 
        of (flatten x) is just a list of atoms with the property that all the atoms appearing 
        in x also appear in (flatten x) and in the same order. Assume that NIL and () 
        will not appear in the given list x

        Example
            (flatten '(a (b c) d)) => (a b c d)
            (flatten '((((a)))))  => (a)
            (flatten '(a (b c) (d ((e)) f))) => (a b c d e f)
        "
        (cond 
            ((atom x) x ) ;; if x is an atom 
            ((atom (car x) ) ;; if first in x is an atom 
                (append (list (car x)) (flatten (cdr x)) ))
            (T ;; if first in x is a list
                (append (flatten (car x)) (cdr x)))))

;QUESTION 3
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
        "This function takes x as a list of atoms and removes repeated ones in x. 
        The order of the elements in the resulting list should preserve the order 
        in the given list.

        Example
            (remove-duplicate '(a b c a d b)) => (a b c d) or (c a d b)
        "
        (if (atom x) x)
        (append (list (car x)) (iterate (cdr x) (list (car x)))))

;QUESTION 4
    (defun mix (L1 L2)
        "This function mixes the elements of L1 and L2 into a single list, by choosing 
        elements from L1 and L2 alternatingly. If one list is shorter than the 
        other, then append all remaining elements from the longer list at the end.

        Example
            (mix '(a b c) '(d e f)) => (a d b e c f)
            (mix '(1 2 3) '(a)) => (1 a 2 3)
            (mix '((a) (b c)) '(d e f g h)) => ((a) d (b c) e f g h)
            (mix '(1 2 3) nil) => (1 2 3)
            (mix '(1 2 3) '(nil)) => (1 nil 2 3)
        "
        (cond
            ((and (null L1) (null L2)) NIL)
            ((atom L1)  L1)
            ((atom L2)  L2)
            (T (append (list (car L1)) (mix L2 (cdr L1)) ))))


;QUESTION 5
    (defun getlast (L)
        (cond
            ((null L) nil)
            ((null (cdr L)) (car L))
            (T (last (cdr L)))))

    (defun addtocurrlist (currlist rest)
        (list (append (flatten (getlast currlist)) (list rest))) )

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
                    (cdr rest)))
            ((atom rest) (flatten (cons currlist (list rest)))) ; rest is an atom
            (T (getsubsets 
                    (append 
                        currlist ; ((1) (1 2))
                        (addtocurrlist currlist (car rest))) ; ((1 2 3))
                    (cdr rest) )))) 

    (defun eachsubset (L)
            (cond 
                ((null L) nil)
                ((atom L) (list L))
                ((null (cdr L)) 
                    (list L))
                (T (append (getsubsets (list (car L)) (cdr L)) (eachsubset (cdr L))))))

    (defun allsubsets (L)
        "This function returns a list of all subsets of L. How the subsets 
        in the resulting list are ordered is unimportant.  

        Example
            (allsubsets nil) => (nil)
            (allsubset '(a)) => (nil (a)) 
            (allsubsets '(a b)) => (nil (a) (b) (a b))
        "
        (append (cons nil nil) (eachsubset L)) )


;QUESTION 6 - RANK
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
        "This function has S is a list of atoms naming web pages, and L as a list of pairs 
        representing linkage. The function returns a permutation of S such that the web pages
        are ordered according to the criterion above, i.e., the most referred web page is 
        the first in the list, and so on. If two web pages are equally important in terms 
        of references, then it doesn't matter how they are ordered.

        Example
            (rank '(a b) '((a a)(b b)(a b)(c a))) ==> (a b) OR (b a)
            (rank '(a b c) '((a b)(a c)(a d))) ==> (b c a) OR (c b a)
            (rank '(a b c d) '((d c)(a c)(b d)(c c)(a a)(d b))) ==> (c b d a) OR (c d b a)
            (rank '(b a k) '((k b)(b k)(a k)(k a))) ==> (k a b) OR (k b a)
            (rank '(m n) '((n m)(m m)(t n)(s t)(t s))) ==> (m n) OR (n m)
        "
        (compilelist (mySort (countobjects S L ()) ) ()))

;QUESTION 6 - REACHED
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
        "This function has x as a web page, L as a list of pairs representing linkage, 
        and returns a list of all web pages that can be reached from x (x should not 
        be part of the result). The order of the web pages in the resulting list is unimportant.

        Example
            (reached 'a '((b b))) ==> NIL
            (reached 'a '((b a))) ==> NIL
            (reached 'a '((a b)(a c)(a d))) ==> (b c d)
            (reached 'a '((c d)(d a)(a b)(b c))) ==> (b c d)
            (reached 'a '((e x)(b x)(x e)(a a)(a b))) ==> (b e x) 
        "
        (cdr (recursivesearch (list x) L (list x))))
