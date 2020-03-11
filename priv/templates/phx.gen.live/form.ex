defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Form do
  use <%= inspect context.web_module %>, :live_component

  alias <%= inspect context.module %>

  def render(assigns) do
    Phoenix.View.render(<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>View, "form.html", assigns)
  end

  def update(%{<%= schema.singular %>: <%= schema.singular %>} = assigns, socket) do
    changeset = socket.assigns[:changeset] || <%= inspect context.alias %>.change_<%= schema.singular %>(<%= schema.singular %>)
    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  def handle_event("validate", %{"<%= schema.singular %>" => <%= schema.singular %>_params}, socket) do
    # TODO add change_[...]/2 to phoenix context generator?
    changeset =
      socket.assigns.<%= schema.singular %>
      |> <%= inspect context.alias %>.change_<%= schema.singular %>(<%= schema.singular %>_params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"<%= schema.singular %>" => <%= schema.singular %>_params}, socket) do
    save_<%= schema.singular %>(socket, socket.assigns.action, <%= schema.singular %>_params)
  end

  defp save_<%= schema.singular %>(socket, :edit, <%= schema.singular %>_params) do
    case <%= inspect context.alias %>.update_<%= schema.singular %>(socket.assigns.<%= schema.singular %>, <%= schema.singular %>_params) do
      {:ok, _<%= schema.singular %>} ->
        {:noreply,
         socket
         |> put_flash(:info, "<%= schema.human_singular %> saved successfully")
         |> push_redirect(to: socket.assigns.redirect_path)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_<%= schema.singular %>(socket, :new, <%= schema.singular %>_params) do
    case <%= inspect context.alias %>.create_<%= schema.singular %>(<%= schema.singular %>_params) do
      {:ok, _<%= schema.singular %>} ->
        {:noreply,
         socket
         |> put_flash(:info, "<%= schema.human_singular %> created successfully")
         |> push_redirect(to: socket.assigns.redirect_path)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
