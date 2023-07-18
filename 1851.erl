-spec min_interval(Intervals :: [[integer()]], Queries :: [integer()]) -> [integer()].
min_interval(Intervals, Queries) ->
    Set = sets:from_list(Intervals),
    Intervals2 = sets:to_list(Set),
    Intervals3 = 
    lists:sort(fun([A1,A2],[B1,B2]) -> 
        (A2 - A1) < (B2 - B1)
    end,Intervals2),
    Intervals4 = lists:map(fun([A,B]) -> 
        [A,B,B-A+1] 
    end,Intervals3),
    
    do(Queries,Intervals4,[],#{}).

do([],_,R,_) ->
    lists:reverse(R);
do([H|T],Intervals,R,M) ->
    {RR,M1} = 
    case maps:get(H,M,-1) of 
        -1 ->
            RR1 = r(H,Intervals,-1),
            M2 = maps:put(H,RR1,M),
            {RR1, M2};
        E ->
            {E,M}
    end,
    do(T,Intervals,[RR|R],M1).

r(_,[],R) ->
    R;
r(I,[[A,B,C]|_],R) when A =< I andalso B >= I ->
    C;
r(I,[_|T],R) ->
    r(I,T,R).