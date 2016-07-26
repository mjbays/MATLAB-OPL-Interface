% =====================================================================
%> @brief this function takes in a cell array of parameter names and a cell array of
%>parameter values and writes them to a dat file. There must be a parameter 
%>name for each parameter value (i.e. the lengths of the arrays are equal) 
%>
%> Author: Michael Yahknis (NREIP Internship program)
%> c/o Dr. Matthew Bays <matthew.bays@navy.mil>
%> Naval Surface Warface Center Panama City Division
%> Created: July. 2014
%> Modified: March 2016
%> This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
%> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%>
%> Distribution Statement A: Approved for public release; distribution is unlimited.
%>
%> importMatDat will by default handle either 1D or 2D numeric arrays in
%>terms of formatting them to be read by OPL. The other option it will
%>accept in runtime_param_values are single values (such as one number or
%>one string). If you need a complex data structure such as a set of tuples,
%>you must pre-format it as a string in placement.m before passing it to
%>importMatDat.m
%>
%> @param runtime_param_names Cell array of string names of variables to be 
%> written to the *.dat file
%> @param runtime_param_values Cell array of values of variables to be
%>written to the *.dat file
%> @param srcDatFilePath String path to the "original" *.dat file relative
%>to the MATLAB working directory 
%>
%> @retval newDatFileName String path to the new *.dat file that includes
%>the runtime_param names and values. This file is placed in the same
%>directory as the source *.dat file. 
% ======================================================================

function [newDatFileName] = importMatDat(runtime_param_names,runtime_param_values,srcDatFilePath)

len = length(runtime_param_names); 

%open the dat file for appending
%NOTE : THIS file path is relative to the MATLAB source code; specify the
%directory of the *.dat file
filepath = '';

%create the new file name by parsing the old one
strCell = strsplit(srcDatFilePath,'.');
name = strCell{1};
newDatFileName = strcat(name,'_NEW','.dat');

%copy the source file into a new file
copyfile(strcat(filepath,srcDatFilePath),strcat(filepath,newDatFileName));

%open the new file for appending
fid = fopen(strcat(filepath,newDatFileName),'a');

for k = 1:len
    name = runtime_param_names{k};
    val = runtime_param_values{k};
    
    %check if the val is a numeric matrix or vector
    formattedVal = '[';
    if (isnumeric(val))
       [m,n] = size(val);
       if (m>1 && n>1)
           for j = 1:m
               formattedVal = strcat(formattedVal,'[',num2str(val(j,:)),']','\n');
           end
           formattedVal = strcat(formattedVal,']',';','\n');
       elseif ((m==1 && n>1) || (n==1 && m>1))
           for j = 1:m
               formattedVal = strcat('[',num2str(val(j,:)),']',';','\n');
           end
       else
           val = num2str(val);
           formattedVal = strcat(val,';','\n');
       end
    else 
       formattedVal = strcat(val,';','\n');
    end
    
    outputStr = strcat(name,'=',formattedVal);
    
    fprintf(fid,outputStr);
    
    
end
