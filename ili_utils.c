#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
asm("SIDT %0;"
	: "=m" (*idtr)
	: 
	:);
}

void my_load_idt(struct desc_ptr *idtr) {
asm("LIDT %0"
	: 
	: "m" (*idtr)
	:);
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
gate->offset_low 	= (u16) addr;
gate->offset_middle	= (u16) (addr >> 16);
gate->offset_high	= (u32) (addr >> 32);
}

unsigned long my_get_gate_offset(gate_desc *gate) {
	unsigned long addr;
	addr = (gate->offset_high) << 32;
	addr += (gate->offset_middle) << 16;
	addr += (gate->offset_low);
return addr;
}
