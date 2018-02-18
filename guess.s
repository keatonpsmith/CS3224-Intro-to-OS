#Keaton Smith kps325

.code16                  # Use 16-bit assembly
.globl start             # This tells the linker where we want to start executing

start:
    movw $question, %si  # Load the offset of our message into %si
    movb $0x00,%ah       # 0x00 - set video mode
    movb $0x03,%al       # 0x03 - 80x25 text mode
    int $0x10            # call into the BIOS

find_rand:
    movb $0x00, %bh      # Moves the value of zero into %bh
    movb $0x00, %al      # Makes a call to the clock for seconds
    out %al, $0x70       # Pulls the local time in seconds
    in $0x71, %al        # Saves the time to %al
    movb $0x0A, %bh      # Puts the value of 10 into %bh
    div %bh              # Divides the value by 10
    movb %ah, %bh        # Puts the remainder of the previous division into %bh

print_char:
    lodsb                # Loads a single byte from (%si) into %al and increments %si
    testb %al,%al        # Checks to see if the byte is 0   
    jz get_guess         # If so, jump out
    movb $0x0E,%ah       # 0x0E is the BIOS code to print the single character
    int $0x10            # Call into the BIOS
    jmp print_char       # Go back to the start of the loop

get_guess:
    movb $0x00, %ah      # Moves the value of zero into %bh
    int $0x16            # Reads in 1 character
    movb $0x0E, %ah      # Moves the value from the previous input into %ah
    int $0x10            # Call into BIOS
    sub $0x30, %al       # Subtract 0x30 from the value in %al
    cmp %bh, %al         # Compares %bh and %al
    je correct           # Jumps to correct if they are equal
    
wrong_guess:
    movw $not_found, %si # Loads not_found into %si
    movb $0x0D, %al      # Puts the cursor at the beginning of the line
    int $0x10            # Call into the BIOS
    movb $0x0A, %al      # Moves the cursor down one line
    int $0x10            # Call into the BIOS

print_wrong:
    lodsb                # Loads a single byte from (%si) into %al and increments %si
    testb %al,%al        # Checks to see if the byte is 0
    jz keep_going        # If so jump out
    movb $0x0E,%ah       # 0x0E is the BIOS code to print the single character
    int $0x10            # Call into BIOS
    jmp print_wrong      # Go back to the start of the loop

done:
    jmp done             # Repeats forever

correct:
    movw $found, %si     # Loads found into %si
    movb $0x0D, %al      # Puts the cursor at the beginning of the line
    int $0x10            # Call into the BIOS
    movb $0x0A, %al      # Moves the cursor down one line
    int $0x10            # Call into the BIOS

print_end:
    lodsb                # Loads a single byte from (%si) into %al and increments %si
    testb %al,%al        # Checks to see if the byte is 0
    jz done              # If so jump out
    movb $0x0E,%ah       # 0x0E is the BIOS code to print the single character
    int $0x10            # Call into the BIOS
    jmp print_end        # Go back to the start of the loop

keep_going:
    movw $question, %si  # Loads question into %si
    movb $0x0A, %al      # Moves the cursor down one line
    int $0x10            # Call into the BIOS
    movb $0x0D, %al      # Puts the cursor at the beginning of the line
    int $0x10            # Call into the BIOS
    jmp print_char       # Jumps to print_char

question:
    .string "What number am I thinking of (0-9)? "
not_found:
    .string "Wrong!"
found:
    .string "Right! Congratulations."

.fill 510 - (. - start), 1, 0
.byte 0x55
.byte 0xAA
