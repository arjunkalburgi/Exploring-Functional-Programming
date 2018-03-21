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
    %  (i) query1(+Semester, +Name, -Total). Total should be bound to the total mark, in terms of percentage out of 100, of the student for that semester
        query1(S, N, T) :- 
            c325(S, N, Q1, _, _, _, _, _), 
            setup(S, as1, D1, M1), 
            weight(Q1, D1, M1, R1), 
            
            c325(S, N, _, Q2, _, _, _, _), 
            setup(S, as2, D2, M2), 
            weight(Q2, D2, M2, R2), 
            
            c325(S, N, _, _, Q3, _, _, _), 
            setup(S, as3, D3, M3), 
            weight(Q3, D3, M3, R3), 
            
            c325(S, N, _, _, _, Q4, _, _), 
            setup(S, as4, D4, M4), 
            weight(Q4, D4, M4, R4), 
            
            c325(S, N, _, _, _, _, Q5, _), 
            setup(S, midterm, D5, M5), 
            weight(Q5, D5, M5, R5), 
            
            c325(S, N, _, _, _, _, _, Q6), 
            setup(S, final, D6, M6), 
            weight(Q6, D6, M6, R6), 
            !, 
            list_sum([R1, R2, R3, R4, R5, R6], T).

        weight(Q, D, M, R) :- 
            I is Q / D,
            R is I * M.

        % https://stackoverflow.com/a/9876309
        list_sum([Item], Item).
        list_sum([Item1, Item2|Tail], Total) :-
            R is Item1 + Item2, 
            list_sum([R|Tail], Total).



    %  (ii) query2(+Semester, -L).
        query2(S, L) :- 
            findall(N, (c325(S, N, _, _, _, _, M, F),
                        setup(S, midterm, MS, _),
                        setup(S, final, FS, _),
                        MP is M/MS, 
                        FP is F/FS, 
                        FP > MP),
                    L).

    %  (iii) query3(+Semester,+Name,+Type,+NewMark)
        query3(S, N, T, NM) :- 
            (T = as1
            ->  retract(c325(S, N, A1, A2, A3, A4, M, F)),
                assert(c325(S, N, NM, A2, A3, A4, M, F))
            ;   true), 
            (T = as2
            ->  retract(c325(S, N, A1, A2, A3, A4, M, F)),
                assert(c325(S, N, A1, NM, A3, A4, M, F))
            ;   true), 
            (T = as3
            ->  retract(c325(S, N, A1, A2, A3, A4, M, F)),
                assert(c325(S, N, A1, A2, NM, A4, M, F))
            ;   true), 
            (T = as4
            ->  retract(c325(S, N, A1, A2, A3, A4, M, F)),
                assert(c325(S, N, A1, A2, A3, NM, M, F))
            ;   true), 
            (T = midterm
            ->  retract(c325(S, N, A1, A2, A3, A4, M, F)),
                assert(c325(S, N, A1, A2, A3, A4, NM, F))
            ;   true), 
            (T = final
            ->  retract(c325(S, N, A1, A2, A3, A4, M, F)),
                assert(c325(S, N, A1, A2, A3, A4, M, NM))
            ;   print("record not found")
            ).

            
            
