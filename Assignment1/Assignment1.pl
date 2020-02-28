% Question 1.1: List Processing
% Write a predicate sumsq_even(Numbers, Sum) that sums the squares of only the
% even numbers in a list of integers.
% Example:
% ?- sumsq_even([1,3,5,2,-4,6,8,-7], Sum).
% Sum = 120
% Note that it is the element of the list, not its position, that should be tested for oddness.
% (The example computes 2*2 + (-4)*(-4) + 6*6 + 8*8). Think carefully about how the
% predicate should behave on the empty list — should it fail or is there a reasonable value
% that Sum can be bound to?
% To decide whether a number is even or odd, you can use the built-in Prolog operator N
% mod M, which computes the remainder after dividing the whole number N by the whole
% number M. Thus a number N is even if the goal 0 is N mod 2 succeeds. Remember that
% arithmetic expressions like X + 1 and N mod M are only evaluated, in Prolog, if they
% appear after the is operator. So 0 is N mod 2 works, but N mod 2 is 0 doesn't work.

% base case empty list
sumsq_even([], 0).

% case 1, next element is odd
% continue to next element
sumsq_even([Head | Remaining], Sum) :-
    Head mod 2 =\= 0,
    sumsq_even(Remaining, Sum). 

% case 2, next element is even
% recursively call sumsq_even, when recursion unwinds off the stack, 
% we add the square of head for the even element to the recursive sum
sumsq_even([Head | Remaining], Sum) :-
    Head mod 2 =:= 0,
    sumsq_even(Remaining, RecursiveSum),
    Sum is RecursiveSum + Head*Head. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Question 1.2: List Processing
% Write a predicate log_table(NumberList,ResultList) that binds
% ResultList to the list of pairs consisting of a number and its log, for each number in
% NumberList. For example:
% ?- log_table([1, 3.7, 5], Result).
% Result = [[1, 0.0], [3.7, 1.308332819650179], [5,
% 1.6094379124341003]].
% Note that the Prolog built-in function log computes the natural logarithm, and that it
% needs to be evaluated using is to actually compute the log:
% ?- X is log(3.7).
% X = 1.308332819650179.
% ?- X = log(3.7).
% X = log(3.7).

log_table([], []).

log_table([Head | Remaining], [[Head, LogResult] | Rest]) :-
    LogResult is log(Head),
    log_table(Remaining, Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Question 1.3: List Processing
% Any list of integers can (uniquely) be broken into "parity runs" where each run is a
% (maximal) sequence of consecutive even or odd numbers within the original list. For
% example, the list List=[8,0,4,3,7,2,-1,9,9] can be broken into [8,0,4],
% [3,7], [2] and [-1,9,9] Write a predicate paruns(List,RunList) that
% converts a list of numbers into the corresponding list of parity runs. For example:
% ?- paruns([8,0,4,3,7,2,-1,9,9], RunList).
% RunList = [[8, 0, 4], [3, 7], [2], [-1, 9, 9]]
% Note: you can find out how to test if a number is even or odd from the Prolog
% Dictionary 

paruns([],[]).

paruns(List, RunList) :-
    List = [Head | _],
    Head mod 2 =\= 0,
    oddRun(List, OddRun, Rest),
    paruns(Rest, Reset),
    RunList = [OddRun | Reset].

oddRun([], [], []).

oddRun([Head | Tail], [], Rest) :-
    Head mod 2 =:= 0,
    Rest = [Head | Tail].

oddRun([Head | Tail], OddRun, Rest) :-
    Head mod 2 =\= 0,
    oddRun(Tail, NextOdd, Rest),
    OddRun = [Head | NextOdd].

paruns(List, RunList) :-
    List = [Head | _],
    Head mod 2 =:= 0,
    evenRun(List, EvenRun, Rest),
    paruns(Rest, Reset),
    RunList = [EvenRun | Reset].    

evenRun([], [], []).

evenRun([Head | Tail], [], Rest) :-
    Head mod 2 =\= 0,
    Rest = [Head | Tail].

evenRun([Head | Tail], EvenRun, Rest) :-
    Head mod 2 =:= 0,
    evenRun(Tail, NextEven, Rest),
    EvenRun = [Head | NextEven].    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Arithmetic expressions can be written in prefix format, e.g 1+2*3 can be written as
% add(1, mul(2, 3)). If the operators available are add, sub, mul, div, write a
% Prolog program, eval(Expr, Val), that will evaluate an expression, e.g.
% ?- eval(add(1, mul(2, 3)), V).
% V = 7
% ?- eval(div(add(1, mul(2, 3)), 2), V).
% V = 3.5

eval(V, V) :- number(V).

eval(add(A, B), V) :-
    number(A),
    number(B),
    V is A + B.

eval(add(A, B), V) :-
    number(A),
    eval(B, C),
    V is A + C.

eval(add(A, B), V) :-
    number(B),
    eval(A, C),
    V is B + C.

eval(sub(A, B), V) :- 
    number(A),
    number(B),
    V is A - B.

eval(sub(A, B), V) :-
    number(A),
    eval(B, C),
    V is A - C.

eval(sub(A, B), V) :-
    number(B),
    eval(A, C),
    V is B - C.

eval(mul(A, B), V) :- 
    number(A),
    number(B),
    V is A * B.

eval(mul(A, B), V) :-
    number(A),
    eval(B, C),
    V is A * C.

eval(mul(A, B), V) :-
    number(B),
    eval(A, C),
    V is B * C.

eval(div(A, B), V) :-
    number(A),
    number(B),
    V is B/A.

eval(div(A, B), V) :- 
    number(A),
    eval(B, C),
    V is C/A.

eval(div(A, B), V) :- 
    number(B),
    eval(A, C),
    V is C/B.        