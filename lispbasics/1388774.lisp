;QUESTION 1
    ; This function searchs for X in in Y (list). 

    (defun xmember (X Y)
        (cond 
            ((or (atom Y) (NULL Y) NIL)) ; return nil if list is empty or not a list
            ((equal X (car Y)) T) ; return T if the first of Y == X
            (T 
                (or (xmember X (car Y)) (xmember X (cdr Y)) ) ; return whichever is true from recursing down both sides of list
            )
        )
    )

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
    ; (remove-duplicate x) https://eclass.srv.ualberta.ca/mod/page/view.php?id=2607174
    (defun remove-duplicate (x)
        NIL 
    )


;QUESTION 4
    ; (mix L1 L2) https://eclass.srv.ualberta.ca/mod/page/view.php?id=2607174
    (defun mix (L1 L2)
        NIL 
    )


;QUESTION 5
    ; (allsubsets L) https://eclass.srv.ualberta.ca/mod/page/view.php?id=2607174
    (defun allsubsets (L)
        NIL 
    )


;QUESTION 6
    ; ok...


; (load "lispbasics/1388774.lisp")