.include "nios_macros.s"
.include "address_map.s"

/* global variables */
.extern TIME

/********************************************************************************
 * RESET SECTION
 * Note: "ax" is REQUIRED to designate the section as allocatable and executable.
 * Also, the Debug Client automatically places the ".reset" section at the reset
 * location specified in the CPU settings in SOPC Builder.
*/
.section .reset, "ax"
	br _start					# branch to start function 

/********************************************************************************
 * EXCEPTIONS SECTION
 * Note: "ax" is REQUIRED to designate the section as allocatable and executable.
 * Also, the Debug Client automatically places the ".exceptions" section at the
 * exception location specified in the CPU settings in SOPC Builder.
*/
.section .exceptions, "ax"
.global EXCEPTION_HANDLER
EXCEPTION_HANDLER:
	subi		sp, sp, 20					# make room on the stack 
	stw		et,  0(sp)

	rdctl		et, ctl4
	beq		et, r0, SKIP_EA_DEC			# Interrupt is not external 

	subi		ea, ea, 4					# Must decrement ea by one instruction  
									#  for external interupts, so that the 
									#  interrupted instruction will be run 
SKIP_EA_DEC:
	stw		ea, 4(sp)					# Save all used registers on the Stack  
	stw		ra, 8(sp)					# needed if call inst is used 
	stw		fp, 12(sp)
	stw		r22, 16(sp)
	addi		fp,  sp, 20
	
	rdctl		et, ctl4
	bne		et, r0, CHECK_LEVEL_0			# Interrupt is an external interrupt    

NOT_EI:								# Interrupt must be unimplemented or     
	br		END_ISR					#   TRAP instruction. This code does    
									#   not handle those cases.             
CHECK_LEVEL_0:
	/* Interval timer is interrupt level 0 */
	andi		r22, et, 1
	beq		r22, zero, CHECK_LEVEL_1
	
	call		INTERVAL_TIMER_ISR			
	br		END_ISR

CHECK_LEVEL_1:
	/* Pushbutton is interrupt level 1 */
	andi		r22, et, 0b10
	beq		r22, zero, CHECK_LEVEL_2

	call		PUSHBUTTON_ISR				
	br		END_ISR

/* if you need to check more...*/
CHECK_LEVEL_2:

END_ISR:
	ldw		et, 0(sp)				# Restore all used register to previous 
	ldw		ea, 4(sp)				#   values.                             
	ldw		ra, 8(sp)				# needed if call inst is used 
	ldw		fp, 12(sp)
	ldw		r22, 16(sp)
	addi		sp, sp, 20

	eret
	
