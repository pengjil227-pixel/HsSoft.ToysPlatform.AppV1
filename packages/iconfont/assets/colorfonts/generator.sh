#!/bin/bash

# iconfont_generator.sh
# 自动生成 Flutter IconFont 类（不依赖 jq）

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT_FILE="iconfont.json"
OUTPUT_FILE="$SCRIPT_DIR/../../lib/src/color_icons.dart"

# 检查输入文件是否存在
if [ ! -f "$INPUT_FILE" ]; then
    echo "错误: 找不到输入文件 $INPUT_FILE"
    exit 1
fi

# 创建输出文件并写入头部
cat > "$OUTPUT_FILE" << 'EOF'
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'constants.dart';

const String _fontFamily = 'Colorfont';

class Colorfont {
EOF

# 解析 JSON 并提取图标信息
grep -A4 '"font_class":' "$INPUT_FILE" | while read -r line; do
    if [[ $line == *'"font_class":'* ]]; then
        font_class=$(echo "$line" | sed 's/.*"font_class": "\([^"]*\)".*/\1/')
        # 将连字符 - 转换为下划线 _
        font_class="${font_class//-/_}"
    elif [[ $line == *'"unicode":'* ]]; then
        unicode=$(echo "$line" | sed 's/.*"unicode": "\([^"]*\)".*/\1/')
        # 生成图标常量
        echo "  static const IconData $font_class = IconData(0x$unicode, fontFamily: _fontFamily, fontPackage: packageName);" >> "$OUTPUT_FILE"
    fi
done

# 写入类结束符
echo "}" >> "$OUTPUT_FILE"

echo "Colorfont 类已生成到 $OUTPUT_FILE"