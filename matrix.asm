.global get_elemnt_from_matrix, multiplyMatrices
.extern set_elemnt_in_matrix
##.section .data
##.bss
##.lcomm result1 ,4
#.lcomm result2 ,4
#.lcomm sum ,4

.section .text


get_elemnt_from_matrix:
    push %rbp
    mov %rsp,%rbp  
  #  %rdi - matrix address
  #  %rsi - n
  #  %rdx - row
  #  %rcx - col
    
   imul %rsi, %rdx    #%rdx=n*row
   add %rdx,%rcx  #%rcx= n*row+col
   movl (%rdi, %rcx,4), %eax    #moved the matrix address %rcx*4 steps - (each int takes 4 bytes) 
  
   leave
   ret


multiplyMatrices:

    push %rbp
    mov %rsp,%rbp  
        
  #  %rdi - *first
  #  %rsi - *second
  #  %rdx - *result
  #  %rcx - m
  #  %r8  - n
  #  %r9  - r
  
  #  16(%rbp) - p
  
         
         mov $0, %r11          #i
         mov $0, %r12          #j
         mov $0, %r13          #k
        xor %r10, %r10 
        xor %r15, %r15
    
          
        .rowloop:
        cmp %rcx, %r11
        je .end
       
       
               .colloop:
                cmp %r9, %r12
                je .continue
                jmp .setmul 
                                                                 
        .continue:
        inc %r11
        mov $0, %r12  
        jmp .rowloop
       
        jmp .end
 

.setmul:
cmp %r8, %r13
jne .loop
jmp .module

.movj:
xor %r15, %r15
xor %r13, %r13
inc %r12
jmp .colloop    




.loop:
.get_element_from_first: 
push %rdi
push %rsi
push %rdx
push %rcx 

mov %r11, %rdx
mov %r13, %rcx
mov %r8, %rsi
     
call get_elemnt_from_matrix
movq %rax,%r10  #r10 holds the first param

pop %rcx
pop %rdx
pop %rsi
pop %rdi
   
.get_element_from_second:
push %rdi
push %rsi
push %rdx
push %rcx

movq %rsi , %rdi
movq %r9, %rsi
movq %r13, %rdx
movq %r12, %rcx

call get_elemnt_from_matrix
mov %rax,%r14 #r14 holds the second param

pop %rcx
pop %rdx
pop %rsi
pop %rdi
      

movq %r10, %rax
pushq %rdx
mul  %r14          #result in rax  
popq %rdx       
       
add %rax, %r15 #result += rax
inc %r13

jmp .setmul


             


   
 .module:
 cmpl %r15d,16(%rbp)
 jg .set_matrix
 cmpl %r15d, 16(%rbp)
 je .set_zero
 
 mov %r15, %rax
 push %rdx
 xor %rdx,%rdx
 divl 16(%rbp)
 movl %edx, %r15d
 pop %rdx
jmp .set_matrix



.set_matrix:
push %rdi
push %rsi
push %rdx
push %rcx
push %r8

movq %rdx , %rdi
movq %r9, %rsi
movq %r11, %rdx
movq %r12, %rcx
movq %r15, %r8

call set_elemnt_in_matrix

pop %r8
pop %rcx
pop %rdx
pop %rsi
pop %rdi

jmp .movj

.set_zero:
mov $0, %r15
jmp .set_matrix



        .end:
        leave 
        ret


