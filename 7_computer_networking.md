# computer networking

## network core

### Network Protocols

A protocol defines the format and the order of messages exchanged between two or more communicating entities, as well as the actions taken on the transmission and/or receipt of a message or other event.

a example:
First, your computer will send a connection request message to the Web server and wait for a reply. The Web server will eventually receive your connection request message and return a connection reply message. Knowing that it is now OK to request the Web document, your computer then sends the name of the Web page it wants to fetch from that Web server in a GET message. Finally, the Web server returns the Web page (file) to your computer.

![1](Image/computer_network/1.png)

### Packet Switching

To send a message from a source end system to a destination end system, the source breaks long messages into smaller chunks of data known as **packets**. Between source and destination, each packet travels through communication links and **packet switches** (for which there are two predominant types, **routers** and **link-layer switches**). Packets are transmitted over each communication link at a rate equal to the full transmission rate of the link. So, if a source end system or a packet switch is sending a packet of L bits over a link with transmission rate R bits/sec, then the time to transmit the packet is
L / R seconds.

![2](Image/computer_network/2.png)

Most packet switches use **store-and-forward transmission** at the inputs to the links. Store-and-forward transmission means that the packet switch must receive the entire packet before it can begin to transmit the first bit of the packet onto the outbound link.

### output queue

Each packet switch has multiple links attached to it.

![3](Image/computer_network/3.png)

For each attached link, the packet switch has an output buffer (also called an output queue), which stores packets that the router is about to send into that link. The output buffers play a key role in packet switching. If an arriving packet needs to be transmitted onto a link but finds the link busy with the transmission of another packet, the arriving packet must wait in the output buffer. Thus, in addition to **the store-and-forward delays, packets suffer output buffer queuing delays.

### Forwarding Tables

how does the router determine which link it should forward the packet onto?

Packet forwarding is actually done in different ways in different types of computer networks. In the internet:

![4](Image/computer_network/4.png)

## Delay, Loss, and Throughput in Packet-Switched Networks

### delay

Recall that a packet starts in a host (the source), passes through a series of routers, and ends its journey in another host (the destination). As a packet travels from one node (host or router) to the subsequent node (host or router) along this path, the packet suffers from several types of delays at each node along the path.

The most important of these delays are **the nodal processing delay**, **queuing delay**, **transmission delay**, and **propagation delay**; together, these delays accumulate to give a **total nodal delay**.

![5](Image/computer_network/5.png)

### Processing Delay

The time required to examine the packet’s header and determine where to direct the packet is part of the processing delay. After this nodal processing, the router directs the packet to the queue that precedes the link to router B.

### Queuing Delay

The length of the queuing delay of a specific packet will depend on the number of earlier-arriving packets that are queued and waiting for transmission onto the link. if the traffic is heavy and many other packets are also waiting to be transmitted, the queuing delay will be long.

### other delay

reading books page 23

## 应用层

### 进程通信

进行通信的实际上是进程（process）而不是程序。当多个进程运行在相同的端系统 上时，它们使用进程间通信机制相互通信。
在两个不同端系统上的进程，通过跨越计算机网络交换报文（message）相互通信。进程通过一个称为套接字（socket）的软件接口向网络发送报文和从网络接收报文。socket类似于计算机的大门（端口），你讲message放到大门那，然后交给运输层传输。另一端，操作系统通过socket把传输的信息拿过来。

因此socket, 也称为应用程序和网络之间的应用程序编程接口（Application Programming Interface, API）

应用程序开发者可以控制套接字在应用层端的一切，但是对该套接字的运输层端几乎没有 控制权。

### 进程寻址

发送信息时候需要知道两个信息： 1. 目的主机（通过IP) 2. 目的主机中指定接收进程的标识符(通过端口号)

### 选个可靠的运输层

选择可靠的运输层需要考虑四个因素： 可靠数据传输、吞吐量、定时和安全性。

可靠数据传输： email等必须保证可靠数据传输，语音等可以有容忍丢失

基于以上四点，目前有两个运输层协议UDP和TCP

TCP： 1. 让客户和服务器互相交换运输层控制信息。这个所谓的握手过程提醒客户和服务器，让它们为大量分组的到来做好准备。在握手阶段后，一个TCP连接（TCP connection）就在两个进程的套接字之间建立了 2. 可靠的数据传送服务：通信进程能够依靠TCP,无差错、按适当顺序交付所有发 送的数据。3. TCP协议还具有拥塞控制机制
4. 无论TCP还是UDP都没有提供任何加密机制，这就是说发送进程传进其套接字的 数据，与经网络传送到目的进程的数据相同。所以因特网界已经研制了TCP的加强版本，称为安全套接字层（Secure Sockets Layer, SSL）

UDP：1. 是无连接的，因此在两个进程通信前没有握手过程 2. 并不保证该报文将到达接收进程。不仅如此，到达接收进程的报文也可能是乱序到达的。3. UDP没有包括拥塞控制机制，所以UDP的发送端可以用它选定的任何速率向其下层（网络层）注入数据

### 应用层协议

应用层协议（application-layer protocol）定义了运行在不同端系统上的应用程序进程如何相互传递报文。特别是应用层协议定义了：

1. 交换的报文类型，例如请求报文和响应报文
2. 各种报文类型的语法，如报文中的各个字段及这些字段是如何描述的。
3. 字段的语义，即这些字段中的信息的含义。
4. 确定一个进程何时以及如何发送报文，对报文进行响应的规则

web的应用层协议为HTTP，它定义了在浏览器和Web服务器之间传输的报文格式和序列。因此，HTTP 只是Web应用的一个部分（尽管是重要部分）
电子邮件的主要应用层协议就是SMTP， 它比Web更复杂，是因为它使用了多个而不是一个应用层协议

### web 和 HTTP

Web页面（Webpage）（也叫文档）是由对象组成的。多数Web页面含有一个HTML基本文件（base HTML file）以及几个引用对象。例如，如果一个Web页面包含HTML文本和5个JPEG图形，那么这个Web页面有6个对象。