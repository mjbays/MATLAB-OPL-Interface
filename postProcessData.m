%> @file postProcessData.m
%> @brief Function to post-process .txt files output from model file
%> and bring output data back into MATLAB.
% ======================================================================
%> @brief Function to post-process .txt files output from model file
%> and bring output data back into MATLAB.
%> Author: Dr. Matthew Bays <matthew.bays@navy.mil>
%> Naval Surface Warface Center Panama City Division
%> Created: July. 2014
%> Modified: March 2016
%>
%> This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
%> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%> Distribution Statement A: Approved for public release; distribution is unlimited.
%>
% ======================================================================
function [Iservice, Ideploy, Idock, Tstart, Tend] = postProcessData()
    tic
    Atot = 3;
    Aservice = 2;
    Atransport = 1;
    P = 12;
    numEdges = 20;
    
        
    
    for at = 1:Atransport
        for as = 1:Aservice
            fid = fopen(['Ideploy' num2str(at+Aservice) '_' num2str(as) '.txt']);
            str = fread(fid,inf,'uint8=>char')';
            fclose(fid);
            str = ['{' str '}'];  %Add braces, this will gather the arrays when evaluated.
            Ideploy(at,as,:,:) = eval(str);
       end
    end
    
     for at = 1:Atransport
        for as = 1:Aservice
            fid = fopen(['Idock' num2str(at+Aservice) '_' num2str(as) '.txt']);
            str = fread(fid,inf,'uint8=>char')';
            fclose(fid);
            str = ['{' str '}'];  %Add braces, this will gather the arrays when evaluated.
            Idock(at,as,:,:) = eval(str);
       end
    end
    
    for a = 1:Aservice
        fid = fopen(['Iservice' num2str(a) '.txt']);
        str = fread(fid,inf,'uint8=>char')';
        fclose(fid);
        str = ['{' str '}'];  %Add braces, this will gather the arrays when evaluated.
        Atemp = eval(str);
        Atemp = cell2mat(Atemp);
        Iservice(a).Area(:,:) = Atemp;
    end
    
     for a = 1:Atot
        fid = fopen(['Tstart' num2str(a) '.txt']);
        str = fread(fid,inf,'uint8=>char')';
        fclose(fid);
        str = ['{' str '}'];  %Add braces, this will gather the arrays when evaluated.
        Tstart(a,:) = eval(str);
    end
    %Tstart = cell2mat(Tstart);


    for a = 1:Atot
        fid = fopen(['Tend' num2str(a) '.txt']);
        str = fread(fid,inf,'uint8=>char')';
        fclose(fid);
        str = ['{' str '}'];  %Add braces, this will gather the arrays when evaluated.
        Tend(a,:) = eval(str);
    end