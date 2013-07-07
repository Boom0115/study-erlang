-module(lib_misc).
-compile(export_all).
%-export([sum/1]).
%-export([sum/2]).

%sum([H|T]) -> H + sum(T);
%sum([]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F)   -> [F(I)|for(I+1, Max, F)].

qsort([]) -> [];
qsort([Pivot|T]) ->
	qsort([X || X <- T, X < Pivot])
	++ [Pivot] ++
	qsort([X || X <- T, X >= Pivot]).

pythag(N) ->
	[ {A,B,C} ||
		A <- lists:seq(1,N),
		B <- lists:seq(1,N),
		C <- lists:seq(1,N),
		A+B+C =< N,
		A*A+B*B =:= C*C
	].

perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

sqrt(X) when X < 0 ->
	erlang:error({squareRootNegativeArgument, X});
sqrt(X) ->
	math:sqrt(X).

sleep(T) ->
	receive
	after T ->
		true
	end.

flush_buffer() ->
	receive
		_Any ->
			flush_buffer()
	after 0 ->
		true
	end.

priority_receive() ->
	receive
		{alarm, X} ->
			{alarm,X}
	after 0 ->
		receive
			Any ->
				Any
		end
	end.

on_exit(Pid, Fun) ->
	spawn(fun() ->
								process_flag(trap_exit, true),
								link(Pid),
								receive
									{'EXIT', Pid, Why} ->
										Fun(Why)
								end
		end).

keep_alive(Name, Fun) ->
	register(Name, Pid = spawn(Fun)),
	on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).
