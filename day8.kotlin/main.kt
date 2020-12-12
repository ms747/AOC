import java.io.File;
import kotlin.system.exitProcess;

enum class Opcode {
    ACC,
    JMP,
    NOP
}

class Instruction {
    var opcode : Opcode;
    var value  : Int;

    constructor(opcode: Opcode, value: Int){
        this.opcode = opcode;
        this.value = value;
    }

    override fun toString(): String {
        return "Instruction ${this.opcode} : ${this.value}";
    }
}

class Cpu {
	var acc: Int
    var ip : Int
    var instructions : MutableList<Instruction>;

    init {
		this.acc = 0
        this.ip = 0
        this.instructions = arrayListOf()
	}

    fun findLoopIndex() : Int {
        var instructionVisit : HashMap<Int, Boolean> = hashMapOf();
        var previousInstruction = 0
        while (true) {
            if (instructionVisit.containsKey(this.ip)) {
                break
            }
            instructionVisit.put(this.ip, true);
            var instruction = this.instructions[this.ip]
            when (instruction.opcode) {
                Opcode.ACC -> {
                    this.acc += instruction.value
                }
                Opcode.NOP -> {}
                Opcode.JMP -> {
                    previousInstruction = this.ip
                    this.ip += (instruction.value - 1)
                }
            }
            this.ip += 1
        }
        return previousInstruction
	}

    fun swapInstruction(index: Int) {
        var instruction = this.instructions[index]
        if (instruction.opcode == Opcode.NOP) {
            instruction.opcode = Opcode.JMP
            instructions.removeAt(index)
            instructions.add(index, instruction)
        } else if (instruction.opcode == Opcode.JMP) {
            instruction.opcode = Opcode.NOP
            instructions.removeAt(index)
            instructions.add(index, instruction)
        }
    }

    fun run() {
        var instructionVisit : HashMap<Int, Boolean> = hashMapOf();
        while (true) {
            if (instructionVisit.containsKey(this.ip)) {
                println("Part 1 : ${this.acc}")
                break
            }
            instructionVisit.put(this.ip, true);
            var instruction = this.instructions[this.ip]
            when (instruction.opcode) {
                Opcode.ACC -> {
                    this.acc += instruction.value
                }
                Opcode.NOP -> {}
                Opcode.JMP -> {
                    this.ip += (instruction.value - 1)
                }
            }
            this.ip += 1
        }
	}

    fun reset() {
        this.ip = 0
        this.acc = 0
    }

    fun run2() {
        var indices : MutableList<Int> = arrayListOf();
        for (i in 0..this.instructions.size - 1) {
            if (this.instructions[i].opcode != Opcode.ACC) {
                indices.add(i)
            }
        }
        var found = false
        for (index in indices) {
            if (found) {
                break
            }
            this.reset()
            this.swapInstruction(index)
            var instructionVisit : HashMap<Int, Boolean> = hashMapOf();
            while (true) {
                if (this.ip == this.instructions.size) {
                    println("Part 2 : ${this.acc}")
                    found = true
                    break
                }
                if (instructionVisit.containsKey(this.ip)) {
                    break
                }
                instructionVisit.put(this.ip, true);
                var instruction = this.instructions[this.ip]
                when (instruction.opcode) {
                    Opcode.ACC -> {
                        this.acc += instruction.value
                    }
                    Opcode.NOP -> {}
                    Opcode.JMP -> {
                        this.ip += (instruction.value - 1)
                    }
                }
                this.ip += 1
            }
            this.swapInstruction(index)
        }
    }

    fun add(instruction:Instruction) {
        this.instructions.add(instruction)
    }

}

fun main(args: Array<String>) {
    var cpu = Cpu()

    if (args.size != 1) {
        println("input.txt not provided")
        exitProcess(-1);
    }

    File(args[0]).forEachLine {
        try {
            var instruction = it.split(" ")
            cpu.add(Instruction(Opcode.valueOf(instruction[0].toUpperCase()), instruction[1].toInt()))
        } catch (e: Exception) {
            println(e.toString())
        }
    }

    cpu.run()
    cpu.run2()
}
