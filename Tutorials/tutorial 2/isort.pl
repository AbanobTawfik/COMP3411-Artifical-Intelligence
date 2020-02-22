% Write a predicate isort(List, NewList) that takes a List of numbers in any order, 
% and binds NewList to the list containing the same numbers sorted in increasing order. 
% Hint: your predicate should call the insert/3 predicate from part 1.
% Note: The notation insert/1 means the predicate insert , which takes 1 argument.

isort([], []).

isort([Head|Tail], NewList) :-
    isort(Tail, SortedTail),
    insert(Head, SortedTail, NewList).
    
insert(Num, [], [Num]).

insert(Num, [Head|Tail], [Num, Head| Tail]) :-
    Num =< Head.

insert(Num, [Head|Tail], [Head|NTail]) :-
    insert(Num, Tail, NTail).
