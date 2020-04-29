defmodule Servy.FileHandler do
    @moduledoc "Handles loading files."

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
end