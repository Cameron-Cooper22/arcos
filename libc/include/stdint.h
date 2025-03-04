#ifndef __STDINT_H
#define __STDINT_H

#ifndef __BIT_TYPES_DEFINED__
#define __BIT_TYPES_DEFINED__
#endif

#ifndef _UINT8_T_DEFINED_
#define _UINT8_T_DEFINED_
typedef unsigned char      uint8_t;
#endif
#ifndef _UINT16_T_DEFINED_
#define _UINT16_T_DEFINED_
typedef unsigned short     uint16_t;
#endif
#ifndef _UINT32_T_DEFINED_
#define _UINT32_T_DEFINED_
typedef unsigned int       uint32_t;
#endif
#ifndef _UINT64_T_DEFINED_
#define _UINT64_T_DEFINED_
typedef unsigned long long uint64_t;
#endif 

#ifndef _INT8_T_DEFINED_
#define _INT8_T_DEFINED_
typedef unsigned char      int8_t;
#endif
#ifndef _INT16_T_DEFINED_
#define _INT16_T_DEFINED_
typedef unsigned short     int16_t;
#endif
#ifndef _INT32_T_DEFINED_
#define _INT32_T_DEFINED_
typedef unsigned int       int32_t;
#endif
#ifndef _INT64_T_DEFINED_
#define _INT64_T_DEFINED_
typedef unsigned long long int64_t;
#endif

#ifndef _UINTPTR_T_DEFINED_
#define _UINTPTR_T_DEFINED_
typedef unsigned long long uintptr_t;
#endif
#ifndef _INTPTR_T_DEFINED_
#define _INTPTR_T_DEFINED_
typedef long long intptr_t;
#endif

/* TODO: Add support for fast, least, max, min etc */

#endif
