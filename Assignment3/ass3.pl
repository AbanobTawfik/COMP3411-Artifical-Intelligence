% A grammar the covers most of the examples in COMP3411 lectures

:- dynamic(history/1).

sentence(VP) --> noun_phrase(Number, Actor), verb_phrase(Actor, Number, VP).

noun_phrase(plural, set(NP1, NP2)) --> np1(_, NP1), [and], noun_phrase(_, NP2).
noun_phrase(Number, NP1) --> np1(Number, NP1).

np1(Number, thing(Noun, Properties)) -->
	determiner(Number, _),
	adjp(Properties),
	noun(Number, Noun).
np1(Number, thing(Noun, [PP | Properties])) -->
	determiner(Number, _),
	adjp(Properties),
	noun(Number, Noun),
	pp(Number, PP).
np1(Number, thing(Name, [])) -->
	proper_noun(Number, _, Name).
np1(Number, personal(Pro)) -->
	pronoun(Number, _, Pro).
np1(Number1, possessive(Pos, thing(Noun, []))) -->
	possessive_pronoun(Number1, _, Pos), noun(_, Noun).
np1(Number, object(Noun)) -->
	num(Number), noun(Number, Noun).

adjp([prop(Adj)]) --> adjective(Adj).
adjp([]) --> [].

verb_phrase(Actor, Number, event(V, [actor(Actor) | Adv])) -->
	verb(Number, V),
	adverb(Adv).
verb_phrase(Actor, Number, event(V, [actor(Actor), object(NP) | Adv])) -->
	verb(Number, V),
	noun_phrase(_, NP),
	adverb(Adv).
verb_phrase(Actor, Number, event(V, [actor(Actor), object(NP), PP])) -->
	verb(Number, V),
	noun_phrase(_, NP),
	pp(Number, PP).
verb_phrase(Actor, Number, event(V, [actor(Actor), PP])) -->
	verb(Number, V),
	pp(_, PP).

pp(_, PP) --> prep(NP, PP), noun_phrase(_, NP).

% The next set of rules represent the lexicon

prep(NP, object(NP)) --> [of].
prep(NP, object(NP)) --> [to].
prep(NP, instrument(NP)) --> [with].
prep(NP, object(NP)) --> [in].
prep(NP, object(NP)) --> [for].

determiner(singular, det(a)) --> [a].
determiner(_, det(the)) --> [the].
determiner(plural, det(those)) --> [those].
determiner(_, _) --> [].

pronoun(singular, masculine, he) --> [he].
pronoun(singular, feminine, she) --> [she].
pronoun(_, neutral, what) --> [what].
pronoun(singular, neutral,Pro) --> [Pro], {member(Pro, [i, someone, it])}.
pronoun(plural, neutral, Pro) --> [Pro], {member(Pro, [they, some])}.

possessive_pronoun(singular, masculine, his) --> [his].
possessive_pronoun(singular, feminine, her) --> [her].

prep(of) --> [of].
prep(to) --> [to].
prep(with) --> [with].
prep(in) --> [in].
prep(for) --> [for].

num(singular) --> [one].
num(plural) --> [two];[three];[four];[five];[six];[seven];[eight];[nine];[ten].

noun(singular, Noun) --> [Noun], {thing(Noun, Props), member(number(singular), Props)}.
noun(plural, Noun) --> [Noun], {thing(Noun, Props), member(number(plural), Props)}.

proper_noun(singular, Gender, Name) -->
	[Name],
	{
		thing(Name, Props), member(isa(person), Props), member(gender(Gender), Props)
	}.
proper_noun(singular, neutral, france) --> [france].

adjective(adj(Adj)) --> [Adj], {member(Adj, [red,green,blue])}.

verb(_, Verb) --> [Verb], {member(Verb, [lost,found,did,gave,looked,saw,forgot,is])}.
verb(singular, Verb) --> [Verb], {member(Verb, [scares,hates])}.
verb(plural, Verb) --> [Verb], {member(Verb, [scare,hate])}.

adverb([adv(too)]) --> [too].
adverb([]) --> [].

% You may chose to use these items in the database to provide another way
% of capturing an objects properties.
% thing(x, Properties) will give us the properties of X

thing(john, [isa(person), gender(masculine), number(singular)]).
thing(sam, [isa(person), gender(masculine), number(singular)]).
thing(bill, [isa(person), gender(masculine), number(singular)]).
thing(jack, [isa(person), gender(masculine), number(singular)]).
thing(monet, [isa(person), gender(masculine), number(singular)]).

thing(mary, [isa(person), gender(feminine), number(singular)]).
thing(annie, [isa(person), gender(feminine), number(singular)]).
thing(sue, [isa(person), gender(feminine), number(singular)]).
thing(jill, [isa(person), gender(feminine), number(singular)]).

thing(wallet, [isa(physical_object), gender(neutral), number(singular)]).
thing(car, [isa(physical_object), gender(neutral), number(singular)]).
thing(book, [isa(physical_object), gender(neutral), number(singular)]).
thing(telescope, [isa(physical_object), gender(neutral), number(singular)]).
thing(pen, [isa(physical_object), gender(neutral), number(singular)]).
thing(pencil, [isa(physical_object), gender(neutral), number(singular)]).
thing(cat, [isa(physical_object), gender(neutral), number(singular)]).
thing(mouse, [isa(physical_object), gender(neutral), number(singular)]).
thing(man, [isa(physical_object), gender(neutral), number(singular)]).
thing(bear, [isa(physical_object), gender(neutral), number(singular)]).

thing(cats, [isa(physical_object), gender(neutral), number(plural)]).
thing(mice, [isa(physical_object), gender(neutral), number(plural)]).
thing(men, [isa(physical_object), gender(neutral), number(plural)]).
thing(bears, [isa(physical_object), gender(neutral), number(plural)]).

thing(capital, [isa(abstract_object), gender(neutral), number(singular)]).

thing(france, [isa(place), gender(neutral), number(singular)]).

event(lost, [actor(_), object(_), tense(past)]).
event(found, [actor(_), object(_), tense(past)]).
event(saw, [actor(_), object(_), tense(past)]).
event(forgot, [actor(_), object(_), tense(past)]).
event(scares, [actor(_), object(_), tense(present), number(singular)]).
event(scare, [actor(_), object(_), tense(present), number(plural)]).
event(hates, [actor(_), object(_), tense(present), number(singular)]).
event(hate, [actor(_), object(_), tense(present), number(plural)]).
event(gave, [actor(Person1), recipient(Person2), object(_), tense(past)]) :- Person1 \= Person2.

% need to distinguish between personal pronouns and possessive pronouns
% can link a posessive pronoun to a personal pronoun
personal(he, [number(singular), gender(masculine)]).
personal(she, [number(singular), gender(feminine)]).
personal(it, [number(singular), gender(neutral)]).
personal(they, [ number(plural), gender(neutral)]).

possessive(his, [number(singular), gender(masculine)]).
possessive(her, [number(singular), gender(feminine)]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You have to write this:
% very similair to eval in assign1, recursively go through terms and break them down
% add things to dictionary
% there will be multiple process clauses, and each one is needed to deal with a certain pattern
% when you go through the list in eval, we need to handle each case, and append any references to the reference list
% event(lost,[actor(thing(john,[])),object(possessive(his,thing(wallet,[])))])
% abolish(history/1). to clear db
% assert, asserts facts in our db

% base case for processing an thing
% process(LogicalForm, Ref1, Ref2).
% process(event(lost, [actor(thing(john, [])), object(possessive(his, thing(wallet, [])))]), [], _G2751)

process(event(_, []), [], Refs).

process(event(_, [actor(X)| T]), Ref1, Refs) :-
	process(event(_, X), Ref1, Ref2),
	process(event(_, T), Ref1, Ref2).

process(event(_, thing(X, _)), Ref1, Ref2) :-
	thing(X, Properties),
	assert(history(thing(X, Properties))).
	% writeln(history(thing(X, Properties))).

process(event(_, [object(X)| T]), Ref1, Ref2) :-
	process(event(_, X), Ref1, Ref2),
	process(event(_, T), Ref1, Ref2).

% if we have something possessive e.g. his her we want to add the reference we find
process(event(_, possessive(Pronoun, X)), Ref1, Ref2) :-
	possessive(Pronoun, [number(Number), gender(Gender) ]),
	% look in history for a thing that matches!
	history(thing(Ref, [_, gender(Gender),number(Number)])),
	add_to_list(Ref, Ref1, Ref2),
	process(event(_, X), Ref1, Ref2).

	% process(event(_, X), Ref1, Ref2),
	% process(event(_, T), Ref1, Ref2).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add_to_list(Element, [], [Element]).
add_to_list(Element, [Head | Tail], [Head| NewTail]) :- add_to_list(Element, Tail, NewTail).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run(S, Refs) :-
	sentence(X, S, []), !,
	writeln(X),
	process(X, [], Refs),
	listing(history/1).