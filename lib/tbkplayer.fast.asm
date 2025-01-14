//player for TBK PSG Packer
//psndcj//tbk - 11.02.2012,01.12.2013
//source for sjasm cross-assembler
							; MAX DURATION				; MIN DURATION
init	ld hl,music:jr mus_init
play	jp trb_play					; 10t					; 10t
stop	ld c,#fd,hl,#ffbf,de,#0d00
1		ld b,h:out (c),d:ld b,l:out (c),e:dec d:jp nz,1b
		ret
		
mus_init	ld (trb_play+1),hl
		xor a:ld (trb_rep+1),a
		ld a,low trb_play,(play+1),a
		jr stop

trb_pause	//pause - skip frame
	ld a,0:dec a:ld (trb_pause+1),a:jp nz,trb_rep						; 7+4+13+10=34t (10+34 = 44t)
	ld a,low trb_play,(play+1),a
	jp trb_rep

pl00		sub 120:jr nc,pl_pause
	ld de,#ffbf
//psg1
 	ld a,(hl):and #0f:cp (hl):jp nz,7f
	ld b,d:outi:ld b,e:outi
	ld a,(hl):and #0f
7	inc hl
	ld b,d:out (c),a:ld b,e:outi
	jp trb_end	
// 2 registr - maximum, second without check

pl_pause// pause or end track
	inc hl:jp z,trb_end	//pause length
	cp 4*63-120:jr z,endtrack
	//set pause
	rrca:rrca:ld (trb_pause+1),a	
	ld a,low trb_pause,(play+1),a
	jp trb_end
//
endtrack	//end of track
		call init:jp trb_play
			
trb_play	//play note
pl_track	ld hl,0					; 10t (10+10 = 20t)
inside		//single repeat
	ld a,(hl):add a:jr nc,pl0x			; 7+4+7=18t

	ld b,(hl):inc hl:ld c,(hl):res 7,b		; 7+6+7+8=28t
	add a:ld a,1:jr nc,pl10				; 4+7+7=18t (20+18+28+18 = 84t)

pl11	inc hl:ld a,(hl):res 6,b			; 6+7+8=21t

pl10	ld (trb_rest+1),hl,(trb_rep+1),a		; 16+13=29t
	sbc hl,bc:dec hl:ld a,(hl):add a		; 15+6+7+4=32t (84+21+29+32 = 166t)

pl0x	ld c,#fd					; 7t
	add a:jr nc,pl00				; 4+7=11t
pl01	// player PSG2
	exa:inc hl:ld a,(hl):inc hl:exa	//second half flag-registr; 4+6+7+6+4=27t
	ld de,#00bf					; 10t (166+7+11+27+10 = 221t)
// sjasm syntacsis!!!
		dup 6
	add a:jr nc,1f:ld b,#ff:out (c),d:ld b,e:outi	; 4+7+7+12+4+16+4=54t (221+54*6 = 545t)
1	inc d
		edup
	exa						; 4t
		dup 7
	add a:jr nc,1f:ld b,#ff:out (c),d:ld b,e:outi	; 54t (545+4+7*54 = 927t)
1	inc d
		edup
 	add a:jp nc,1f:ld b,#ff:out (c),d:ld b,e:outi	//!!! JP ������� JR (��������� �� ��������); 4+10+7+12+4+16=53t
1	
trb_end	//end of play note
	ld (pl_track+1),hl				; 16t (927+53+16 = 996t)
trb_rep	ld a,0						; 7t					; 7t
	dec a:ld (trb_rep+1),a:jr nz,bookkeeping	; 4+13+7=24t				; 4+13+12=29t (44+7+29 = 80t)
// end of repeat, restore position in track
trb_rest ld hl,0:inc hl:ld (trb_play+1),hl		; 10+6+16=32t
	ld a,low trb_play,(play+1),a			; 7+13=20t
	ret						; 10t (996+7+24+32+20+10 = 1089t)

bookkeeping inc a:ret nz:ld (trb_rep+1),a:ret							; 4+11=15t (80+15 = 95t)
	
			DISPLAY	"player code occupies ", /D, $-init, " bytes"

music	equ $