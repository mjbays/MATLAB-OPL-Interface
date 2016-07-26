%>\mainpage MATLAB-OPL Index Page
%>\section intro_sec Introduction
%>The purpose of this software is to provide an interface between MATLAB and OPL in order to facilitate easy data exchange and testing between the two programs. 
%>This software should help expand the user's ability to prototype and test models in OPL.
%>
%>\section Authors
%>
%> Michael Yahknis (NREIP Internship program)
%> Matthew Bays <matthew.bays@navy.mil>
%> Naval Surface Warface Center Panama City Division
%> Created: July. 2014
%> Modified: March 2016
%> This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
%> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%>
%> Distribution Statement A: Approved for public release; distribution is unlimited.
%>
%>\section Supported Operating Systems
%>Any that support installation of MATLAB, OPL, and the Java Virtual Machine
%>
%>\section Critical Notes
%>There are currently two versions of the API which are very similar, but not compatible with each other. 
%>
%>If you are looking for just the general MATLAB-OPL interface, use these files:
%>callOPL.m
%>importOPLParams.m
%>OPL_Parameter.m
%>
%>This set of files will be referred to as VERSION2 from now on. 
%>
%>If you are looking to implement the mine-field-optimization project, use these files:
%>javatest.m
%>importOPLParams.m
%>placement/placement_mines.m
%>OPLload.java (version that came with the mine-field-optimization project)
%>
%>This set of files will be referred to as VERSION1 from now on. 
%>
%>In terms of functionality, the files correspond as 
%>javatest.m        --> callOPL.m
%>placement.m       --> OPL_Paramter.m
%>importOPLParams.m  --> importMatDat.m
%>
%>Unless you are working on the mine-field-optimization project, you should be using VERSION2. 
%>
%>\section Dependencies
%>
%>The API consists of two Java source files: OPLload.java and ElmNames.java. However, MATLAB uses the compiled (*.class) versions of these files.  
%>
%>The main Matlab function is javatest.m, which in turn calls placement.m and importMatDat.m. (VERSION1) 
%>
%>The main Matlab function is callOPL.m, which calls importOPLParams.m, which in turn uses a list of OPL_Parameter objects as inputs. (VERSION2). 
%>
%>All Matlab files must be placed in the same directory. The Java and OPL files can be placed in an arbitrary place on the system as long as the location 
%>is specified in the MATLAB code in the manner instructed in the INSTALLATION section.
%>
%>OPL must be installed for this API to work.
%>
%> \section Installation
%> Please see the README for installation steps. 
%>
%>\section How To Run the API
%>
%>callOPL.m takes arguments: 
%>
%>modFilePath:  The filepath relative to the MATLAB working directory of the OPL model file
%>srcDatFilePath: The filepath relative to the MATLAB working directory of the OPL data file
%>OPL_ParameterArray: Array of OPL_Parameter objects containing the name, type, and value of runtime parameters you wish to add to the *.dat file
%>numDecVars: The number of decision variables you wish to export
%>decVarNames: A cell array containing the names of the decision variables you wish to export
%>decVarInds: A cell array containing in each index another cell array that contains the names of the indices of decision variables
%>
%>To run callOPL.m,
%>
%>1. Specify in string variables modFilePath and srcDatFilePath the relative path of the OPL model and data files respectively. 
%>In development, these were located in either the working directory or one level down from the working directory in a separate folder. 
%>
%>2. Specify in OPL_ParameterArray variables you want written to the copy of the *.dat file that is created at runtime (the software creates a copy of the 
%>original *.dat file so the original data is unaffected but new values can be added and overwritten multiple times). 
%>
%>3. The main purpose of importOPLParams.m is process and store the values of the variables you want written to the new *.dat file at runtime. The function
%>takes in an array of OPL_Parameters, puts them into the  correct format, creates a copy of the *.dat file specified, and writes the values to the new *.dat file. 
%>Only 1D and 2D numeric arrays, 2D tuples, single values, and strings are handled  automatically in terms of formatting the values correctly for OPL. If you need 
%>a special format outside of these, write the variables to a string in the format needed, and then just put that string in an OPL_Parameter object. 
%>importOPLParams.m will take care of the rest.
%>
%>4. Finally, you must specify for javatest.m the names of your decision variables and their corresponding indices. To do this, first specify the number of 
%>decision variables in the numDecVars variable. Then create two cell arrays, decVarNames and decVarInds. decVarNames stores the names of your decision variables
%>in the format of {'nameOfDecVar1', 'nameOfDecVar2', ...}. decVarInds then stores the names of the indices of your decision variable. The syntax for decVarInds is 
%>{ {'index1ForDecVar1', 'index2forDecVar1'}, {'index1forDecVar2'}, ... }. To illustrate this procedure, consider the following example: 
%>Let's say we had a decision variable in OPL called 'Inside' and 'Inside' was a 2D array indexed by named integer ranges 'Products' and 'Periods'. If this was the
%>only decision variable we wanted to export back to MATLAB, we would write decVarNames as {'Inside'} and decVarInds as {{'Products','Periods'}}. Note that decVarInds 
%>is a cell array of cell arrays. 
%>
%>The software currently only supports single value, 1D, and 2D arrays of float or int type values as the decision variable types. Note that if your decision
%>variable is a single value, you must still specify an index for it in the MATLAB code. This index can just be an integer index from somewhere else in your 
%>model. Whatever index you specify will be ignored at runtime for single values; this workaround is simply to avoid a more complex workaround in the Java code. 
%>If you wish to avoid confusion, perhaps the best strategy is to index your single value with an integer of 1 (thus technically making it a 1x1 array). 
%>
%>Once this is all complete, you can go ahead and run callOPL.m and the OPL solution should be returned in the MATLAB struct soln. This structure is 
%>displayed in the command window at runtime. 











