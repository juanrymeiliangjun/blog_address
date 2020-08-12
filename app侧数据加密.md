# app侧数据加密


## 通用的加密方式

### 对称加密

#### AES

#### DES

#### 流密码

#### 分组密码

### 非对称加密

#### RSA/RSA2

#### 离散对数公钥密码

### 哈希

#### MD5

#### SHA-1

### 新密码

#### 量子技术


#### 混沌机制


## 文件访问权限
数据存储之于数据安全最大的部分是数据加密。Amazon CTO Werner Vogels曾经总结：“AWS所有的新服务，在原型设计阶段就会考虑到对数据加密的支持。”国外的互联网公司中普遍比较重视数据加密。

#### HSM/KMS
业界的普遍问题是不加密，或者加密了但没有使用正确的方法：使用自定义UDF，算法选用不正确或加密强度不合适，或随机数问题，或者密钥没有Rotation机制，密钥没有存储在KMS中。数据加密的正确方法本身就是可信计算的思路，信任根存储在HSM中，加密采用分层密钥结构，以方便动态转换和过期失效。当Intel CPU普遍开始支持SGX安全特性时，密钥、指纹、凭证等数据的处理也将以更加平民化的方式使用类似Trustzone的芯片级隔离技术。

#### 结构化数据
这里主要是指结构化数据静态加密，以对称加密算法对诸如手机、身份证、银行卡等需要保密的字段加密持久化，另外除了数据库外，数仓里的加密也是类似的。比如，在 Amazon Redshift 服务中，每一个数据块都通过一个随机的密钥进行加密，而这些随机密钥则由一个主密钥进行加密存储。用户可以自定义这个主密钥，这样也就保证了只有用户本人才能访问这些机密数据或敏感信息。鉴于这部分属于比较常用的技术，不再展开。

#### 文件加密
对单个文件独立加密，一般情况下采用分块加密，典型的场景譬如在《互联网企业安全高级指南》一书中提到的iCloud将手机备份分块加密后存储于AWS的S3，每一个文件切块用随机密钥加密后放在文件的meta data中，meta data再用file key包裹，file key再用特定类型的data key（涉及数据类型和访问权限）加密，然后data key被master key包裹。

#### 文件系统加密
文件系统加密由于对应用来说是透明的，所以只要应用具备访问权限，那么文件系统加密对用户来说也是“无感知”的。它解决的主要是冷数据持久化后存储介质可访问的问题，即使去机房拔一块硬盘，或者从一块报废的硬盘上尝试恢复数据，都是没有用的。但是对于API鉴权漏洞或者SQL注入而言，显然文件系统的加密是透明的，只要App有权限，漏洞利用也有权限。


## app代码混淆


## 数据传输加/解密



## 参考资料

[CheckMark](https://www.binqsoft.com/bq-security/3087)</br>
[黑客入侵攻击下的银行 App，数据安全何去何从？](https://segmentfault.com/a/1190000021973351)</br>
[Android App 安全策略](https://www.jianshu.com/p/0eb6df1e9c4d)</br>
[BAT 技术博客地址](https://www.jianshu.com/p/7079454cbe92)</br>
[网易博客](https://sq.163yun.com/blog)</br>
[cloudera](https://blog.cloudera.com/)</br>
[QQ/微信数据库解密](https://cloud.tencent.com/developer/article/1090650)</br>
[Android密匙库](https://source.android.com/security/keystore)</br>

### 加密性能测试

[加密性能测试](http://being23.github.io/2015/04/02/%E5%8A%A0%E5%AF%86%E6%80%A7%E8%83%BD%E6%B5%8B%E8%AF%95/)
[openssl speed](https://blog.csdn.net/as3luyuan123/article/details/16851125)

### IoT安全

从三方面来考虑：

1、设备与云连接安全
2、设备安装安全性
3、app内保证数据的安全

[IoT 安全性概述](https://azure.microsoft.com/zh-cn/overview/internet-of-things-iot/iot-security-cybersecurity/)


### 数据风控

