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
    countAll([], []). 
    countAll(L, R) :- countHelper(L, L, [], R).
    countAll(L, Ro) :- 
        countHelper(L, L, [], Ru),
        quick_sort2(Ru, Ro).

    countHelper(_, [], _, []). 
    countHelper(L, [H|T], S, Rf) :- 
        (member(H, S)
        ->  countHelper(L, T, S, Rf)
        ;   append(S, [H], Sn),
            countVar(L, H, CR),
            countHelper(L, T, Sn, Ri),
            append(Ri, [CR], Rf)
        ).
    
    countVar([], V, [V, 0]). 
    countVar([V|L], V, [V, R]) :-
        countVar(L, V, [V, R1]), 
        R is R1 + 1. 
    countVar([A|L], V, [V, R]) :- 
        countVar(L, V, [V, R]),
        A \= V.

    append([],X,X).                            
    append([X|Y],Z,[X|W]) :- append(Y,Z,W).

    % https://stackoverflow.com/a/8429550 & http://kti.mff.cuni.cz/~bartak/prolog/sorting.html
    pivoting(_,[],[],[]).
    pivoting(H,[X|T],[X|L],G):-X=<H,pivoting(H,T,L,G).
    pivoting(H,[X|T],L,[X|G]):-X>H,pivoting(H,T,L,G).
    quick_sort2(List,Sorted) :- q_sort(List,[],Sorted).
    q_sort([],Acc,Acc).
    q_sort([H|T],Acc,Sorted) :-
        pivoting(H,T,L1,L2),
        q_sort(L1,Acc,Sorted1),q_sort(L2,[H|Sorted1],Sorted).


%QUESTION 5
    sub([], _, []).
    sub(L, Ds, R) :-
        subHelper(L, Ds, Ds, R). 
        
    subHelper(L, [], L).
    subHelper(L, Ds, [D|R], Lf) :- 
        swapAll(Ds, D, L, Li), 
        subHelper(Li, R, Lf).

    swapAll(_, _, [], []). 
    swapAll(Ds, [Var, Val|E], [H|T], Lu) :- 
    (is_list(H) %% if head is list 
    ->  %% then callsubhelper on it
        subHelper(H, Ds, Ds, Rh),
        %% and append it in this spot with the result of the rest
        swapAll(Ds, [Var, Val|E], T, Rr), 
        append([Rh], Rr, Lu)
    ;   %% if head is not list 
        (H = Var %% if head is definition 
        ->  %% then append the definition value to the rest of the list
            swapAll(Ds, [Var, Val|E], T, Rr), 
            append([Val], Rr, Lu)
        ;   %% if head isn't definition 
            %% continue with Head
            swapAll(Ds, [Var, Val|E], T, Rr), 
            append([H], Rr, Lu)
        )
    ).




%QUESTION 6 