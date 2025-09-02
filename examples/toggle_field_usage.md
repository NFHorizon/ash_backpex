# Apple-Style Toggle Field for AshBackpex

这个文档展示了如何在 AshBackpex 项目中使用新创建的苹果风格滑动开关字段。

## 功能特性

- 🎨 **苹果风格设计**: 模仿 iOS 开关的外观和动画
- 🌙 **深色模式支持**: 自动适配系统主题
- ♿ **无障碍访问**: 支持键盘导航和屏幕阅读器
- 🎯 **平滑动画**: 使用 CSS3 贝塞尔曲线实现流畅过渡
- 📱 **响应式设计**: 在各种屏幕尺寸下都能良好显示

## 基本用法

### 1. 在 LiveResource 中使用

```elixir
defmodule MyApp.Admin.UserLive do
  use AshBackpex.LiveResource

  backpex do
    resource MyApp.Accounts.User
    
    fields do
      # 基本用法
      field :is_active, AshBackpex.Fields.Toggle do
        label("Active Status")
      end
      
      # 带帮助文本
      field :email_notifications, AshBackpex.Fields.Toggle do
        label("Email Notifications")
        help_text("Receive email notifications for important updates")
      end
      
      # 只在特定视图中显示
      field :is_admin, AshBackpex.Fields.Toggle do
        label("Administrator")
        help_text("Grant administrative privileges")
        only([:edit, :show])
      end
    end
  end
end
```

### 2. 在 Ash Resource 中定义布尔字段

```elixir
defmodule MyApp.Accounts.User do
  use Ash.Resource

  attributes do
    uuid_primary_key :id
    
    attribute :is_active, :boolean do
      default true
      description "Whether the user account is active"
    end
    
    attribute :email_notifications, :boolean do
      default false
      description "User preference for email notifications"
    end
    
    attribute :is_admin, :boolean do
      default false
      description "Administrative privileges flag"
    end
  end
end
```

## 高级用法

### 1. 条件显示和权限控制

```elixir
field :is_admin, AshBackpex.Fields.Toggle do
  label("Administrator")
  help_text("Grant administrative privileges")
  visible(fn assigns -> 
    assigns.current_user.role == :super_admin 
  end)
  can?(fn assigns, _action, _item -> 
    assigns.current_user.permissions |> Enum.member?(:manage_admins)
  end)
end
```

### 2. 自定义样式

如果您需要自定义样式，可以在您的 CSS 文件中覆盖默认样式：

```css
/* 自定义开关颜色 */
.toggle-input:checked + .toggle-label .toggle-slider {
  background-color: #007AFF; /* iOS 蓝色 */
}

/* 自定义尺寸 */
.toggle-label {
  width: 60px;
  height: 36px;
}

.toggle-slider:before {
  height: 32px;
  width: 32px;
}

.toggle-input:checked + .toggle-label .toggle-slider:before {
  transform: translateX(24px);
}
```

### 3. 与过滤器集成

```elixir
filters do
  filter :is_active do
    module MyApp.Filters.BooleanFilter
    label("Active Users")
  end
  
  filter :email_notifications do
    module MyApp.Filters.BooleanFilter
    label("Email Subscribers")
  end
end
```

## 样式定制

### 颜色主题

您可以通过 CSS 变量来定制颜色主题：

```css
:root {
  --toggle-off-bg: #e5e7eb;
  --toggle-on-bg: #34c759;
  --toggle-thumb-bg: #ffffff;
  --toggle-shadow: rgba(0, 0, 0, 0.15);
}

[data-theme="dark"] {
  --toggle-off-bg: #374151;
  --toggle-on-bg: #10b981;
  --toggle-thumb-bg: #ffffff;
  --toggle-shadow: rgba(0, 0, 0, 0.3);
}
```

### 动画定制

```css
.toggle-slider,
.toggle-slider:before {
  transition: all 0.2s ease-in-out; /* 更快的动画 */
}

/* 或者使用弹性动画 */
.toggle-slider:before {
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
```

## 最佳实践

1. **语义化标签**: 使用清晰、描述性的标签
2. **帮助文本**: 为复杂的开关提供说明
3. **权限控制**: 根据用户权限显示/隐藏敏感开关
4. **默认值**: 为布尔字段设置合理的默认值
5. **验证**: 在 Ash Resource 中添加适当的验证规则

## 故障排除

### 常见问题

1. **开关不显示**: 确保字段类型为 `:boolean`
2. **样式冲突**: 检查是否有其他 CSS 规则覆盖了开关样式
3. **点击无响应**: 确保没有其他元素遮挡了开关区域

### 调试技巧

```elixir
# 在 LiveResource 中添加调试信息
field :is_active, AshBackpex.Fields.Toggle do
  label("Active Status")
  render(fn assigns ->
    IO.inspect(assigns.value, label: "Toggle Value")
    # 正常渲染...
  end)
end
```

## 浏览器兼容性

- ✅ Chrome 60+
- ✅ Firefox 55+
- ✅ Safari 12+
- ✅ Edge 79+
- ⚠️ IE 11 (需要 polyfill)

## 贡献

如果您发现问题或有改进建议，请提交 Issue 或 Pull Request。
