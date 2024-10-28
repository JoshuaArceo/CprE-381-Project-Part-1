.data
# Testbench example data
array:         .word 5, 3, 8, 1, 2, 0, 0  # Array of 5 integers with padding
array_size:    .word 5                    # Size of the array to sort

# Expected sorted output example data
expected:      .word 1, 2, 3, 5, 8, 0, 0   # Expected sorted array (5 integers and padding)

# Messages for output
error_msg:     .asciiz "Error: Array not sorted correctly!\n"
success_msg:   .asciiz "Success: Array sorted correctly!\n"

.text
.globl main

main:
    # Load size of array
    la   $t0, array_size                # Load address of array_size
    lw   $t1, 0($t0)                    # $t1 = size of the array

    # Call Bubble Sort program
    jal  bubble_sort

    # Check if array is correctly sorted 
    la   $t2, array                     # Load address of actual sorted array
    la   $t3, expected                  # Load address of expected sorted array
    li   $t4, 0                         # Index for comparison

check_loop:
    bge  $t4, $t1, finish_check         # If index >= size, finish checking

    lw   $t5, 0($t2)                    # Load sorted array value
    lw   $t6, 0($t3)                    # Load expected value
    bne  $t5, $t6, error                # If values don't match, error

    addi $t2, $t2, 4                    # Move to next element in sorted array
    addi $t3, $t3, 4                    # Move to next expected element
    addi $t4, $t4, 1                    # Increment index
    j    check_loop                     # Repeat checking

error:
    # Print error message
    li   $v0, 4                         # syscall to print string
    la   $a0, error_msg                 # Load address of error message
    syscall
    j    end_program                    # Exit after error

finish_check:
    # Print success message
    li   $v0, 4                         # syscall to print string
    la   $a0, success_msg               # Load address of success message
    syscall

end_program:
    li   $v0, 10                        # syscall to exit
    syscall

bubble_sort:
    # Prompt user for size of array
    li   $v0, 4                     # syscall to print string
    la   $a0, prompt                # load address of prompt message
    syscall

    li   $v0, 5                     # syscall to read integer
    syscall
    sw   $v0, array_size            # store input size in array_size

    # Load array size into a register
    lw   $t1, array_size            # $t1 = array size
    la   $t0, array                 # $t0 = array address

    # Check if size exceeds 7
    li   $t2, 7                     # Set max. array size to 7
    ble  $t1, $t2, read_values      # If size <= 7, read values

    # Exit if size is greater than 7
    li   $v0, 10                    # syscall to exit
    syscall

read_values:
    # Prompt user for array values
    li   $v0, 4                     # syscall to print string
    la   $a0, prompt_values         # load address of prompt for array values
    syscall

    # Read values into array
    li   $t2, 0                     # Initialize index i for array input

read_loop:
    bge  $t2, $t1, sort_array       # If i >= size, go to sort_array

    li   $v0, 5                     # syscall to read integer
    syscall
    sw   $v0, 0($t0)                # Store input value in array[i]

    addi $t0, $t0, 4                # Move to next array element
    addi $t2, $t2, 1                # Increment index i
    j    read_loop                  # Repeat reading values

sort_array:
    la   $t0, array                 # Reset $t0 to start of array
    li   $t2, 0                     # Outer loop index i = 0

outer_loop:
    li   $t3, 0                     # Inner loop index j = 0
    li   $t4, 0                     # Swapped flag (0 = no swaps)

inner_loop:
    # Load current and next element for comparison
    lw   $t5, 0($t0)                # Load array[j]
    lw   $t6, 4($t0)                # Load array[j+1]

    # Compare and swap if necessary
    bge  $t5, $t6, no_swap          # If array[j] >= array[j+1], no swap needed

    # Perform swap between array[j] and array[j+1]
    sw   $t6, 0($t0)                # array[j] = array[j+1]
    sw   $t5, 4($t0)                # array[j+1] = array[j]
    li   $t4, 1                     # Set swapped flag to indicate swap occurrence

no_swap:
    addi $t3, $t3, 1                # Increment inner loop index j
    addi $t0, $t0, 4                # Move to next array element (array[j+1])
    bne  $t3, $t1, inner_loop       # Repeat inner loop until j < (size - 1)

    # Check if any swaps were made in this pass
    beq  $t4, $zero, end_outer      # If no swaps, array is sorted

    addi $t2, $t2, 1                # Increment outer loop index i
    la   $t0, array                 # Reset $t0 to start of array for next pass
    j    outer_loop                 # Repeat outer loop

end_outer:
    # Exit program
    li   $v0, 10                    # syscall to exit
    syscall