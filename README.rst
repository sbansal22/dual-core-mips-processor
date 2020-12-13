:Name: Dual-core Processor 
:Authors: Thomas Jagielski, Sparsh Bansal, Dhara Patel
:Version: 1.0
:Website: ADD WEBSITE!!!!!!!!!!!

===== 
Dual-core Processor
===== 

We created a multicore processor with the intent of parallelizing program execution and allowing for optimized computing units. Using two of the same core computing units in a computer, we created a homogeneous multicore processor.  Each of the cores has a private memory space which is used for core-specific data storage as well as for instructions.

============

Requirements

:i: iVerilog
:ii: GTKWave
:iii: Verliator
:iv: Java
:v: MARS

Installation
============

The easiest and fastest way to get the packages up and running:

.. code-block:: bash

    sudo chmod +x install.sh 
    sudo ./install.sh
    
    
Documentation
=============

To run the assembly program on our processor, run the following command:

.. code-block:: bash

    make test_{asm_file_name}

Note: Do not include the .asm extension in the make command.

To test the code in GTKWave, run the following command:

.. code-block:: bash

    make test_{asm_file_name}
    gtkwave ./{asm_file_name}.vcd

To test the code in MARS, run the following command: 

.. code-block:: bash

    java -jar ./bin/Mars4_5.jar
    

Contributing Works
==================

We used information from:

:i: Lab 04 - Single Cycle CPU Computer Architecture FA 2020 Assignment - Jon Tse  

:ii: https://insights.sei.cmu.edu/sei_blog/2017/08/multicore-processing.html

:iii: https://en.wikipedia.org/wiki/Multi-core_processor

:iv: https://www.cs.cmu.edu/~fp/courses/15213-s07/lectures/27-multicore.pdf

:v: https://en.wikipedia.org/wiki/Apple_A11

Authors
======
Thomas Jagielski - Electrical and Computer Engineer, Olin College

Sparsh Bansal - Electrical and Computer Engineer, Olin College

Dhara Patel - Electrical and Computer Engineer, Olin College

Acknowledgments
======

We acknowledge all the guidance and remarks from the Computer Architecture teaching team.