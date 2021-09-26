# Mechanism

## Limited Direct Execution

 the operating system needs to somehowshare the physical CPU among many jobs running seemingly at the same time. The basic idea is simple: run one process for a little while, then run another one, and so forth. By time sharingthe CPU in this manner,virtualization is achieved.

## Direct Execution Protoco

![8](../Image/Operating_System/8.png

But this approach gives rise to a few problemsin our quest to virtualize the CPU.

1. The first is simple: if we just run aprogram, how can the OS make sure the program doesn’t do anythingthat we don’t want it to do, while still running it efficiently?
2. The second:when we are running a process, how does the operating system stop itfrom running and switch to another process, thus implementing thetimesharingwe require to virtualize the CPU?

## Problem #1: Restricted Operations

How to guarantee the process doesn's do some operation harming the operating system? the approach we take is to introduce a new processor mode,known as **user mode**;

code that runs in user mode is restricted in what itcan do. For example, when running in user mode, a process can’t issueI/O requests; doing so would result in the processor raising an exception;the OS would then likely kill the process.

**kernel mode**, which the operating system(or kernel) runs in. In this mode, code that runs can do what it likes, in-cluding privileged operations such as issuing I/O requests and executingall types of restricted instruction

: what should a user process do when it wishes to perform some kind of privileged operation,such as reading from disk? To enable this, virtually all modernhard-ware provides the ability for user programs to perform a **system call**

### system call

define: allow the kernel to carefully expose certain key pieces of functionality touser programs

To execute a system call, a program must execute a special **trap** instruction. This instruction simultaneously jumps into the kernel and raises the privilege level to kernel mode; once in the kernel, the system can now perform whatever privileged operations are needed (if allowed), and thus dothe required work for the calling process. When finished, the OS calls a special **return-from-trap** instruction, which, as you might expect, returns into the calling user program while simultaneously reducing the privi-lege level back to user mode.

how does thetrap know which code to run inside the OS?

## Problem #2: Switching Between Processes

if a process isrunning on the CPU, this by definition means the OS isnotrunning. Ifthe OS is not running, how can it do anything at all? How can the operating systemregain controlof the CPU so that it canswitch between processes?

