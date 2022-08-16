	ld de, #4000

	ld hl, GREETS
	ld b,8
1	push bc
	call greetsLine
	pop bc 
	djnz 1b

	call nextLine

	ld b,30 : halt : djnz $-1	

	; "I CAN DO IT ALL NIGHT"
	push de

	; scr -> attr
	ld a,d : rrca : rrca : rrca : and 3 : or #58 : ld d,a
	ld h,a : ld a, e : ld l, a 
	inc e

	ld bc,#001f
	ld (hl),#46
	ldir

	pop de
	push de
	ld hl, allnight
	call lib.PrintCpu
	pop de
	call nextLine
	call nextLine

	ld b,150 : halt : djnz $-1

	call lib.PrintCursor	
	dec e

	ld hl, GREETS2
	ld b,6
	call greetsFast
	call nextLine

	call lib.PrintCursor	
	dec e
	
	ld b,80 : halt : djnz $-1
	
	ld hl, GREETS3
	ld b,6
	jp greetsFast

allnight	db "I CAN DO IT ALL NIGHT", 0

greetsLine	push de
	push hl
	call lib.PrintCursor	
	dec e
	ld b,30 : halt : djnz $-1	
	ld hl, .gstrt
	call printHuman
	pop hl
	call printHuman
	inc hl
	push hl
	ld a,"\""
	call lib.PrintChar_8x8	
	pop hl
	pop de
	call nextLine
	ret
.gstrt	db "undefine \"", 0
GREETS	db "stardust", 0
	db "sibcrew", 0
	db "shiru", 0
	db "rmda", 0
	db "lom", 0
	db "errorsoft", 0
	db "demarche", 0
	db "bfox", 0

greetsFast	push bc
	push de
	call printHumanFast
	inc hl		
	pop de
	call nextLine
	dec e
	pop bc
	dec b

1	push bc	
	push de
	call printHumanFast
	inc hl	
	pop de
	call nextLine
	pop bc
	djnz 1b
	ret

GREETS2	db "undefine (uris, toughthrough,", 0
	db "prof4d, pixelrat, nodeus, vinnny", 0
	db "kakos_nonos, joe vondayl, flast,", 0
	db "helpcomputer0, grongy, garvalf,", 0
	db "dman, dimidrol, devstratum,", 0
	db "blastoff, art-top, aggressor)", 0

GREETS3	db "undefine (target, speccy.pl,", 0
	db "serzhsoft, q-bone, nedopc,", 0
	db "megus, mayhem, marquee design,", 0
	db "joker, invaders, hooy-program,", 0
	db "gogin, gemba boys, excess team,", 0
	db "darklite / offence, ate bit)", 0

; GREETS2	db "undefine (aggressor, art-top,",0
; 	db "blastoff, devstratum, dimidrol,", 0
; 	db "diver, dman, garvalf, grongy,", 0
; 	db "helpcomputer0, joe vondayl,",0
; 	db "kakos_nonos, nodeus, pixelrat,",0
; 	db "prof4d, toughthrough, uris)", 0

; GREETS3	db "undefine (ate bit, darklite", 0
; 	db "excess team, gemba, gogin,",0
; 	db "hooy-program, invaders, joker,",0
; 	db "marquee design, mayhem, megus,",0
; 	db "nedopc, offence, q-bone,", 0
; 	db "serzhsoft, speccy.pl, target)",0

nextLine	ld b, 8
	call lib.DownDE
	djnz $-3
	ret

; Print zero ended string with font 8х8 - human speed
; DE - Screen memory address
; HL - Text pointer
printHuman 	ld a, (hl)
	or a : ret z
	push af
	ld a,"_"
	call lib.PrintChar_8x8
	pop af
	dec de
	dec hl
	halt : halt
	call lib.PrintChar_8x8
	jr printHuman

printHumanFast 	ld a, (hl)
	or a : ret z
	push af
	ld a,"_"
	call lib.PrintChar_8x8
	pop af
	dec de
	dec hl
	halt
	call lib.PrintChar_8x8
	jr printHumanFast