#include <drivers/screen.h>
void main() {
	//clear_screen();
	volatile char message[] = "eeeeeeeeeeeeeeeeeeeeeeeee";
	// char* message2 = &message;
	clear_screen();
	print_char('h', 0, 0, 0);
	print_at(message, 1, 1, 0);
	// message2 = (char*)4;
	// print_char('c', 79, 24, 0);
	// char* video_memory = (char*) 0xb8000;
	// video_memory[3] = 'y';
	// video_memory[4] = 0x0f;
	// for(int i = 2;;i++)
	// {
	// 	*(video_memory + i) = 's';
	// }
}
