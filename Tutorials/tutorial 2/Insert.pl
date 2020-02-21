% Write a prolog predicate insert(Num, List, NewList) that takes a number Num along with a list of 
% numbers List which is already sorted in increasing order, and binds NewList to the list obtained by 
% inserting Num into List so that the resulting list is still sorted in increasing order.
insert(Num, [], [Num]).

insert(Num, [Head|Tail], [Num, Head| Tail]) :-
    Num =< Head.

insert(Num, [Head|Tail], [Head|NTail]) :-
    insert(Num, Tail, NTail).
