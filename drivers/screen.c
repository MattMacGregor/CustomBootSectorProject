#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
//Attribute byte for our default color scheme
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5
#include "kernel/low_level.h"
int get_screen_offset(int col, int row)
{
  return ((row * MAX_COLS) + col) * 2;
}
int get_cursor()
{
  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset += port_byte_in(REG_SCREEN_DATA);
  return offset * 2;
}
void set_cursor(int offset)
{
  offset /= 2;
  port_word_out(REG_SCREEN_CTRL, 14);
  port_word_out(REG_SCREEN_DATA, offset >> 8);
  port_word_out(REG_SCREEN_CTRL, 15);
  port_word_out(REG_SCREEN_DATA, offset - ((offset >> 8) << 8));
}
void print_char(char character, int col, int row, char attribute_byte)
{
  volatile char* vidmem = VIDEO_ADDRESS;
  if(!attribute_byte)
  {
    attribute_byte = WHITE_ON_BLACK;
  }
  volatile int offset = 0;
  if (col >= 0 && row >= 0)
  {
    offset = get_screen_offset(col, row);
  }
  else
  {
    offset = get_cursor();
  }
  if (character == '\n')
  {
    int rows = offset / (2*MAX_COLS);
    offset = get_screen_offset(79, rows);
  }
  else
  {
    // offset += 1;
    vidmem[1] = '0' + (offset / 10000);
    vidmem[3] = '0' + (offset / 1000) % 10;
    vidmem[5] = '0' + (offset / 100) % 10;
    vidmem[7] = '0' + (offset / 10) % 10;
    vidmem[9] = '0' + (offset % 10);
    // vidmem[offset + 1] = 0xf0;
    // vidmem[2] = vidmem[1];
    char* useless = 0;
    *(useless + VIDEO_ADDRESS + offset + 4) = WHITE_ON_BLACK;
    *(useless + VIDEO_ADDRESS + offset + 3) = character;
  }
  offset += 2;
  //offset = handle_scrolling(offset);
  set_cursor(offset);
}
void print_at(char message[], int col, int row)
{
  if (col >= 0 && row >= 0)
  {
    set_cursor(get_screen_offset(col, row));
  }
  char i = 0;
  print_char((int)i, -1, -1, 0);
  for(int i = 0; 1;/*message[i] != '\0';*/ i++)
  {
    print_char('0' + sizeof(message) / sizeof(char), -1, -1, 0);
  }
}
void print(char* message)
{
  print_at(message, -1, -1);
}
void clear_screen() {
  int row = 0;
  int col = 0;
  for(row = 0; row < MAX_ROWS; row++)
  {
    for(col = 0; col < MAX_COLS; col++)
    {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }
  set_cursor(get_screen_offset(0,0));
}
