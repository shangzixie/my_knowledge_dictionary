# 服务器集群, 不同机器之间用grpc比http好在哪里

## 高效二进制序列化

使用Protocol Buffers（protobuf）进行数据序列化和反序列化。这是一种紧凑、高效的二进制格式，比HTTP所用的JSON或XML等文本格式更小且更快, JSON或XML进行数据传输，这些格式是文本格式，数据冗余较大，占用**更多的带宽，解析速度相对较慢**。

## 强类型

grpc使用Protocol Buffers定义服务接口和消息格式，提供强类型保证, 保证了接口的一致性和可靠性。

## 多类型

grpc支持多种通讯模式: 单向RPC、服务器流式RPC、客户端流式RPC和双向流式RPC。
http 主要是基于请求-响应模型，不支持流式通信。可以通过WebSocket实现双向通信，但这与标准RESTful API设计模式不一致，需要额外的实现和维护。

## 多路复用

grpc是构建在HTTP/2之上，支持多路复用, 多路复用允许在单一连接上并行发送多个请求和响应，减少了连接管理的开销。

## http的长连接和grpc的多路复用区别

![8](/Image/network/8.png)
![9](/Image/network/9.png)