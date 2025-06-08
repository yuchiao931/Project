
cd ..
/* this should be the path to the folder that contains the data/ and code/ folders */
// global immcrime "/Users/.../immcrime" 
/* Or just leave this line, and run the code by right-click and "Do" */
global immcrime : pwd

cd "$immcrime"
global results "$immcrime/results"

// the following code produces the tables and figures of the main text
do "$immcrime/code/config.do" // to install nescessary Stata packages
* do "$immcrime/code/make_data_for_figure1.do" // to create data needed for figure 1 from raw data (NB: needs authorization!)
* do "$immcrime/code/Figure1_replic.do" // to reproduce Figure 1 
do "$immcrime/code/Figure2_replic.do" // to reproduce Figure 2 top and bottom panels
do "$immcrime/code/Figure3_replic.do" // to reproduce Figure 3
do "$immcrime/code/Figure4_replic.do" // to reproduce Figure 4
do "$immcrime/code/make_data_for_figure5_tableA1.do" // to create data needed for figure 5 and table A1 from raw data
do "$immcrime/code/Figure5_TableA1_replic.do" // to reproduce Figure 5 and Table A1
