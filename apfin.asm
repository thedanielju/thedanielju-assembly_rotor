.ORIG x3000

LEA R0, PROMPT1
PUTS

GETC
OUT
ST R0, MODE

LEA R0, PROMPT2
PUTS

GETC
OUT
ADD R0, R0, #-16
ADD R0, R0, #-16
ADD R0, R0, #-16
ST R0, KEY

LEA R0, PROMPT3
PUTS

LEA R2, INPUT_BUF
LD R4, MAX_COUNT

GET_MSG
    GETC
    OUT
    STR R0, R2, #0
    ADD R2, R2, #1
    ADD R0, R0, #-10
    BRz END_INPUT
    ADD R4, R4, #-1
    BRp GET_MSG

END_INPUT
    ADD R2, R2, #-1
    LD R0, LF_CHAR
    STR R0, R2, #1

LEA R1, INPUT_BUF
LEA R2, OUTPUT_BUF

PROCESS_LOOP
    LDR R0, R1, #0
    ADD R0, R0, #-10
    BRz END_PROCESS

    LDR R0, R1, #0
    LD R3, MODE
    LD R4, E_CHAR
    
    ADD R5, R3, #0
    NOT R4, R4
    ADD R4, R4, #1
    ADD R5, R5, R4
    
    BRz ENCRYPT
    BRnp DECRYPT

ENCRYPT
    ADD R3, R0, #0
    AND R4, R4, #0
    ADD R4, R4, #1
    AND R5, R3, R4
    BRz ENCRYPT_ADD_BIT
    ADD R0, R3, #-1
    BRnzp ENCRYPT_CONTINUE

ENCRYPT_ADD_BIT
    ADD R0, R3, #1

ENCRYPT_CONTINUE
    LD R4, KEY
    ADD R0, R0, R4
    BRnzp STORE_RESULT

DECRYPT
    LD R4, KEY
    NOT R4, R4
    ADD R4, R4, #1
    ADD R0, R0, R4
    ADD R3, R0, #0
    AND R4, R4, #0
    ADD R4, R4, #1
    AND R5, R3, R4
    BRz DECRYPT_ADD_BIT
    ADD R0, R3, #-1
    BRnzp STORE_RESULT

DECRYPT_ADD_BIT
    ADD R0, R3, #1

STORE_RESULT
    STR R0, R2, #0
    ADD R1, R1, #1
    ADD R2, R2, #1
    BR PROCESS_LOOP

END_PROCESS
    LDR R0, R1, #0
    STR R0, R2, #0

LEA R0, RESULT_MSG
PUTS

LEA R0, OUTPUT_BUF
PUTS

HALT

PROMPT1     .STRINGZ "\n(E)ncrypt/(D)ecrypt: "
PROMPT2     .STRINGZ "\nEncryption Key: "
PROMPT3     .STRINGZ "\nInput Message: "
RESULT_MSG  .STRINGZ "\nResult: "
MODE        .BLKW 1
KEY         .BLKW 1
INPUT_BUF   .BLKW 21
OUTPUT_BUF  .BLKW 21
E_CHAR      .FILL x0045
LF_CHAR     .FILL x000A
MAX_COUNT   .FILL #20

.END