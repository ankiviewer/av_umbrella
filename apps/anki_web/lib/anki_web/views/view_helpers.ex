defmodule AnkiWeb.ViewHelpers do
  def js_file(%{request_path: "/"}),
    do: "home.js"
  def js_file(%{request_path: "/" <> file}),
    do: file <> ".js"
end
