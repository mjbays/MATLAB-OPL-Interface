% =====================================================================
%> @brief this function takes in a list of OPL_Parameter class objects 
%> and writes them to a dat file. There must be a parameter 
%> name for each parameter value (i.e. the lengths of the arrays are equal) 
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
%> importMatDat will by default handle either 1D or 2D numeric arrays or 
%> tuples in%>terms of formatting them to be read by OPL. The other option 
%> it will accept in runtime_param_values are single values (such as one 
%> number or one string). If you need a complex data structure such as a 
%> set of tuples, you must pre-format it as a string in placement.m before 
%> passing it to importMatDat.m
%>
%> @param OPL_ParameterArray An Array of OPL_Parameter class objects to be 
%> written to a *.dat file
%> 
%> @param srcDatFilePath String path to the "original" *.dat file relative
%>to the MATLAB working directory 
%>
%> @retval newDatFileName String path to the new *.dat file that includes
%>the runtime_param names and values. This file is placed in the same
%>directory as the source *.dat file. 
% ======================================================================

function [newDatFileName] = importOPLParams(OPL_ParameterArray,srcDatFilePath)

len = length(OPL_ParameterArray); 

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
fprintf(fid,'\n');
for k = 1:len
    name = OPL_ParameterArray(k).name;
    val = OPL_ParameterArray(k).value;
    type = OPL_ParameterArray(k).type;
    
    
    
    if(strcmp(type,'Array'))
        
        formattedVal = '[';
        if (isnumeric(val))
           if OPL_ParameterArray(k).dims == -1
                numDims = ndims(OPL_ParameterArray(k).value);
           else 
               numDims = OPL_ParameterArray(k).dims;
           end
           if numDims<=2
               [m,n] = size(val);
               if (m>1 && n>1 || (OPL_ParameterArray(k).dims ==2))
                   for j = 1:m
                       formattedVal = strcat(formattedVal,'[',num2str(val(j,:)),']','\n');
                   end
                   formattedVal = strcat(formattedVal,']',';','\n');
               elseif ((m==1 && n>1)) 
                   formattedVal = strcat('[',num2str(val(1,:)),']',';','\n');
               elseif(n==1 && m>1)
                   for j=1:m
                      formattedVal = strcat(formattedVal,num2str(val(j,n)),'\n');
                   end
                   formattedVal =strcat(formattedVal,']',';','\n');
               else
                   val = num2str(val);
                   formattedVal = strcat(val,';','\n');
               end
           elseif numDims == 3
               [m, n, o] = size(val);
               for j = 1:o
                    formattedVal = strcat(formattedVal,'[');
                    for i = 1:m
                       formattedVal = strcat(formattedVal,'[',num2str(val(i,:,j)),']');
                       if j==o && i == m
                            formattedVal = strcat(formattedVal,']]',';','\n');
                       elseif j~=o && i == m
                           formattedVal = strcat(formattedVal,'],','\n');
                       else
                           formattedVal = strcat(formattedVal,'\n');
                       end
                    end
               end
               
           elseif numDims == 4
               [m, n, o, p] = size(val);
               for l = 1:p
                   formattedVal = strcat(formattedVal,'[');
                   for j = 1:o
                        formattedVal = strcat(formattedVal,'[');
                        for i = 1:m
                           formattedVal = strcat(formattedVal,'[',num2str(val(i,:,j)),']');
                           if i~=m 
                               formattedVal = strcat(formattedVal,'\n');
                           end
                        end
                        if j~=o
                            formattedVal = strcat(formattedVal,'],' ,'\n');
                        end
                   end
                   if l ~= p
                       formattedVal = strcat(formattedVal,'],' ,'\n');
                   elseif l==p
                       formattedVal = strcat(formattedVal,']');
                   end
               end
               formattedVal = strcat(formattedVal,']];','\n');
           end
        else 
           formattedVal = strcat(val,']];','\n');
        end
        
    elseif(strcmp(type,'2DTupleArray'))
        formattedVal = '{';
        [m,n] = size(val);
        for i = 1:m
            formattedVal = strcat(formattedVal, '<');
            for j = 1:n
                if j<n
                    formattedVal = strcat(formattedVal,[num2str(val(i,j)),',']);
                else
                    formattedVal = strcat(formattedVal,[num2str(val(i,j)),'>', '\n']);
                end
            end
        end
        formattedVal = strcat(formattedVal,'};\n');
    elseif(strcmp(type,'Dual1DTupleArray'))
        numArrayTypes = length(val);
        lengthFirstArray = length(val{1}(1,:));
        lengthSecondArray = length(val{2}(1,:));
        numTuples = length(val{1}(:,1));
        formattedVal = '{';
        for l = 1:numTuples
            formattedVal = strcat(formattedVal, '<');
            for m = 1:numArrayTypes
                formattedVal = strcat(formattedVal,'[',num2str(val{m}(l,:)),']');
                if m ~= numArrayTypes
                   formattedVal = strcat(formattedVal,',')
                else
                    formattedVal = strcat(formattedVal, '>');
                end
            end
            if l~=numTuples
                   formattedVal = strcat(formattedVal,',');
            else
                formattedVal = strcat(formattedVal, '};\n');
            end
        end
    else
        formattedVal = strcat(num2str(val), ';\n');
    end
    outputStr = strcat(name,'=',formattedVal);
    fprintf(fid,outputStr);
    
end
