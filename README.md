# miniMatlab Compiler
Developed as part of laboratory coursework for Compilers Lab course _(CS39003-Autumn 2017)_ of CSE department at IIT Kharagpur

The compiler is developed in phases:
  - User-defined Library
  - Lexical Analyser
  - Parser
  - Intermediate Code Generator _(Three Address Code)_
  - Target Code Generator _(x86 Assembly)_

_ass5_15CS10053_ contains the final developed compiler. It converts source code in _miniMatlab_ (subset of Matlab language comprising basic matrix operations) to target assembly code.

To see the compiler in action:
+ `git-clone` the repository in your machine
+ `cd ass5_15CS10053` to move to the final folder
+ `make clean` to remove any previous executables
+ `make run` to run the compiler on the 5 test cases
+ verify the target assembly code in the `.s`files created
