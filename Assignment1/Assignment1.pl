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
% we add the square of head to even element to the recursive sum
sumsq_even([Head | Remaining], Sum) :-
Head mod 2 =:= 0,
sumsq_even(Remaining, RecursiveSum),
Sum is RecursiveSum + Head*Head. 