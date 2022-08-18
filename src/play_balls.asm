	; part.balls: depack
	ld a, P_BALLS : call lib.SetPage
	ld hl, A_PART_BALLS_PACKED
	ld de, A_PART_BALLS
	call lib.Depack

	; part.preballs: play
	ld b,32
.preballsCycle	push bc
	ld de, #4000
	call A_PART_BALLS
	halt
	halt
	halt
	pop bc
	djnz .preballsCycle

	ld b, 50 : halt : djnz $-1

	; Play balls on interrupts
	ld hl,playBallsCycle
	call interrStart

	ld b, 250 : halt : djnz $-1
	
	ld hl, TRANS_PIPELINE
	ld b, (TRANS_PIPELINE_END - TRANS_PIPELINE)/3
1	push bc 
	ld a, (hl) : inc hl : ld c, a
	ld a, (hl) : inc hl
	push hl
	call A_PART_BALLS + 9
	pop hl : ld a, (hl) : inc hl
	ld b, a : halt : djnz $-1	
	pop bc : djnz 1b

	call interrStop
	jr playBallsDone
TRANS_PIPELINE	
	db %01000101, 02, 50
	db %01000101, 03, 50

	db %01000011, 00, 50
	db %01000011, 01, 50

	db %01000010, 04, 1
	db %01000100, 04, 1
	db %01000100, 05, 1
	db %01000110, 05, 1
	db %01000010, 02, 1
	db %01000111, 01, 1
	db %01000001, 00, 1
TRANS_PIPELINE_END


	; part.balls: main
playBallsCycle	ld a,#00
	inc a : and #01 : ld(playBallsCycle+1),a
	or a : ret z
	ld de, #4000
	call A_PART_BALLS + 6
	jp A_PART_BALLS + 3

playBallsDone                