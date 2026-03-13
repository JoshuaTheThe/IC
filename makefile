ifneq ($(ARCH),i386)
	ARCH          := i386
	ARCH_FLAGS    := -m32
	ARCH_LD_FLAGS := -melf_i386 -e _start
else
	ARCH          := x64
	ARCH_FLAGS    := -m64
	ARCH_LD_FLAGS := -melf_x86_64 -e _IC_I
endif

override FILE   := ic
override OUTPUT := bin/$(FILE)
override TEMP   := /tmp/$(FILE).o
override START  := src/$(ARCH)/start.S

$(OUTPUT): $(START)
	mkdir -p bin
	cc $(START) -o $(TEMP) -no-pie -nostdlib -c -I src/$(ARCH) $(ARCH_FLAGS)
	ld $(TEMP) -o $(OUTPUT) --no-pie --build-id=none \
		-z noseparate-code \
		--no-eh-frame-hdr \
		-z norelro \
		$(ARCH_LD_FLAGS)
	strip --strip-all $(OUTPUT)

.PHONY: clean
clean:
	rm -rf bin