override ARCH := x64
override ARCH_FLAGS := -m64
override ARCH_LD_FLAGS := -melf_x86_64

override FILE   := ic
override OUTPUT := bin/$(FILE)
override TEMP   := /tmp/$(FILE).o
override START  := src/$(ARCH)/start.S

$(OUTPUT): $(START)
	mkdir -p bin
	cc $(START) -o $(TEMP) -no-pie -nostdlib -c -I src/$(ARCH) $(ARCH_FLAGS)
	ld $(TEMP) -o $(OUTPUT) -e _IC_I --no-pie --build-id=none \
		-z noseparate-code \
		--no-eh-frame-hdr \
		-z norelro \
		$(ARCH_LD_FLAGS)
	strip --strip-all $(OUTPUT)

.PHONY: clean
clean:
	rm -rf bin