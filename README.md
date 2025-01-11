### SuperWidget 插件使用说明

`super_widget` 是一个用于简化 Flutter 开发的插件库，提供了多种实用的组件和工具。以下是该库中各个模块的功能介绍和主要参数说明。

#### 1. 引入库

首先，在 `pubspec.yaml` 文件中添加依赖：
```yaml
dependencies:
  super_widget: ^x.x.x  # 替换为实际版本号
```


然后在 Dart 文件中引入库：
```dart
import 'package:super_widget/super_widget.dart';
```


#### 2. 模块详细说明

##### 2.1 `super_load`
- **功能**：处理页面加载状态（如加载中、空数据、错误等）。
  
###### 参数说明：

| 参数名            | 类型                                              | 描述                                               |
| ----------------- | ------------------------------------------------- | -------------------------------------------------- |
| `controller`      | `SuperLoadController`                             | 控制器，用于切换不同的加载状态                     |
| `onTap`           | `FutureOr Function(Map<String, String>? params)?` | 缺省页点击事件回调                                 |
| `child`           | `Widget`                                          | 正常内容页面，用于展示给用户                       |
| `stateBuilder`    | `Widget Function(Widget widget)?`                 | 自定义缺省页包装器，默认情况下会返回定义的缺省布局 |
| `params`          | `Map<String, String>?`                            | 自定义参数，传递到 `SuperLoadPage` 中              |
| `otherPages`      | `Map<String, SuperLoadPage>?`                     | 自定义页面，key 会覆盖全局配置的 key               |
| `defaultStateTag` | `String?`                                         | 默认展示的状态标签                                 |

##### 2.2 `super_load_page`
- **功能**：定义缺省页的具体内容。

###### 参数说明：

| 参数名   | 类型                                              | 描述         |
| -------- | ------------------------------------------------- | ------------ |
| `onTap`  | `FutureOr Function(Map<String, String>? params)?` | 点击事件回调 |
| `params` | `Map<String, String>?`                            | 自定义参数   |

##### 2.3 `super_load_status`
- **功能**：定义缺省页的状态枚举。

| 枚举值     | 描述           |
| ---------- | -------------- |
| `loading`  | 加载中         |
| `empty`    | 空数据         |
| `error`    | 错误           |
| `netError` | 网络错误       |
| `content`  | 正常内容       |
| `other`    | 其他自定义状态 |

##### 2.4 `super_body`
- **功能**：提供一个可配置的页面主体容器。

###### 参数说明：

| 参数名  | 类型     | 描述         |
| ------- | -------- | ------------ |
| `child` | `Widget` | 页面主体内容 |

##### 2.5 `super_button`
- **功能**：增强的按钮组件。

###### 参数说明：

| 参数名          | 类型                    | 描述             |
| --------------- | ----------------------- | ---------------- |
| `text`          | `String`                | 按钮文本         |
| `onPressed`     | `VoidCallback?`         | 点击事件回调     |
| `icon`          | `Widget?`               | 按钮图标         |
| `color`         | `Color?`                | 按钮背景颜色     |
| `disabledColor` | `Color?`                | 禁用时的按钮颜色 |
| `padding`       | `EdgeInsetsGeometry?`   | 按钮内边距       |
| `borderRadius`  | `BorderRadiusGeometry?` | 按钮圆角半径     |

##### 2.6 `super_divider`
- **功能**：增强的分割线组件。

###### 参数说明：

| 参数名      | 类型     | 描述       |
| ----------- | -------- | ---------- |
| `height`    | `double` | 分割线高度 |
| `color`     | `Color`  | 分割线颜色 |
| `indent`    | `double` | 左侧缩进   |
| `endIndent` | `double` | 右侧缩进   |

##### 2.7 `super_keep_wrapper`
- **功能**：保持子组件状态的包装器。

###### 参数说明：

| 参数名  | 类型     | 描述                 |
| ------- | -------- | -------------------- |
| `child` | `Widget` | 需要保持状态的子组件 |

##### 2.8 `super_popup`
- **功能**：弹出窗口组件。

###### 参数说明：

| 参数名               | 类型           | 描述                 |
| -------------------- | -------------- | -------------------- |
| `title`              | `String?`      | 弹窗标题             |
| `content`            | `Widget`       | 弹窗内容             |
| `actions`            | `List<Widget>` | 弹窗操作按钮列表     |
| `barrierDismissible` | `bool`         | 点击背景是否关闭弹窗 |
| `backgroundColor`    | `Color?`       | 弹窗背景颜色         |

##### 2.9 `super_text_field`
- **功能**：增强的文本输入框组件。

###### 参数说明：

| 参数名            | 类型                    | 描述                       |
| ----------------- | ----------------------- | -------------------------- |
| `labelText`       | `String?`               | 输入框标签文本             |
| `hintText`        | `String?`               | 输入框提示文本             |
| `onChanged`       | `ValueChanged<String>?` | 文本变化事件回调           |
| `onSubmitted`     | `ValueChanged<String>?` | 提交事件回调               |
| `obscureText`     | `bool`                  | 是否隐藏输入内容（如密码） |
| `keyboardType`    | `TextInputType`         | 键盘类型                   |
| `textInputAction` | `TextInputAction`       | 输入动作类型               |

##### 2.10 Sliver 相关组件
- **功能**：提供与 `Sliver` 相关的组件。

###### 导出的 Sliver 组件：

| 组件                             | 功能                                  |
| -------------------------------- | ------------------------------------- |
| `SliverPinnedPersistentHeader`   | 固定的持久头部组件                    |
| `SliverPinnedToBoxAdapter`       | 将 Sliver 转换为 Box 的适配器         |
| `SliverAppbarExtended`           | 扩展的 SliverAppBar 组件              |
| `SliverToNestedScrollBoxAdapter` | 将 Sliver 转换为嵌套滚动的 Box 适配器 |

#### 3. 配置模块

##### 3.1 `super_widget_config`
- **功能**：全局配置项。

###### 参数说明：

| 参数名            | 类型              | 描述           |
| ----------------- | ----------------- | -------------- |
| `loadPageConfig`  | `LoadPageConfig`  | 缺省页配置     |
| `buttonConfig`    | `ButtonConfig`    | 按钮配置       |
| `dividerConfig`   | `DividerConfig`   | 分割线配置     |
| `popupConfig`     | `PopupConfig`     | 弹窗配置       |
| `textFieldConfig` | `TextFieldConfig` | 文本输入框配置 |

---

### 总结
`super_widget` 提供了一系列便捷且功能强大的组件，能够显著提升 Flutter 开发效率。通过合理使用这些组件，可以快速构建出美观且功能丰富的应用界面。以上是各个模块的功能介绍和主要参数说明，具体使用时可以根据项目需求进行调整。