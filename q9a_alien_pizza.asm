.data
    order:      .word 987654
    msg1:       .string "Destiny Number: "
    msg2:       .string "\nFactorial of Destiny: "
    newline:    .string "\n"

.text
.globl main

main:
    # Load the order number into t0
    la   t1, order
    lw   t0, 0(t1)          # t0 = 987654

outer_loop:
    addi t2, x0, 10
    blt  t0, t2, done_reduce   # if t0 < 10, single digit reached

    # Sum digits of t0 into t3
    addi t3, x0, 0            # t3 = digit_sum = 0
digit_loop:
    beq  t0, x0, next_outer   # while t0 != 0
    # digit = t0 % 10
    addi t4, x0, 10
    # RISC-V RV32I has no rem; use: digit = t0 - (t0/10)*10
    # integer divide t0 by 10 via repeated subtraction
    addi t5, x0, 0            # t5 = quotient
div_loop:
    blt  t0, t4, div_done     # if t0 < 10 stop
    sub  t0, t0, t4
    addi t5, t5, 1
    jal  x0, div_loop
div_done:
    # now t0 = remainder (digit), t5 = quotient
    add  t3, t3, t0           # digit_sum += digit
    add  t0, t5, x0           # t0 = quotient (shift right in decimal)
    jal  x0, digit_loop

next_outer:
    add  t0, t3, x0           # t0 = new number (sum of digits)
    jal  x0, outer_loop

done_reduce:
    # t0 now holds the single-digit destiny number
    add  s0, t0, x0           # save destiny number in s0

    # Print "Destiny Number: "
    addi a7, x0, 4
    la   a0, msg1
    ecall

    # Print destiny number
    addi a7, x0, 1
    add  a0, s0, x0
    ecall

    # Print newline
    addi a7, x0, 4
    la   a0, newline
    ecall

    addi s1, x0, 1            # s1 = result = 1
    addi s2, x0, 1            # s2 = counter = 1

fact_loop:
    blt  s0, s2, fact_done    # if counter > destiny, stop
    # s1 = s1 * s2  
    addi t0, x0, 0            # t0 = product = 0
    add  t1, x0, x0           # t1 = i = 0
mul_loop:
    beq  t1, s2, mul_done
    add  t0, t0, s1
    addi t1, t1, 1
    jal  x0, mul_loop
mul_done:
    add  s1, t0, x0           # s1 = s1 * s2
    addi s2, s2, 1
    jal  x0, fact_loop

fact_done:
    # Print "Factorial of Destiny: "
    addi a7, x0, 4
    la   a0, msg2
    ecall

    # Print factorial result
    addi a7, x0, 1
    add  a0, s1, x0
    ecall

    # Print newline
    addi a7, x0, 4
    la   a0, newline
    ecall

    # Exit
    addi a7, x0, 10
    ecall
