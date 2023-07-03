# SQL中定义变量
## 1.示例SQL
```sql
#终止调拨任务
BEGIN;
#1.设置要终止的调拨任务编号
SET @allocate='XXXX2023070300001';
#获取调拨任务关联的备货申请编号
SET @stock = (SELECT stock_request_code FROM t_allocate_task where allocate_task_code = @allocate);
#1.删除占用资产
delete  from t_asset_occupy  where associated_task_code = @allocate;
#2.修改调拨任务状态
update t_allocate_task set task_state = 'terminated' where allocate_task_code = @allocate;
#3.插入调拨任务操作记录
INSERT INTO t_allocate_task_log (id, allocate_task_code, operate_type, operate_content, create_user_id, create_user_name)
SELECT MAX(id) + 1, @allocate, '终止', '由系统管理员终止', -1, '超级管理员' FROM t_allocate_task_log;

#4.修改拆分数量 
update t_stock_request_detail set split_number = 0 where stock_request_code = @stock;

commit;
```

## 2.变量定义
其中， `@allocate` 和 `@stock` 就是变量，可以在SQL中定义，然后在SQL中使用。
变量可以直接指定固定的值，也可以通过查询语句获取值。
定义完的变量可以直接在SQL中使用，如上面的SQL中的 `@allocate` 和 `@stock` 。
```sql
update t_stock_request_detail set split_number = 0 where stock_request_code = @stock;
```