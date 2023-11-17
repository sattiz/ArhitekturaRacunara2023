build_x86:
	mkdir -p build
	gcc -m32 -c $(src) -o build/main.o
	ld -m elf_i386 -o build/main.out build/main.o

build_x86-64:
	mkdir -p build
	gcc -c $(src) -o build/main.o
	ld -o build/main.out build/main.o


debug_x86:
	mkdir -p build
	gcc -m32 -g -c $(src) -o build/main.o
	ld -m elf_i386 -o build/main.out build/main.o

debug_x86-64:
	mkdir -p build
	gcc -g -c $(src) -o build/main.o
	ld -o build/main.out build/main.o

run:
	./build/main.out $(ARGS)

clean:
	rm -r build

.SILENT: build_x86 build_x86-64 debug_x86-64 debug_x86 clean
.PHONY: build_x86 build_x86-64 debug_x86-64 debug_x86 clean

