.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
pushq %rbp
mov %rsp, %rbp

movq 8(%rsp), %rax #rip

movb (%rax), %dil
cmpb $0x0f, (%rax)
jne .continue
movb 1(%rax), %dil  ##take the second byte

.continue:
call what_to_do
cmp $0, %al
jne .not_zero

.zero:
movq %rbp, %rsp
popq %rbp
movl %eax, %edi
jmp *old_ili_handler


.not_zero:
movl %eax, %edi
pushq %rax

movq 16(%rsp), %rax
addq $2, %rax #rax now holds the address of the next instruction
movq %rax, 16(%rsp) #move %rax to %rip

popq %rax

mov %rbp, %rsp
popq %rbp
  
  
iretq
