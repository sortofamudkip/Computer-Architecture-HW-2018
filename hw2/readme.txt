Platform: Windows 10

Code:

Step 4: 
Compare $s3 (operator) with each of the operators, jumping to the the corresponding segments if a match is found.
If no match is found, $s1 is set to -1 to signify an invalid operator.

Step 5:
If $s1 == -1, jump straight to output. Otherwise, go through itoa first.

itoa:
Repeatedly divide $a0 by 10, taking the last digit (in Hi), converting it to ascii, and then moving it to output_ascii (which is in $t5).

Nothing else is changed.