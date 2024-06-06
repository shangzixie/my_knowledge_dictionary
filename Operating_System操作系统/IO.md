
## I/O

### file descriptors（APUE）

To the kernel, all open files are referred to by file descriptors. A file descriptor is a non-negative integer. When we open an existing file or create a new file, the kernel returns a file descriptor to the process.

A file is opened or created by calling either the **open** function or the **openat** function.

The file descriptor returned by open and openat is guaranteed to be the lowestnumbered unused descriptor. For example, an application
might close standard output — normally, file descriptor 1—and then open another file, knowing that it will be opened on file descriptor 1.

### architecture (OSTEP)

system designers have adopted this hierarchical approach, where components that demand high performance (such as the graphics card) are nearer the CPU. Lower performance components are further away

![2](../Image//Operating_System/2.png)

Of course, modern systems increasingly use specialized chipsets and faster point-to-point interconnects to improve performance. Such as graphics.

The CPU connects to an I/O chip via Intel’s proprietary DMI (Direct Media Interface), and the rest of the devices connect to this chip via a number of different interconnects.

![3](../Image//Operating_System/3.png)

### A Canonical Device (OSTEP)

拿一个抽象的例子来理解I/O

![4](../Image//Operating_System/4.png)

设备通过interface和操作系统内部打交道。 设备需要需要三个registers组成： status, command, data. status是告诉操作系统该设备的状态，是忙还是闲等，command就是操作系统需要告诉设备进行哪些任务操作

![4](../Image//Operating_System/5.png)

### interrupt

操作系统为了能感知一个I/O设备的状态，首先考虑的是轮询polling。 但是轮询消耗大量cpu资源。 一些工程师想到了用the interrupt.

the OS can issue a request, put the calling process to sleep, and context switch to another task. When the device is finally finished with the operation, it will raise a hardware interrupt, causing the CPU to jump into the OS at a predetermined interrupt service routine (ISR) or more simply an interrupt handler. The handler is just a piece of operating system code that will finish the request (for example, by reading data and perhaps an error code from the device) and wake the process waiting for the I/O, which can then proceed as desired.

![4](../Image//Operating_System/6.png)

### Direct Memory Access (DMA)

当进行大量数据的IO时候，interrupt也不是一个好的方法。

DMA works as follows. To transfer data to the device, for example, the OS would program the DMA engine by telling it where the data lives in memory, how much data to copy, and which device to send it to. At that point, the OS is done with the transfer and can proceed with other work. When the DMA is complete, the DMA controller raises an interrupt, and
the OS thus knows the transfer is complete.