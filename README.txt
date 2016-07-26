PURPOSE 

The purpose of this software is to provide an interface between MATLAB and IBM's Optimization Programming Language (OPL), part of IBM's Optization Studion,
in order to facilitate easy data exchange and testing between the two programs. 
This software should help expand the user's ability to prototype and test models in OPL.

AUTHORS

Mikhail Yakhnis, Summer 2014 NREIP intern under Dr. Matthew Bays
Dr. Matthew Bays
Naval Surface Warface Center Panama City Division
Created: July. 2014
Modified: March 2016
This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Distribution Statement A: Approved for public release; distribution is unlimited.


SUPPORTED OPERATING SYSTEMS

Any that support installation of MATLAB, OPL, and the Java Virtual Machine

******* CRITICAL NOTES ABOUT THIS README:
There are currently two versions of the API which are very similar, but not compatible with each other. 

If you are looking for just the general MATLAB-OPL interface, use these files:
callOPL.m
importOPLParams.m
OPL_Parameter.m


If you are looking to implement the the example
.mod files, additionally use
interfaceExample.m
createOPLParams.m
postProcessData.m

These are provided to give an example of how to read and write using the
class files and .txt files output, and imported back into MATLAB.
********




DEPENDENCIES

The API consists of two Java source files: OPLload.java and ElmNames.java. However, MATLAB uses the compiled (*.class) versions of these files.  

The main Matlab function is javatest.m, which in turn calls placement.m and importMatDat.m. (VERSION1) 

The main Matlab function is callOPL.m, which calls importOPLParams.m, which in turn uses a list of OPL_Parameter objects as inputs. (VERSION2). 

All Matlab files must be placed in the same directory. The Java and OPL files can be placed in an arbitrary place on the system as long as the location 
is specified in the MATLAB code in the manner instructed in the INSTALLATION section.

OPL must be installed for this API to work. 

The comments were largely written using the Doxygen for MATLAB package found at
http://www.mathworks.com/matlabcentral/fileexchange/25925-using-doxygen-with-matlab



INSTALLATION 

1. Install MATLAB, OPL, and the Java Virtual Machine if they are not yet installed. 

2. Load OPLload.java and ElmNames.java into a new project in Eclipse. Make sure Eclipse did not automatically create a package for you (this should only be the case
if you copy-pasted the contents of these java files into a file that was automatically created with the project. In any case, a package should not be specified at the 
top of either source file). 

3. Right click on the project name in Eclipse and select Build Path -> Configure Build Path. 

4. In the window that opens, click on the Libraries tab. Make sure the JRE System Library is already included (if it is not, look online on how to include it),
then click Add External JARS. 

5. Navigate to the OPL installation folder and find the oplall.jar file located in opl/lib. Click OK to add this JAR file. (On the author's computer, the 
opl folder was located at /opt/ibm/ILOG/CPLEX_Studio_Preview126/opl/. Although the folder structure should be similar in the user's case, the actual path
will depend on the installation location of OPL.)

6. Click the arrow to the left side of the oplall.jar filename in the same window. A number of options should appear below the filename. 

7. Click on Native Library Location and navigate to the opl installation folder. Find the folder containing all the *.so files. This should be in the 
root opl directory under bin/x86-64_linux. Click OK to add this Native Library Location. 

8. Click run in the Eclipse IDE to compile/build both files. You can leave whatever *.mod file name is specified in OPLload.java alone, 
the main concern here is to have compiled versions of the above files. (The program will error out if it can't find the *.mod file 
or the *.dat file, but this is OK as long as the file compiles). 

9. Make sure there are compiled *.class versions of the files in the bin folder in the project directory.

10. Open MATLAB and type prefdir in the command window to get the path of MATLAB's preferences directory. 

11. Copy paste this path into your file explorer to navigate to the preferences directory. In this directory, create a new file called
javalibrarypath.txt. In this file, write the complete/absolute path of the Native Library Location that you fougit nd in step 7. Save the file. 

12. In the same directory, create a file called javaclasspath.txt. In this file, write the complete path to the oplall.jar file that you found
in step 5 (including oplall.jar name). Note that this filepath must contain the actual file name (oplall.jar). As before this should be under opl/lib in the opl installation directory. 

13. Open javatest.m (for VERSION1) or callOPL.m (for VERSION2) in MATLAB. 

14. There are two lines at the top of this file that begin with javaaddpath. These two lines give MATLAB access to the OPL libraries and also 
the Java classes that we just compiled. Specify the relative (to the MATLAB working directory) or absolute paths to the directory containing
the *.class files you just made and the directory containing the oplall.jar file. (Make sure both paths are to the directory and not the actual files).

15. Add the the the library paths and oplrun process path to your PATH and
library file paths. E.g. for linux:
 ../ibm/ILOG/CPLEX_Studio1263/opl/bin/x86-64_linux
 ../home/mjbays/ibm/ILOG/CPLEX_Studio1263/cplex/bin/x86-64_linux
 ../opt/ibm/ILOG/CPLEX_Studio1263/opl/bin/x86-64_linux

16. Add matlab-opl-interface/matlab to your MATLAB path.

RUNNING 

Introduction: 

The MATLAB code revolves around 3 main files: 
callOPL.m
importOPLParams.m
OPL_Parameter.m

callOPL.m is the "master" function which calls importOPLParams.m, a helper function which packages any runtime parameters you want to include in the *.dat file. 
The runtime parameters themselves are provided as a list of OPL_Parameters, which is a MATLAB class that records the name, type, and value in each instance. 
importOPLParams.m takes these values, applies extra formatting, creates a copy of the original *.dat file (appending the original name with _NEW), 
and finally writes the values to this new *.dat file. It currently has two modes:
commandLine: runs oplrun from the command line
java: uses the Java API from OPL. This version is less stable and tested.

This package comes with an example .mod and .dat file used as part of research
found in the paper
M.J. Bays and T. A. Wettergren, "A solution to the service agent transport problem," IEEE/RSJ International Conference on Robotics and Automation, Hamburg, Germany, 2015.

Procedure:

callOPL.m takes arguments: 

modFilePath:  The filepath relative to the MATLAB working directory of the OPL model file
srcDatFilePath: The filepath relative to the MATLAB working directory of the OPL data file
OPL_ParameterArray: Array of OPL_Parameter objects containing the name, type, and value of runtime parameters you wish to add to the *.dat file
numDecVars: The number of decision variables you wish to export
decVarNames: A cell array containing the names of the decision variables you wish to export
decVarInds: A cell array containing in each index another cell array that contains the names of the indices of decision variables
callType: A string that should have one of two option choices:
commandLine: runs oplrun from the command line
java: uses the Java API from OPL. This version is less stable and less tested.
To run callOPL.m,

1. Specify in string variables modFilePath and srcDatFilePath the relative path of the OPL model and data files respectively. 
In development, these were located in either the working directory or one level down from the working directory in a separate folder. 

2. Specify in OPL_ParameterArray variables you want written to the copy of the *.dat file that is created at runtime (the software creates a copy of the 
original *.dat file so the original data is unaffected but new values can be added and overwritten multiple times). 

3. The main purpose of importOPLParams.m is process and store the values of the variables you want written to the new *.dat file at runtime. The function
takes in an array of OPL_Parameters, puts them into the  correct format, creates a copy of the *.dat file specified, and writes the values to the new *.dat file. 
Only 1D and 2D numeric arrays, 2D tuples, single values, and strings are handled  automatically in terms of formatting the values correctly for OPL. If you need 
a special format outside of these, write the variables to a string in the format needed, and then just put that string in an OPL_Parameter object. 
importOPLParams.m will take care of the rest.

4. a. Running with the commandLine Option:
run CallOPL with the commandLine otion set in the callType parameter. This is the default variable and does not use the 
numDecVars,decVarNames,decVarInds variables


b.Running with the java interface in callType

 Finally, you must specify names of your decision variables and their corresponding indices. To do this, first specify the number of decision variables in the numDecVars variable. Then create two cell arrays, decVarNames and decVarInds. decVarNames stores the names of your decision variables
in the format of {'nameOfDecVar1', 'nameOfDecVar2', ...}. decVarInds then stores the names of the indices of your decision variable. The syntax for decVarInds is 
{ {'index1ForDecVar1', 'index2forDecVar1'}, {'index1forDecVar2'}, ... }. To illustrate this procedure, consider the following example: 
Let's say we had a decision variable in OPL called 'Inside' and 'Inside' was a 2D array indexed by named integer ranges 'Products' and 'Periods'. If this was the
only decision variable we wanted to export back to MATLAB, we would write decVarNames as {'Inside'} and decVarInds as {{'Products','Periods'}}. Note that decVarInds 
is a cell array of cell arrays. 

The software currently only supports single value, 1D, and 2D arrays of float or int type values as the decision variable types. Note that if your decision
variable is a single value, you must still specify an index for it in the MATLAB code. This index can just be an integer index from somewhere else in your 
model. Whatever index you specify will be ignored at runtime for single values; this workaround is simply to avoid a more complex workaround in the Java code. 
If you wish to avoid confusion, perhaps the best strategy is to index your single value with an integer of 1 (thus technically making it a 1x1 array). 

5. Once this is all complete, you can go ahead and run callOPL.m and the OPL solution should be returned in the MATLAB struct soln. This structure is 
displayed in the command window at runtime. 



***NOTE***: If your model is infeasible for whatever reason (such as a conflict between constraints), the API WILL NOT relax the constraints automatically. 
In this case, it is recommended that the model be debugged in the OPL IDE until a feasible model is achieved. 
