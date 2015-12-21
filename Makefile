TARGET=test.hex
EXECUTABLE=test.elf

PWD := $(shell pwd)

LOCATION := ~/gcc-arm-none-eabi-4_9-2015q3/bin

CC=$(LOCATION)/arm-none-eabi-gcc
#LD=arm-none-eabi-ld 
LD=$(LOCATION)/arm-none-eabi-gcc
AR=$(LOCATION)/arm-none-eabi-ar
AS=$(LOCATION)/arm-none-eabi-as
CP=$(LOCATION)/arm-none-eabi-objcopy
OD=$(LOCATION)/arm-none-eabi-objdump

BIN=$(CP) -O ihex

DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F40_41xxx
#-DSTM32F410xx

MCU = cortex-m4
MCFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork  
#-mfpu=fpa -mfloat-abi=hard -mthumb-interwork  
STM32_INCLUDES = -I $(PWD)/Libraries/STM32F4xx_StdPeriph_Driver/inc \
	-I $(PWD)/Libraries/CMSIS/Include \
	-I$(PWD)

OPTIMIZE       = -Os

CFLAGS	= --specs=nosys.specs $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I./ -I./ $(STM32_INCLUDES)  -Wl,-T,stm32_flash.ld
AFLAGS	= $(MCFLAGS) 

SRC = main.c \
	system_stm32f4xx.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/misc.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
	Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c 

STARTUP = startup_stm32f4xx.S

OBJDIR = .
OBJ = $(SRC:%.c=$(OBJDIR)/%.o) 
OBJ += Startup.o


all: $(TARGET)

$(TARGET): $(EXECUTABLE)
	$(CP) -O ihex $^ $@

$(EXECUTABLE): $(SRC) $(STARTUP)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f Startup.lst  $(TARGET)  $(EXECUTABLE) *.lst $(OBJ) $(AUTOGEN)  *.out *.map \
	 *.dmp
