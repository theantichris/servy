defmodule Servy.Parser do
    @moduledoc "Parses a request into a conversation map."

    alias Servy.Conv

    def parse(request) do
        [method, path, _] =
            request 
            |> String.split("\n") 
            |> List.first
            |> String.split(" ")

        %Conv{
            method: method,
            path: path
        }
    end
end