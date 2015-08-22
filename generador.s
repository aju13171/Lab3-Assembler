@@Archivo: generador.s
@@Contiene todas las subrutinas necesarias para
@@el main

@@Astable: 
@@recibe en r0: el período
@@recibe en r1 el valor del tiempo de encendido
.globl Astable
Astable:
	




@@Fail:
@@subrutina que muestra una secuencia de encendido y
apagado de 0.5s del led ok 3 veces. Se mantendra apagado
.globl Fail
Fail:
	
	

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

	
@@**************************************************
@@subrutinas Wait, GetTimeStamp, GetSystemTimerBase
@@tomadas del ejemplo ok4 
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

@@GetTimeStamp gets the current timestamp of
@@the system timer, and returns it in registers 
@@r0 and r1, with r1 being the most significant 32 bits.
.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerBase
	ldrd r0,r1,[r0,#4]
	pop {pc}

	
@@GetSystemTimerBase returns the base address of the System Timer region as a
@@physical address in register r0.
@@C++ Signature: void* GetSystemTimerBase()
.globl GetSystemTimerBase
GetSystemTimerBase: 
	ldr r0,=0x20003000
	mov pc,lr
	
	
	
	
	