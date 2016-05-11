%%%-------------------------------------------------------------------
%% @doc helloerlang public API
%% @end
%%%-------------------------------------------------------------------

-module(helloerlang_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_', routes() }]),
    ok = case cowboy:start_http(
                helloerlang_http_listener, 100,
                [{port, 4000}],
                [{env, [{dispatch, Dispatch}]}]) of
             {ok, _} -> ok;
             {error, {already_started, _}} -> ok;
             {error, _} = Error -> Error
         end,
    helloerlang_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

routes() ->
    [
        {"/", cowboy_static, {priv_file, helloerlang, "index.html"}}
    ].
