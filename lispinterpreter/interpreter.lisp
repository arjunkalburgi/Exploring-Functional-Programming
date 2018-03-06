;; implement an interpreter


;; NOTES
;  I couldn't figure out how to implement some recursive userdefined functions for my interpreter. 
;  Ex: (fl-interp '(pop (1 2 3)) '((pop (x) = (if (atom (rest (rest x))) (cons (first x) nil) (cons (first x)(pop (rest x)))))))
;  However, if the user defined function is written such that the interpreter doesn't try the recursion, it will work
;  Ex: (fl-interp '(push (1 2 3) 4) '((push (x y) = (if (null x) (cons y nil) (cons (first x) (push (rest x) y))))))


;; (fl-interp E P)
;; given a program P and an expression E, returns the result of evaluating E with respect to P
(defun fl-interp (E P)
    (if (atom E)
        E ; return primitives back as they are
        (let* ( 
			;; Break down input 
			(command (car E)) ; the command the user wants to run 
			(args (cdr E)) ; the command's arguments
			(customdefun (getcustomdefun command P))
		)(cond 

			;Primitives that require two arguments and can be called by name
			((member command '(+ - * > < = eq cons equal)) (apply command (format2args args P)))

			;Primitives which require one argument and can be called by name
			((member command '(null atom)) (apply command (format1arg args)))

			;Primitives which require special interpretation to function
			((eq command 'and) (not (not (and (fl-interp (car args) P) (fl-interp (cadr args) P)))))
			((eq command 'or) (not (not (or (fl-interp (car args) P) (fl-interp (cadr args) P)))))
			((eq command 'number) (numberp (fl-interp (car args) P)))
			((eq command 'first) (car (fl-interp (car args) P))) 
			((eq command 'rest) (cdr (fl-interp (car args) P)))
			((eq command 'not) (not (fl-interp (car args) P)))
			((eq command 'if) (if (fl-interp (car args) P) (fl-interp (cadr args) P) (fl-interp (caddr args) P)))

			;is it user defined?
			((not (null customdefun)) (fl-interp (substituteargs customdefun args P) P))

			;might just be a list of atoms? 
			(t E)
		))
    )
)

; when there is only 2 arguments, format it to be used
(defun format2args (args P) 
	(if (null args)
		nil
		(cons (fl-interp (car args) P) (format2args (cdr args) P)))) ; list of 2 simplified args

; when there is only 1 argument, format it to be used
(defun format1arg (args)
	(list (car args))) ; list of 1 arg

; retrieve the custom defun from P
(defun getcustomdefun (cmd P)
	(cond 
		((null P) nil) ; do nothing if there isn't a function
		((eq cmd (caar P)) (car P)) ; return the defun 
		(T (getcustomdefun cmd (cdr P))))) ; continue searching for the defun

; parse defun for function arguments
(defun getcustomfuncargs (customdefun)
	;; customdefun = (greater (x y) = (if (> x y) x (if (< x y) y nil)))
	(cadr customdefun))

; parse defun for function body
(defun getcustomfuncbody (customdefun)
	;; customdefun = (greater (x y) = (if (> x y) x (if (< x y) y nil)))
	;; customdefun = (pi () = (if (> x y) x (if (< x y) y nil)))
	(cadddr customdefun))


; substitute arguments in function body with argument values (master function, has helper substitutehelper)
(defun substituteargs (customdefun args P) 
	;; (last (x) = (if (null (rest x)) (first x) (last (rest x))) => (last ((s u p)) = (if (null (rest (s u p))) (first (s u p)) (last (rest (s u p)))) 
	(let* ( 
		(body (getcustomfuncbody customdefun)) ; the command the user wants to run 
		(argvars (getcustomfuncargs customdefun)) ; the command's arguments
		(argsmap (createargsmap argvars args P)))
	(substitutehelper body argvars argsmap)))

; create a mapping of argvars and argvals => ((x 3) (y 5)) for x=3 and y=5
(defun createargsmap (argvars argvals P) 
	(if (null argvars)
		nil 
		(cons 
			(cons (car argvars) (list (fl-interp (car argvals) P)))
			(createargsmap (cdr argvars) (cdr argvals) P))))

; xmember from assignment 1
(defun xmember (X Y)
	(cond 
		((or (atom Y) (NULL Y)) NIL) 
		((equal X (car Y)) T) 
		(T (or (xmember X (car Y)) (xmember X (cdr Y)) ))))

; get the value of var from the argsmap
(defun getvalue (var argsmap) 
	(cond 
		((null argsmap) nil)
		((eq (caar argsmap) var) (cadar argsmap))
		(T (getvalue var (cdr argsmap)))))

; helper function for substitute
(defun substitutehelper (body argvars argsmap)
	(cond 
		((null body) nil)
		((atom (car body)) (if (xmember (car body) argvars)
							(cons (getvalue (car body) argsmap) (substitutehelper (cdr body) argvars argsmap))
							(cons (car body) (substitutehelper (cdr body) argvars argsmap)))) 
		(T (cons (substitutehelper (car body) argvars argsmap) (substitutehelper (cdr body) argvars argsmap)))))

