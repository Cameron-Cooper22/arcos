#ifndef __ARCOS_MEMORY_MANAGEMENT
#define __ARCOS_MEMORY_MANAGEMENT



void* get_physaddr(void* virtualaddr);

void map_page(void* physaddr, void* virtualaddr, unsigned int flags);

#endif
