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

defmodule Servy.Handler do
    @moduledoc "Handles HTTP requests."

    @pages_path Path.expand("../../pages", __DIR__)

    import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

    @doc "Transforsm the request into a response."
    def handle(request) do
        request 
        |> parse
        |> rewrite_path 
        |> log
        |> route
        |> track
        |> format_response
    end

    @doc "Parses a request into a conversation map."
    def parse(request) do
        [method, path, _] =
            request 
            |> String.split("\n") 
            |> List.first
            |> String.split(" ")

        %{ method: method, path: path, resp_body: "", status: nil }
    end

    @doc "Creates the response for the /wildthings route."
    def route(%{method: "GET", path: "/wildthings"} = conv) do
        %{ conv | resp_body: "Bears, Lions, Tigers", status: 200 }
    end

    @doc "Creates the response for the /bears route."
    def route(%{method: "GET", path: "/bears"} = conv) do
        %{ conv | resp_body: "Teddy, Smokey, Paddington", status: 200 }
    end

    @doc "Creates the response for the /bears/id route."
    def route(%{method: "GET", path: "/bears/" <> id} = conv) do
        %{ conv | resp_body: "Bear #{id}", status: 200 }
    end

    @doc "Creates the response for the /about route."
    def route(%{method: "GET", path: "/about"} = conv) do
        @pages_path
        |> Path.join("about.html")
        |> File.read
        |> handle_file(conv)
    end

    @doc "Creates 404 responses."
    def route(%{path: path} = conv) do
        %{ conv | resp_body: "No #{path} here!", status: 404}
    end

    @doc "Adds file contents onto the conversation."
    def handle_file({:ok, content}, conv) do
        %{conv | status: 200, resp_body: content}
    end

    @doc "Creates a response if a file is not found."
    def handle_file({:error, :enoent}, conv) do
        %{conv | status: 404, resp_body: "File not found!"}
    end

    @doc "Creates a response for other file errors."
    def handle_file({:error, reason}, conv) do
        %{conv | status: 500, resp_body: "File error: #{reason}"}
    end

    @doc "Formats the response string."
    def format_response(conv) do
        """
        HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
        Content-Type: text/html
        Content-Length: #{byte_size(conv.resp_body)}

        #{conv.resp_body}
        """
    end

    defp status_reason(code) do
        %{
            200 => "OK",
            201 => "Created",
            401 => "Unauthorized",
            403 => "Forbidden",
            404 => "Not Found",
            500 => "Internal Server Error"
        }[code]
    end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /about HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts response