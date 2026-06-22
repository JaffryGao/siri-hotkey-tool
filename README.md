# Siri Hotkey Tool

![Siri Hotkey Tool screenshot](assets/siri-hotkey-tool.png)

Languages: [English](#english) | [中文](#中文)

## English

Change the keyboard shortcut for the new macOS 27 Siri / Apple Intelligence `Search or Ask` entry point.

On macOS 27, Apple binds this new Siri entry point to double-press Command by default. That shortcut is easy to trigger accidentally, and it can conflict with existing tools such as Raycast, launchers, automation utilities, or personal keyboard workflows.

The confusing part is that this shortcut is not Spotlight. It is also not saved in the normal macOS keyboard shortcut settings. In some macOS 27 builds, System Settings does not expose a reliable place to change it.

This tool wraps the hidden Siri preference API in a small command-line script, so you can change the shortcut directly.

## Quick Start

```bash
cd ~/Downloads/siri-hotkey-tool
chmod +x ./siri-hotkey
./siri-hotkey set cmd-space
```

## Choose A Shortcut

Run one command based on what you want:

| I want Siri to use... | Run this |
| --- | --- |
| Command + Space | `./siri-hotkey set cmd-space` |
| Command + Shift + Space | `./siri-hotkey set cmd-shift-space` |
| Command + Option + Space | `./siri-hotkey set cmd-option-space` |
| Control + Option + Space | `./siri-hotkey set ctrl-option-space` |
| Command + Return | `./siri-hotkey set cmd-return` |
| Command + Option + Return | `./siri-hotkey set cmd-option-return` |
| Double right Command | `./siri-hotkey set right` |
| Double left Command | `./siri-hotkey set left` |
| Double either Command, Apple's default | `./siri-hotkey set either` |
| No Siri keyboard shortcut | `./siri-hotkey set off` |

## Check Current Setting

```bash
./siri-hotkey status
```

This prints the shortcut currently saved by Siri.

## Show Help

```bash
./siri-hotkey list
```

This prints the supported shortcuts, custom syntax, and examples.

## Notes

- Command-based shortcuts do not distinguish left Command from right Command.
- Double-Command shortcuts can distinguish left, right, or either Command.
- If a change does not take effect immediately, restart Siri or reboot macOS.
- The helper is compiled locally into `~/Library/Caches/siri-hotkey-tool/`.

## Advanced Custom Shortcut

Most users should use the commands above. If you need a custom key combination, use:

```bash
./siri-hotkey custom-sae <charCode> <keyCode> <modifiers>
```

Example, Command + Shift + Space:

```bash
./siri-hotkey custom-sae 32 49 1179648
```

Modifier masks:

```text
Shift   = 131072
Control = 262144
Option  = 524288
Command = 1048576
Fn      = 8388608
```

## 中文

修改 macOS 27 新版 Siri / Apple Intelligence `Search or Ask` 入口的键盘快捷键。

在 macOS 27 里，Apple 默认把这个新版 Siri 入口绑定为“双击 Command”。这个快捷键很容易误触，也可能和 Raycast、启动器、自动化工具，或者你自己的键盘习惯冲突。

容易让人困惑的是：这个入口不是 Spotlight。它也不保存在 macOS 常规的键盘快捷键设置里。在某些 macOS 27 版本中，系统设置里甚至没有稳定可用的修改入口。

这个工具把隐藏的 Siri 偏好 API 封装成了一个小命令行脚本，让你可以直接修改这个快捷键。

## 快速开始

```bash
cd ~/Downloads/siri-hotkey-tool
chmod +x ./siri-hotkey
./siri-hotkey set cmd-space
```

## 选择你想要的快捷键

想把 Siri 改成什么快捷键，就运行对应命令：

| 我想让 Siri 使用... | 运行这条命令 |
| --- | --- |
| Command + Space | `./siri-hotkey set cmd-space` |
| Command + Shift + Space | `./siri-hotkey set cmd-shift-space` |
| Command + Option + Space | `./siri-hotkey set cmd-option-space` |
| Control + Option + Space | `./siri-hotkey set ctrl-option-space` |
| Command + Return | `./siri-hotkey set cmd-return` |
| Command + Option + Return | `./siri-hotkey set cmd-option-return` |
| 双击右 Command | `./siri-hotkey set right` |
| 双击左 Command | `./siri-hotkey set left` |
| 双击任意 Command，Apple 默认值 | `./siri-hotkey set either` |
| 不使用 Siri 键盘快捷键 | `./siri-hotkey set off` |

## 查看当前设置

```bash
./siri-hotkey status
```

这个命令会打印 Siri 当前保存的快捷键。

## 查看帮助

```bash
./siri-hotkey list
```

这个命令会打印支持的快捷键、自定义语法和示例。

## 注意事项

- 普通 Command 组合键不区分左 Command 和右 Command。
- 双击 Command 快捷键可以区分左 Command、右 Command 或任意 Command。
- 如果修改后没有立刻生效，重启 Siri 或重启 macOS。
- helper 会在本地编译到 `~/Library/Caches/siri-hotkey-tool/`。

## 高级自定义快捷键

大多数用户直接使用上面的命令就够了。如果你需要自定义组合键，可以使用：

```bash
./siri-hotkey custom-sae <charCode> <keyCode> <modifiers>
```

示例，Command + Shift + Space：

```bash
./siri-hotkey custom-sae 32 49 1179648
```

修饰键掩码：

```text
Shift   = 131072
Control = 262144
Option  = 524288
Command = 1048576
Fn      = 8388608
```
