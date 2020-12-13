# Lab 04 - Single Cycle CPU

Well, we're here! It's time to build your very own Single Cycle CPU in Verilog.
This is a very involved undertaking and will require dedicated focus over the
next few weeks. This is a large, interconected structure, and you'll spend a
good deal of time If there was a simpler way restling with debugging your CPU.

Unfortunately, part of the exercise will be the frustration of dealing with the
tools and Verilog. We've attempted to mitigate as much as possible by providing
some templating in the Verilog, but I would start early and reach out often for
feedback and help.

You can absolutely change the portlists of the modules, if you feel your design
needs it.

You are allowed to consult other groups for help if you'd like--you're all in
this together. Since this is such a large undertaking, we're going to split the
lab up into three deliverables, one due each week.


We're also going to learn about tagging in Git. Here's a deailed explanation
from the Git Book:

[git Basics - Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

A git tag is what it sounds like. You're assigning a human readable "tag" to a
particular Git commit so you can find it again later. I'm going to be asking you
to tag a particular commit for each part below and submit your repo link and
a tag name to Canvas. This way, you and your team can keep working and break
things in your repo and the NINJAs can grade things.

Don't worry, if you mess up Tagging that's fine, just include a note in your
submission with the correct tag so your NINJA can find your code.

If you haven't installed java, do so in docker with sudo apt install default-jre

## Lab 4A - Testbenches and Tables

To test the CPU, you'll want to write some assembly programs. I strongly
recommend writing the assembly programs in MARS first and single-stepping
through them in order to fully understand the behavior of the CPU. In order to
complete this part of the lab, please commit the following to your repo:

1. At least two assembly programs of reasonble complexity -- several different
   types of instructions, somewhere in the range of 5-10 instructions. Make sure
   to include some arithmetic instructions. One of your programs should include
   jumps and branches, but not all of them need to.
2. A block diagram of your CPU, similar to the datapath diagram we've looked at
   in class. Expect this to change as you work on the CPU, this exercise is just
   to push you through the next step, which is:
3. A complete decode table for each instruction of one of your assembly
   programs.

We've seen a decode table in class already, it was the decoding of an
instruction to the mux control bits, ALU control, register file and memory
address bits, etc. This decode table and the analysis you'll be doing will be a
critical aspect of debugging your CPU, so we're going to do it early, on
paper.

This portion of the lab will be due after the first week. Please tag it with the
string "Part1".

## Lab 4B - Muxes and Math

By the end of the second week, the arithmetic data and control paths should be
complete. You should have your ALU done as well as all of the control structures
required to push arithmetic instructions through the datapath. This includes
fetching the next instruction, decoding the instruction into register
reads/writes, and doing computation in your ALU.

Your CPU must pass the arith.asm test by the end of week two. Please tag your
functional arithmetic-only CPU with "Part2".

Here's a list of instructions your CPU should properly execute at this point:
add, addi, addiu, addu, and, andi, nor, or, ori, slt, slti, sltiu, sltu, sll,
srl, sub, subu, nop.

You can test your CPU by running "make test_part2"

## Lab 4C - Collaboration and CPUs

By the end of the third week, branches, jumps, and loads/stores should work.
Your CPU should be complete, and pass the appropriate battery of tests.

This part will be due after 3 weeks. Please tag your functional CPU with
"Part3".

Here's a list of instructions that your CPU should properly execute at this
point: add, addi, addiu, addu, and, andi, beq, bne, j, jal, jr, lbu, lhu, luui,
lw, nor, or, ori, slt, slti, sltiu, sltu, sll, srl, sb, sh, sw, sub, subu, nop.

You can test your CPU by running "make test_part3"

Note that part3.asm will run for longer than #2000 ticks, so you'll need to
comment out the $finish statement in test_cpu.v for it to complete.

## Heavy Lift

Add support for the following instructions: div, divu, mfhi, mflo, mult, multu,
bgez, bgezal, bgtz, blez, bletz, bltzal.

## Resources and Hints

* [Instruction Table](https://opencores.org/projects/plasma/opcodes)
* [SYSCALL](https://courses.missouristate.edu/KenVollmar/mars/Help/SyscallHelp.html)
* Pay close attention to the FUNCT field for arithmetic operations! A lot of
  them have 0x0 as the OPCODE, and the FUNCT field differentiates them.
* SHAMT is important for shifts!
* la, li, and move are "pseudo instructions," which the assembler converts to
  the appropriate instruction.
* Don't be afraid ot use behavioral verilog--you're more than welcome to write
  C = A + B instead of instantiating dedicated adders.
* Look at Lab 03 for mux structures! You'll be making heavy use of them!
* Be careful with signed/unsigned instructions--most of the complexity is in the
  reporting of the overflow flags and the like, as well as sign extension.
* Make heavy use of defines--if you have to use the same constant in multiple
  places, have a SINGLE SOURCE OF TRUTH. Not having to remember to keep 2-3
  files updated when you change a constant will save you HOURS of debugging, and
  save you from premature balding (ripping your hair out in frustration).
* lint early, lint often! Use the makefile targets to lint each block, you'll
  need them! You can use "make lint_<X>" where <X> can be fetch, decode, alu,
  regfile, memory, and cpu.

