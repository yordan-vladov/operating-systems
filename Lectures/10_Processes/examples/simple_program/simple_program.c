// simple-program.c
#include <stdio.h>
#include <stdlib.h>

// Global variables are stored in the Data/BSS segment
int global_initialized = 42;    // Data segment
int global_uninitialized;       // BSS segment

void function() {
    // Stack variables
    int stack_var = 5;
    printf("Stack variable: %d\n", stack_var);
}

int main() {
    // Stack variables
    int local_var = 10;

    // Heap allocation
    int* heap_var = (int*)malloc(sizeof(int));
    *heap_var = 20;

    printf("Global initialized: %d\n", global_initialized);
    printf("Local variable: %d\n", local_var);
    printf("Heap variable: %d\n", *heap_var);

    function();

    free(heap_var);
    return 0;
}
