% Question 2 (3 marks)  War and Peace

% Two countries have signed a peace treaty and want to disarm over a period of months, but they still don't completely trust each other. Each month one of the countries can choose to dismantle one military division while the other can dismantle two. Each division has a certain strength, and both sides want to make sure that the total military strength remains equal at each point during the disarmament process. 

% For example, suppose the strengths of the country's divisions are:

% Country A: 1, 3, 3, 4, 6, 10, 12
% Country B: 3, 4, 7, 9, 16
% One solution is:

% Month 1: A dismantles 1 and 3, B dismantles 4
% Month 2: A dismantles 3 and 4, B dismantles 7
% Month 3: A dismantles 12, B dismantles 3 and 9
% Month 4: A dismantles 6 and 10, B dismantles 16
% Write a predicate

% disarm(+Adivisions, +Bdivisions,-Solution)
% Where Adivisions and Bdivisions are lists containing the strength of each country's divisions and Solution is a list describing the successive dismantlements. In the example above, 

% Solution = [[[1,3],[4]], [[3,4],[7]], [[12],[3,9]], [[6,10],[16]]]
% Each element of Solution represents one dismantlement, where a dismantlement is a list containing two elements: the first element is a list of country A's dismantlements and the second is a list of country B's dismantlements.

% Finally, the countries want to start with small dismantlements first in order to build confidence, so make sure that the total strength of one month's dismantlement is less than or equal to the total strength of next month's dismantlement.

% We will only evaluate the first solution computed by your program. If there is no solution, then your program should return false.



