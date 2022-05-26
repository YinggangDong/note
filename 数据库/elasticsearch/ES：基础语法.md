# ES:基础语法

## 查询相关
### SQL->ES
```shell
POST /_sql/translate
{
  "query":"select * FROM t_statistic_select_pro_fee where 1=1 limit 100 "
}
```

