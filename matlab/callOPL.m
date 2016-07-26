% =====================================================================
%> @brief this matlab script loads the Java API for OPL, specifies the OPL model and
%> data file, adds additional parameters to the data file, then returns the
%> OPL solution as a MATLAB struct (soln) 
%> Author: Michael Yahknis (NREIP Internship program.
%> c/o Dr. Matthew Bays <matthew.bays@navy.mil>
%> Naval Surface Warface Center Panama City Division
%> Created: July. 2014
%> Modified: March 2016
%> This program comes with ABSOLUTELY NO WARRANTY. 
%> This software was written by DoD contractor employee while
%> performing official directly for the Government. As such, this software
%> comes with Unlimited Rights to the U.S. Government, which is releasing it
%> to the public.
%> %NOTE: the opl model must be able to get a feasible solution in order for
%>this API to function properly. If relaxation is required, this model will
%>simply not return a solution. In this case, it is better to debug the
%>model in the OPL IDE. 
%>
%>%NOTE: between each run of this software, the Java objects should be
%>cleared from the MATLAB memory in order to avoid errors
%>
%> Distribution Statement A: Approved for public release; distribution is unlimited.
% ======================================================================

function [soln] =  callOPL(modFilePath,srcDatFilePath,OPL_ParameterArray,numDecVars,decVarNames,decVarInds, callType)
%> @param modFilePath String that contains path of OPL model file relative
%>to the MATLAB working directory

%> @param srcDatFilePath String that contains path of the OPL data file
%>relative to the MATLAB working directory. This file is unaltered and any
%>runtime parameters get added to a copy of the file that is appended with 
%>_NEW.

%> @param runArgNames Cell array of strings that contain the names of the
%>OPL variables you wish to write to the *.dat file at runtime. 
%>Ex. {'myVar1','myVar2'}

%> @param runArgVals Cell array of the values that correspond to the
%>variables in runArgNames.

%>Ex. {valForMyVar1, valForMyVar2}
%> @param numDecVars Integer indicating how many decision variables you
%>wish to export from the OPL model solution

%> @param decVarNames Cell array that contains the names of the decision
%>variables. Ex. {'decVar1', 'decVar2',...}

%> @param decVarInds Cell array of cell arrays that contains the names of 
%> the indices of the decision variables specified in decVarNames 
%> Syntax is { {'index1ForDecVar1', 'index2ForDecVar1'} , {'index1ForDecVar2'}, ...}
%>if the decision variable is a single value, such as a float, just put an
%>integer range as its index. This will be ignored at runtime anyways, but 
%>avoids a buggy workaround. 
%>
%> @param callType Type of MATLAB-OPL interfae call. 
%> callType = commandLine: Use commandline oplrun
%> callType = java: Use Java API.
%>
%> @retval soln MATLAB structure containing in its fields the values and
%>names of the decision variables specified in decVarNames and decVarInds

    if nargin == 3
        numDecVars = 0;
        decVarNames = {};
        decVarInds = {};
        callType = 'commandLine';
    end

%add the location of the java file to the MATLAB path
javaaddpath ../matlab-opl-interface/bin/
% javaaddpath ../opl/lib/


%initialize the runtime parameters
% [runtime_param_names,runtime_param_values] = placement(runArgNames,runArgVals);

%import additional data
newDatFilePath = importOPLParams(OPL_ParameterArray,srcDatFilePath);
if strcmp(callType, 'commandLine')

    status = system(['/opt/ibm/ILOG/CPLEX_Studio1263/opl/bin/x86-64_linux/oplrun ' modFilePath ' ' newDatFilePath ]);

    fid = fopen('ObjVal.txt');
        
    soln.objValue = csvread('ObjVal.txt');
elseif strcmp(callType, 'java')
    %create an instance of the main API class
    oplAPI = OPLload(modFilePath, newDatFilePath, 0, 600);
    %load file paths into Java 
    oplAPI.setModFilePath(modFilePath); 
    oplAPI.setDatFilePath(newDatFilePath); %this should be newDatFileName in actual operation

    %specify decision variables / variables of interest

    for k = 1:numDecVars
        oplAPI.elmNames.put(decVarNames{k},decVarInds{k});
    end
    


%%%%%%%%%%%%%% END USER INPUT %%%%%%%%%%%%%%%%%

    %create an instance of the model object and solve it in OPL
    opl = oplAPI.modObj();

    %convert string names of variables
    oplAPI.getElm(opl,oplAPI.elmNames);

    %this returns a Java Hashmap
    solnMap = oplAPI.soln(oplAPI.elmsToIndices,oplAPI.types); 

    %get the keys of the map as an array
    keyArr = solnMap.keySet().toArray();


    %create the output struct
    soln = struct();
    for k = 1:numDecVars
        key = keyArr(k);

        val = solnMap.get(key);

        soln.(key) = val;
    end

    %add the objective value to the soln object
    if(oplAPI.isSolved())
        soln.('objValue') = opl.getCplex().getObjValue();

    else
        soln.('objValue') = -999;
    end

    fprintf('\n Solution: \n \n');
    disp(soln);
end


