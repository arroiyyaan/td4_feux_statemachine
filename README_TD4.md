#### ADVANCED DIGITAL ELECTRONIC MODULE
Supervisor: Prof. Herve Mathias

Rilwanu Ar Roiyyaan KASNO | M2 Integration Circuit and System

----

**TD4: TRAFFIC LIGHT MODELLING**

#### A. Objective
- Creating a clock divier with fixed value of divider resulting in a particular clock frequency
- Modifying the clock divider into adjustable mode through switch input on the board

#### B. Method
> The process is basically done by firstly detecting change (rising edge) at the input.
> Then the internal system clock of 50 MHz is recurrently divided by 'facteur' to result in 1 MHz clock Outputs
> The fixed value of facteur is then modified to make it adjustable from the 4-bit range switches at the input

> ###### _For the fixed facteur (divider):_
> 1. A change of rising edge at the input is detected
> 2. Assess the current value of the counter
>  - The subsequential substraction of 'facteur - 1' when the counter is zero, and the subtraction of the 'counter - 1' for other condition, is equivalent to 50 Mhz = 2*25MHz which result in 1 Hz clock.
>   - The resulted clock is linked  the port of CLK_OUT which will give 1 Hz blinking LED

> ###### _For the adjustable facteur (divider):_
> 1. The divider is set to 4-bits in size
>   - This divider is connected to the four switches of the board
>   - 4-bits ranges from 0-15
> 2. With generally the same process with the fixed facteur, when the rising edge is detected and when the current value of counter is zero, the output is set to logical high. The second condition to be assessed is when the clock is equal to the division of the factuer and added by 1 (facteur/2+1).
>  - However, the division at this step is not taken from the internatl clock of 50 MHz, but instead from the output of the previous division (1 Hz). See the connection in the image below.
> 3.  Apart from from above possible conditions, the clock is then decreamented by 1 at each clock.

#### C. Results

###### _Fixed facteur division:_
the result is the 1 Hz clock, corresponding to the 1 blinking LED every second

###### _Fixed adjustable division:_
the results with the 4-bits adjustable facteur with as follows:
- facteur = 0001 -> 2 times bigger delay with respect to 1 Hz clock
- facteur = 0011 -> 3/2 times bigger delay with respect to 1 Hz clock
- facteur = 0111 -> 4 times bigger delay with respect to 1 Hz clock
- facteur = 1111 -> 8 times bigger delay with respect to 1 Hz clock


###### _The final Schematic is shown below:_
![](final_schematic.PNG)

###### _The video of the final result is included in the folder of submission_
named: clk_div_video.mp4



#### D. Issues
