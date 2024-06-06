# assume there are manys process in OS, how to decide which process to work and how long it will work?

shceduling algorithm

## Multi-level feedback queue(MLFQ)

The fundamental problem MLFQ tries to address is two-fold. First, it would like to optimize turnaround time, which, as we saw in the previous note, is done by running shorter jobs ﬁrst; unfortunately, the OS doesn’t generally know how long a job will run for, exactly the knowledge that algorithms like SJF (or STCF) require. Second, MLFQ would like to make a system feel responsive to interactive users (i.e., users sitting and staring at the screen, waiting for a process to ﬁnish), and thus minimize response time; unfortunately, algorithms like Round Robin reduce response time but are terrible for turnaround time. Thus, our problem: given that we in general do not know anything about a process, how can we build a scheduler to achieve these goals? How can the scheduler learn, as the system runs, the characteristics of the jobs it is running, and thus make better scheduling decisions?

