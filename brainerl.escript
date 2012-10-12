#!/usr/bin/env escript
%% -*- erlang -*-
-define(LOW_PRIMES, [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127]).

main([Filename]) ->
    case file:read_file(Filename) of
        {ok, Binary} -> 
            io:format("~s", [interpret(Binary)]); 
        {error, Reason} -> 
            io:format("Error - could not read ~s - ~p\n", [Filename, Reason])
    end;
main(_) ->
    usage().

usage() ->
    io:format("Usage: Turns an input file from text into Brainfuck\n"),
    halt(1).

interpret(Binary) when is_binary(Binary) ->
    interpret(binary_to_list(Binary));
interpret(List) when is_list(List) ->
    interpret(List, []).

interpret([], Output) ->
    lists:flatten(lists:reverse(Output));
interpret([Character | Tail], Output) ->
    interpret(Tail, [find_factors(Character, 1) | Output]).

find_factors(Left, Right) ->
    case lists:dropwhile(fun(Prime) ->
        (Left rem Prime > 0)
    end, ?LOW_PRIMES) of
        [] ->
            find_factors_string(Left, Right);
        [Prime | _Rest] ->
            New_difference = abs((Left div Prime) - (Right * Prime)),
            Old_difference = abs(Left - Right),
            if 
                New_difference < Old_difference ->
                    find_factors(Left div Prime, Right * Prime);
                New_difference >= Old_difference ->
                    find_factors_string(Left, Right)
            end
    end.

find_factors_string(Left, Right) ->
    [lists:concat([">", string:copies("+", Left), "[<", string:copies("+", Right), ">-]<.>"])].
