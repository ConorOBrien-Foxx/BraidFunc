# Commands

```
+               Increment current cell
-               Decrement current cell
>               Move right one cell
<               Move left one cell
[               Open loop
]               Close loop
.               Output current cell
,               Input byte to current cell
^               Push current cell to argument stack
v               Pop from argument stack to current cell

{name|code}     Begin subroutine definition
```

The following code prints a newline (0x10):
```
{Add5|+++++} Add5Add5.
```