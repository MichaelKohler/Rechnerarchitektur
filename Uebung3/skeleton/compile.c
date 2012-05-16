/* 
 * author(s):   Michael Kohler - 11-108-289 
 *              Lars Schütz - 11-122-348
 * modified:    April 2012
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include "memory.h"
#include "mips.h"
#include "compiler.h"
 
int main ( int argc, char** argv ) {
    if (argc == 3) {
        printf("%s %s\n", "Input: ", argv[1]);
        verbose = TRUE;
        printf("%s", "Postfix: ", argv[2]);
        compiler(argv[1], argv[2]);
        verbose = FALSE;
        printf("%s %s\n", "MIPS binary saved to: ", argv[2]);
    }
    else {
        printf("usage: %s expression filename\n", argv[0]);
    }
    return EXIT_SUCCESS;
}

