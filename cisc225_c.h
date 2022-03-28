#pragma once

extern "C" {
	void c_delay(int ms);
	void c_endprogram();
	int c_getmaxxy();
	int c_gettextcolor();
	void c_gotoxy(int x, int y);
	int c_random32();
	void c_randomize();
	int c_readchar();
	double c_readfloat();
	int c_readint();
	size_t c_readstring(char* buf, size_t size);
	void c_settextcolor(int color);
	void c_writechar(int ch);
	void c_writefloat(double f);
	void c_writehex(int n);
	void c_writeint(int n);
	void c_writestring(const char* str);
};