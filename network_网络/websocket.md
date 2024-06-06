# websocket

它最初使用HTTP协议进行握手，然后升级到WebSocket协议以实现全双工通信。一旦握手完成，HTTP连接会升级为WebSocket连接，这时就不再是HTTP协议，而是WebSocket协议。

HTTP/2也支持WebSocket握手，但由于HTTP/2的多路复用特性，其实现更为复杂。
HTTP/2的多路复用允许多个WebSocket连接在单个TCP连接中并行进行，而HTTP/1.1中每个WebSocket连接都需要一个单独的TCP连接。
