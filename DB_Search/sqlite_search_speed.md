#### 测试数据：

sqlite> select count(*) from lw_user;
count(*)  
----------
35430     
Run Time: real 0.026 user 0.000610 sys 0.004309

以下数据都是基于该数据库得出。仅为参考，故暂不考虑其他因素影响


#### 搜索速度 - 未加密

1. 单个字段模糊搜索

sqlite> select uid from lw_user where userName like "%张%";
Run Time: real 0.021 user 0.011608 sys 0.009198

sqlite> select uid,userName,namePinyin from lw_user where userName like "%张%";
Run Time: real 0.022 user 0.012283 sys 0.009653

sqlite> select * from lw_user where userName like "%张%";
Run Time: real 0.032 user 0.014842 sys 0.011210

sqlite> select * from lw_user where namePinyin like "z%";
Run Time: real 0.044 user 0.020339 sys 0.014965

sqlite> select * from lw_user where namePinyin like "%z%";
Run Time: real 0.090 user 0.033815 sys 0.020227

sqlite> select * from lw_user where namePinyin like "%zhang%";
Run Time: real 0.033 user 0.015094 sys 0.010686

以上给出的数据表明：
1、模糊匹配输出字段越多，查找速度会变慢
2、首尾匹配比全模糊匹速度快

2. 两个字段模糊搜索

sqlite> select * from lw_user where userName like "%zhang%" OR namePinyin like "%zhang%";
Run Time: real 0.037 user 0.019218 sys 0.011365

sqlite> select * from lw_user where userName like "%张%" OR namePinyin like "%zhang%";
Run Time: real 0.037 user 0.018766 sys 0.011438

sqlite> select * from lw_user where userName like "%张%" OR namePinyin like "%q%";
Run Time: real 0.047 user 0.024153 sys 0.013698

以上数据表明：
1、两个字段模糊搜索结果集相似时，速度差别不大
2、与单个相比，速度差别不是很大

3. 多个字段模糊搜索

sqlite> select * from lw_user where userName like "%张%" OR namePinyin like "%q%" or email like "%y%";
Run Time: real 0.172 user 0.058854 sys 0.030705

4. 单个字段精确搜索

sqlite> select * from lw_user where depart_id="52000935";
Run Time: real 0.020 user 0.010334 sys 0.009053

5. 多个字段精确搜索

sqlite> select * from lw_user where depart_id="52000935" and namePinyin="fengying";
Run Time: real 0.021 user 0.010302 sys 0.009040

#### 搜索速度 - 加密








