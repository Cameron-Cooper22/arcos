#ifndef _ARCOS_GDT_H
#define _ARCOS_GDT_H

#ifndef GDT_PRESENT
#define GDT_PRESENT (1 << 15)
#endif

#ifndef GDT_CODE
#define GDT_CODE (3 << 11)
#endif

#ifndef GDT_LONG
#define GDT_LONG (1 << 21)
#endif

#endif
