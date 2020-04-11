#!/bin/bash

source public.sh

sql="
create database if not exists $DBNAME;
use $DBNAME;

CREATE TABLE if not exists  ods_role_recharge(
plat_id            string     comment '平台id',
server_id          int        comment '服务器ID       ',
channel_id         string     comment '渠道ID         ',
user_id            string     comment '用户ID         ',
role_id            string     comment '角色ID         ',
role_name          string     comment '角色名称       ',
event_time         int        comment '事件时间       ',
order_id           string     comment '订单ID         ',
acer_count         int        comment '获得的元宝数量 ',
recharge_amount    double     comment '充值金额       ',
order_status       int        comment '订单状态       ',
recharge_purpose   int        comment '充值用途（0:商城充值,充值获得元宝的形式1:月卡充值2:礼包充值）'
)
comment '角色充值日志'
PARTITIONED BY(part_date date)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

CREATE TABLE if not exists  tmp_ods_role_recharge(
plat_id            string     comment '平台id',
server_id          int        comment '服务器ID       ',
channel_id         string     comment '渠道ID         ',
user_id            string     comment '用户ID         ',
role_id            string     comment '角色ID         ',
role_name          string     comment '角色名称       ',
event_time         int        comment '事件时间       ',
order_id           string     comment '订单ID         ',
acer_count         int        comment '获得的元宝数量 ',
recharge_amount    double     comment '充值金额       ',
order_status       int        comment '订单状态       ',
recharge_purpose   int        comment '充值用途（0:商城充值,充值获得元宝的形式1:月卡充值2:礼包充值）'
)
comment '角色充值日志-临时表，用于将数据通过动态分区载入ods_role_recharge中'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


load data local inpath '${DATAPATH}ods_role_recharge.txt' overwrite into table tmp_ods_role_recharge;

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nostrict;
set hive.exec.max.dynamic.partitions.pernode=1000;

insert overwrite table ods_role_recharge partition(part_date)
select plat_id,server_id,channel_id,user_id,role_id,role_name,event_time,order_id,acer_count,recharge_amount,order_status,recharge_purpose,from_unixtime(event_time,'yyyy-MM-dd') as part_date from tmp_ods_role_recharge;

"

$HIVEBIN -e "$sql"