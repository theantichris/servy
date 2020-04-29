defmodule Servy.Plugins do
    @doc "Tracks 404 responses."
    def track(%{status: 404, path: path} = conv) do
        IO.puts "Warning: #{path} is on the loose!"
        conv
    end

    @doc "Catch-all for non-404 routes."
    def track(conv), do: conv

    @doc "Rewrites the /wildlife route to /wildthings."
    def rewrite_path(%{path: "/wildlife"} = conv) do
        %{ conv | path: "/wildthings"}
    end

    @doc "Default rewrite for other routes."
    def rewrite_path(conv), do: conv

    @doc "Logs a request conversation."
    def log(conv), do: IO.inspect conv
end