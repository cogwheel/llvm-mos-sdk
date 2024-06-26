; Copyright 2024 LLVM-MOS Project
; Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
; See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license
; information.

; Originally from cc65. Modified from original version.

;
; Christian Groessler, May-2000
; Moved from fdtable.s to it's own file by Daniel Serpell, 2009.
;
; Convert file descriptor to IOCB number
;

        .include "atari.inc"
        .include "fd.inc"
        .globl fdtoiocb

; gets fd in ax
; return iocb index in A, fd_table index in X
; return N bit set for invalid fd
; all registers destroyed
fdtoiocb:

        cpx     #0
        bne     inval
        cmp     #MAX_FD_INDEX
        bcs     inval
        tax
        lda     fd_index,x
        asl     a                       ; create index into fd table
        asl     a
        tax
        lda     #$ff
        cmp     fd_table+ft_iocb,x      ; entry in use?
        beq     inval                   ; no, return error
        lda     fd_table+ft_usa,x       ; get usage counter
        beq     inval                   ; 0? should not happen
        lda     fd_table+ft_iocb,x      ; get iocb
        rts

inval:  ldx     #$ff                    ; sets N
        rts

