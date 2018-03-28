% Question 3 (2 marks) The seating problem

% The seating problem is to generate a sitting arrangement for a number of guests, with m tables and n chairs per table. Guests who like each other should sit at the same table; guests who dislike each other should not sit at the same table.

% To make the issue of symmetry go away, we assume that, by "guests A and B like each other", we mean either A likes B or B likes A; similarly, by "guests A and B dislike each other", we mean either A dislikes B or B dislikes A.

% The background information is represented by some facts. Given a specific number k, the following represents k tables.

% table(1).
% ...
% table(k). 

% The like and dislike relationships

% like(A,B).      % A likes B
% dislike(A,C). % A dislikes C

% Given a listing of variables P representing persons, and a number N representing the number of chairs per table, the top predicate you need to define is:

%   seating(P,N) :-  ......

% For a query, e.g., 

%  ?- seating([P1,P2,P3,P4,P5,P6],3). 

% If solved, each Pi should be bound to a number representing a table. By typing ";", all alternative answers should be generated.

% For example, 

%  ?- seating([P1,P2,P3,P4,P5,P6],3). 

% is a query of whether there is a sitting arrangement for 6 guests and 3 chairs per table. 

% Test cases will be provided later.
