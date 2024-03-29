; Nth Fibonacci number, implemented recursively with the use of a stack
;
                .ORIG   x3000
                LD      R1, FIBO_N
                JSR     FIBO
                ST      R1, RES_FIBO
                HALT
;
; R1 is the input AND the output number
FIBO            ADD     R1, R1, #-1
                BRz     base_case
                ADD     R1, R1, #-1
                BRz     base_case
                ADD     R1, R1, #2      ; When >2, restore original     
;
                AND     R0, R0, #0      ; Copy and push R7 for RET
                ADD     R0, R0, R7
                JSR     PUSH
                AND     R0, R0, #0      ; Copy and push N
                ADD     R0, R0, R1
                JSR     PUSH
;
                ADD     R1, R1, #-1
                JSR     FIBO            ; Go f(n-1)
                ST      R1, SaveRes     ; Save f(n-1)
;
                JSR     POP             ; Retrieve and pop N
                AND     R1, R1, #0
                ADD     R1, R1, R0      ; N is restored
;
                LD      R0, SaveRes
                JSR     PUSH            ; Save retrieved result to stack
;
                ADD     R1, R1, #-2
                JSR     FIBO            ; Go f(n-2)
                JSR     POP             ; Retrieve 1st arg from solution
                ADD     R1, R1, R0      ; Add args, get ret value
;
                JSR     POP             ; Retrieve and pop R7 for RET
                AND     R7, R7, #0
                ADD     R7, R7, R0      ; R7 is restored
                RET 
;   
base_case       AND     R1, R1, #0
                ADD     R1, R1, #1      ; f(1) = f(2) = 1
                RET
;
SaveRes         .FILL   x0000
FIBO_N          .FILL   x0004           ; FIBO(n) will be computed
RES_FIBO        .FILL   x0000           ; The returned result of the computation
;                   
;
; Stack implementation
; Introduction to Computing Systems: from bits and gates to C and beyond,
; Second Edition. Yale N. Patt, Sanjay J. Patel. McGraw-Hill 2005.
;
; R6 is the stack pointer, R0 is the input.
; BASE > MAX (bottom-up), BASE and MAX are the negated memory addresses of
; the ends of the range where the stack resides. 
; In this case, the stack consists of memory locations x3FFF (BASE) to x3F00 (MAX).
;
POP             ST      R2, Save2
                ST      R1, Save1
                LD      R1, BASE
                ADD     R1, R1, #-1
                ADD     R2, R6, R1
                BRz     fail_exit
                LDR     R0, R6, #0
                ADD     R6, R6, #1
                BRnzp   success_exit
PUSH            ST      R2, Save2
                ST      R1, Save1
                LD      R1, MAX
                ADD     R2, R6, R1
                BRz     fail_exit
                ADD     R6, R6, #-1
                STR     R0, R6, #0
success_exit    LD      R1, Save1
                LD      R2, Save2
                AND     R5, R5, #0
                RET
fail_exit       LD      R1, Save1
                LD      R2, Save2
                AND     R5, R5, #0
                ADD     R5, R5, #1
                RET
BASE            .FILL   xC001           ; BASE is -x3FFF
MAX             .FILL   xC100           ; MAX is -x3F00
Save1           .FILL   x0000
Save2           .FILL   x0000
;
;
                .END
