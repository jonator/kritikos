defmodule KritikosWeb.ErrorView do
  @doc """
  Defines how errors should look. They should all eventually be lists of strings.
  """
  use KritikosWeb, :view

  def render("error.json", %{message: %Ecto.Changeset{valid?: false} = cs}) do
    errors = Ecto.Changeset.traverse_errors(cs, &convert_errors/3)
    %{errors: flatten_errors(errors)}
  end

  def render("error.json", %{message: m}) when is_list(m) do
    %{errors: m}
  end

  def render("error.json", %{message: m}) do
    %{errors: [m]}
  end

  def render("redirect.json", assigns) do
    Map.merge(render("error.json", assigns), %{redirect: assigns[:redirect]})
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  defp convert_errors(_changeset, field, {msg, opts}) do
    field_name =
      (Atom.to_string(field)
       |> String.replace("_", " ")
       |> String.capitalize()) <> " "

    msg =
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)

    field_name <> msg
  end

  defp flatten_errors(errors) do
    errs = Map.values(errors)
    flatten_errors_r(errs)
  end

  defp flatten_errors_r([%{} = map | es]) do
    vals = Map.values(map)
    flatten_errors_r(vals) ++ flatten_errors_r(es)
  end

  defp flatten_errors_r([e | es]) do
    e ++ flatten_errors_r(es)
  end

  defp flatten_errors_r([]) do
    []
  end
end
