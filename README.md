### SuperWidget 插件使用说明

SuperWidget 是一个功能丰富的 Flutter UI 组件库，提供了一系列常用的、高度可定制的 UI 组件，帮助开发者快速构建美观的应用界面。

#### 主要功能

1. **基础组件**

   - `SuperText`: 增强型文本组件，支持自定义样式和交互
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `text` | String | 显示的文本内容 | - |
     | `style` | TextStyle? | 文本样式 | null |
     | `textAlign` | TextAlign? | 文本对齐方式 | null |
     | `maxLines` | int? | 最大行数 | null |
     | `overflow` | TextOverflow? | 文本溢出处理方式 | null |
     | `onTap` | VoidCallback? | 点击回调 | null |

     **TextAlign 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `left` | 左对齐 |
     | `right` | 右对齐 |
     | `center` | 居中对齐 |
     | `justify` | 两端对齐 |
     | `start` | 起始位置对齐 |
     | `end` | 结束位置对齐 |

     **TextOverflow 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `clip` | 裁剪溢出文本 |
     | `fade` | 淡出溢出文本 |
     | `ellipsis` | 使用省略号表示溢出 |
     | `visible` | 显示溢出文本 |

   - `SuperRichText`: 富文本组件，支持混合文本样式
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `textSpans` | List<TextSpan> | 文本片段列表 | - |
     | `textAlign` | TextAlign? | 文本对齐方式 | null |
     | `maxLines` | int? | 最大行数 | null |
     | `overflow` | TextOverflow? | 文本溢出处理方式 | null |

   - `SuperButton`: 自定义按钮组件，支持多种样式和状态
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `text` | String | 按钮文本 | - |
     | `onPressed` | VoidCallback? | 点击回调 | null |
     | `icon` | Widget? | 按钮图标 | null |
     | `color` | Color? | 按钮背景色 | null |
     | `disabledColor` | Color? | 禁用状态背景色 | null |
     | `padding` | EdgeInsetsGeometry? | 内边距 | null |
     | `borderRadius` | BorderRadiusGeometry? | 圆角 | null |
     | `isLoading` | bool | 是否显示加载状态 | false |
     | `buttonType` | ButtonType | 按钮类型 | ButtonType.primary |

     **ButtonType 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `primary` | 主要按钮 |
     | `secondary` | 次要按钮 |
     | `outline` | 轮廓按钮 |
     | `text` | 文本按钮 |
     | `link` | 链接按钮 |

   - `SuperTextField`: 增强型输入框组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `hint` | String? | 提示文本 | null |
     | `controller` | TextEditingController? | 控制器 | null |
     | `onChanged` | ValueChanged<String>? | 文本变化回调 | null |
     | `onSubmitted` | ValueChanged<String>? | 提交回调 | null |
     | `obscureText` | bool | 是否隐藏文本 | false |
     | `keyboardType` | TextInputType | 键盘类型 | TextInputType.text |
     | `maxLines` | int | 最大行数 | 1 |
     | `prefixIcon` | Widget? | 前缀图标 | null |
     | `suffixIcon` | Widget? | 后缀图标 | null |
     | `textInputAction` | TextInputAction | 输入动作 | TextInputAction.done |

     **TextInputType 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `text` | 普通文本 |
     | `multiline` | 多行文本 |
     | `number` | 数字 |
     | `phone` | 电话号码 |
     | `datetime` | 日期时间 |
     | `emailAddress` | 邮箱地址 |
     | `url` | URL |
     | `visiblePassword` | 可见密码 |
     | `name` | 姓名 |
     | `streetAddress` | 街道地址 |

     **TextInputAction 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `none` | 无动作 |
     | `unspecified` | 未指定 |
     | `done` | 完成 |
     | `go` | 前往 |
     | `search` | 搜索 |
     | `send` | 发送 |
     | `next` | 下一个 |
     | `previous` | 上一个 |
     | `continueAction` | 继续 |
     | `join` | 加入 |
     | `route` | 路由 |
     | `emergencyCall` | 紧急呼叫 |
     | `newline` | 新行 |

   - `SuperDivider`: 自定义分割线组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `height` | double | 高度 | 1.0 |
     | `color` | Color | 颜色 | Colors.grey |
     | `indent` | double | 左侧缩进 | 0.0 |
     | `endIndent` | double | 右侧缩进 | 0.0 |
     | `thickness` | double | 厚度 | 1.0 |
     | `type` | DividerType | 分割线类型 | DividerType.horizontal |

     **DividerType 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `horizontal` | 水平分割线 |
     | `vertical` | 垂直分割线 |

   - `SuperBody`: 页面主体容器组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `child` | Widget | 子组件 | - |
     | `padding` | EdgeInsetsGeometry? | 内边距 | null |
     | `backgroundColor` | Color? | 背景色 | null |
     | `scrollDirection` | Axis | 滚动方向 | Axis.vertical |

     **Axis 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `horizontal` | 水平方向 |
     | `vertical` | 垂直方向 |

   - `SuperKeepWrapper`: 状态保持包装组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `child` | Widget | 需要保持状态的子组件 | - |
     | `keepAlive` | bool | 是否保持状态 | true |

2. **加载组件**

   - `SuperLoad`: 加载状态管理组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `controller` | SuperLoadController | 控制器 | - |
     | `onTap` | FutureOr Function(Map<String, String>?)? | 点击回调 | null |
     | `child` | Widget | 内容组件 | - |
     | `params` | Map<String, String>? | 自定义参数 | null |
     | `loadType` | LoadType | 加载类型 | LoadType.page |

     **LoadType 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `page` | 页面加载 |
     | `dialog` | 对话框加载 |
     | `toast` | 提示加载 |

   - `SuperLoadPage`: 页面加载组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `status` | SuperLoadStatus | 加载状态 | - |
     | `child` | Widget | 内容组件 | - |
     | `onTap` | VoidCallback? | 点击回调 | null |
     | `animationType` | AnimationType | 动画类型 | AnimationType.fade |

     **AnimationType 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `fade` | 淡入淡出 |
     | `scale` | 缩放 |
     | `slide` | 滑动 |
     | `none` | 无动画 |

   - `SuperLoadStatus`: 加载状态枚举
     | 枚举值 | 描述 |
     |--------|------|
     | `loading` | 加载中 |
     | `empty` | 空数据 |
     | `error` | 错误 |
     | `netError` | 网络错误 |
     | `content` | 正常内容 |
     | `other` | 其他状态 |

3. **Sliver 组件**

   - `SliverPinnedPersistentHeader`: 固定头部组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `child` | Widget | 头部内容 | - |
     | `pinned` | bool | 是否固定 | true |
     | `floating` | bool | 是否浮动 | false |
     | `stretchMode` | StretchMode | 拉伸模式 | StretchMode.zoomBackground |

     **StretchMode 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `zoomBackground` | 背景缩放 |
     | `blurBackground` | 背景模糊 |
     | `fadeTitle` | 标题淡出 |

   - `SliverPinnedToBoxAdapter`: 固定盒子适配器
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `child` | Widget | 子组件 | - |
     | `pinned` | bool | 是否固定 | true |
     | `stretchTriggerOffset` | double | 拉伸触发偏移 | 100.0 |

   - `SliverAppbarExtended`: 扩展应用栏组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `title` | Widget | 标题 | - |
     | `actions` | List<Widget>? | 操作按钮 | null |
     | `pinned` | bool | 是否固定 | true |
     | `floating` | bool | 是否浮动 | false |
     | `expandedHeight` | double | 展开高度 | 200.0 |
     | `collapsedHeight` | double | 折叠高度 | 56.0 |
     | `toolbarHeight` | double | 工具栏高度 | 56.0 |
     | `leadingWidth` | double | 前导宽度 | 56.0 |
     | `backgroundColor` | Color? | 背景色 | null |
     | `elevation` | double | 阴影高度 | 4.0 |
     | `shape` | ShapeBorder? | 形状 | null |
     | `iconTheme` | IconThemeData? | 图标主题 | null |
     | `actionsIconTheme` | IconThemeData? | 操作图标主题 | null |
     | `textTheme` | TextTheme? | 文本主题 | null |
     | `primary` | bool | 是否为主要应用栏 | true |
     | `centerTitle` | bool | 标题是否居中 | false |
     | `excludeHeaderSemantics` | bool | 是否排除头部语义 | false |
     | `titleSpacing` | double | 标题间距 | 16.0 |
     | `collapsedOpacity` | double | 折叠不透明度 | 0.0 |
     | `stretchModes` | List<StretchMode> | 拉伸模式列表 | [StretchMode.zoomBackground] |

   - `SliverToNestedScrollBoxAdapter`: 嵌套滚动适配器
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `child` | Widget | 子组件 | - |
     | `controller` | ScrollController? | 滚动控制器 | null |
     | `physics` | ScrollPhysics? | 滚动物理特性 | null |
     | `cacheExtent` | double? | 缓存范围 | null |

4. **弹出组件**

   - `SuperPopup`: 自定义弹出框组件
     | 参数名 | 类型 | 描述 | 默认值 |
     |--------|------|------|--------|
     | `title` | String? | 标题 | null |
     | `content` | Widget | 内容 | - |
     | `actions` | List<Widget>? | 操作按钮 | null |
     | `barrierDismissible` | bool | 点击背景是否关闭 | true |
     | `backgroundColor` | Color? | 背景色 | null |
     | `shape` | ShapeBorder? | 形状 | null |
     | `animationType` | AnimationType | 动画类型 | AnimationType.fade |
     | `position` | PopupPosition | 弹出位置 | PopupPosition.center |

     **PopupPosition 枚举值**:
     | 枚举值 | 描述 |
     |--------|------|
     | `center` | 居中 |
     | `top` | 顶部 |
     | `bottom` | 底部 |
     | `left` | 左侧 |
     | `right` | 右侧 |
     | `topLeft` | 左上角 |
     | `topRight` | 右上角 |
     | `bottomLeft` | 左下角 |
     | `bottomRight` | 右下角 |

#### 使用方法

1. 添加依赖
```yaml
dependencies:
  super_widget: ^latest_version
```

2. 导入包
```dart
import 'package:super_widget/super_widget.dart';
```

3. 配置（可选）
```dart
// 在应用初始化时配置
SuperWidgetConfig.instance.configure(
  // 自定义配置项
);
```

#### 示例

1. 使用 SuperButton
```dart
SuperButton(
  text: '确定',
  onPressed: () {
    // 处理点击事件
  },
)
```

2. 使用 SuperTextField
```dart
SuperTextField(
  hint: '请输入内容',
  onChanged: (value) {
    // 处理输入变化
  },
)
```

3. 使用 SuperLoadPage
```dart
SuperLoadPage(
  status: SuperLoadStatus.loading,
  child: YourPageContent(),
)
```

更多详细用法请参考各组件的具体文档说明。

#### 注意事项

- 使用 SuperKeepWrapper 时需要注意内存管理
- SuperPopup 建议在路由级别使用
- Sliver 相关组件需要在 CustomScrollView 中使用

#### 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目。