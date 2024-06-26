# 详解https

## 什么是对称加密和非对称加密？

**对称加密（Symmetric Encryption**: 对称加密使用同一个密钥进行数据的加密和解密。

特点：

单一密钥：加密和解密使用同一个密钥。
速度快：对称加密算法通常比非对称加密算法更快，适用于大数据量的加密。
密钥管理难度大：需要确保密钥在传输和存储过程中不被泄露。如果密钥被盗，所有用该密钥加密的数据都可能被解密。

**非对称加密（Asymmetric Encryption）**: 非对称加密使用两个密钥进行数据加密和解密，其中一个密钥用于加密，另一个密钥用于解密。

特点:
密钥对：包括公钥（public key）和私钥（private key）。公钥用于加密，私钥用于解密，或者反过来，私钥用于加密，公钥用于解密（数字签名）。
安全性高：私钥不需要在网络上传输，因此安全性更高。即使公钥被公开，只有对应的私钥才能解密数据。
速度慢：非对称加密算法相对较慢，不适合大数据量的加密，通常用于加密小数据块或密钥交换。

一般我们不会用非对称加密来加密实际的传输内容，因为非对称加密的计算比较耗费性能的, 所以一般私钥加密只用来加密简单的信息, 例如来确认消息的身份.

**公钥加密，私钥解密**。 这个目的是为了保证内容传输的安全，因为被公钥加密的内容，其他人是无法解密的，只有持有私钥的人，才能解密出实际的内容；
**私钥加密，公钥解密**。这个目的是为了保证消息不会被冒充，因为私钥是不可泄露的，如果公钥能正常解密出私钥加密的内容，就能证明这个消息是来源于持有私钥身份的人发送的。

## https适用混合加密

在通信建立前采用非对称加密的方式交换「会话秘钥」，后续就不再使用非对称加密。
在通信过程中全部使用对称加密的「会话秘钥」的方式加密明文数据。
