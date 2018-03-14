%QUESTION 1 
    setUnion(S1, [], S1).
    setUnion(S1, [B|S2], [B|S3]) :-
        \+ member(B, S1),
        setUnion(S1, S2, S3).
    setUnion(S1, [B|S2], S3) :-
        member(B, S1),
        setUnion(S1, S2, S3). 

%QUESTION 2
    swap([], []).
    swap([A, B|L], [B, A|R]) :-
        swap(L, R).
    swap([A], [A]).

%QUESTION 3 
    largest([A], A) :- 
        number(A). 
    largest([A], N) :-
        largest(A, N). 
    largest([A|L], A) :-
        number(A),
        largest(L, R),
        A>R.
    largest([A|L], R) :-
        number(A),
        largest(L, R),
        R>=A.
    largest([A|L], R) :-
        largest(L, R),
        largest(A, Rr),
        R>Rr.
    largest([A|L], Rr) :-
        largest(L, R),
        largest(A, Rr),
        Rr>=R.

%QUESTION 4 
append([],X,X).                            
append([X|Y],Z,[X|W]) :- append(Y,Z,W).

countVar([], V, [V, 0]). 
countVar([V|L], V, [V, R]) :-
    countVar(L, V, [V, R1]), 
    R is R1 + 1. 
countVar([A|L], V, [V, R]) :- 
    countVar(L, V, [V, R]),
    A \= V.

countHelper(_, [], _, []). 
countHelper(L, [H|T], S, Rf) :- 
    (member(H, S)
    ->  countHelper(L, T, S, Rf)
    ;   append(S, [H], Sn),
        countVar(L, H, CR),
        countHelper(L, T, Sn, Ri),
        append(Ri, [CR], Rf)
    ).

countAll([], []). 
countAll(L, Ro) :- countHelper(L, L, [], Ru).
%QUESTION 5
%QUESTION 6 