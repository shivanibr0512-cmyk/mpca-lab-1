.data
    moves:.word 3, -1, 5, -2, 4
    N:.word 5
    msg1:.string "Final Floor: "
    msg2:.string "\nTotal floors travelled: "
    newline:.string "\n"
.text
.globl main
main:
    la   t0, moves            
    la   t1, N
    lw   t1, 0(t1)          
    addi s0, x0, 0           
    addi s1, x0, 0           
    addi t2, x0, 0           
lift_loop:
    beq  t2, t1, lift_done    
    lw   t3, 0(t0)            
    add  s0, s0, t3
    bge  t3, x0, positive_move   
    # negative: abs = 0 - t3
    sub  t4, x0, t3
    jal  x0, add_abs
positive_move:
    add  t4, t3, x0          
add_abs:
    add  s1, s1, t4
    addi t0, t0, 4            
    addi t2, t2, 1
    jal  x0, lift_loop
lift_done:
    addi a7, x0, 4
    la   a0, msg1
    ecall
    addi a7, x0, 1
    add  a0, s0, x0
    ecall
    addi a7, x0, 4
    la   a0, msg2
    ecall
    addi a7, x0, 1
    add  a0, s1, x0
    ecall
    addi a7, x0, 4
    la   a0, newline
    ecall
    addi a7, x0, 10
    ecall
