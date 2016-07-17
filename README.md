# Magic_Wine_Bottle_Holder

This respository is meant to house anything and everything pertaining to my (single and double) magic wine bottle holder designs.  I'm going to use the abbreviations "MWBH-1B" and "MWBH-2B" from now on for simplicity.  The "1B" stands for single-bottle, while the "2B" stands for double-bottle.

I've broken this readme into several sections:
* 1) Getting Started
* 2) Gist of the Math
* 3) Code
  * MATLAB
  * C++
  * Excel Spreadsheet
* 4) How to Find the Wine Bottle Center of Gravity (CG)
* 5) How to Calculate the Wood Density
* 6) Assumptions
* 7) Final Thoughts

If you want to see how to design and build a single-bottle MWBH, check out this [YouTube video](https://www.youtube.com/watch?v=LFT5_KenCFo)!

If you want to see how to desgin and build a double-bottle MWBH, check out this [YouTube video](https://www.youtube.com/watch?v=f5bap2hN8Xc)!

If you want to see the underlying math behind the design, check out this [PDF document](MWBH_Design.pdf).

## 1) Getting Started

The first question you should ask yourself is whether you want to design/build a single-bottle or a double-bottle magic wine bottle holder.  With that decision out of the way, you can decide whether you want to use some typical (good-looking) dimensions that I can provide for you, or if you want to have control over your design.

The default settings in my programs provided in this repository will give you something that looks normal.  For the MWBH-1B, the *Add Length %* is safe to keep at 20%.  For the MWBH-2B, the *Add Length %* looks good anywhere from 10% to 20%.  For the MWBH-2B, I would leave the *Vert Sep %* at 50%.  Anything higher will separate the bottles too much, and anything lower will bring the bottles too close together.  You'll still need to input your wood dimensions (thickness and width).

You can also ignore my sage advice and design your own from scratch.  That's what the code is for, after all!  Play with the settings and see what makes sense.  I haven't added error checks for everything yet.  For example, if you decrease the *Vert Sep %* field for the MWBH-2B, you will eventually see that the bottles actually interfere with each other without error.  These kinds of error checks will be updated in future versions, I just haven't had the time lately.

## 2) The Gist of the Math

A detailed description of the underlying math can be found in the [design document](MWBH_Design.pdf).  A shortened version will be provided here shortly.

## 3) Code

### MATLAB Code

The MWBH-1B and MWBH-2B MATLAB codes are provided.  They are both GUIs, so you will need both the *.m* and *.fig* files in order to run them.  To design a single-bottle MWBH, download [GUI_MWBH_1Bottle.m](GUI_MWBH_1Bottle.m) and [GUI_MWBH_1Bottle.fig](GUI_MWBH_1Bottle.fig).

To design a double-bottle MWBH, download [GUI_MWBH_2Bottle.m](GUI_MWBH_2Bottle.m) and [GUI_MWBH_2Bottle.fig](GUI_MWBH_2Bottle.fig).

When you have both the desired *.m* and *.fig* files in the same directory, run the *.m* file.

### C++ Code

The C++ codes for the MWBH-1B and MWBH-2B are provided in separate *.cpp* files.  For the MWBH-1B and the MWBH-2B, you'll need to download [MWBH_1Bottle.cpp](MWBH_1Bottle.cpp) and [MWBH_2Bottle.cpp](MWBH_2Bottle.cpp), respectively.

For the C++ code, there is the option of using an input file (extension *.inp*) that houses all the pertinent variables.  The input file is necessary if you want to input a new type of wood (with corresponding density).  Technically you can hardcode it in the *.cpp* file if you can find that section, but the default way is to alter the *.inp* file.  The input files are different for the single-bottle and double-bottle.  If you're opening/editing the input files on Windows, I suggest using Notepad++ instead of the default Notepad, because it will correctly format the file as I intended it.

For the MWBH-1B and MWBH-2B, you'll need to download [inputFile_1Bottle.inp](inputFile_1Bottle.inp) and [inputFile_2Bottle.inp](inputFile_2Bottle.inp), respectively.

To run the code, you'll need to compile it first.  I use the following command on my computer (as an example):

```
g++ MWBH_1Bottle.cpp
```

Once you have compiled the code, you can type ```ls``` and see that there is a new file in the current directory called ```a.out```.  You can run the code as follows:

```
./a.out
```

Because there are no inputs, the usage of the file will appear (and is the same if you type ```./a.out -h``` or ```./a.out --help```).  It will also instruct you (in red font) to "Enter at least one argument!".  If you just want to use the default values provided in the code, you can type either of the following:

```
./a.out -d
./a.out --default
```

If you want to use the input file, you can type any of the following (for example):

```
./a.out -i inputFile_1Bottle.inp
./a.out -i inputFile_1Bottle
./a.out --inputfile inputFile_1Bottle.inp
./a.out --inputfile inputFile_1Bottle
```

If you want more information, I'll be posting a PDF in this repository that will go into more detail.

### Excel Spreadsheet

I wrote the spreadsheet after I had written the code in MATLAB, and tried to translate it into a sheet that will fit on one page of a normal laptop.  Apologies if you have to scroll a little (which you will if you use the double-bottle worksheet).  The Excel spreadsheet you need to download is [Wine_Bottle_Holder.xlsx](Wine_Bottle_Holder.xlsx).

First note that there are five worksheets.  Two worksheets are for the design of the MWBH-1B, while two worksheets are for the design of the MWBH-2B.  The last worksheet contains the list needed to change the wood type.  I didn't hide this worksheet so that other users (you) could add to the list as you see fit.  Also note that the cells are color coded.  I didn't lock any cells, so just make sure you only change values in the blue cells.  I still need to update the MWBH-2B section of this workbook to include a variable, so it's best to just stick to the single-bottle until I update this readme file.  As a final note, you need to make sure you have iterative calculations enabled.  To do this, go to:

```
File > Options > Formulas
```

In the section titled *Calculation options*, check the box next to *Enable iterative calculation*.  I have my iterations set to 250, and the maximum change set to 0.001.  It seems to work fine.  If you need more iterations, just increase that number.

In the **WINE BOTTLE** section, the changeable parameters are, by default, given for a Bordeaux type wine bottle.  In my MATLAB and C++ programs, I have options for a Burgundy type bottle as well (and also a custom bottle).  I'll be updating this in the future as well, but the Bordeaux type should be fine.  The design really doesn't change too much unless you have some extremely odd shape.  If you design for a Bordeaux, and you put a Burgundy in it, you'll probably just need to push/pull the neck in/out a little farther.  Not a big deal.

In the **WOOD** section, you need to change the thickness and width of you wood piece.  Obviously, this code only designs rectangular wine bottle holders.  No weird fish shapes just yet.  The *Add Percentage* variable basically defines how much wood to add above the bottle neck to make it look good.  You can see the more detailed PDF that I will post in the future for a better explanation.  You could also look at the equations in the worksheet.

In the **MINIMUM ANGLE CALCULATION** section, I recommend just leaving the flag at *0*.  Using the minimum angle for your design will probably make it look semi-stupid.  But hey, it's your design.

As long as you made sure you have iterative calculations enabled, then the final results will be displayed in the 'SOLUTIONS' section.  Don't worry about the *Adjusted ### Hole Length* answer.  It is something I was playing around with, and will probably get rid of anyway.  The hole diameter that you drill must be between the minimum and maximum hole diameters listed in this section.  It's up to you.  If you use the minimum diameter, your bottle won't fit because the hole is literally just the size of the bottle neck.  However, in theory, this will make your bottle stand perpendicular to your wood.  If you use the maximum hole diameter, your bottle will lie flat with respect to the table.  I tend to choose a value in between the min and max (1.5 inches for a 3 inch bottle neck diameter) such that the bottle lies at a slight upward angle.

## 4) How to Find the Wine Bottle Center of Gravity (CG)

You've chosen the bottle you want to display, but you don't know how to find the center of gravity, so here you are!  You'll need three things: the wine bottle, a flat table, and a cylindrical object like a pencil or pen (without any clips attached to it that will impede its rolling motion).  I use a pen with the cap removed for the cylindrical object.  Turn the bottle horizontal with respect to the table, and lie it down on the pen.  The longitudinal pen axis should be perpendicular to the longitudinal bottle axis.  Lightly support the bottle on the neck end or base end as necessary.  Roll the bottle back and forth on the pen until the bottle doesn't need any support from your hands on either side.  Make a note (or a mark) of where that point is on the bottle.  This is the CG location!  The important input paramter for the design is the distance from the bottle base to the CG location, so stand the bottle upright again, and measure from the base to the marked location.  This is the variable *bLcg*.

It is important to note that this CG location is only accurate for a horizontal bottle.  This makes sense because if you tilt the bottle upward at an angle, the wine will slosh to the bottle neck (away from the base), and will move your CG closer to the neck.  This will affect the resulting calculations.  If you think about it, this means that as you increase the angle of the bottle with respect to the table (by drilling a smaller hole), you'll need to pull the bottle farther out of the hole to keep it balanced for that particular design (which was based on a horizontal bottle, with the maximum diameter hole).

## 5) How to Calculate the Wood Density

**Coming soon!**

## 6) Assumptions

**Coming soon!**

## 7) Final Thoughts

That's it!  Now you can go off to design and build your magic wine bottle holder.  I'll be updating this readme file as more things become available, so keep checking back if you want updates.

As a final disclaimer, let me say that I usually stay within normal limits when I design my MWBHs.  That is, I don't go too crazy with the design, using extreme angles and percentages and such.  There are inherent assumptions in my code that only makes the design valid up to a certain point.  These assumptions are discussed further in the [PDF](MWBH_Design.pdf).  I also obviously can't test out every single design, so if you find one that doesn't work for you, let me know and I can try to figure out why.

