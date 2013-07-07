-module(try_test).
-compile(export_all).

generate_exeption(1) -> a;
generate_exeption(2) -> throw(a);
generate_exeption(3) -> exit(a);
generate_exeption(4) -> {'EXIT', a};
generate_exeption(5) -> erlang:error(a).

demo1() ->
	[catcher(I) || I <- [1,2,3,4,5]].

	catcher(N) ->
		try generate_exeption(N) of
			Val -> {N, normal, Val}
		catch
			throw:X -> {N, caught, thrown, X};
			exit:X  -> {N, caught, exited, X};
			error:X -> {N, caught, error, X}
		end.

demo2() ->
	[{I, (catch generate_exeption(I))} || I <- [1,2,3,4,5]].

