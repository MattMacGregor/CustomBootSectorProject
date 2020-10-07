C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
ASM_SOURCES = $(wildcard boot/*.asm)
OBJ = ${C_SOURCES:.c=.o}
all : os-image
${C_SOURCES}:${HEADERS}
run : os-image
	qemu-system-x86_64 $^
kernel.bin : kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary
%.o : %.c ${HEADERS}
	gcc -I. -ffreestanding -c $< -o $@
%.o : %.asm
	nasm $^ -f elf64 -o $@
%.bin : %.asm
	nasm $^ -f bin -I "boot/" -o $@
os-image : boot/bootstrap.bin kernel.bin
	cat $^ > $@
clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
