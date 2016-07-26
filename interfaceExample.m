%> @file interfaceExample.m
%> @brief Example MATLAB script showing use of opl-matlab-interface
% ======================================================================
%> @brief Example MATLAB script showing use of opl-matlab-interface
%> Author: Dr. Matthew Bays <matthew.bays@navy.mil>
%> Naval Surface Warface Center Panama City Division
%> Created: July. 2014
%> Modified: March 2016
%>
%> This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
%> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%>
%> Distribution Statement A: Approved for public release; distribution is unlimited.
% ======================================================================
%> Load OPL_Parameters in the form of a OPL_Parameter MATLAB class.
OPL_ParameterArray = createOPLParams();
modFilePath = 'SATP_model_MATLAB.mod';
%> File path/Name for data, *.dat file. [text]
srcDatFilePath = 'SATP_data2.dat';
%> Split off .dat component
srcDatFileName = strsplit(srcDatFilePath, '.');
srcDatFileName = cell2mat(srcDatFileName(1));
% Calls OPL under default run option (use oplrun).
soln = callOPL(modFilePath, srcDatFilePath, OPL_ParameterArray);
[Iservice, Ideploy, Idock, Tstart, Tend] = postProcessData();