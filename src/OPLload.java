//%>
//%> Author: Michael Yahknis (NREIP Internship program)
//%> c/o Dr. Matthew Bays <matthew.bays@navy.mil>
//%> Naval Surface Warface Center Panama City Division
//%> Created: July. 2014
//%> Modified: March 2016
//%> This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
//%> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//%> Distribution Statement A: Approved for public release; distribution is unlimited.
//%>
import java.util.*;

import ilog.concert.*;
import ilog.cplex.*;
import ilog.opl.*;

public class OPLload {
	public OPLload(String mod, String data){
		this.modFilePath = mod;
		this.datFilePath = data;
		this.timeOut = -1;
		this.emphasis=0;
	}
	public OPLload(String mod, String data, int emph, double tiOut){
		this.modFilePath = mod;
		this.datFilePath = data;
		this.timeOut = tiOut;
		this.emphasis=emph;
		
		
		//System.setProperty( "java.library.path", "/home/researcher_1/opl/bin/x86-64_linux" );
//		
//		
//				//create the concert environment
//				IloOplFactory oplF = new IloOplFactory();
//				//turn off debug mode
//				oplF.setDebugMode(false);
//				//create the error handler
//				IloOplErrorHandler errHandler = oplF.createOplErrorHandler();
//				//identify the model source
//				IloOplModelSource modelSource = oplF.createOplModelSource(modFilePath);
//				//identify the model definition
//				IloOplModelDefinition def = oplF.createOplModelDefinition(modelSource,errHandler);
//				//create the engine instance
//				IloCplex cplex = oplF.createCplex();
//				//create the opl model
//				IloOplModel opl = oplF.createOplModel(def, cplex);
//				//specify data source
//				IloOplDataSource dataSource = oplF.createOplDataSource(datFilePath);
//		        opl.addDataSource(dataSource);
//		        
//		        cplex.setParam(IloCplex.IntParam.MIPEmphasis, 0);
//		        
//		        //generate the concert model
//		        opl.generate();
//		        //solve the model
//		        if (cplex.solve()){};
//		        opl.postProcess();
//		        
//		        //print the solution
//		        opl.printSolution(System.out);
		
	}
	
	
	//these file paths are relative to the parent directory of the directory
	//containing the Java src code. i.e. if my code is in MATLABOPL3/src,
	//I need to put my mod/dat files in MATLABOPL3 and specify them as "mymodel.mod"
	private String modFilePath;
	
	private String datFilePath;
	
	private int emphasis;
	private double timeOut;
	
	private IloCplex.Status stat;
	private boolean isSolved;
	
	//public String[] args;
	
	public Map<String, double[][]> totSoln = new HashMap<String, double[][]>();
	
	//public ArrayList<ElmNames> elmNames = new ArrayList<ElmNames>();
	
	public Map<String, String[]> elmNames = new HashMap<String, String[]>(); //user specified decision variables and indices
	
	public Map<IloOplElement, ArrayList<IloOplElement>> elmsToIndices = new HashMap <IloOplElement,ArrayList<IloOplElement>>(); //program stored map of decision variables to their indices
	
	public Map<Object,String> types = new HashMap <Object,String>(); //Map of every decision variable and index to its proper type (expressed as a string)
	
	public static void main (String[] arguments) throws IloException {
		
    
        
        
        
	
	}
	

	
	public IloOplModel modObj() throws IloException{
		//create the concert environment
		IloOplFactory oplF = new IloOplFactory();
		//make sure we are in production mode
		IloOplFactory.setDebugMode(false);
		//create the error handler
		IloOplErrorHandler errHandler = oplF.createOplErrorHandler();
		
		IloOplSettings oplsettings = oplF.createOplSettings(errHandler);;
		
		//identify the model source		
		IloOplModelSource modelSource = oplF.createOplModelSource(modFilePath);
		//identify the model definition
		IloOplModelDefinition def = oplF.createOplModelDefinition(modelSource,oplsettings);
		//create the engine instance
		IloCplex cplex = oplF.createCplex();
		
		if(this.emphasis>0 && this.emphasis<=4){
			cplex.setParam(IloCplex.IntParam.MIPEmphasis, this.emphasis);
		}
		else{
			System.out.println("Warning, illegal or unset MIPEmphasis. Using Balanced.");
			cplex.setParam(IloCplex.IntParam.MIPEmphasis, IloCplex.MIPEmphasis.Balanced);
		}
		
		if(this.timeOut>0){
			cplex.setParam(IloCplex.DoubleParam.TiLim, this.timeOut);
		}
		else{
			System.out.println("Warning, illegal or unset Time Limit. Using default.");
		}
		
		
		//create the opl model
		IloOplModel opl = oplF.createOplModel(def, cplex);
		//specify data source
		IloOplDataSource dataSource = oplF.createOplDataSource(datFilePath);
        opl.addDataSource(dataSource);
        
        
        
        //generate the concert model
        opl.generate();
        //solve the model
        if (cplex.solve()){
        	opl.postProcess();
        }
        stat = cplex.getStatus();
        
        return opl;
              

	}
	


////        //get elements and convert to appropriate type
////        IloNumMap Inside = opl.getElement("Inside").asNumMap(); //(returns IloOplElement and then converts to IloNumMap)
////        
////        //get indices
////        IloSymbolSet Products = opl.getElement("Products").asSymbolSet();
////        IloIntRange Periods = opl.getElement("Periods").asIntRange();
////        
////        ElmPack myElm = new ElmPack(Inside,Products,Periods);
////        
////        return myElm;
//		
//		
//		
//		/************* POSSIBLE AUTOMATION FOR THE FUTURE ************/
//		
////		//get all data elements as an ArrayList of Strings
////		String allElms = opl.makeDataElements().toString();
////		List<String> elmNameArr = Arrays.asList(allElms.split(";"));	
////		int len = elmNameArr.size();
////		//elmNameArr.remove(len-1); //remove the last element (since it is an empty string)
////		
////		//iterate through each element name to find the decision variables
////		for(Iterator<String> i = elmNameArr.iterator(); i.hasNext(); ) {
////		    String elmName = i.next();
////		    
////		    IloOplElement elm = opl.getElement(elmName);
////		    
////		}
//	
//		/**************************************************************/
//	}

	
	public void getElm(IloOplModel opl, Map<String, String[]> elmNames){
		
		//loop through all elements in the map
		for (Map.Entry<String, String[]> elmPair : elmNames.entrySet()) { 
			String elmName = elmPair.getKey(); //get string name of decision variable
			IloOplElement elm = opl.getElement(elmName); //OPLelement version of decision variable
			String elmType = elm.getElementType().toString(); //get element type as string
			types.put(elm, elmType); //add the type of the decision variable to the HashMap
			
			
			System.out.println(elmName);
			System.out.println(elmType);
			
			//get the names of indices associated with this decision variable
			String[] indNames = elmPair.getValue();
			
			//initialize a storage array for the index elements
			ArrayList<IloOplElement> inds = new ArrayList<IloOplElement>();
			for (int k = 0; k<indNames.length; k++){
				String indName = indNames[k]; //get the name of this index
				IloOplElement ind = opl.getElement(indName); //get the OPlelement version of this index
				inds.add(ind); //add this index to the list
				
				String indType = ind.getElementType().toString(); //get the type of the element as a string
				types.put(ind, indType); //add the type of the index to the HashMap
				
				
				System.out.println(indName);
				System.out.println(indType);
				
			}
			
			//add the indices for this decision variable to the proper map
			elmsToIndices.put(elm, inds);
			
		}
		
		
	}
	
	
	
	
	public Map<String,double[][]> soln(Map<IloOplElement, ArrayList<IloOplElement>> elmsToIndices, Map<Object,String> types) throws IloException{
			
		
		//loop over all entries
		for (Map.Entry<IloOplElement, ArrayList<IloOplElement>> elmToIndex : elmsToIndices.entrySet()) { 
			
			IloOplElement elm = elmToIndex.getKey(); //get the element
			String elmType = elm.getElementType().toString();
			
			
			ArrayList<IloOplElement> inds = elmToIndex.getValue(); //get the list of indices
			
			//initialize default sizes for the indices
			int size1 = 1;
			int size2 = 1; 
			
			IloIntRange ind1 = null;
			IloIntRange ind2 = null; 
		
			List<List<Double>> ReturnList = new ArrayList<List<Double>>();  //initialize the return array
			
			//check the type of the element and cast the element to the appropriate type
			if (elmType.equals("MAP_NUM")){
				
				IloNumMap newElm = elm.asNumMap(); 
				
				
				if(inds.size()==2){
					
					//assume that we are only dealing with 2D matrices
					ind1 = inds.get(0).asIntRange();
					ind2 = inds.get(1).asIntRange();
					
					// Iterate on the first indexer.
			          for (java.util.Iterator it1 = ind1.iterator(); it1.hasNext();) {
			              int sub1 = (int) it1.next();
			              // Get the 2nd dimension array from the 1st dimension.
			              IloNumMap sub = newElm.getSub(sub1);
			              // Iterate on the second indexer of x (that is the indexer of the
			              // sub array).
			              List<Double> thisRow = new ArrayList<Double>(); //initialize storage for each row
			              for (java.util.Iterator it2 = ind2.iterator(); it2.hasNext();) {
			                  int sub2 = (int) it2.next();
			                  // We are in the last dimension of the array, so we can directly
			                  // use the get method.
			                  System.out.println(sub1 + " " + sub2 + " " + sub.get(sub2));
			                  thisRow.add(sub.get(sub2));  
			              }
			              ReturnList.add(thisRow);
			           }
					
				}
				
				
				else if(inds.size()==1){
					
					//we are only dealing with 1D arrays
					ind1 = inds.get(0).asIntRange();
					
					List<Double> thisRow = new ArrayList<Double>(); //initialize storage for each row
		            	for (java.util.Iterator it1 = ind1.iterator(); it1.hasNext();) {
		            		int sub2 = (int) it1.next();
		            		// We are in the last dimension of the array, so we can directly
		            		// use the get method.
		            		thisRow.add(newElm.get(sub2));
		            	}
		            	ReturnList.add(thisRow);
				}
			}
			else if(elmType.equals("SET_SYMBOL")){
				IloSymbolSet newElm= elm.asSymbolSet(); 
			}
			else if(elmType.equals("MAP_INT")){
				IloIntMap newElm = elm.asIntMap();	
				
				if(inds.size()==2){
					
					//assume that we are only dealing with 2D matrices
					ind1 = inds.get(0).asIntRange();
					ind2 = inds.get(1).asIntRange();
					
					// Iterate on the first indexer.
			          for (java.util.Iterator it1 = ind1.iterator(); it1.hasNext();) {
			              int sub1 = (int) it1.next();
			              // Get the 2nd dimension array from the 1st dimension.
			              IloIntMap sub = newElm.getSub(sub1);
			              // Iterate on the second indexer of x (that is the indexer of the
			              // sub array).
			              List<Double> thisRow = new ArrayList<Double>(); //initialize storage for each row
			              for (java.util.Iterator it2 = ind2.iterator(); it2.hasNext();) {
			                  int sub2 = (int) it2.next();
			                  // We are in the last dimension of the array, so we can directly
			                  // use the get method.
			                  thisRow.add((double) sub.get(sub2));   
			              }
			              ReturnList.add(thisRow);
			           }
					
				}
				
				else if(inds.size()==1){
					
					//we are only dealing with 1D arrays
					ind1 = inds.get(0).asIntRange();

					List<Double> thisRow = new ArrayList<Double>(); //initialize storage for each row
		            	for (java.util.Iterator it1 = ind1.iterator(); it1.hasNext();) {
		            		int sub2 = (int) it1.next();
		            		// We are in the last dimension of the array, so we can directly
		            		// use the get method.
		            		thisRow.add((double)newElm.get(sub2));
		            	}
		            ReturnList.add(thisRow);
				}
				
				
			}
			else if(elmType.equals("RANGE_INT")){
				IloIntRange newElm = elm.asIntRange();
			}
			else if(elmType.equals("SET_INT")){
				IloIntSet newElm = elm.asIntSet();
			}
			else if(elmType.equals("VAR_INT")){
				IloIntVar newElm = elm.asIntVar();
			}
			else if(elmType.equals("VAR_INTERVAL")){
				IloIntervalVar newElm = elm.asIntervalVar();
			}
			else if(elmType.equals("INT")){
				double newElm = (double) elm.asInt();
				
				List<Double> thisRow = new ArrayList<Double>(); //initialize storage for each row
				thisRow.add(newElm);
				ReturnList.add(thisRow);
			}
			else if(elmType.equals("MAP")){
				IloMap newElm = elm.asMap();
			}
			else if(elmType.equals("NUM")){
				double newElm = elm.asNum();
				
				List<Double> thisRow = new ArrayList<Double>(); //initialize storage for each row
				thisRow.add(newElm);
				ReturnList.add(thisRow);
				
			}
			else{
				Object newElm = null;
			}
			
		
			int len1 = ReturnList.size();
			int len2 = ReturnList.get(0).size();
			double[][] ReturnArr = new double[len1][len2];
			for (int i = 0; i < ReturnList.size(); i++) {
			    List<Double> row = ReturnList.get(i);
			    for (int j = 0; j<row.size(); j++){
			    	ReturnArr[i][j] = row.get(j);
			    }
			}
			
			
			
			
			totSoln.put(elm.getName(), ReturnArr);
			
		}
		
	          
	        return totSoln;
		
	}
	public boolean isSolved(){
		if(stat == IloCplex.Status.Unknown || 
		   stat == IloCplex.Status.InfeasibleOrUnbounded || 
		   stat == IloCplex.Status.Error){
			return false;
		}
		else return true;
		
	}
	
	public void setModFilePath(String input){
		modFilePath = input;
	}
	
	public void setDatFilePath(String input){
		datFilePath = input;
	}
	
	public void setMIPEmphasis(int emph){
		emphasis = emph;
	}
	
	public void setTimeout(double tiOut){
		timeOut = tiOut;
	}
//	public void printelms(){
//		ElmNames el = elmNames.get(0);
//		el.main(args);
//	}
	


	

}
