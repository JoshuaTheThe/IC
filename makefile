override FILE   := ic
override OUTPUT := bin/$(FILE)
override TEMP   := /tmp/$(FILE).o
override START  := src/start.S

$(OUTPUT): $(START)
	mkdir -p bin
	cc $(START) -o $(TEMP) -no-pie -nostdlib -c -I src
	ld $(TEMP) -o $(OUTPUT) -e _IC_I --no-pie --build-id=none \
		-z noseparate-code \
		--no-eh-frame-hdr \
		-z norelro
	strip --strip-all $(OUTPUT)

.PHONY: clean
clean:
	rm -rf bin