% Question 1 (3 marks)  (this is a written question)  

% (a) [1.5 marks] This website gives the details of how sudoku is solved as a CSP and in particular,  the details of constraint propagation using arc-consistency algorithm AC-3 combined with backtracking.  Study the algorithms of AC-3 and BACKTRACK.  First, show 5 examples of the removal of domain values in Example 1.  Then, show 2 examples in Example 2 of domain values that cannot be removed by AC-3 (you need to argue why they cannot be removed).


% (b) [1.5 mark] Suppose we have the following prolog program P:

%   path(X,Y) :- edge(X,Y).  

%   path(X,Z) :- edge(X,Y), path(Y,Z). 

%   edge(a,b).  edge(b,c).  edge(c,d).   edge(b,e).  edge(e,c).  edge(d,e).  edge(e,f).  edge(f,a).

% Treated as the corresponding logic formulas, we are interested in their logic consequences. Show the set of ground atoms that are logic consequences of the program. You should show this by an iterative construction of the fixpoint of the following operator T: Given a set of ground atoms S, 

% T(S) = { head(r) | body(r) is a subset of S, for some ground instance r of a clause in P} 

% where head(r) is the head atom of an instance of clause r and body(r) is the conjunction of body atoms of the same instance.

% Remark:  Tackle this problem after week13 lectures on Foundations of Logic Programming.  

