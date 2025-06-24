  .macro isr_err_stub num
isr_stub_\num:
  call	exception_handler
  iretq
  .endm

  .macro isr_no_err_stub num
isr_stub_\num:
  call exception_handler
  iretq
  .endm

.extern exception_handler
isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31

#define STUB(n)    .quad isr_stub_##n

.globl isr_stub_table
isr_stub_table:
    STUB(0)
    STUB(1)
    STUB(2)
    STUB(3)
    STUB(4)
    STUB(5)
    STUB(6)
    STUB(7)
    STUB(8)
    STUB(9)
    STUB(10)
    STUB(11)
    STUB(12)
    STUB(13)
    STUB(14)
    STUB(15)
    STUB(16)
    STUB(17)
    STUB(18)
    STUB(19)
    STUB(20)
    STUB(21)
    STUB(22)
    STUB(23)
    STUB(24)
    STUB(25)
    STUB(26)
    STUB(27)
    STUB(28)
    STUB(29)
    STUB(30)
    STUB(31)
#undef STUB
