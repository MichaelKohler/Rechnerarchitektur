.include "nios_macros.s"
.include "address_map.s"

/* global variables */
.extern TIME

/*****************************************************************************
 * Interval Timer - Interrupt Service Routine                                
 *   Must write to the Interval Timer to clear it. 
******************************************************************************/
.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:					
	subi		sp,  sp, 8		# reserve space on the stack 
	stw		r21, 0(sp)
	stw		r22, 4(sp)
   
	movia	r21, TIMER_RUN_TO
	sthio		r0,  0(r21)				# Clear the interrupt 

	/* increment the delay counter used for changing the displayed message */
	movia	r22, TIME
	ldw		r21, 0(r22)
	addi		r21, r21, 1
	stw		r21, 0(r22)
	
	ldw		r21, 0(sp)				# Restore all used register to previous 
	ldw		r22, 4(sp)   
	addi		sp,  sp, 8			# release the reserved space on the stack 

	ret

.end

