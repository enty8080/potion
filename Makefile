#
# Makefile
# Potion Payload
#
# Created by EntySec on 2020.
# Copyright (C) 2020 by EntySec. All rights reserved.
#

ASM      = nasm
ASMFLAGS =

LD       = ld
LDFLAGS  = -m elf_i386

TARGET   = payload
FORMAT   = elf32

SRCS     = payload.nasm
OBJS     = payload.o

Q        = @

all: payload shellcode

payload:
	$(Q) $(ASM) -f $(FORMAT) $(SRCS) $(ASMFLAGS)
	$(Q) $(LD) $(OBJS) -o $(TARGET) $(LDFLAGS)

shellcode: $(TARGET)
	$(Q) objdump -d ./$(TARGET) | sxtractor

debug: $(TARGET)
	$(Q) strace ./$(TARGET)

clean:
	$(Q) rm -rf $(TARGET) $(OBJS)
