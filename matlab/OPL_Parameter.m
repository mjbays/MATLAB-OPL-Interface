%> @file OPL_Parameter.m
%> @brief Class for use in converting MATLAB parameters to OPL parameters.
% ======================================================================
%> @brief Class for use in converting MATLAB parameters to OPL parameters
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
%> And here we can put some more detailed informations about the class.

classdef OPL_Parameter
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = protected, GetAccess = public)
        name;
        type;
        value;
        dims;
    end
    
    methods
         % ======================================================================
        %> @brief OPL_Parameter Class constructor
        %>
        %> Class constructor for OPL_Parameter class
        %>
        %> @param name  Name of OPL parameter [String]
        %> @param type Parameter type [String]
        %> @param value Values of OPL Parameter [Currently Only suports:
        %> singleton [int], 1 to 2D Array [Array], and 2D array of tuples 
        %> [2DTupleArray]
        %> @param dims [int] number of dimensions for array
        %>
        %> @return instance of the OPL_Parameter class.
        % ======================================================================    
        function newOPL_Parameter = OPL_Parameter(name, type, value, dims)
            if nargin == 3
               newOPL_Parameter.name = name; 
               newOPL_Parameter.type = type; 
               newOPL_Parameter.value = value; 
               newOPL_Parameter.dims = -1;
            elseif nargin == 4
               newOPL_Parameter.name = name; 
               newOPL_Parameter.type = type; 
               newOPL_Parameter.value = value; 
               newOPL_Parameter.dims = dims;
            end
        end
    end
    
end

