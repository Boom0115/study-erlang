-module(mylists).
-compile(export_all).
%-export([sum/1]).

sum([H|T]) -> H + sum(T);
sum([])    -> 0.