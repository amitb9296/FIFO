# FIFO
A FIFO (first-in-first-out) buffer is an "elastic" storage between two subsystems. 
It has two control signals, wr and rd, for write and read operations. 
When wr is asserted, the input data is written into the buffer. 
The head of the FIFO buffer is normally always available and thus can be read at any time. 
The rd signal actually acts like a "remove" signal. When it is asserted, the first item (i.e., head) of the FIFO buffer is removed and the
next item becomes available.

The registers in the register file are arranged as a
queue with two pointers. The write pointer points to the head of the queue, and the
read pointer points to the tail of the queue. 
The pointer advances one position for each write or read operation.

A FIFO buffer contains two status signals, full and empty, to indicate that the
FIFO is full (i.e., cannot be written) and empty (i.e., cannot be read), respectively. 
One of the two conditions occurs when the read pointer is equal to the write pointer.
