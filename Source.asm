INCLUDE Irvine32.inc

.data
Array DWORD 1200 DUP(?)
frame_x DWORD 50 ;邊框
frame_y DWORD 24
wall BYTE "□",0
space BYTE "  ",0
food BYTE "★",0
snake1 BYTE "■",0

snake struct	;用struct定義蛇的座標
	x DWORD ?
	y DWORD ?
snake ENDS

Arraysnake snake 1200 DUP(<40,17>,<40,18>,<40,19>,<40,20>,<40,21>,<40,22>,<0,0>)	;初始化蛇的座標
count DWORD ?
countt DWORD ?
count1 DWORD ?
foodx DWORD ?
foody DWORD ?
dir BYTE 48H	;初始化蛇的位置向上
gameover BYTE "GAMEOVER",0
scoreis BYTE "SCORE:",0
level1 BYTE "1.EASY",0
level2 BYTE "2.HARD",0
over DWORD 0
tailx DWORD ?
taily DWORD ?
eaten DWORD ?
score DWORD 0
eatitselff DWORD 0
speedd DWORD 3
time DWORD 120
blockx DWORD ?
blocky DWORD ?

.code
main PROC
	MOV edx,OFFSET level1
	call WriteString
	call crlf
	MOV edx,OFFSET level2
	call WriteString
	call crlf
	call readInt	;使用者選擇難易度
	cmp eax,1
	je easy
	cmp eax,2
	je hard
	hard:
		call frame_proc2	;進入較難關卡
		jmp GO
	easy:
		call frame_proc1	;進入較簡關卡
	GO:
	MOV ecx,1
	START:
		cmp over,1
		je ENDEND
		INC ecx
		call Readkey	;讀取方向
		jnz notsame		;使用者沒輸入方向會回傳1
		jz same		;使用者輸入方向則回傳0
		notsame:
			call direction
			jmp NONEE
		same:
			mov ah, dir
			call direction
			jmp NONEE
		NONEE:

	LOOP START
	ENDEND:

EXIT
main ENDP

frame_proc1 PROC uses ebx ecx edx esi	;space=0 ,wall=1 ,food=2 ,snake=3
	MOV ecx,frame_x
	MOV esi,0
	L1:
		MOV Array[esi],1	;設定圍牆
		ADD esi,4
	LOOP L1
	MOV ebx,frame_y
	SUB ebx,2
	MOV ecx,ebx
	MOV esi,200		;第二橫排第一個
	L2:
		MOV Array[esi],1
		ADD esi,196		;每一橫排最後一個
		MOV Array[esi],1
		Add esi,4	;每一橫排第一個
	LOOP L2
	MOV esi,4600	;最後一橫排第一個
	MOV ecx,frame_x
	L3:
		MOV Array[esi],1
		ADD esi,4
	LOOP L3
	MOV esi,204		;第二橫排第二個
	MOV ebx,frame_y
	SUB ebx,2
	MOV ecx,ebx
	MOV ebx,frame_x
	SUB ebx,2
	L4:
		MOV count,ecx
		MOV ecx,ebx
		L5:
			MOV Array[esi],0
			ADD esi,4 
		LOOP L5
		MOV ecx,count
		ADD esi,8
	LOOP L4

	call lengthofarray
	MOV ecx,count1		;蛇的長度
	MOV esi,0
	L8:
		CMP Arraysnake[esi].x,0		
		je xiszero
		jne xisnotzero
		xiszero:
		CMP Arraysnake[esi].y,0		;x=0,y=0則為空白
		je OUTX
		xisnotzero:
		MOV eax,Arraysnake[esi].y
		MUL frame_x
		ADD eax,Arraysnake[esi].x
		MOV ebx,4
		MUL ebx
		ADD esi,8
		MOV Array[eax],3
	LOOP L8
	OUTX:
	call print
	call createfood
	mov dl,0	;showscore
	mov dh,24	;座標到(0,24)
	call Gotoxy 
	mov edx,OFFSET scoreis
	call writeString
	call showscore

ret
frame_proc1 ENDP

frame_proc2 PROC uses ebx ecx edx esi	;wall=1, space=0,food=2,snake=3
	MOV ecx,frame_x
	MOV esi,0
	L1:
		MOV Array[esi],1
		ADD esi,4
	LOOP L1
	MOV ebx,frame_y
	SUB ebx,2
	MOV ecx,ebx
	MOV esi,200
	L2:
		MOV Array[esi],1
		ADD esi,196
		MOV Array[esi],1
		Add esi,4
	LOOP L2
	MOV esi,4600
	MOV ecx,frame_x
	L3:
		MOV Array[esi],1
		ADD esi,4
	LOOP L3
	MOV esi,204
	MOV ebx,frame_y
	SUB ebx,2
	MOV ecx,ebx
	MOV ebx,frame_x
	SUB ebx,2
	L4:
		MOV count,ecx
		MOV ecx,ebx
		L5:
			MOV Array[esi],0
			ADD esi,4 
		LOOP L5
		MOV ecx,count
		ADD esi,8
	LOOP L4

	MOV blockx,13	;設定障礙物
	MOV blocky,7
	MOV ecx,10
	MOV eax,blocky
	MUL frame_x
	ADD eax,blockx
	MOV ebx,4
	MUL ebx
	MOV esi,eax
	BLOCK1:
		MOV Array[esi],1
		ADD esi,200
	LOOP BLOCK1

	MOV blockx,36
	MOV blocky,7
	MOV ecx,10
	MOV eax,blocky
	MUL frame_x
	ADD eax,blockx
	MOV ebx,4
	MUL ebx
	MOV esi,eax
	BLOCK2:
		MOV Array[esi],1
		ADD esi,200
	LOOP BLOCK2

	MOV blockx,11
	MOV blocky,12
	MOV ecx,28
	MOV eax,blocky
	MUL frame_x
	ADD eax,blockx
	MOV ebx,4
	MUL ebx
	MOV esi,eax
	BLOCK3:
		MOV Array[esi],1
		ADD esi,4
	LOOP BLOCK3

	call lengthofarray
	MOV ecx,count1
	MOV esi,0
	L8:
		CMP Arraysnake[esi].x,0
		je xiszero
		jne xisnotzero
		xiszero:
		CMP Arraysnake[esi].y,0
		je OUTX
		xisnotzero:
		MOV eax,Arraysnake[esi].y
		MUL frame_x
		ADD eax,Arraysnake[esi].x
		MOV ebx,4
		MUL ebx
		ADD esi,8
		MOV Array[eax],3
	LOOP L8
	OUTX:
	call print
	call createfood
	;showscore
	mov dl,0
	mov dh,24
	call Gotoxy 
	mov edx,OFFSET scoreis
	call writeString
	call showscore

ret
frame_proc2 ENDP


print PROC uses ebx ecx edx esi
	call  Clrscr
	MOV ecx,frame_y
	MOV esi,0
	L6:
		MOV count,ecx
		MOV ecx,frame_x
		L7:
			CMP Array[esi],0
			je equalzero
			CMP Array[esi],1
			je equalone
			CMP Array[esi],3
			je equalthree
			equalzero:
				MOV edx,OFFSET space
				call WriteString
				ADD esi,4
				jmp NONE
			equalone:
				MOV edx,OFFSET wall
				call WriteString
				ADD esi,4
				jmp NONE
			equalthree:
				MOV edx,OFFSET snake1
				call WriteString
				ADD esi,4
				jmp NONE
			NONE:

		LOOP L7
		MOV ecx,count
		call crlf
	LOOP L6
ret
print ENDP

direction PROC uses ebx ecx edx esi
	cmp ah, 48H            ; Control of the motion if it is upwards.
	je com1
	cmp ah, 50H            ; Control of the motion if it is downwards. 
	je com2
	cmp ah, 4BH            ; Control of the motion if it is leftwards. 
	je com3
	cmp ah, 4DH            ; Control of the motion if it is rightwards. 
	je com4
	jne NON
	com1:
		cmp dir, 50H
		je Down
		jmp Up
	com2:
		cmp dir, 48H
		je Up
		jmp Down
	com3:
		cmp dir, 4DH
		je Right
		jmp Left
	com4:
		cmp dir, 4BH
		je Left
		jmp Right

	Up:
		mov dir, 48H
		call moveindex
		MOV edx,Arraysnake[8].x	;丟x座標
		MOV Arraysnake[0].x,edx
		MOV edx,Arraysnake[8].y ;丟y座標
		DEC edx
		MOV Arraysnake[0].y,edx
		MOV eax,Arraysnake[0].y ;改值
		MUL frame_x
		ADD eax,Arraysnake[0].x
		MOV esi,4
		MUL esi
		cmp Array[eax],1
		je OVEROVER
		MOV Array[eax],3
		jmp NON

	Down:
		mov dir, 50h
		call moveindex
		MOV edx,Arraysnake[8].x	;丟x座標
		MOV Arraysnake[0].x,edx
		MOV edx,Arraysnake[8].y ;丟y座標
		INC edx
		MOV Arraysnake[0].y,edx
		MOV eax,Arraysnake[0].y ;改值
		MUL frame_x
		ADD eax,Arraysnake[0].x
		MOV esi,4
		MUL esi
		cmp Array[eax],1
		je OVEROVER
		MOV Array[eax],3
		jmp NON

	Left:
		mov dir, 4Bh
		call moveindex
		MOV edx,Arraysnake[8].x	;丟x座標
		DEC edx
		MOV Arraysnake[0].x,edx
		MOV edx,Arraysnake[8].y ;丟y座標
		MOV Arraysnake[0].y,edx
		MOV eax,Arraysnake[0].y ;改值
		MUL frame_x
		ADD eax,Arraysnake[0].x
		MOV esi,4
		MUL esi
		cmp Array[eax],1
		je OVEROVER
		MOV Array[eax],3
		jmp NON

	Right:
		mov dir, 4Dh
		call moveindex
		MOV edx,Arraysnake[8].x	;丟x座標
		INC edx
		MOV Arraysnake[0].x,edx
		MOV edx,Arraysnake[8].y ;丟y座標
		MOV Arraysnake[0].y,edx
		MOV eax,Arraysnake[0].y ;改值
		MUL frame_x
		ADD eax,Arraysnake[0].x
		MOV esi,4
		MUL esi
		cmp Array[eax],1
		je OVEROVER
		MOV Array[eax],3
		jmp NON
	NON:
		call eatitself
		CMP eatitselff,1
		je OVEROVER
		jne NEXT
	OVEROVER:
		;call clrscr
		mov dl,0
		mov dh,25
		call Gotoxy 
		mov edx,OFFSET gameover
		call writeString
		call crlf
		MOV eax,1
		MOV over,eax
		jmp DONE
	NEXT:
		call eatfood
		cmp eaten,1
		jne noteat

		MOV eax,Arraysnake[0].x
		mov ebx,2
		mul ebx
		mov dl,al	;利用座標印蛇
		MOV eax,Arraysnake[0].y
		mov dh,al
		call Gotoxy 
		MOV edx,OFFSET snake1
		call WriteString

		mov eax,tailx	;利用座標印尾巴(吃到食物)
		mul ebx
		mov dl,al
		mov eax,taily
		mov dh,al
		call Gotoxy 
		MOV edx,OFFSET snake1
		call WriteString

		mov eax,time
		call Delay
		
		call createfood
		call showscore
		jmp DONE
		noteat:
			MOV eax,Arraysnake[0].x
			mov ebx,2
			mul ebx
			mov dl,al
			MOV eax,Arraysnake[0].y
			mov dh,al
			call Gotoxy 
			MOV edx,OFFSET snake1
			call WriteString
	
			mov eax,tailx	;尾巴印空白
			mul ebx
			mov dl,al
			mov eax,taily
			mov dh,al
			call Gotoxy 
			MOV edx,OFFSET space
			call WriteString
			mov eax,time
			call Delay
	DONE:

ret
direction ENDP

moveindex PROC uses ebx ecx esi
	call lengthofarray	;為了定義尾巴而記錄尾巴座標
	MOV ebx,count1	;ebx前
	DEC ebx
	MOV ecx,count1	;ecx後
	MOV eax,Arraysnake[ebx*8].x
	MOV tailx,eax
	MOV eax,Arraysnake[ebx*8].y
	MOV taily,eax
	MUL frame_x
	ADD eax,Arraysnake[ebx*8].x
	MOV esi,4
	MUL esi
	MOV Array[eax],0
	DEC ebx
	DEC ecx
	L10:
		MOV eax,Arraysnake[ebx*8].x
		MOV Arraysnake[ecx*8].x,eax
		MOV eax,Arraysnake[ebx*8].y
		MOV Arraysnake[ecx*8].y,eax
		SUB ebx,1
	LOOP L10

ret
moveindex ENDP

lengthofarray PROC uses esi ebx
	MOV count1,0
	MOV esi,0
	lengthofsnake:
		CMP Arraysnake[esi].x,0
		je xequalzero
		jne notequalzero
	xequalzero:
		CMP Arraysnake[esi].y,0
		je zero
	notequalzero:
		ADD count1,1
		ADD esi,8
		jmp lengthofsnake
	zero:
 
ret
lengthofarray ENDP

createfood PROC uses eax ebx ecx esi
	createfoodx:
		MOV ebx,frame_x
		SUB ebx,2
		MOV eax,ebx
		call randomize
		call RandomRange
		MOV foodx,eax
		CMP foodx,0		;檢查食物是否產生在牆壁上
		je createfoodx
		CMP foodx,49
		je createfoodx
		MOV ebx,frame_y
		SUB ebx,2
	createfoody:
		MOV eax,ebx
		call Randomize
		call RandomRange
		MOV foody,eax
		CMP foody,0
		je createfoody
		CMP foody,23
		je createfoody
	MOV eax,foody
	MUL frame_x
	ADD eax,foodx
	MOV ebx,4
	MUL ebx
	MOV esi,eax
	CMP Array[esi],0	;食物是否產生在空白上
	jne createfoodx 
	MOV Array[esi],2

	mov eax,foodx
	mov ebx,2
	mul ebx
	mov dl,al
	mov eax,foody
	mov dh,al
	call Gotoxy 
	MOV edx,OFFSET food
	call WriteString
	MOV eaten,0
ret
createfood ENDP

eatfood PROC uses ebx ecx edx esi
	mov ebx,foodx
	CMP ebx,Arraysnake[0].x
	jne noteatfood
	MOV ebx,foody
	CMP ebx,Arraysnake[0].y
	jne noteatfood
	MOV eax,foody
	MUL frame_x
	ADD eax,foodx
	MOV ebx,4
	MUL ebx
	MOV esi,eax
	MOV Array[esi],0
	call lengthofarray
	MOV ebx,tailx
	MOV esi,count1
	MOV Arraysnake[esi*8].x,ebx
	MOV ebx,taily
	MOV Arraysnake[esi*8].y,ebx
	MOV eax,Arraysnake[esi*8].y
	MUL frame_x
	ADD eax,Arraysnake[esi*8].x
	MOV esi,4
	MUL esi
	MOV Array[eax],3
	ADD count1,1
	MOV ebx,count1
	MOV Arraysnake[ebx*8].x,0
	MOV Arraysnake[ebx*8].y,0
	MOV eaten,1
	noteatfood:

ret
eatfood ENDP

showscore PROC uses edx
	call lengthofarray
	MOV eax,count1
	SUB eax,6
	mov score,eax
	mov dl,6
	mov dh,24
	call Gotoxy 
	MOV edx,score
	call WriteDec
	call speed
ret
showscore ENDP

eatitself PROC uses ebx ecx esi
	call lengthofarray
	MOV ecx,count1
	MOV esi,8
	DEC ecx
	testeat:
		MOV ebx,Arraysnake[esi].x
		CMP Arraysnake[0].x,ebx
		jne noteatit
		MOV ebx,Arraysnake[esi].y
		CMP Arraysnake[0].y,ebx
		jne noteatit
		jmp eatit
		noteatit:
			ADD esi,8
	loop testeat
	jmp NO
	eatit:
		MOV eatitselff,1
	NO:
ret
eatitself ENDP

speed PROC uses ebx		;速度加快
	MOV ebx,speedd
	cmp score,ebx
	je	upup
	jne NOTHING
	upup:
		SUB time,10
		ADD speedd,3
	NOTHING:

ret
speed ENDP

END main