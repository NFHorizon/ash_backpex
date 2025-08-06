defmodule Teen.Resources.ActivitySystem.LossRebatJar.LossRebateJar do
  @moduledoc """
  Loss Rebate Jar resource with Apple-style toggle switches for status fields.
  """

  use AshBackpex.LiveResource

  backpex do
    resource Teen.ActivitySystem.LossRebateJar
    layout({TeenWeb.Layouts, :admin})

    fields do
      field :id, Backpex.Fields.Number do
        only([:show, :index])
      end

      field :name, Backpex.Fields.Text do
        label("Jar Name")
        placeholder("Enter jar name")
      end

      field :description, Backpex.Fields.Textarea do
        label("Description")
        placeholder("Enter description")
        rows(3)
      end

      # 使用新的滑动开关替换原本的状态按钮
      field :is_active, AshBackpex.Fields.Toggle do
        label("Active Status")
        help_text("Toggle to activate or deactivate this jar")
      end

      field :is_featured, AshBackpex.Fields.Toggle do
        label("Featured")
        help_text("Mark this jar as featured")
      end

      field :auto_rebate_enabled, AshBackpex.Fields.Toggle do
        label("Auto Rebate")
        help_text("Enable automatic rebate processing")
      end

      field :notification_enabled, AshBackpex.Fields.Toggle do
        label("Notifications")
        help_text("Send notifications for this jar")
      end

      field :rebate_percentage, Backpex.Fields.Number do
        label("Rebate Percentage")
        placeholder("0.00")
      end

      field :max_rebate_amount, Backpex.Fields.Number do
        label("Max Rebate Amount")
        placeholder("0.00")
      end

      field :min_loss_amount, Backpex.Fields.Number do
        label("Minimum Loss Amount")
        placeholder("0.00")
      end

      field :start_date, Backpex.Fields.Date do
        label("Start Date")
      end

      field :end_date, Backpex.Fields.Date do
        label("End Date")
      end

      field :created_at, Backpex.Fields.DateTime do
        label("Created At")
        only([:show, :index])
        format("%Y-%m-%d %H:%M:%S")
      end

      field :updated_at, Backpex.Fields.DateTime do
        label("Updated At")
        only([:show, :index])
        format("%Y-%m-%d %H:%M:%S")
      end
    end

    filters do
      filter :is_active do
        module Teen.Filters.BooleanFilter
        label("Active Status")
      end

      filter :is_featured do
        module Teen.Filters.BooleanFilter
        label("Featured")
      end

      filter :auto_rebate_enabled do
        module Teen.Filters.BooleanFilter
        label("Auto Rebate")
      end
    end

    item_actions do
      action :activate do
        module Teen.ItemActions.ActivateJar
      end

      action :deactivate do
        module Teen.ItemActions.DeactivateJar
      end

      action :duplicate do
        module Teen.ItemActions.DuplicateJar
      end
    end

    singular_name("Loss Rebate Jar")
    plural_name("Loss Rebate Jars")
  end

  @impl Backpex.LiveResource
  def can?(assigns, action, item) do
    # 实现权限检查逻辑
    case action do
      :index -> true
      :show -> true
      :new -> has_permission?(assigns, :create_jar)
      :edit -> has_permission?(assigns, :edit_jar)
      :delete -> has_permission?(assigns, :delete_jar)
      _ -> false
    end
  end

  defp has_permission?(assigns, permission) do
    # 根据您的权限系统实现
    # 这里是一个示例实现
    case Map.get(assigns, :current_user) do
      nil -> false
      user -> user.permissions |> Enum.member?(permission)
    end
  end
end
