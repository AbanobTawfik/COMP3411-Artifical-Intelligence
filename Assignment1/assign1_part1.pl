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

% base case empty list
log_table([], []).

% case 2, go through list adding the value and log value pair to the return list
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

% base case empty list
paruns([],[]).

% case when we have next element as odd
% pass the list to add all elements up until the next even value
% as a sublist, to the return list
paruns([Head | Tail], [OddRun | Reset]) :-
    Head mod 2 =\= 0,
    oddRun([Head | Tail], OddRun, Rest),
    paruns(Rest, Reset).

% same logic as handling odd runs, just flipped around for even values
paruns([Head | Tail], [EvenRun | Reset]) :-
    Head mod 2 =:= 0,
    evenRun([Head | Tail], EvenRun, Rest),
    paruns(Rest, Reset).  
    
% base case for oddrun, no more values to compute
oddRun([], [], []).

% exit case for odd run when next element is even, we return the remaining list to be proccessed
oddRun([Head | Tail], [], [Head | Tail]) :-
    Head mod 2 =:= 0.

% case when next element is odd, we want to add the current head of list to the sublist, and 
% continue through to the rest of the list. 
% the rest parameter will give us the rest of the list remaining to proccess after our oddrun is created
% for example if we had [1, 3, 2, 4] as our list and our current oddrun is [1, 3], the rest paramter will contain [2, 4]
% as the remaining list to proccess, note above when we hit our exit case, the remaining list is assigned to the Tail 
% passed in just before our exit case, [2, 4] is the last call to oddrun where we hit our exit case and the recursion unwinds 
oddRun([Head | Tail], [Head | NextOdd], Rest) :-
    Head mod 2 =\= 0,
    oddRun(Tail, NextOdd, Rest).

% base case for even run, no more values to computer
evenRun([], [], []).

% exit case for even run when next element is odd, we return the remaining list to be proccessed
evenRun([Head | Tail], [], [Head | Tail]) :-
    Head mod 2 =\= 0.

% case when next element is even, follows the same logic as the case for oddrun when next element is odd
evenRun([Head | Tail], [Head | NextEven], Rest) :-
    Head mod 2 =:= 0,
    evenRun(Tail, NextEven, Rest).  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Arithmetic expressions can be written in prefix format, e.g 1+2*3 can be written as
% add(1, mul(2, 3)). If the operators available are add, sub, mul, div, write a
% Prolog program, eval(Expr, Val), that will evaluate an expression, e.g.
% ?- eval(add(1, mul(2, 3)), V).
% V = 7
% ?- eval(div(add(1, mul(2, 3)), 2), V).
% V = 3.5

% case when we are evaluating a number, returns just number in V
% example usage, eval(3, V) --> V = 3.
eval(V, V) :- number(V).

%%%%% ADD %%%%%
% case when both variables in the add is numeric
% just add the two numbers together
% example usage, eval(add(3, 4), V) --> V = 3 + 4 --> V = 7
eval(add(A, B), V) :-
    number(A),
    number(B),
    V is A + B.

% otherwise evaluate both sub-expressions
eval(add(A, B), V) :-
    eval(A, C),
    eval(B, D),
    V is C + D.

%%%%% SUB %%%%%
% case when both variables in the sub is numeric
% subtract B from A
% example usage, eval(sub(10, 5), V) --> V = 10 - 5 --> V = 5
eval(sub(A, B), V) :- 
    number(A),
    number(B),
    V is A - B.

% otherwise evaluate both sub-expressions
eval(sub(A, B), V) :-
    eval(A, C),
    eval(B, D),
    V is C - D.

%%%%% MUL %%%%%
% case when both variables in the mul is numeric
% multiply A and B
% example usage, eval(mul(10, 5), V) --> V = 10 * 5 --> V = 50
eval(mul(A, B), V) :- 
    number(A),
    number(B),
    V is A * B.

% otherwise evaluate both sub-expressions
eval(mul(A, B), V) :-
    eval(A, C),
    eval(B, D),
    V is C * D.

%%%%% DIV %%%%%
% case when both variables in the div is numeric
% divide A by B
% example usage, eval(div(10, 5), V) --> V = 10 / 5 --> V = 2
eval(div(A, B), V) :-
    number(A),
    number(B),
    V is A/B.

% otherwise evaluate both sub-expressions
eval(div(A, B), V) :- 
    eval(A, C),
    eval(B, D),
    V is C/D.        