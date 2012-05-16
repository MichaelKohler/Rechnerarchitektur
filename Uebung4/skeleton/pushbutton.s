/* 
 *
 * author(s):   Michael Kohler - 11-108-289
 *              Lars Schütz
 * modified:    2012-05-02
 *
 */

.include "nios_macros.s"
.include "address_map.s"
.extern KEY_PRESSED
.global PUSHBUTTON_ISR

/*****************************************************************************
 * Pushbutton - Interrupt Service Routine                                
 *                                                                          
 ******************************************************************************/

PUSHBUTTON_ISR: /* speichere die Register auf dem Stack */
    subi sp, sp, 12
    stw r10, 0(sp)
    stw r11, 4(sp)
    stw r12, 8(sp)

/* Task (d) managed speed of wandering light */

    # Unterbrechungen
    movia r10, PUSHBUTTON_BASE
    ldwio r11, 0xC(r10)
    stwio zero, 0xC(r10)

# zeige key_pressed welcher Key gedrückt wurde
CHECK_KEY1:
    andi r12, r11, 0b0010
    beq r12, zero, CHECK_KEY2
    movi r12, KEY1
    movia r10, KEY_PRESSED
    stw r12, 0(r10)
    br END_PUSHBUTTON_ISR

CHECK_KEY2:
    andi r12, r11, 0b0100
    beq r12, zero, CHECK_KEY3
    movi r12, KEY2
    movia r10, KEY_PRESSED
    stw r12, 0(r10)
    br END_PUSHBUTTON_ISR

CHECK_KEY3:
    andi r12, r11, 0b1000
    beq r12, zero, END_PUSHBUTTON_ISR
    movi r12, KEY3
    movia r10, KEY_PRESSED
    stw r12, 0(r10)

#speichere zurück ins Register
END_PUSHBUTTON_ISR:
    ldw r10, 0(sp)
    ldw r11, 4(sp)
    ldw r12, 8(sp)
    addi sp, sp, 12
    ret

.end
