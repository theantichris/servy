defmodule Servy.Plugins do
    @moduledoc "Support functions for the HTTP server."

    alias Servy.Conv

    @doc "Tracks 404 responses."
    def track(%Conv{status: 404, path: path} = conv) do
        IO.puts "Warning: #{path} is on the loose!"
        conv
    end

    @doc "Catch-all for non-404 routes."
    def track(%Conv{} = conv), do: conv

    @doc "Rewrites the /wildlife route to /wildthings."
    def rewrite_path(%Conv{path: "/wildlife"} = conv) do
        %{ conv | path: "/wildthings"}
    end

    @doc "Default rewrite for other routes."
    def rewrite_path(%Conv{} = conv), do: conv

    @doc "Logs a request conversation."
    def log(%Conv{} = conv), do: IO.inspect conv
end