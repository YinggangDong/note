# Mysql的字段类型（一）：text

| 字段类型   | 存储字节数 |
| ---------- | ---------- |
| TINYTEXT   | 256        |
| TEXT       | 65535      |
| MEDIUMTEXT | 16777215   |
| LONGTEXT   | 4294967295 |

```
varchar和text类型对比：
varchar在MySQL中存储最大字节数为65535，在MySQL中，一个字符占用3个字节，varchar类型需要使用1~2个字节存储字段长度。所以varchar类型存储字符数最大为(65535-2)/3=21844个字符。
text存储字节数与varchar最大字节数相同，所以也可以存储21844个字符。
```

