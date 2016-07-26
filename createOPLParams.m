% =====================================================================
%> @brief This function converts the needed information in an
% SATP_Parameters class object into an array of OPL_Parameter objects.
%> Author: Dr. Matthew Bays <matthew.bays@navy.mil>
%> Naval Surface Warface Center Panama City Division
%> Created: July. 2014
%> Modified: March 2016
%> This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
%> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%> Distribution Statement A: Approved for public release; distribution is unlimited.
%>
%> @param cSATP_Parameters SATP_Parameter object containing all of the 
%> information needed to run an SATP simulation instance
%>
%> @retval OPL_ParameterArray Array of OPL_Parameter objects.
% ======================================================================

function [ OPL_ParameterArray ] = createOPLParams()
    paramNum = 0;
    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('M', 'Singelton', 2);
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('N', 'Singelton', 1);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('S', 'Singelton', 4);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('nNodes', 'Singelton', 5);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('P', 'Singelton', 12);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('originPoint', 'Array', [0 0]);    
    paramNum = paramNum+1;    
    OPL_ParameterArray(paramNum) = OPL_Parameter('c_dock', 'Singelton', 20);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('c_deploy', 'Singelton', 10);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('c_service', 'Singelton', 100);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('Edges', '2DTupleArray', [1,2;1,3;1,4;1,5;2,1;2,3;2,4;2,5;3,1;3,2;3,4;3,5;4,1;4,2;4,3;4,5;5,1;5,2;5,3;5,4]);    
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('c_move', 'Array', [56.3778025497596;62.6266233674210;65.9348152497185;124.362158758086;56.3778025497596;29.5739077950135;30.8487703844348;81.2082147851515;62.6266233674210;29.5739077950135;4.82448963578097;65.9348152497185;65.9348152497185;30.8487703844348;4.82448963578097;62.6266233674210;124.362158758086;81.2082147851515;65.9348152497185;62.6266233674210]);
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('c_transport', 'Array', [12.2126803694698;13.4785288451456;14.1467873405846;25.8071756944709;12.2126803694698;6.70606560015636;6.97201496995369;17.2178819289184;13.4785288451456;6.70606560015636;1.31749330854977;14.1467873405846;14.1467873405846;6.97201496995369;1.31749330854977;13.4785288451456;25.8071756944709;17.2178819289184;14.1467873405846;13.4785288451456]);
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('nodesConnectedS1', 'Array', [0,1,0,0,0]);
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('nodesConnectedS2', 'Array', [0,0,1,0,0]);
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('nodesConnectedS3', 'Array', [0,0,0,1,0]);
    paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('nodesConnectedS4', 'Array', [0,0,0,0,1]);
     paramNum = paramNum+1;
    OPL_ParameterArray(paramNum) = OPL_Parameter('tiLim', 'Singleton', 1500);
    
%     OPL_ParameterArray(7) = OPL_Parameter('Finit', 'Singelton', 10);  
%     OPL_ParameterArray(11) = OPL_Parameter('f_dock', 'Singelton', cSATP_Parameters.c_transport);    
%     OPL_ParameterArray(12) = OPL_Parameter('f_deploy', 'Singelton', cSATP_Parameters.c_transport);    
%     OPL_ParameterArray(13) = OPL_Parameter('f_service', 'Singelton', cSATP_Parameters.c_transport);  
end

