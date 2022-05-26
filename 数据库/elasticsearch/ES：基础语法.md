# ES:基础语法

## 索引操作

### 创建索引

形如：

```shell
PUT /索引名称
{
  "settings": {
    "属性名": "属性值"
  }
}
```

settings：就是索引库设置，其中可以定义索引库的各种属性 比如分片数 副本数等，可以不设置，都走默认

```shell
PUT /lagou-company-index
```

## 查询相关

### SQL 转化 ES

```shell
POST /_sql/translate
{
  "query":"select * FROM t_statistic_select_pro_fee where 1=1 limit 100 "
}
```

