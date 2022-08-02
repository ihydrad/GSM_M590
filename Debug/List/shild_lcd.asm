
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R4
	.DEF __lcd_x=R3
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R5

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr_100ms
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0xF:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x11:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x25,0x63,0x0,0x41,0x54,0x2B,0x43,0x4D
	.DB  0x47,0x53,0x3D,0x22,0x0,0x22,0xD,0x0
	.DB  0x41,0x54,0x44,0x2B,0x0,0x3B,0xD,0x0
	.DB  0x41,0x54,0x48,0x30,0xD,0x0,0x52,0x49
	.DB  0x4E,0x47,0x0,0x41,0x54,0x2B,0x43,0x4C
	.DB  0x49,0x50,0x3D,0x31,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x4C,0x49,0x50,0x3D,0x30,0xD
	.DB  0x0,0x43,0x4D,0x54,0x0,0x61,0x64,0x6D
	.DB  0x69,0x6E,0x31,0x32,0x33,0x34,0x35,0x36
	.DB  0x0,0x61,0x64,0x6D,0x5F,0x70,0x68,0x20
	.DB  0x69,0x73,0x3A,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4D,0x47,0x44,0x3D,0x31,0x2C,0x34,0x0
	.DB  0x73,0x77,0x5F,0x70,0x6F,0x77,0x0,0x53
	.DB  0x57,0x20,0x73,0x77,0x69,0x74,0x63,0x68
	.DB  0x65,0x64,0x21,0x0,0x77,0x61,0x69,0x74
	.DB  0x20,0x6D,0x6F,0x64,0x65,0x6D,0x2E,0x2E
	.DB  0x2E,0x0,0x41,0x54,0xD,0x0,0x4F,0x4B
	.DB  0x0,0x4D,0x6F,0x64,0x65,0x6D,0x20,0x6F
	.DB  0x6B,0x21,0x0,0x41,0x54,0x2B,0x43,0x4D
	.DB  0x47,0x46,0x3D,0x31,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x53,0x43,0x53,0x3D,0x22,0x47
	.DB  0x53,0x4D,0x22,0xD,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4E,0x4D,0x49,0x3D,0x32,0x2C,0x32
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x52,0x45
	.DB  0x47,0x3F,0xD,0x0,0x43,0x52,0x45,0x47
	.DB  0x3A,0x20,0x30,0x2C,0x31,0x0,0x52,0x53
	.DB  0x54,0x5F,0x47,0x53,0x4D,0x0,0x77,0x6F
	.DB  0x72,0x6B,0x69,0x6E,0x67,0x2E,0x2E,0x2E
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _0x10
	.DW  _0x0*2+3

	.DW  0x03
	.DW  _0x10+10
	.DW  _0x0*2+13

	.DW  0x05
	.DW  _0x12
	.DW  _0x0*2+16

	.DW  0x03
	.DW  _0x12+5
	.DW  _0x0*2+21

	.DW  0x06
	.DW  _0x12+8
	.DW  _0x0*2+24

	.DW  0x05
	.DW  _0x1A
	.DW  _0x0*2+30

	.DW  0x0B
	.DW  _0x1A+5
	.DW  _0x0*2+35

	.DW  0x0B
	.DW  _0x1A+16
	.DW  _0x0*2+46

	.DW  0x06
	.DW  _0x1A+27
	.DW  _0x0*2+24

	.DW  0x0B
	.DW  _0x1A+33
	.DW  _0x0*2+46

	.DW  0x06
	.DW  _0x1A+44
	.DW  _0x0*2+24

	.DW  0x04
	.DW  _0x21
	.DW  _0x0*2+57

	.DW  0x0C
	.DW  _0x21+4
	.DW  _0x0*2+61

	.DW  0x0B
	.DW  _0x21+16
	.DW  _0x0*2+73

	.DW  0x0C
	.DW  _0x27
	.DW  _0x0*2+84

	.DW  0x04
	.DW  _0x29
	.DW  _0x0*2+57

	.DW  0x07
	.DW  _0x29+4
	.DW  _0x0*2+96

	.DW  0x0D
	.DW  _0x29+11
	.DW  _0x0*2+103

	.DW  0x0E
	.DW  _0x34
	.DW  _0x0*2+116

	.DW  0x04
	.DW  _0x34+14
	.DW  _0x0*2+130

	.DW  0x03
	.DW  _0x34+18
	.DW  _0x0*2+134

	.DW  0x0A
	.DW  _0x37
	.DW  _0x0*2+137

	.DW  0x0B
	.DW  _0x37+10
	.DW  _0x0*2+147

	.DW  0x0F
	.DW  _0x37+21
	.DW  _0x0*2+158

	.DW  0x0D
	.DW  _0x37+36
	.DW  _0x0*2+173

	.DW  0x0A
	.DW  _0x3E
	.DW  _0x0*2+186

	.DW  0x0A
	.DW  _0x3E+10
	.DW  _0x0*2+196

	.DW  0x08
	.DW  _0x3E+20
	.DW  _0x0*2+206

	.DW  0x0B
	.DW  _0x47
	.DW  _0x0*2+73

	.DW  0x0B
	.DW  _0x47+11
	.DW  _0x0*2+214

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <alcd.h>
;#include <stdio.h>
;#include <string.h>
;
;#define SBR(port, bit)        port |= (1<<bit)
;#define CBR(port, bit)        port &= (~(1<<bit))
;#define INV(port, bit)        port ^= (1<<bit)
;#define SBRC(port, bit)      ((port & (1<<bit)) == 0)
;#define SBRS(port, bit)      ((port & (1<<bit)) != 0)
;
;#define  LIGHT_LCD           PORTB.2
;#define  RELAY_ON            DDRC.5=1
;#define  RELAY_OFF           DDRC.5=0
;#define  IN_5V               PINC.1
;#define  POWER_SW            PORTC.2
;#define  LED                 PORTB.5
;#define  SHORT               0
;#define  LONG                1
;
;#define RST_BUF              rx_wr_index=0
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;//FLAGS***********************************************
;#define START_PING_GSM      0
;#define CALL_SENDED         1
;//****************************************************
;
;#define RX_BUFFER_SIZE0 254
;char rx_buffer[RX_BUFFER_SIZE0];
;
;unsigned char rx_wr_index,
;              adm_phone_tmp[12];
;
;volatile unsigned int timer_ping;
;volatile unsigned char flag;
;
;eeprom unsigned char adm_phone[12]={0};
;
;void gsm_ping();
;void rst_gsm();
;
;interrupt [TIM1_OVF] void timer1_ovf_isr_100ms(void)
; 0000 0032 {

	.CSEG
_timer1_ovf_isr_100ms:
; .FSTART _timer1_ovf_isr_100ms
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0033   TCNT1H=0x9E58 >> 8;
	CALL SUBOPT_0x0
; 0000 0034   TCNT1L=0x9E58 & 0xff;
; 0000 0035 
; 0000 0036   //TIMER PING***************************************
; 0000 0037   timer_ping++;
	LDI  R26,LOW(_timer_ping)
	LDI  R27,HIGH(_timer_ping)
	CALL SUBOPT_0x1
; 0000 0038   if(timer_ping > 1200) // 120sec
	LDS  R26,_timer_ping
	LDS  R27,_timer_ping+1
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRLO _0x3
; 0000 0039   {
; 0000 003A     timer_ping = 0;
	LDI  R30,LOW(0)
	STS  _timer_ping,R30
	STS  _timer_ping+1,R30
; 0000 003B 
; 0000 003C     SBR(flag, START_PING_GSM);
	LDS  R30,_flag
	ORI  R30,1
	STS  _flag,R30
; 0000 003D   }
; 0000 003E   //*************************************************
; 0000 003F 
; 0000 0040 }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0043 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0044     char status,data;
; 0000 0045 
; 0000 0046     status = UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0047     data = UDR0;
	LDS  R16,198
; 0000 0048 
; 0000 0049     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
; 0000 004A     {
; 0000 004B         rx_buffer[rx_wr_index++] = data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 004C 
; 0000 004D         if (rx_wr_index == RX_BUFFER_SIZE0) RST_BUF;
	LDI  R30,LOW(254)
	CP   R30,R4
	BRNE _0x5
	CLR  R4
; 0000 004E     }
_0x5:
; 0000 004F }
_0x4:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;void init_dev()
; 0000 0052 {
_init_dev:
; .FSTART _init_dev
; 0000 0053 #pragma optsize-
; 0000 0054 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0055 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0056 #ifdef _OPTIMIZE_SIZE_
; 0000 0057 #pragma optsize+
; 0000 0058 #endif
; 0000 0059 
; 0000 005A // Input/Output Ports initialization
; 0000 005B // Port B initialization
; 0000 005C // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 005D DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x4,R30
; 0000 005E // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 005F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0060 
; 0000 0061 // Port C initialization
; 0000 0062 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0063 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(4)
	OUT  0x7,R30
; 0000 0064 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0065 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
; 0000 0066 
; 0000 0067 // Port D initialization
; 0000 0068 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0069 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0xA,R30
; 0000 006A // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 006B PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 006C 
; 0000 006D // Timer/Counter 0 initialization
; 0000 006E // Clock source: System Clock
; 0000 006F // Clock value: Timer 0 Stopped
; 0000 0070 // Mode: Normal top=0xFF
; 0000 0071 // OC0A output: Disconnected
; 0000 0072 // OC0B output: Disconnected
; 0000 0073 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0074 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 0075 TCNT0=0x00;
	OUT  0x26,R30
; 0000 0076 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0077 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0078 
; 0000 0079 // Timer/Counter 1 initialization
; 0000 007A // Clock source: System Clock
; 0000 007B // Clock value: Timer1 Stopped
; 0000 007C // Mode: Normal top=0xFFFF
; 0000 007D // OC1A output: Disconnected
; 0000 007E // OC1B output: Disconnected
; 0000 007F // Noise Canceler: Off
; 0000 0080 // Input Capture on Falling Edge
; 0000 0081 // Timer1 Overflow Interrupt: Off
; 0000 0082 // Input Capture Interrupt: Off
; 0000 0083 // Compare A Match Interrupt: Off
; 0000 0084 // Compare B Match Interrupt: Off
; 0000 0085 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 0086 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	STS  129,R30
; 0000 0087 TCNT1H=0x9E;
	CALL SUBOPT_0x0
; 0000 0088 TCNT1L=0x58;
; 0000 0089 ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 008A ICR1L=0x00;
	STS  134,R30
; 0000 008B OCR1AH=0x00;
	STS  137,R30
; 0000 008C OCR1AL=0x00;
	STS  136,R30
; 0000 008D OCR1BH=0x00;
	STS  139,R30
; 0000 008E OCR1BL=0x00;
	STS  138,R30
; 0000 008F 
; 0000 0090 // Timer/Counter 2 initialization
; 0000 0091 // Clock source: System Clock
; 0000 0092 // Clock value: 15,625 kHz
; 0000 0093 // Mode: Normal top=0xFF
; 0000 0094 // OC2A output: Disconnected
; 0000 0095 // OC2B output: Disconnected
; 0000 0096 // Timer Period: 9,984 ms
; 0000 0097 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0098 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0099 TCCR2B=(0<<WGM22) | (1<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(7)
	STS  177,R30
; 0000 009A TCNT2=0x64;
	LDI  R30,LOW(100)
	STS  178,R30
; 0000 009B OCR2A=0x00;
	LDI  R30,LOW(0)
	STS  179,R30
; 0000 009C OCR2B=0x00;
	STS  180,R30
; 0000 009D 
; 0000 009E // Timer/Counter 0 Interrupt(s) initialization
; 0000 009F TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 00A0 
; 0000 00A1 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00A2 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 00A3 
; 0000 00A4 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00A5 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 00A6 
; 0000 00A7 // External Interrupt(s) initialization
; 0000 00A8 // INT0: Off
; 0000 00A9 // INT1: Off
; 0000 00AA // Interrupt on any change on pins PCINT0-7: Off
; 0000 00AB // Interrupt on any change on pins PCINT8-14: Off
; 0000 00AC // Interrupt on any change on pins PCINT16-23: Off
; 0000 00AD EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 00AE EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00AF PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 00B0 
; 0000 00B1 // USART initialization
; 0000 00B2 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00B3 // USART Receiver: On
; 0000 00B4 // USART Transmitter: On
; 0000 00B5 // USART0 Mode: Asynchronous
; 0000 00B6 // USART Baud Rate: 9600
; 0000 00B7 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	STS  192,R30
; 0000 00B8 UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 00B9 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00BA UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00BB UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 00BC 
; 0000 00BD // Analog Comparator initialization
; 0000 00BE // Analog Comparator: Off
; 0000 00BF // The Analog Comparator's positive input is
; 0000 00C0 // connected to the AIN0 pin
; 0000 00C1 // The Analog Comparator's negative input is
; 0000 00C2 // connected to the AIN1 pin
; 0000 00C3 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00C4 // Digital input buffer on AIN0: On
; 0000 00C5 // Digital input buffer on AIN1: On
; 0000 00C6 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 00C7 
; 0000 00C8 // ADC initialization
; 0000 00C9 // ADC Clock frequency: 125,000 kHz
; 0000 00CA // ADC Voltage Reference: AVCC pin
; 0000 00CB // ADC Auto Trigger Source: ADC Stopped
; 0000 00CC // Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
; 0000 00CD // ADC4: On, ADC5: On
; 0000 00CE #define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
; 0000 00CF DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 00D0 ADMUX=ADC_VREF_TYPE;
	STS  124,R30
; 0000 00D1 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 00D2 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	STS  123,R30
; 0000 00D3 
; 0000 00D4 // SPI initialization
; 0000 00D5 // SPI Type: Master
; 0000 00D6 // SPI Clock Rate: 2*4000,000 kHz
; 0000 00D7 // SPI Clock Phase: Cycle Start
; 0000 00D8 // SPI Clock Polarity: Low
; 0000 00D9 // SPI Data Order: MSB First
; 0000 00DA SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0000 00DB SPSR=(1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0x2D,R30
; 0000 00DC 
; 0000 00DD // TWI initialization
; 0000 00DE // TWI disabled
; 0000 00DF TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	LDI  R30,LOW(0)
	STS  188,R30
; 0000 00E0 
; 0000 00E1 // Bit-Banged I2C Bus initialization
; 0000 00E2 // I2C Port: PORTC
; 0000 00E3 // I2C SDA bit: 4
; 0000 00E4 // I2C SCL bit: 5
; 0000 00E5 // Bit Rate: 100 kHz
; 0000 00E6 // Note: I2C settings are specified in the
; 0000 00E7 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 00E8 
; 0000 00E9 // Alphanumeric LCD initialization
; 0000 00EA // Connections are specified in the
; 0000 00EB // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00EC // RS - PORTB Bit 0
; 0000 00ED // RD - PORTB Bit 7
; 0000 00EE // EN - PORTB Bit 1
; 0000 00EF // D4 - PORTD Bit 4
; 0000 00F0 // D5 - PORTD Bit 5
; 0000 00F1 // D6 - PORTD Bit 6
; 0000 00F2 // D7 - PORTD Bit 7
; 0000 00F3 // Characters/line: 16
; 0000 00F4 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00F5 }
	RET
; .FEND
;
;void print_uart_to_lcd()
; 0000 00F8 {
_print_uart_to_lcd:
; .FSTART _print_uart_to_lcd
; 0000 00F9     unsigned char i = 0, array[16];
; 0000 00FA 
; 0000 00FB     if(rx_wr_index)
	SBIW R28,16
	ST   -Y,R17
;	i -> R17
;	array -> Y+1
	LDI  R17,0
	TST  R4
	BRNE PC+2
	RJMP _0x6
; 0000 00FC     {
; 0000 00FD         delay_ms(100);
	CALL SUBOPT_0x2
; 0000 00FE         lcd_clear();
	CALL _lcd_clear
; 0000 00FF         for(i = 0; i <= rx_wr_index; i++)
	LDI  R17,LOW(0)
_0x8:
	CP   R4,R17
	BRLO _0x9
; 0000 0100         {
; 0000 0101             if( rx_buffer[i] == 0x0D )
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R26,Z
	CPI  R26,LOW(0xD)
	BREQ _0x7
; 0000 0102                 continue;;
; 0000 0103             if( rx_buffer[i] == 0x0A )
	CALL SUBOPT_0x3
	LD   R26,Z
	CPI  R26,LOW(0xA)
	BRNE _0xB
; 0000 0104                 rx_buffer[i] = ' ';
	CALL SUBOPT_0x3
	LDI  R26,LOW(32)
	STD  Z+0,R26
; 0000 0105 
; 0000 0106             if(i%32 == 0 && i)
_0xB:
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL __MODW21
	SBIW R30,0
	BRNE _0xD
	CPI  R17,0
	BRNE _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 0107             {
; 0000 0108                 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 0109                 lcd_clear();
	CALL _lcd_clear
; 0000 010A             }
; 0000 010B 
; 0000 010C          sprintf(array, "%c", rx_buffer[i]);
_0xC:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
	LD   R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 010D          lcd_puts(array);
	MOVW R26,R28
	ADIW R26,1
	CALL _lcd_puts
; 0000 010E         }
_0x7:
	SUBI R17,-1
	RJMP _0x8
_0x9:
; 0000 010F         RST_BUF;
	CLR  R4
; 0000 0110         delay_ms(500);
	CALL SUBOPT_0x4
; 0000 0111     }
; 0000 0112 }
_0x6:
	LDD  R17,Y+0
	ADIW R28,17
	RET
; .FEND
;
;void send_sms(unsigned char *txt)
; 0000 0115 {
_send_sms:
; .FSTART _send_sms
; 0000 0116     unsigned char data[30] = {0};
; 0000 0117 
; 0000 0118     strcat(data, "AT+CMGS=\"");
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,30
	LDI  R24,30
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xF*2)
	LDI  R31,HIGH(_0xF*2)
	CALL __INITLOCB
;	*txt -> Y+30
;	data -> Y+0
	CALL SUBOPT_0x5
	__POINTW2MN _0x10,0
	CALL SUBOPT_0x6
; 0000 0119     strcat(data, adm_phone_tmp);
	LDI  R26,LOW(_adm_phone_tmp)
	LDI  R27,HIGH(_adm_phone_tmp)
	CALL SUBOPT_0x6
; 0000 011A     strcat(data, "\"\r");
	__POINTW2MN _0x10,10
	CALL _strcat
; 0000 011B 
; 0000 011C     delay_ms(100);
	CALL SUBOPT_0x2
; 0000 011D     puts(data);
	MOVW R26,R28
	CALL SUBOPT_0x7
; 0000 011E     delay_ms(100);
; 0000 011F     puts(txt);
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL _puts
; 0000 0120     putchar(0x1A);
	LDI  R26,LOW(26)
	CALL _putchar
; 0000 0121 }
	ADIW R28,32
	RET
; .FEND

	.DSEG
_0x10:
	.BYTE 0xD
;
;void send_call()
; 0000 0124 {

	.CSEG
_send_call:
; .FSTART _send_call
; 0000 0125     unsigned char data[20] = {0};
; 0000 0126 
; 0000 0127     strcat(data, "ATD+");
	SBIW R28,20
	LDI  R24,20
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x11*2)
	LDI  R31,HIGH(_0x11*2)
	CALL __INITLOCB
;	data -> Y+0
	CALL SUBOPT_0x5
	__POINTW2MN _0x12,0
	CALL SUBOPT_0x6
; 0000 0128     strcat(data, adm_phone_tmp);
	LDI  R26,LOW(_adm_phone_tmp)
	LDI  R27,HIGH(_adm_phone_tmp)
	CALL SUBOPT_0x6
; 0000 0129     strcat(data, ";\r");
	__POINTW2MN _0x12,5
	CALL _strcat
; 0000 012A 
; 0000 012B     delay_ms(500);
	CALL SUBOPT_0x4
; 0000 012C     puts(data);
	MOVW R26,R28
	CALL _puts
; 0000 012D     delay_ms(12000);
	LDI  R26,LOW(12000)
	LDI  R27,HIGH(12000)
	CALL _delay_ms
; 0000 012E     puts("ATH0\r");
	__POINTW2MN _0x12,8
	CALL SUBOPT_0x7
; 0000 012F     delay_ms(100);
; 0000 0130 }
	JMP  _0x2080003
; .FEND

	.DSEG
_0x12:
	.BYTE 0xE
;
;void pow_sw(unsigned char var)
; 0000 0133 {

	.CSEG
_pow_sw:
; .FSTART _pow_sw
; 0000 0134     RELAY_ON;
	ST   -Y,R26
;	var -> Y+0
	SBI  0x7,5
; 0000 0135 
; 0000 0136     if(var == SHORT)
	LD   R30,Y
	CPI  R30,0
	BRNE _0x15
; 0000 0137         delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 0138     if(var == LONG)
_0x15:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x16
; 0000 0139         delay_ms(7000);
	LDI  R26,LOW(7000)
	LDI  R27,HIGH(7000)
	CALL _delay_ms
; 0000 013A 
; 0000 013B     RELAY_OFF;
_0x16:
	CBI  0x7,5
; 0000 013C 
; 0000 013D     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 013E }
	JMP  _0x2080005
; .FEND
;
;void call_func()
; 0000 0141 {
_call_func:
; .FSTART _call_func
; 0000 0142     static unsigned char i = 0;
; 0000 0143 
; 0000 0144     if( strstr(rx_buffer, "RING") )
	CALL SUBOPT_0x8
	__POINTW2MN _0x1A,0
	CALL _strstr
	SBIW R30,0
	BREQ _0x19
; 0000 0145     {
; 0000 0146         i++;
	LDS  R30,_i_S0000007000
	SUBI R30,-LOW(1)
	STS  _i_S0000007000,R30
; 0000 0147         puts("AT+CLIP=1\r");
	__POINTW2MN _0x1A,5
	CALL SUBOPT_0x7
; 0000 0148         delay_ms(100);
; 0000 0149 
; 0000 014A         if( strstr(rx_buffer, adm_phone_tmp) )
	CALL SUBOPT_0x8
	LDI  R26,LOW(_adm_phone_tmp)
	LDI  R27,HIGH(_adm_phone_tmp)
	CALL _strstr
	SBIW R30,0
	BREQ _0x1B
; 0000 014B         {
; 0000 014C             delay_ms(100);
	CALL SUBOPT_0x2
; 0000 014D             puts("AT+CLIP=0\r");
	__POINTW2MN _0x1A,16
	CALL SUBOPT_0x7
; 0000 014E             delay_ms(100);
; 0000 014F             puts("ATH0\r");
	__POINTW2MN _0x1A,27
	CALL _puts
; 0000 0150             i = 0;
	LDI  R30,LOW(0)
	STS  _i_S0000007000,R30
; 0000 0151             pow_sw(SHORT);
	LDI  R26,LOW(0)
	RCALL _pow_sw
; 0000 0152         }
; 0000 0153 
; 0000 0154         if(i > 2)
_0x1B:
	LDS  R26,_i_S0000007000
	CPI  R26,LOW(0x3)
	BRLO _0x1C
; 0000 0155         {
; 0000 0156             i = 0;
	LDI  R30,LOW(0)
	STS  _i_S0000007000,R30
; 0000 0157             delay_ms(100);
	CALL SUBOPT_0x2
; 0000 0158             puts("AT+CLIP=0\r");
	__POINTW2MN _0x1A,33
	CALL SUBOPT_0x7
; 0000 0159             delay_ms(100);
; 0000 015A             puts("ATH0\r");
	__POINTW2MN _0x1A,44
	CALL _puts
; 0000 015B         }
; 0000 015C     }
_0x1C:
; 0000 015D }
_0x19:
	RET
; .FEND

	.DSEG
_0x1A:
	.BYTE 0x32
;
;void cpy_ram_ph()
; 0000 0160 {

	.CSEG
_cpy_ram_ph:
; .FSTART _cpy_ram_ph
; 0000 0161     unsigned char i = 0;
; 0000 0162 
; 0000 0163     for(i = 0; i < 11; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x1E:
	CPI  R17,11
	BRSH _0x1F
; 0000 0164         adm_phone_tmp[i] = adm_phone[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_adm_phone_tmp)
	SBCI R31,HIGH(-_adm_phone_tmp)
	MOVW R0,R30
	CALL SUBOPT_0x9
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x1E
_0x1F:
; 0000 0165 adm_phone_tmp[11] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _adm_phone_tmp,11
; 0000 0166 }
	RJMP _0x2080007
; .FEND
;
;void reg_admin()
; 0000 0169 {
_reg_admin:
; .FSTART _reg_admin
; 0000 016A     unsigned char i = 0;
; 0000 016B 
; 0000 016C     if( strstr(rx_buffer, "CMT") && strstr(rx_buffer, "admin123456") )
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	CALL SUBOPT_0x8
	__POINTW2MN _0x21,0
	CALL _strstr
	SBIW R30,0
	BREQ _0x22
	CALL SUBOPT_0x8
	__POINTW2MN _0x21,4
	CALL _strstr
	SBIW R30,0
	BRNE _0x23
_0x22:
	RJMP _0x20
_0x23:
; 0000 016D     {
; 0000 016E        for(i = 0; i < 11; i++)
	LDI  R17,LOW(0)
_0x25:
	CPI  R17,11
	BRSH _0x26
; 0000 016F         adm_phone[i] = rx_buffer[10 + i];      //записать номер админа в ипром
	CALL SUBOPT_0x9
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _rx_buffer,10
	LD   R30,Z
	CALL __EEPROMWRB
	SUBI R17,-1
	RJMP _0x25
_0x26:
; 0000 0171 adm_phone[i] = 0x00;
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0172 
; 0000 0173        lcd_clear();
	RCALL _lcd_clear
; 0000 0174        lcd_puts("adm_ph is:");
	__POINTW2MN _0x21,16
	CALL SUBOPT_0xA
; 0000 0175        lcd_gotoxy(0, 1);
; 0000 0176        lcd_putse(adm_phone);
; 0000 0177        delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0178 
; 0000 0179        cpy_ram_ph();
	RCALL _cpy_ram_ph
; 0000 017A     }
; 0000 017B }
_0x20:
_0x2080007:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x21:
	.BYTE 0x1B
;
;void clr_sms()
; 0000 017E {

	.CSEG
_clr_sms:
; .FSTART _clr_sms
; 0000 017F     delay_ms(100);
	CALL SUBOPT_0x2
; 0000 0180     puts("AT+CMGD=1,4");
	__POINTW2MN _0x27,0
	CALL _puts
; 0000 0181     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RJMP _0x2080006
; 0000 0182 }
; .FEND

	.DSEG
_0x27:
	.BYTE 0xC
;
;void sms_cmd()
; 0000 0185 {

	.CSEG
_sms_cmd:
; .FSTART _sms_cmd
; 0000 0186     if( strstr(rx_buffer, "CMT") && strstr(rx_buffer, adm_phone_tmp) )
	CALL SUBOPT_0x8
	__POINTW2MN _0x29,0
	CALL _strstr
	SBIW R30,0
	BREQ _0x2A
	CALL SUBOPT_0x8
	LDI  R26,LOW(_adm_phone_tmp)
	LDI  R27,HIGH(_adm_phone_tmp)
	CALL _strstr
	SBIW R30,0
	BRNE _0x2B
_0x2A:
	RJMP _0x28
_0x2B:
; 0000 0187     {
; 0000 0188         if( strstr(rx_buffer, "sw_pow") )
	CALL SUBOPT_0x8
	__POINTW2MN _0x29,4
	CALL _strstr
	SBIW R30,0
	BREQ _0x2C
; 0000 0189         {
; 0000 018A             send_sms("SW switched!");
	__POINTW2MN _0x29,11
	RCALL _send_sms
; 0000 018B             pow_sw(LONG);
	LDI  R26,LOW(1)
	RCALL _pow_sw
; 0000 018C         }
; 0000 018D 
; 0000 018E         clr_sms();
_0x2C:
	RCALL _clr_sms
; 0000 018F     }
; 0000 0190 }
_0x28:
	RET
; .FEND

	.DSEG
_0x29:
	.BYTE 0x18
;
;void sms_func()
; 0000 0193 {

	.CSEG
_sms_func:
; .FSTART _sms_func
; 0000 0194     reg_admin();
	RCALL _reg_admin
; 0000 0195     sms_cmd();
	RCALL _sms_cmd
; 0000 0196 }
	RET
; .FEND
;
;void wait_modem()
; 0000 0199 {
_wait_modem:
; .FSTART _wait_modem
; 0000 019A     unsigned char i = 0, var = 1;
; 0000 019B 
; 0000 019C     while(var)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	var -> R16
	LDI  R17,0
	LDI  R16,1
_0x2D:
	CPI  R16,0
	BREQ _0x2F
; 0000 019D     {
; 0000 019E         i++;
	SUBI R17,-1
; 0000 019F         LED=0;
	CBI  0x5,5
; 0000 01A0         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01A1         LED=1;
	SBI  0x5,5
; 0000 01A2         lcd_clear();
	RCALL _lcd_clear
; 0000 01A3         lcd_puts("wait modem...");
	__POINTW2MN _0x34,0
	RCALL _lcd_puts
; 0000 01A4 
; 0000 01A5         if(i==5)
	CPI  R17,5
	BRNE _0x35
; 0000 01A6         {
; 0000 01A7              i=0;
	LDI  R17,LOW(0)
; 0000 01A8              rst_gsm();
	RCALL _rst_gsm
; 0000 01A9              delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01AA         }
; 0000 01AB 
; 0000 01AC         puts("AT\r");
_0x35:
	__POINTW2MN _0x34,14
	CALL SUBOPT_0x7
; 0000 01AD         delay_ms(100);
; 0000 01AE         if( strstr(rx_buffer, "OK") )
	CALL SUBOPT_0x8
	__POINTW2MN _0x34,18
	CALL _strstr
	SBIW R30,0
	BREQ _0x36
; 0000 01AF             var=0;
	LDI  R16,LOW(0)
; 0000 01B0     }
_0x36:
	RJMP _0x2D
_0x2F:
; 0000 01B1 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x34:
	.BYTE 0x15
;
;void conf_m590()
; 0000 01B4 {

	.CSEG
_conf_m590:
; .FSTART _conf_m590
; 0000 01B5     wait_modem();
	RCALL _wait_modem
; 0000 01B6 
; 0000 01B7     lcd_clear();
	RCALL _lcd_clear
; 0000 01B8     lcd_puts("Modem ok!");
	__POINTW2MN _0x37,0
	RCALL _lcd_puts
; 0000 01B9     delay_ms(1000);
	CALL SUBOPT_0xB
; 0000 01BA 
; 0000 01BB     puts("AT+CMGF=1\r");            //включить текстовый режим
	__POINTW2MN _0x37,10
	CALL _puts
; 0000 01BC     delay_ms(1000);
	CALL SUBOPT_0xB
; 0000 01BD     puts("AT+CSCS=\"GSM\"\r");          //УGSMФ Ц кодировка ASCII
	__POINTW2MN _0x37,21
	CALL _puts
; 0000 01BE     delay_ms(1000);
	CALL SUBOPT_0xB
; 0000 01BF     puts("AT+CNMI=2,2\r");          //не сохран€ть SMS в пам€ти;
	__POINTW2MN _0x37,36
	CALL _puts
; 0000 01C0     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
_0x2080006:
	CALL _delay_ms
; 0000 01C1 }
	RET
; .FEND

	.DSEG
_0x37:
	.BYTE 0x31
;
;void gsm_func()
; 0000 01C4 {

	.CSEG
_gsm_func:
; .FSTART _gsm_func
; 0000 01C5     if(rx_wr_index)
	TST  R4
	BREQ _0x38
; 0000 01C6     {
; 0000 01C7         delay_ms(100);
	CALL SUBOPT_0x2
; 0000 01C8         call_func();
	RCALL _call_func
; 0000 01C9         sms_func();
	RCALL _sms_func
; 0000 01CA         print_uart_to_lcd();
	RCALL _print_uart_to_lcd
; 0000 01CB         memset(rx_buffer, 0, 254);
	CALL SUBOPT_0x8
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(254)
	LDI  R27,0
	CALL _memset
; 0000 01CC     }
; 0000 01CD }
_0x38:
	RET
; .FEND
;
;void rst_gsm()
; 0000 01D0 {
_rst_gsm:
; .FSTART _rst_gsm
; 0000 01D1     POWER_SW = 1;
	SBI  0x8,2
; 0000 01D2     delay_ms(350);
	LDI  R26,LOW(350)
	LDI  R27,HIGH(350)
	CALL _delay_ms
; 0000 01D3     POWER_SW = 0;
	CBI  0x8,2
; 0000 01D4 }
	RET
; .FEND
;
;void gsm_ping()
; 0000 01D7 {
_gsm_ping:
; .FSTART _gsm_ping
; 0000 01D8     if( SBRS(flag, START_PING_GSM) )
	LDS  R30,_flag
	ANDI R30,LOW(0x1)
	BREQ _0x3D
; 0000 01D9     {
; 0000 01DA         puts("AT+CREG?\r");
	__POINTW2MN _0x3E,0
	CALL SUBOPT_0x7
; 0000 01DB         delay_ms(100);
; 0000 01DC 
; 0000 01DD         if( !strstr(rx_buffer, "CREG: 0,1") )
	CALL SUBOPT_0x8
	__POINTW2MN _0x3E,10
	CALL _strstr
	SBIW R30,0
	BRNE _0x3F
; 0000 01DE         {
; 0000 01DF             lcd_clear();
	RCALL _lcd_clear
; 0000 01E0             lcd_puts("RST_GSM");
	__POINTW2MN _0x3E,20
	RCALL _lcd_puts
; 0000 01E1             delay_ms(500);
	CALL SUBOPT_0x4
; 0000 01E2             rst_gsm();
	RCALL _rst_gsm
; 0000 01E3         }
; 0000 01E4 
; 0000 01E5         CBR(flag, START_PING_GSM);
_0x3F:
	LDS  R30,_flag
	ANDI R30,0xFE
	STS  _flag,R30
; 0000 01E6     }
; 0000 01E7 }
_0x3D:
	RET
; .FEND

	.DSEG
_0x3E:
	.BYTE 0x1C
;
;void pc_pow_control()
; 0000 01EA {

	.CSEG
_pc_pow_control:
; .FSTART _pc_pow_control
; 0000 01EB 
; 0000 01EC     if( IN_5V && SBRC(flag, CALL_SENDED) )
	SBIS 0x6,1
	RJMP _0x41
	LDS  R30,_flag
	ANDI R30,LOW(0x2)
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 01ED     {
; 0000 01EE 
; 0000 01EF         send_call();
	RCALL _send_call
; 0000 01F0         SBR(flag, CALL_SENDED);
	LDS  R30,_flag
	ORI  R30,2
	RJMP _0x4C
; 0000 01F1 
; 0000 01F2     }
; 0000 01F3     else if(!IN_5V)
_0x40:
	SBIC 0x6,1
	RJMP _0x44
; 0000 01F4             CBR(flag, CALL_SENDED);
	LDS  R30,_flag
	ANDI R30,0xFD
_0x4C:
	STS  _flag,R30
; 0000 01F5 
; 0000 01F6 }
_0x44:
	RET
; .FEND
;
;void main(void)
; 0000 01F9 {
_main:
; .FSTART _main
; 0000 01FA     init_dev();
	RCALL _init_dev
; 0000 01FB     LIGHT_LCD = 1;
	SBI  0x5,2
; 0000 01FC     cpy_ram_ph();
	RCALL _cpy_ram_ph
; 0000 01FD     lcd_clear();
	RCALL _lcd_clear
; 0000 01FE     lcd_puts("adm_ph is:");
	__POINTW2MN _0x47,0
	CALL SUBOPT_0xA
; 0000 01FF     lcd_gotoxy(0, 1);
; 0000 0200     lcd_putse(adm_phone);
; 0000 0201     #asm("sei");
	sei
; 0000 0202     conf_m590();
	RCALL _conf_m590
; 0000 0203     lcd_clear();
	RCALL _lcd_clear
; 0000 0204     lcd_puts("working...");
	__POINTW2MN _0x47,11
	RCALL _lcd_puts
; 0000 0205 
; 0000 0206       while (1)
_0x48:
; 0000 0207       {
; 0000 0208             gsm_func();
	RCALL _gsm_func
; 0000 0209             gsm_ping();
	RCALL _gsm_ping
; 0000 020A             print_uart_to_lcd();
	RCALL _print_uart_to_lcd
; 0000 020B             delay_ms(500);
	CALL SUBOPT_0x4
; 0000 020C             pc_pow_control();
	RCALL _pc_pow_control
; 0000 020D       }
	RJMP _0x48
; 0000 020E }
_0x4B:
	RJMP _0x4B
; .FEND

	.DSEG
_0x47:
	.BYTE 0x16
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0xB,R30
	__DELAY_USB 27
	SBI  0x5,1
	__DELAY_USB 27
	CBI  0x5,1
	__DELAY_USB 27
	RJMP _0x2080005
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2080005
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R3,Y+1
	LDD  R6,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xC
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xC
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R3,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R3,R5
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080005
_0x2000007:
_0x2000004:
	INC  R3
	SBI  0x5,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x5,0
	RJMP _0x2080005
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	CALL SUBOPT_0xD
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x2080004
; .FEND
_lcd_putse:
; .FSTART _lcd_putse
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000E:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	STD  Y+1,R26
	STD  Y+1+1,R27
	SBIW R26,1
	CALL __EEPROMRDB
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000010
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000E
_0x2000010:
	RJMP _0x2080004
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0xA
	ORI  R30,LOW(0xF0)
	OUT  0xA,R30
	SBI  0x4,1
	SBI  0x4,0
	SBI  0x4,7
	CBI  0x5,1
	CBI  0x5,0
	CBI  0x5,7
	LDD  R5,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x2080005
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
_0x2020006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	LD   R30,Y
	STS  198,R30
_0x2080005:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020009:
	CALL SUBOPT_0xD
	BREQ _0x202000B
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2020009
_0x202000B:
	LDI  R26,LOW(10)
	RCALL _putchar
_0x2080004:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020018
	__CPWRN 16,17,2
	BRLO _0x2020019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x1
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020019:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x202001A
	CALL SUBOPT_0x1
_0x202001A:
	RJMP _0x202001B
_0x2020016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x202001B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080001
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x202001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x202001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020022
	CPI  R18,37
	BRNE _0x2020023
	LDI  R17,LOW(1)
	RJMP _0x2020024
_0x2020023:
	CALL SUBOPT_0xF
_0x2020024:
	RJMP _0x2020021
_0x2020022:
	CPI  R30,LOW(0x1)
	BRNE _0x2020025
	CPI  R18,37
	BRNE _0x2020026
	CALL SUBOPT_0xF
	RJMP _0x20200D2
_0x2020026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020027
	LDI  R16,LOW(1)
	RJMP _0x2020021
_0x2020027:
	CPI  R18,43
	BRNE _0x2020028
	LDI  R20,LOW(43)
	RJMP _0x2020021
_0x2020028:
	CPI  R18,32
	BRNE _0x2020029
	LDI  R20,LOW(32)
	RJMP _0x2020021
_0x2020029:
	RJMP _0x202002A
_0x2020025:
	CPI  R30,LOW(0x2)
	BRNE _0x202002B
_0x202002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x202002C
	ORI  R16,LOW(128)
	RJMP _0x2020021
_0x202002C:
	RJMP _0x202002D
_0x202002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2020021
_0x202002D:
	CPI  R18,48
	BRLO _0x2020030
	CPI  R18,58
	BRLO _0x2020031
_0x2020030:
	RJMP _0x202002F
_0x2020031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020021
_0x202002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020035
	CALL SUBOPT_0x10
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x11
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x73)
	BRNE _0x2020038
	CALL SUBOPT_0x10
	CALL SUBOPT_0x12
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020039
_0x2020038:
	CPI  R30,LOW(0x70)
	BRNE _0x202003B
	CALL SUBOPT_0x10
	CALL SUBOPT_0x12
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x202003C
_0x202003B:
	CPI  R30,LOW(0x64)
	BREQ _0x202003F
	CPI  R30,LOW(0x69)
	BRNE _0x2020040
_0x202003F:
	ORI  R16,LOW(4)
	RJMP _0x2020041
_0x2020040:
	CPI  R30,LOW(0x75)
	BRNE _0x2020042
_0x2020041:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2020043
_0x2020042:
	CPI  R30,LOW(0x58)
	BRNE _0x2020045
	ORI  R16,LOW(8)
	RJMP _0x2020046
_0x2020045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020077
_0x2020046:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2020043:
	SBRS R16,2
	RJMP _0x2020048
	CALL SUBOPT_0x10
	CALL SUBOPT_0x13
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020049
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020049:
	CPI  R20,0
	BREQ _0x202004A
	SUBI R17,-LOW(1)
	RJMP _0x202004B
_0x202004A:
	ANDI R16,LOW(251)
_0x202004B:
	RJMP _0x202004C
_0x2020048:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x13
_0x202004C:
_0x202003C:
	SBRC R16,0
	RJMP _0x202004D
_0x202004E:
	CP   R17,R21
	BRSH _0x2020050
	SBRS R16,7
	RJMP _0x2020051
	SBRS R16,2
	RJMP _0x2020052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2020053
_0x2020052:
	LDI  R18,LOW(48)
_0x2020053:
	RJMP _0x2020054
_0x2020051:
	LDI  R18,LOW(32)
_0x2020054:
	CALL SUBOPT_0xF
	SUBI R21,LOW(1)
	RJMP _0x202004E
_0x2020050:
_0x202004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2020055
_0x2020056:
	CPI  R19,0
	BREQ _0x2020058
	SBRS R16,3
	RJMP _0x2020059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x202005A
_0x2020059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x202005A:
	CALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x202005B
	SUBI R21,LOW(1)
_0x202005B:
	SUBI R19,LOW(1)
	RJMP _0x2020056
_0x2020058:
	RJMP _0x202005C
_0x2020055:
_0x202005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2020060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2020062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2020060
_0x2020062:
	CPI  R18,58
	BRLO _0x2020063
	SBRS R16,3
	RJMP _0x2020064
	SUBI R18,-LOW(7)
	RJMP _0x2020065
_0x2020064:
	SUBI R18,-LOW(39)
_0x2020065:
_0x2020063:
	SBRC R16,4
	RJMP _0x2020067
	CPI  R18,49
	BRSH _0x2020069
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020068
_0x2020069:
	RJMP _0x20200D3
_0x2020068:
	CP   R21,R19
	BRLO _0x202006D
	SBRS R16,0
	RJMP _0x202006E
_0x202006D:
	RJMP _0x202006C
_0x202006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x202006F
	LDI  R18,LOW(48)
_0x20200D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020070
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2020071
	SUBI R21,LOW(1)
_0x2020071:
_0x2020070:
_0x202006F:
_0x2020067:
	CALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x2020072
	SUBI R21,LOW(1)
_0x2020072:
_0x202006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x202005F
	RJMP _0x202005E
_0x202005F:
_0x202005C:
	SBRS R16,0
	RJMP _0x2020073
_0x2020074:
	CPI  R21,0
	BREQ _0x2020076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x11
	RJMP _0x2020074
_0x2020076:
_0x2020073:
_0x2020077:
_0x2020036:
_0x20200D2:
	LDI  R17,LOW(0)
_0x2020021:
	RJMP _0x202001C
_0x202001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
_0x2080003:
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x14
	SBIW R30,0
	BRNE _0x2020078
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080002
_0x2020078:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x14
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2080001:
	ADIW R28,5
	RET
; .FEND
_strcat:
; .FSTART _strcat
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0xFE
_adm_phone_tmp:
	.BYTE 0xC
_timer_ping:
	.BYTE 0x2
_flag:
	.BYTE 0x1

	.ESEG
_adm_phone:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

	.DSEG
_i_S0000007000:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(158)
	STS  133,R30
	LDI  R30,LOW(88)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	CALL _strcat
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	CALL _puts
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_adm_phone)
	SBCI R27,HIGH(-_adm_phone)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R26,LOW(_adm_phone)
	LDI  R27,HIGH(_adm_phone)
	JMP  _lcd_putse

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x08
	.equ __w1_bit=0x01

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
