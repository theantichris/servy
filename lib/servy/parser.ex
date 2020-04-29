defmodule Servy.Parser do
    @moduledoc "Parses a request into a conversation map."
    
    def parse(request) do
        [method, path, _] =
            request 
            |> String.split("\n") 
            |> List.first
            |> String.split(" ")

        %{ method: method, path: path, resp_body: "", status: nil }
    end
end