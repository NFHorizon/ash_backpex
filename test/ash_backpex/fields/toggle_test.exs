defmodule AshBackpex.Fields.ToggleTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  alias AshBackpex.Fields.Toggle

  describe "render_value/1" do
    test "renders ON status for true value" do
      assigns = %{value: true}
      
      html = render_component(&Toggle.render_value/1, assigns)
      
      assert html =~ "toggle-on"
      assert html =~ "ON"
      assert html =~ "svg" # Check icon
    end

    test "renders OFF status for false value" do
      assigns = %{value: false}
      
      html = render_component(&Toggle.render_value/1, assigns)
      
      assert html =~ "toggle-off"
      assert html =~ "OFF"
      assert html =~ "svg" # Check icon
    end

    test "renders OFF status for nil value" do
      assigns = %{value: nil}
      
      html = render_component(&Toggle.render_value/1, assigns)
      
      assert html =~ "toggle-off"
      assert html =~ "OFF"
    end
  end

  describe "render_form/1" do
    setup do
      form = %Phoenix.HTML.Form{
        source: %{},
        impl: Phoenix.HTML.FormData.Map,
        id: "test_form",
        name: "test_form",
        data: %{},
        params: %{},
        errors: [],
        options: []
      }

      field = %{
        attribute: :is_active,
        help_text: "Toggle to activate"
      }

      %{form: form, field: field}
    end

    test "renders checkbox input with proper attributes", %{form: form, field: field} do
      assigns = %{
        form: form,
        field: field,
        value: true,
        readonly: false
      }
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      assert html =~ ~s(type="checkbox")
      assert html =~ ~s(value="true")
      assert html =~ ~s(checked)
      assert html =~ "toggle-input"
      assert html =~ "toggle-label"
      assert html =~ "toggle-slider"
    end

    test "renders unchecked state for false value", %{form: form, field: field} do
      assigns = %{
        form: form,
        field: field,
        value: false,
        readonly: false
      }
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      assert html =~ ~s(type="checkbox")
      assert html =~ ~s(value="true")
      refute html =~ ~s(checked)
    end

    test "renders disabled state when readonly", %{form: form, field: field} do
      assigns = %{
        form: form,
        field: field,
        value: true,
        readonly: true
      }
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      assert html =~ ~s(disabled)
    end

    test "renders help text when provided", %{form: form, field: field} do
      assigns = %{
        form: form,
        field: field,
        value: true,
        readonly: false
      }
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      assert html =~ "Toggle to activate"
      assert html =~ "toggle-help-text"
    end

    test "renders hidden input for form submission", %{form: form, field: field} do
      assigns = %{
        form: form,
        field: field,
        value: true,
        readonly: false
      }
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      assert html =~ ~s(type="hidden")
      assert html =~ ~s(value="false")
    end
  end

  describe "CSS styles" do
    test "includes all necessary CSS classes in form render", %{} do
      form = %Phoenix.HTML.Form{
        source: %{},
        impl: Phoenix.HTML.FormData.Map,
        id: "test_form",
        name: "test_form",
        data: %{},
        params: %{},
        errors: [],
        options: []
      }

      field = %{attribute: :test_field, help_text: nil}
      assigns = %{form: form, field: field, value: false, readonly: false}
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      # Check for essential CSS classes
      assert html =~ "toggle-field"
      assert html =~ "toggle-container"
      assert html =~ "toggle-input"
      assert html =~ "toggle-label"
      assert html =~ "toggle-slider"
      
      # Check for CSS styles
      assert html =~ "position: relative"
      assert html =~ "border-radius: 31px"
      assert html =~ "transition:"
      assert html =~ "cubic-bezier"
    end

    test "includes dark mode styles" do
      form = %Phoenix.HTML.Form{
        source: %{},
        impl: Phoenix.HTML.FormData.Map,
        id: "test_form",
        name: "test_form",
        data: %{},
        params: %{},
        errors: [],
        options: []
      }

      field = %{attribute: :test_field, help_text: nil}
      assigns = %{form: form, field: field, value: false, readonly: false}
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      assert html =~ "@media (prefers-color-scheme: dark)"
      assert html =~ "#374151" # Dark mode background
      assert html =~ "#10b981" # Dark mode active color
    end
  end

  describe "accessibility" do
    test "includes proper ARIA attributes", %{} do
      form = %Phoenix.HTML.Form{
        source: %{},
        impl: Phoenix.HTML.FormData.Map,
        id: "test_form",
        name: "test_form",
        data: %{},
        params: %{},
        errors: [],
        options: []
      }

      field = %{attribute: :is_active, help_text: "Toggle description"}
      assigns = %{form: form, field: field, value: true, readonly: false}
      
      html = render_component(&Toggle.render_form/1, assigns)
      
      # Check for proper label association
      assert html =~ ~r/id="[^"]*is_active[^"]*"/
      assert html =~ ~r/for="[^"]*is_active[^"]*"/
      
      # Check that label and input have matching IDs
      [input_id] = Regex.run(~r/id="([^"]*is_active[^"]*)"/, html, capture: :all_but_first)
      assert html =~ ~s(for="#{input_id}")
    end
  end
end
