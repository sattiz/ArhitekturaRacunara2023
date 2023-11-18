#include <stdio.h>
#include <unistd.h>

int main () {
	char buffer[50];
	read(0, buffer, 50);
	printf("%s\n", buffer);
	return 0;
}
