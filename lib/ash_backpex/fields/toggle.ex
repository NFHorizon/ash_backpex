defmodule AshBackpex.Fields.Toggle do
  @moduledoc """
  A field for handling boolean values with an Apple-style toggle switch.

  This field provides a modern, iOS-style toggle switch for boolean values,
  offering a more intuitive user experience compared to traditional checkboxes.

  ## Features
  - Apple-style sliding animation
  - Dark mode support
  - Accessibility compliant
  - Smooth transitions
  - Visual feedback for different states

  ## Usage

      field :is_active, AshBackpex.Fields.Toggle do
        label("Active Status")
        help_text("Toggle to activate or deactivate")
      end
  """

  @behaviour Backpex.Field

  @impl Backpex.Field
  def render_value(assigns) do
    ~H"""
    <div class="toggle-display">
      <%= if @value do %>
        <span class="toggle-status toggle-on">
          <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
          </svg>
          ON
        </span>
      <% else %>
        <span class="toggle-status toggle-off">
          <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
          </svg>
          OFF
        </span>
      <% end %>
    </div>
    """
  end

  @impl Backpex.Field
  def render_form(assigns) do
    ~H"""
    <div class="toggle-field">
      <div class="toggle-container">
        <input
          type="hidden"
          name={input_name(@form, @field)}
          value="false"
        />
        <input
          type="checkbox"
          id={input_id(@form, @field)}
          name={input_name(@form, @field)}
          value="true"
          checked={get_field_value(assigns)}
          class="toggle-input"
          disabled={@readonly}
          {input_validations(@form, @field)}
        />
        <label for={input_id(@form, @field)} class="toggle-label">
          <span class="toggle-slider"></span>
        </label>
        <%= if @field[:help_text] do %>
          <div class="toggle-help-text">
            <%= @field.help_text %>
          </div>
        <% end %>
      </div>
    </div>

    <style>
      .toggle-field {
        display: flex;
        flex-direction: column;
        gap: 8px;
      }

      .toggle-container {
        position: relative;
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .toggle-input {
        opacity: 0;
        width: 0;
        height: 0;
        position: absolute;
      }

      .toggle-label {
        position: relative;
        display: inline-block;
        width: 51px;
        height: 31px;
        cursor: pointer;
        user-select: none;
        flex-shrink: 0;
      }

      .toggle-slider {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #e5e7eb;
        border-radius: 31px;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
      }

      .toggle-slider:before {
        position: absolute;
        content: "";
        height: 27px;
        width: 27px;
        left: 2px;
        bottom: 2px;
        background-color: white;
        border-radius: 50%;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
      }

      .toggle-input:checked + .toggle-label .toggle-slider {
        background-color: #34c759;
        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
      }

      .toggle-input:checked + .toggle-label .toggle-slider:before {
        transform: translateX(20px);
      }

      .toggle-input:focus + .toggle-label .toggle-slider {
        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1), 0 0 0 3px rgba(52, 199, 89, 0.3);
      }

      .toggle-input:disabled + .toggle-label {
        opacity: 0.5;
        cursor: not-allowed;
      }

      .toggle-input:disabled + .toggle-label .toggle-slider {
        background-color: #f3f4f6;
      }

      .toggle-input:disabled:checked + .toggle-label .toggle-slider {
        background-color: #9ca3af;
      }

      .toggle-help-text {
        font-size: 0.875rem;
        color: #6b7280;
        margin-top: 4px;
      }

      .toggle-display {
        display: flex;
        align-items: center;
      }

      .toggle-status {
        display: flex;
        align-items: center;
        padding: 6px 12px;
        border-radius: 16px;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
      }

      .toggle-on {
        background-color: #dcfce7;
        color: #166534;
        border: 1px solid #bbf7d0;
      }

      .toggle-off {
        background-color: #fef2f2;
        color: #991b1b;
        border: 1px solid #fecaca;
      }

      /* Dark mode support */
      @media (prefers-color-scheme: dark) {
        .toggle-slider {
          background-color: #374151;
        }

        .toggle-input:checked + .toggle-label .toggle-slider {
          background-color: #10b981;
        }

        .toggle-help-text {
          color: #9ca3af;
        }

        .toggle-on {
          background-color: #064e3b;
          color: #6ee7b7;
          border: 1px solid #047857;
        }

        .toggle-off {
          background-color: #7f1d1d;
          color: #fca5a5;
          border: 1px solid #dc2626;
        }
      }
    </style>
    """
  end

  # Helper functions
  defp get_field_value(assigns) do
    case Map.get(assigns, :value) do
      true -> true
      "true" -> true
      _ -> false
    end
  end

  defp input_name(form, field) do
    Phoenix.HTML.Form.input_name(form, field.attribute)
  end

  defp input_id(form, field) do
    Phoenix.HTML.Form.input_id(form, field.attribute)
  end

  defp input_validations(form, field) do
    Phoenix.HTML.Form.input_validations(form, field.attribute)
  end
end
