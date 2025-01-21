## Paging
### Page Directory Entry

|63|62 .. 52|51 .. M|M-1 .. 12|11 .. 8|7|6|5|4|3|2|1|0|
|-----------------------------------------------------|
|XD|AVL|RESERVED|Bits 12 - (m-1) of address|AVL|PS(0)|AVL|A|PCD|PWT|U/S|R/W|P|

### Page Directory Pointer Table Entry

|63|62 .. 52|51 .. M|M-1 .. 12|11 .. 8|7|6|5|4|3|2|1|0|
|-----------------------------------------------------|
|XD|AVL|RESERVED|Bits 12 - (m-1) of address|AVL|PS(0)|AVL|A|PCD|PWT|U/S|R/W|P|

### Page Map Level 4 Entry

|63|62 .. 52|51 .. M|M-1 .. 12|11 .. 8|7|6|5|4|3|2|1|0|
|-----------------------------------------------------|
|XD|AVL|RESERVED|Bits 12 - (m-1) of address|AVL|RSVD(0)|AVL|A|PCD|PWT|U/S|R/W|P|

### Page Map Level 5 Entry

|63|62 .. 52|51 .. M|M-1 .. 12|11 .. 8|7|6|5|4|3|2|1|0|
|-----------------------------------------------------|
|XD|AVL|RESERVED|Bits 12 - (m-1) of address|AVL|RSVD(0)|AVL|A|PCD|PWT|U/S|R/W|P|

