@ Universidad del Valle de Guatemala
@ Taller de Assembler
@ Sección 21
@
@ Laboratorio 3
@
@ main.s
@
@ Jorge Manrique
@ 13600
@
@ Christopher Ajú
@ 13171
@
@ -----------------------------------

.section .init
.globl _start
_start:

b main

.section .text

main:

@@ se pone como punto de inicio para el programa la direccion #0x8000
mov sp,#0x8000


@@se usa la funcion SetGpioFunction para defnir la funcion del puerto 16 como 001(escribir)

pinNum .req r0
pinFunc .req r1

mov pinNum,#16 @@ numero de pin
mov pinFunc,#1 @@ set escribir en pin 16
bl SetGpioFunction @@ llamo a la subrutina

@@retiro los alias
.unreq pinNum 
.unreq pinFunc

ldr r0,=estadoBajo 	@apunto a la variable tipo .word
ldr r0,[r0] 	@cargo el dato de la variable

ldr r0,=estadoAlto 	@apunto a la variable tipo .word
ldr r1,[r0] 	@cargo el dato de la variable

add r3, r0, r1	@ suma de estadoBajo y estadoAlto

cmp r3, #100	@ comparacion estadoAlto + estadoBajo = 100
bne Alarma		@ si la suma no es igual a 100 ejecutar alarma.


	@ loop infinito
loop$:



b loop$

.section .data
.align 2

estadoBajo: .word 0	@ valores de 5 a 95 (%)
estadoAlto: .word 0	@ valores de 5 a 95 (%)
periodo: .word 0