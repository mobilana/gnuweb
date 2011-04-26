-module(hello_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_, _) ->
   Pid = spawn(
          fun() ->
             receive
                 _ -> nop
              end
          end
   ),
   io:format('~p~n',[Pid]),
   {ok, Pid}.

stop(_) ->
   ok.
