import os, shutil, re

opcodes = {
    "add":  0,
    "sub":  0,
    "mult": 0,
    "div":  0,
    "mod":  0,
    "and":  0,
    "or":   0,
    "slt":  0,
    "addi":  16,
    "subi":  17,
    "multi": 18,
    "divi":  19,
    "modi":  20,
    "andi":  21,
    "ori":   22,
    "slti":  23,
    "lw":   35,
    "sw":   43,
    "beq":  4,
    "j":    2,
    "jr":    8,
    "hlt": 63,
}

funct = {
    "add":  0,
    "sub":  1,
    "mult": 2,
    "div":  3,
    "mod":  4,
    "and":  5,
    "or":   6,
    "slt":  7,
}

registers = ["$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"]

addresses = {}

def save_address(line, i):
    if line[0] == '@':
        addresses[line] = i

def get_address(line, i):
    if line == '@here':
        return i+2
    if line[:6] == '@here+':
        return i+int(line[6:])
    elif line in addresses:
        return addresses[line]
    else:
        return int(line)

def is_instruction(line):
    return line != '' and line[0] != '@'

def is_address(line):
    return len(line) > 1 and line[0] == '@'

def registers_match(match):
    label, var1, var2 = match.groups()
    if var1 == var2:
        return 'new_label {}, {}'.format(var1, var2)
    else:
        return match.group()

def preprocess(lines):
    result = []
    for line in lines:
        line = line.split("//")[0]
        line = line.strip()
        line = line.lower()
        line = re.sub(' +', ' ', line)

        # MOVE
        line = re.sub('move', 'add $0', line)

        # LOADI
        line = re.sub('loadi', 'addi $0', line)

        # JAL
        if line.startswith('jal'):
            result.append('addi $0 $ra @here+2')
            line = 'j' + line[3:]
        
        # INC and DEC
        line = re.sub(
            r'inc (\$[a-zA-Z0-9_]+)', 
            lambda x: 'addi {} {} 1'.format(
                x.groups()[0],
                x.groups()[0],
            ), 
            line
        )
        line = re.sub(
            r'dec (\$[a-zA-Z0-9_]+)', 
            lambda x: 'addi {} {} -1'.format(
                x.groups()[0],
                x.groups()[0],
            ), 
            line
        )

        result.append(line)
    return result    

def get_register(reg):
    if reg in registers:
        reg = registers.index(reg)
    else:
        reg = int(reg[1:])
    return "{0:05b}".format(reg)

def compile(code, i):    
    instruction, *items = code.split(' ')

    binary = ''
    opcode = opcodes[instruction]
    if opcode == 0: # R-Type
        binary += get_register(items[0])
        binary += get_register(items[1])
        binary += get_register(items[2])
        binary += "0" * 5
        binary += "{0:06b}".format(funct[instruction])
    elif opcode in [35, 43, 4] + list(range(16, 24)): # Load / Store / Branch / I-Type
        binary += get_register(items[0])
        binary += get_register(items[1])
        if opcode == 4:
            binary += int2word(get_address(items[2], i) - (i+1))
        else:
            binary += int2word(get_address(items[2], i)) # Get address will return integer in argument isn't an address
    elif opcode == 2: # Jump
        binary += "{0:026b}".format(get_address(items[0], i))
    elif opcode == 8: # Jump register
        binary += get_register(items[0])
        binary += "0" * 21
    else:
        binary = "0" * 26
    
    return "{0:06b}".format(opcode) + binary

def twos_complement(val, nbits):
    if val < 0:
        val = (1 << nbits) + val
    else:
        if (val & (1 << (nbits - 1))) != 0:
            val = val - (1 << nbits)
    return val

def int2word(val):
    if val < 0:
        val = (1 << 16) + val
    else:
        if (val & (1 << (16 - 1))) != 0:
            val = val - (1 << 16)
    return "{0:016b}".format(val)

def word2int(val_str):
    import sys
    val = int(val_str, 2)
    b = val.to_bytes(4, byteorder=sys.byteorder, signed=False)                                                          
    return str(int.from_bytes(b, byteorder=sys.byteorder, signed=False))

if __name__ == '__main__':
    src_path = './src/'
    bin_path = './bin/'
    dec_path = './dec/'

    shutil.rmtree(bin_path)
    shutil.rmtree(dec_path)
    os.makedirs(bin_path)
    os.makedirs(dec_path)

    for filename in os.listdir(src_path):
        file, ext = filename.split('.')
        binary = decimal = ''
        with open(src_path + filename) as f:
            lines = preprocess(f.readlines())
            lines = [l for l in lines if l != '']

            i = 0
            for line in lines:
                if is_instruction(line):
                    i += 1
                elif is_address(line):
                    save_address(line, i)

            lines = [l for l in lines if is_instruction(l)]

            for i, line in enumerate(lines):
                print(line)
                bin = compile(line, i)
                if not bin:
                    continue

                binary += bin + '\n'
                decimal += word2int(bin) + '\n'
            print(f'{filename} compiled successfully with {len(lines)} instructions!')
            for i, line in enumerate(lines):
                print(str(i).rjust(3) + ' - ' + line)

        with open(bin_path + file + '.txt', 'w+') as f:
            f.write(binary)

        with open(dec_path + file + '.txt', 'w+') as f:
            f.write(decimal)

