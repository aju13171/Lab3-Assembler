@ Universidad del Valle de Guatemala
@ Taller de Assembler
@ Sección 21
@
@ Laboratorio 3
@
@ generador.s
@
@ Christopher Ajú
@ 13171
@
@ Jorge Manrique
@ 13600
@
@ -----------------------------------


@@Archivo: generador.s
@@Contiene todas las subrutinas necesarias para
@@el main

@@Astable: 
@@recibe en r0: el período
@@recibe en r1 el valor del tiempo de encendido
@@el tiempo se recibe en segundos y solo se hace un encendido
@@y un apagado con los tiempos enviados porque en el main
@@existe un loop infinito
.globl Astable
Astable:
	/*r0 = periodo*/
	/*r1 = tiempo de ALTO*/
	/*r2 = tiempo de BAJO*/

	SUB r2, r0, r1 /*bajo = periodo - alto*/
	/*se reasignan los registros de los estados*/
	MOV R4, R1 /*tiempo de ALTO*/
	MOV R5, R2 /*tiempo de BAJO*/
	
	/*mando instruccion de encendidio*/
	MOV R0, #16
	MOV R1, #0
	push {lr} /*se almacena el lr por subrutinas anidadas*/
	BL SetGpio
	
	/*se crea un delay con el tiempo alto*/
	MOV R3, #1 
	LSL R3, R3, #7 /*un segundo en microsegundos*/
	MUL R0, R3, R4 /*se multiplica los segundos altos por 1000000 microsegundos*/
	BL Wait /*en r0 se envia la cantidad en microsengundos a esperar*/
	
	/*mando instruccion de apagado*/
	MOV R0, #16
	MOV R1, #1
	BL SetGpio
	
	/*se crea un delay con el tiempo bajo*/
	MOV R3, #1
	LSL R3, R3, #7
	MUL R0, R3, R5 /*se multiplica los segundos bajos por 1000000 microsegundos*/
	BL Wait
	
	/*retorno al main*/
	pop{pc}
	
	

@ --------------------------------------------------------------------------------------------------------

@@subrutina Alarma que muestra una secuencia de encendido y
@ apagado de 0.5s del led ok 3 veces. Se mantendra apagado

.globl Alarma
Alarma:
	@@push {lr}
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#0	@ Encender el led
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	/*
	* Now, to create a delay, we busy the processor on a pointless quest to 
	* decrement the number 0x3F0000 to 0!
	*/
	decr .req r0
	mov decr,#0x3F0000
	wait1$: 
		sub decr,#1
		teq decr,#0
		bne wait1$
	.unreq decr

	/* NEW
	* Use our new SetGpio function to set GPIO 16 to high, causing the LED to turn 
	* off.
	*/
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#1	@ Apagar el led
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	/*
	* Wait once more.
	*/
	decr .req r0
	mov decr,#0x3F0000
	wait2$:
		sub decr,#1
		teq decr,#0
		bne wait2$
	.unreq decr
	
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#0	@ Encender el led
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	/*
	* Now, to create a delay, we busy the processor on a pointless quest to 
	* decrement the number 0x3F0000 to 0!
	*/
	decr .req r0
	mov decr,#0x3F0000
	wait3$: 
		sub decr,#1
		teq decr,#0
		bne wait3$
	.unreq decr

	/* NEW
	* Use our new SetGpio function to set GPIO 16 to high, causing the LED to turn 
	* off.
	*/
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#1	@ Apagar el led
	bl SetGpio
	.unreq pinNum
	.unreq pinVal
	
	/*
	* Wait once more.
	*/
	decr .req r0
	mov decr,#0x3F0000
	wait4$:
		sub decr,#1
		teq decr,#0
		bne wait4$
	.unreq decr
	
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#0	@ Encender el led
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	/*
	* Now, to create a delay, we busy the processor on a pointless quest to 
	* decrement the number 0x3F0000 to 0!
	*/
	decr .req r0
	mov decr,#0x3F0000
	wait5$: 
		sub decr,#1
		teq decr,#0
		bne wait5$
	.unreq decr

	/* NEW
	* Use our new SetGpio function to set GPIO 16 to high, causing the LED to turn 
	* off.
	*/
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#1	@ Apagar el led
	bl SetGpio
	.unreq pinNum
	.unreq pinVal
	@@pop{pc}
	
@ --------------------------------------------------------------------------------------------------------	

@@Check:
@@subrutina que verifica que la suma de porcentajes 
@@no es mayor a 100%
@@Recibe en R0: el porcentaje 1
@@Recibe en R1: el porcentaje 2
@@Devuelve en R0: 1 si es menor o igual a 100
@@Devuelve en R0: 0 si es mayor a 100
.globl Check
Check:
	push {lr}
	/*R0 = porcenaje 1*/
	/*R1 = porcentaje 2*/
	/*se realiza la suma*/
	ADD R0, R0, R1
	CMP R0, #100
	MOVGT R0, #0 /*si es mayor a 100 devuelve un 0*/
	BGT fin /*se termina la subrutina*/
	MOV R0 , #1 /*si no se cumplen las condiciones anteriores*/
fin:
	pop {pc}

@ --------------------------------------------------------------------------------------------------------

@@**************************************************
@@subrutinas Wait, GetTimeStamp, GetSystemTimerBase
@@tomadas del ejemplo ok04 del taller de Assembler
@@**************************************************


@@realiza un delay de una cantidad especificada en 
@@microsegundos en el R0
.globl Wait
Wait:
	delay .req r2
	mov delay,r0	
	push {lr}
	bl GetTimeStamp
	start .req r3
	mov start,r0

	loop$:
		bl GetTimeStamp
		elapsed .req r1
		sub elapsed,r0,start
		cmp elapsed,delay
		.unreq elapsed
		bls loop$
		
	.unreq delay
	.unreq start
	pop {pc}
	
@ --------------------------------------------------------------------------------------------------------

@@GetTimeStamp gets the current timestamp of
@@the system timer, and returns it in registers 
@@r0 and r1, with r1 being the most significant 32 bits.
.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerBase
	ldrd r0,r1,[r0,#4]
	pop {pc}
	
@ --------------------------------------------------------------------------------------------------------

	
@@GetSystemTimerBase returns the base address of the System Timer region as a
@@physical address in register r0.
@@C++ Signature: void* GetSystemTimerBase()
.globl GetSystemTimerBase
GetSystemTimerBase: 
	ldr r0,=0x20003000
	mov pc,lr
	
@ --------------------------------------------------------------------------------------------------------
	
@@****************************************************
@@subrutinas GetGpioAddress, setGpioFunction, SetGpio
@@tomadas del ejemplo ok04 del taller de Assembler
@@****************************************************

@@Se agrega la funcion al pin del GPIO dado por R0
.globl SetGpioFunction
SetGpioFunction:
    pinNum .req r0
    pinFunc .req r1
	cmp pinNum,#53
	cmpls pinFunc,#7
	movhi pc,lr

	push {lr}
	mov r2,pinNum
	.unreq pinNum
	pinNum .req r2
	bl GetGpioAddress
	gpioAddr .req r0

	functionLoop$:
		cmp pinNum,#9
		subhi pinNum,#10
		addhi gpioAddr,#4
		bhi functionLoop$

	add pinNum, pinNum,lsl #1
	lsl pinFunc,pinNum

	mask .req r3
	mov mask,#7					/* r3 = 111 in binary */
	lsl mask,pinNum				/* r3 = 11100..00 where the 111 is in the same position as the function in r1 */
	.unreq pinNum

	mvn mask,mask				/* r3 = 11..1100011..11 where the 000 is in the same poisiont as the function in r1 */
	oldFunc .req r2
	ldr oldFunc,[gpioAddr]		/* r2 = existing code */
	and oldFunc,mask			/* r2 = existing code with bits for this pin all 0 */
	.unreq mask

	orr pinFunc,oldFunc			/* r1 = existing code with correct bits set */
	.unreq oldFunc

	str pinFunc,[gpioAddr]
	.unreq pinFunc
	.unreq gpioAddr
	pop {pc}
	
@ --------------------------------------------------------------------------------------------------------
	
@@Envia la señal (encendido/apagado) puesto en R1 al pin del GPIO enviado por R0
.globl SetGpio
SetGpio:	
    pinNum .req r0
    pinVal .req r1

	cmp pinNum,#53
	movhi pc,lr
	push {lr}
	mov r2,pinNum	
    .unreq pinNum	
    pinNum .req r2
	bl GetGpioAddress
    gpioAddr .req r0

	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr,pinBank
	.unreq pinBank

	and pinNum,#31
	setBit .req r3
	mov setBit,#1
	lsl setBit,pinNum
	.unreq pinNum

	teq pinVal,#0
	.unreq pinVal
	streq setBit,[gpioAddr,#40]
	strne setBit,[gpioAddr,#28]
	.unreq setBit
	.unreq gpioAddr
	pop {pc}
	
@ --------------------------------------------------------------------------------------------------------
	
@@Retorna la direccion del GPIO en R0
.globl GetGpioAddress
GetGpioAddress: 
	gpioAddr .req r0
	ldr gpioAddr,=0x20200000
	mov pc,lr
	.unreq gpioAddr
	
	