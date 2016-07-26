/*********************************************
 * OPL 12.6.0.0 Model
 * Author: mjbays
 * Creation Date: Mar 5, 2014 at 9:20:09 AM
 * Author: Dr. Matthew Bays <matthew.bays@navy.mil>
 * Naval Surface Warface Center Panama City Division
 * Created: March 2014
 * Modified: March 2016
 * This program comes with ABSOLUTELY NO WARRANTY, without even the implied 
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * Distribution Statement A: Approved for public release; distribution is unlimited.
*********************************************/
// Parameters
int nNodes       = ...;
int M = ...;
int N = ...;
int P = ...;
//int A = ...;
int S = ...;

float originPoint[1..2] =...;

float Finit = ...;

float c_dock = ...;
float c_deploy = ...;
float c_service = ...;

float f_dock = ...;
float f_deploy = ...;
float f_service = ...;
float f_move = ...;

int Fmax = 100;
float Fcharge = 10;
int Dmax = 4;
float tiLim = ...;





range   Nodes  = 1..nNodes;

range Atot = 1..M+N;
range Aservice = 1..M;
range Atransport = M+1..M+N;

range Phases = 1..P;

range SurveyNodeRange = 1..1;



// Edges -- sparse set
tuple       edge        {int i; int j;}
setof(edge) Edges  = ...;     //= {<i,j> | i,j in Nodes: i!=j};
//range ServiceAreasPerDock[Areas];

tuple area {int nodeGraph[Nodes];};
{area} Areas;

float         c_move[Edges] = ...;
float		  c_transport[Edges] = ...;


int nodesConnectedS1[Nodes] = ...;
int nodesConnectedS2[Nodes] = ...;
int nodesConnectedS3[Nodes] = ...;
int nodesConnectedS4[Nodes] = ...;

// Decision variables
dvar boolean Imove[Atot][Phases][Edges];
dvar boolean Idock[Atransport][Aservice][Phases][Nodes];
dvar boolean Ideploy[Atransport][Aservice][Phases][Nodes];
dvar boolean Iservice[Aservice][Phases][Areas];
dvar boolean D[Atransport][Aservice][Phases];
dvar boolean Dgen[Aservice][Phases];
dvar boolean Iwait[Atot][Phases][Nodes];


dvar float+ Fuel[Aservice][Phases];
dvar float+ FuelCharge[Aservice][Phases];

dvar float+ Tstart[Atot][Phases];


dvar float+ Tend[Atot][Phases];

//dvar float+ Tcoop[Atot][Phases];
//dvar float+ TstartR[Atot][Phases];
//dvar float+ TendR[Atot][Phases];
//dvar float+ Tbuff[Atot][Phases];

int initItransport[n in Atransport][m in Aservice][p in Phases][e in Edges] =0;
int initImove[m in Atot][p in Phases][e in Edges] =0;
int constraintOn =1;

int Dinit[Atransport][Aservice] = [[1,1]]; //[[1,0], [0,1]];
//int Dinit[Atransport][Aservice] = [[1,1, 0,0], [0,0,1,1]];



// PRE-PROCESSING
execute 
{   var s  = 1;
    Areas.add(nodesConnectedS1);
    Areas.add(nodesConnectedS2);
    Areas.add(nodesConnectedS3);
    Areas.add(nodesConnectedS4);
       
    writeln(Areas);
  
  

}

// Objective
minimize (max(a in Atot)Tend[a][P]);
//+sum(n in Atransport, p in Phases, e in Edges) Imove[n][p][e]; //+ 1000*sum(m in Aservice, p in Phases, e in Edges) Imove[m][p][e];//+.0001*sum(a in Atot, p in Phases, e in Edges)(Imove[a][p][e]);
subject to {
   
   
   //Initialization
   forall (a in Atot)
     Iwait[a][1][1]==1;
   
   forall (a in Atot,d in Nodes:d!=1)
     Iwait[a][1][d]==0;
   
   //Iwait def Service
     forall (m in Aservice, p in Phases, d in Nodes)
     ctIwaitp:
     sum(d1 in Nodes, n in Atransport) (Idock[n][m][p][d1]+Ideploy[n][m][p][d1]) +
        sum(e in Edges)Imove[m][p][e] + 
   		sum(s in Areas) Iservice[m][p][s] + sum(d1 in Nodes:d1!=d) Iwait[m][p][d1]== 1 =>
   	     Iwait[m][p][d] == 0;
   	     
   	 forall (m in Aservice, p in Phases)
     ctIwaitp1:
     sum(d in Nodes, n in Atransport) (Idock[n][m][p][d]+Ideploy[n][m][p][d]) +
        sum(e in Edges)Imove[m][p][e] + 
   		sum(s in Areas) Iservice[m][p][s] == 0 =>
   	    sum(d in Nodes)Iwait[m][p][d] == 1;
   	
   	
   	 forall (a in Atot, p in Phases:p!=1, d in Nodes)
   	   ctIwaitp12:
   	   Iwait[a][p-1][d] == 1 => sum(d1 in Nodes: d1!=d) Iwait[a][p][d1]==0;
   	   
     forall (m in Aservice, p in Phases:p!=1, d in Nodes)
     ctIwaitpm1:
     sum(d1 in Nodes:d1!=d, n in Atransport) (Idock[n][m][p-1][d1]+Ideploy[n][m][p-1][d1]) +
        sum(<i,j> in Edges:j!=d)Imove[m][p-1][<i,j>] + 
   		sum(s in Areas:s.nodeGraph[d]!=1) Iservice[m][p-1][s] +
   		sum(d1 in Nodes:d1!=d) Iwait[m][p-1][d1] == 1 => Iwait[m][p][d] == 0;
   		
   forall (n in Atransport, p in Phases, d in Nodes)
     ctIwaitmp:
     sum(d1 in Nodes, m in Aservice) (Idock[n][m][p][d1]+Ideploy[n][m][p][d1]) +
        sum(e in Edges)Imove[n][p][e] + 
   		sum(d1 in Nodes:d1!=d) Iwait[n][p][d1] == 1 => Iwait[n][p][d] == 0;
   	
   forall (n in Atransport, p in Phases)
       ctIwaitmp1:
        sum(d in Nodes, m in Aservice) (Idock[n][m][p][d]+Ideploy[n][m][p][d]) +
        sum(e in Edges)Imove[n][p][e]  == 0 => 
   		sum(d in Nodes) Iwait[n][p][d] == 1;
   	
   	
   	 forall (n in Atransport, p in Phases:p!=1, d in Nodes)
     ctIwaitmpm1:
     sum(d1 in Nodes:d1!=d, m in Aservice) (Idock[n][m][p-1][d1]+Ideploy[n][m][p-1][d1]) +
        sum(<i,j> in Edges:j!=d)Imove[n][p-1][<i,j>] + 
   		sum(d1 in Nodes:d1!=d) Iwait[n][p-1][d1] == 1 => Iwait[n][p][d] == 0;
   
     
   // Dock and deploy constraint (2)
   forall (m in Aservice, n in Atransport, p in Phases)
        ctDockDeploy:
        D[n][m][p] == Dinit[n][m] + sum(d in Nodes, p2 in Phases:p2<=p) (Idock[n][m][p2][d] -  Ideploy[n][m][p2][d]);
   		
   
   // Dock and deploy Bounds (3-4)
   forall (m in Aservice, n in Atransport, p in Phases)
        ctdockDeployLBound:
        D[n][m][p] <= 1;
           
   forall (m in Aservice, n in Atransport, p in Phases)
        ctdockDeployUBound:
        D[n][m][p] >= 0;
   
   // General Dock and deploy constraint def (5)
   forall (m in Aservice, p in Phases)
        ctDockGenDef:
        Dgen[m][p] ==  sum(n in Atransport) D[n][m][p];    
   
   // General Dock and deploy bounds (6-7)
   forall (m in Aservice, p in Phases)
        ctDockGenDefLBound:
        Dgen[m][p] <= 1;
        
   
   forall (m in Aservice, p in Phases)
        ctDockGenDefUBound:
        Dgen[m][p] >= 0;
  
   // Max num of service agents docked (8)
   forall (n in Atransport, p in Phases)
     ctDockMax:
     sum(m in Aservice)
       D[n][m][p] <=Dmax;
       
       
   forall (m in Aservice, p in Phases)
          ctFuelDef:
          Fuel[m][p] == Finit + sum(p2 in Phases:p2<=p)(
          FuelCharge[m][p2] -sum(s in Areas)(f_service*Iservice[m][p2][s]) - sum(n in Atransport, d in Nodes)(f_dock*Idock[n][m][p2][d]
          +f_deploy*Ideploy[n][m][p2][d]) - sum(e in Edges)(f_move*c_move[e]*Imove[m][p2][e]));


   // Fuel upper bound (10)       
   forall (m in Aservice, p in Phases)
     ctFuelUBound:
     Fuel[m][p]<=Fmax;
   
   // Fuel lower bound (11)
   forall (m in Aservice, p in Phases)
     ctFuelLBound:
     0<=Fuel[m][p];
   
   // Fuel def (9)
   forall (m in Aservice, p in Phases)
     ctFuelCharge1:
     Dgen[m][p] == 1 => FuelCharge[m][p] <= Fcharge*(Tend[m][p]-Tstart[m][p]);
     
   forall (m in Aservice, p in Phases)
     ctFuelCharge0:
     Dgen[m][p] == 0 => FuelCharge[m][p] == 0;
   
   // Service agent max tasks (13)
   forall (m in Aservice, p in Phases)
     ctServiceTaskMax:
     ( sum(e in Edges)(Imove[m][p][e])
     + sum(n in Atransport, d in Nodes)(Idock[n][m][p][d] +  Ideploy[n][m][p][d]) 
     + sum(d in Nodes)(Iwait[m][p][d])
     + sum(s in Areas)(Iservice[m][p][s]))<=1;
   
   // Transport agent max tasks (13)
   forall (n in Atransport, p in Phases)
     ctTransportTaskMax:
     sum(e in Edges)(Imove[n][p][e]) + sum(m in Aservice, d in Nodes)(Idock[n][m][p][d] + Ideploy[n][m][p][d]) 
     + sum(d in Nodes)(Iwait[n][p][d])<=1;
   
   // Tstart init (15)
   forall(a in Atot, p in Phases:p==1)
      ctTstart:
      Tstart[a][p]==0;
   
   // Tstart Def (16)
   forall(a in Atot, p in Phases:p!=1)
     ctTstartP1:
     Tstart[a][p]>= Tend[a][p-1];
   
   // Tend service def (17)
   forall(m in Aservice, p in Phases)
     Tend[m][p] == Tstart[m][p]+
     sum(e in Edges)(c_move[e]*Imove[m][p][e])+
     sum(d in Nodes, n in Atransport) (c_deploy*Ideploy[n][m][p][d] + c_dock*Idock[n][m][p][d])
     + sum(s in Areas) c_service*Iservice[m][p][s];
   
   // Tend transport def (17)
   forall(n in Atransport, p in Phases)
     Tend[n][p] == Tstart[n][p]+
     sum(e in Edges)(c_transport[e]*Imove[n][p][e]) 
     + sum(m in Aservice, d in Nodes)(c_deploy*Ideploy[n][m][p][d]+c_dock*Idock[n][m][p][d]);
  
   //forall(n in Atransport)
     //sum(p in Phases, s in Areas) Iservice[n][p][s] == 0;
   
   // Dock and deploy duel start (18-19)  
   forall(m in Aservice, n in Atransport, p in Phases)
     ctDockDualTstart:
     sum(d in Nodes) Idock[n][m][p][d] == 1 => Tstart[m][p] == Tstart[n][p];
   
   forall(m in Aservice, n in Atransport, p in Phases)
     ctDeployDualTstart:
     sum(d in Nodes) Ideploy[n][m][p][d] == 1 => Tstart[m][p] == Tstart[n][p];

   // In order to dock, both agents must be co-located (22)
      
   forall(m in Aservice, n in Atransport, p in Phases:p!=1, d in Nodes)
     ctDockLocM:
     Idock[n][m][p][d] == 1 => sum(<d1,j> in Edges: j==d)Imove[m][p-1][<d1,j>] + 
     sum(s in Areas: s.nodeGraph[d]==1) Iservice[m][p-1][s]+
     Iwait[m][p-1][d]  ==1;
     
   forall(m in Aservice, n in Atransport, p in Phases:p!=1, d in Nodes)
     ctDockLocN:
     Idock[n][m][p][d] == 1 =>  
     sum(<d2,j> in Edges: j==d)(Imove[n][p-1][<d2,j>])+ 
     Iwait[n][p-1][d] + sum(m1 in Aservice: m1!= m)(Ideploy[n][m1][p-1][d] + Idock[n][m1][p-1][d])  ==1;
     
    //In order to deploy, both agents must be co-located (22)
    //add other actions for d
    forall(m in Aservice, n in Atransport, p in Phases:p!=1, d in Nodes)
     ctDeployLocM:
     Ideploy[n][m][p][d] == 1 => D[n][m][p-1] == 1;
   
   forall(m in Aservice, n in Atransport, p in Phases:p!=1, d in Nodes)
     ctDeployLocN: 
     Ideploy[n][m][p][d] == 1 => sum(<d1,j> in Edges: j==d)Imove[n][p-1][<d1,j>] + Iwait[n][p-1][d]+ 
     sum(m1 in Aservice: m1!= m)(Ideploy[n][m1][p-1][d] + Idock[n][m1][p-1][d])==1;

   

   // Service needs to be deployed (Dgen == 0) (21 & 26)
   forall(m in Aservice, p in Phases)
    sum(e in Edges) Imove[m][p][e] +sum(s in Areas) Iservice[m][p][s] == 1 => Dgen[m][p]==0;

   // Service requirement constraint (27)
   forall(s in Areas)
     ctService:
     sum(m in Aservice, p in Phases) Iservice[m][p][s] ==1;
   
   //Service constraint due to destination (25)
   forall(m in Aservice, n in Atransport, p in Phases:p!=1, s in Areas)
     Iservice[m][p][s]==1 => sum(n in Atransport, d in Nodes: s.nodeGraph[d]==1)(Ideploy[n][m][p-1][d]
     + sum(<i,j> in Edges:j==d)(Imove[m][p-1][<i,j>])+ Iwait[m][p-1][d])  ==1;
     
   // Move needs to move from last constraint (20)
   forall(m in Aservice, p in Phases:p!=1, d in Nodes)
     if(constraintOn == 1){
     sum(<d0,d1> in Edges:d0==d) Imove[m][p][<d0,d1>]==1 => sum(<dp,d0> in Edges:d0==d) (Imove[m][p-1][<dp,d0>]) + sum(n in Atransport) Ideploy[n][m][p-1][d] + 
     Iwait[m][p-1][d]+sum(s in Areas:s.nodeGraph[d]==1) Iservice[m][p-1][s]==1;
     }       
   forall(n in Atransport, p in Phases:p!=1, d in Nodes)
     if(constraintOn == 1){
     sum(<d0,d1> in Edges:d0==d) Imove[n][p][<d0,d1>]==1 => sum(<dp,d0> in Edges:d0==d) (Imove[n][p-1][<dp,d0>]) + sum(m in Aservice)( Ideploy[n][m][p-1][d] + Idock[n][m][p-1][d]) + Iwait[n][p-1][d] ==1;
     }       
  forall (m in Aservice)
     Dgen[m][P]==1;


    
};


execute{
     writeln(c_move);
	 //writeln(Edges.i)
    
    //writeln("Move Tuples: ");
    //writeln(Edges);
    
   // writeln("Agent S1 Iservice: ");
    //writeln(Iservice[1]);
    var IserviceTxt = new Array();
    for(var a in Aservice){
    	IserviceTxt[a] = new IloOplOutputFile("Iservice"+a+".txt");
    	IserviceTxt[a].writeln(Iservice[a]);    
    }
    
    
    //writeln("Agent S2 Iservice: ");
    //writeln(Iservice[2]);
    
    //writeln("Agent S3 Iservice: ");
    //writeln(Iservice[3]);
   
    
    
    
   
    
    //writeln("Imove: ")
    //writeln(Imove);
    
    var ImoveTxt = new Array();
    for(var a in Atot){
    	ImoveTxt[a] = new IloOplOutputFile("Imove"+a+".txt");
    	for(var p in Phases){
    	   	for(var e in Edges){
    	   		ImoveTxt[a].write(Imove[a][p][e]);
    	   		ImoveTxt[a].write(" ");  	   	
    	   	}
    	   	ImoveTxt[a].write("\n");
       }    	   	
    }
    
    
    
    //writeln("Idock: ")
    //writeln(Idock);
    
    var IdockTxt = new Array();
    for(var at in Atransport){
    	for(var as in Aservice){
    	    IdockTxt[as+(at-1)*as] = new IloOplOutputFile("Idock"+at+"_"+as+".txt");
    		IdockTxt[as+(at-1)*as].writeln(Idock[at][as]);   	
    	}
    }
    	 
    
    //writeln("Ideploy: ")
    //writeln(Ideploy);
    
    var IdeployTxt = new Array();
    for(var at in Atransport){
    	for(var as in Aservice){
    	    IdeployTxt[as+(at-1)*as] = new IloOplOutputFile("Ideploy"+at+"_"+as+".txt");
    		IdeployTxt[as+(at-1)*as].writeln(Ideploy[at][as]);   	
    	}
    }
    
    //writeln("Agent S1 Tstart : ")
    //writeln(Tstart[1]);
    
    //writeln("Agent S2 Tstart : ")
    //writeln(Tstart[2]);
        
    //writeln("Agent S3 Tstart : ")
    //writeln(Tstart[3]);
    
    //writeln("Agent T1 Tstart : ");
    //writeln(Tstart[M+1]);
    
    var TstartTxt = new Array();
    for(var a in Atot){
    	TstartTxt[a] = new IloOplOutputFile("Tstart"+a+".txt");
    	for(var p in Phases){
    	TstartTxt[a].write(Tstart[a][p]);    	
    	TstartTxt[a].write(" ");  
    	}
        TstartTxt[a].write("\n");   
    }
    
    //writeln("Tend: ");
    //writeln(Tend);
    var TendTxt = new Array();
    for(var a in Atot){
    	TendTxt[a] = new IloOplOutputFile("Tend"+a+".txt");
    	for(var p in Phases){
	    	TendTxt[a].write(Tend[a][p]);  
	    	TendTxt[a].write(" ");  	
    	}
    	TendTxt[a].write("\n");
    }
    
        
    //writeln("Fuel: ")
    //writeln(Fuel);
    var FuelTxt = new Array();
    for(var a in Aservice){
    	FuelTxt[a] = new IloOplOutputFile("Fuel"+a+".txt");
    	for(var p in Phases){
    		FuelTxt[a].write(Fuel[a][p]);
            FuelTxt[a].write(" ");
    	}    
    	    FuelTxt[a].write("\n");
    }
    
    //writeln("Fuel: ")
    //writeln(Fuel);
    //writeln("D: ")
    //writeln(D);
    //writeln("Iwait: ")
    //writeln(Iwait);
    
    var IwaitTxt = new Array();
    for(var a in Atot){
    	IwaitTxt[a] = new IloOplOutputFile("Iwait"+a+".txt");
    	IwaitTxt[a].writeln(Iwait[a]);    
    }
    var ObjTxt = new IloOplOutputFile("ObjVal.txt");
    ObjTxt.writeln(cplex1.getObjValue());


}


main {

    var opl = thisOplModel
    var mod = opl.modelDefinition;
    var dat = opl.dataElements;
    var set = opl.settings;
    writeln(opl.Atransport);
    var status = 0;
    var it =0;
    writeln(opl.initItransport);
    writeln(opl.Edges.get(1, 2));
    
    var cplex1 = new IloCplex();
    opl = new IloOplModel(mod,cplex1);
    opl.addDataSource(dat);
    opl.generate();
    
    var vectors = new IloOplCplexVectors();
    vectors.attach(opl.Imove, opl.initImove);
    
    
    
    vectors.setVectors(cplex1);
    
    cplex1.tilim = opl.tiLim;
    cplex1.mipemphasis =2;
    
        
    cplex1.solve();
    
            
    if(cplex1.getCplexStatus()==1){
    	writeln("Optimal solution found!");    
    }        
    else{
    writeln("Exit Code: ");
    }    
        
    
    writeln("Best Value: ", cplex1.getObjValue());
    writeln(opl.Edges.i)
    
    writeln("Move Tuples: ");
    writeln(opl.Edges);
    
    writeln("Agent S1 Iservice: ");
    writeln(opl.Iservice[1]);
    var IserviceTxt = new Array();
    for(var a in opl.Aservice){
    	IserviceTxt[a] = new IloOplOutputFile("Iservice"+a+".txt");
    	IserviceTxt[a].writeln(opl.Iservice[a]);    
    }
    
    
    writeln("Agent S2 Iservice: ");
    //writeln(opl.Iservice[2]);
    
    writeln("Agent S3 Iservice: ");
    //writeln(opl.Iservice[3]);
   
    
    
    
   
    
    writeln("Imove: ")
    writeln(opl.Imove);
    
    var ImoveTxt = new Array();
    for(var a in opl.Atot){
    	ImoveTxt[a] = new IloOplOutputFile("Imove"+a+".txt");
    	for(var p in opl.Phases){
    	   	for(var e in opl.Edges){
    	   		ImoveTxt[a].write(opl.Imove[a][p][e]);
    	   		ImoveTxt[a].write(" ");  	   	
    	   	}
    	   	ImoveTxt[a].write("\n");
       }    	   	
    }
    
    
    
    writeln("Idock: ")
    writeln(opl.Idock);
    
    var IdockTxt = new Array();
    for(var at in opl.Atransport){
    	for(var as in opl.Aservice){
    	    IdockTxt[as+(at-1)*as] = new IloOplOutputFile("Idock"+at+"_"+as+".txt");
    		IdockTxt[as+(at-1)*as].writeln(opl.Idock[at][as]);   	
    	}
    }
    	 
    
    writeln("Ideploy: ")
    writeln(opl.Ideploy);
    
    var IdeployTxt = new Array();
    for(var at in opl.Atransport){
    	for(var as in opl.Aservice){
    	    IdeployTxt[as+(at-1)*as] = new IloOplOutputFile("Ideploy"+at+"_"+as+".txt");
    		IdeployTxt[as+(at-1)*as].writeln(opl.Ideploy[at][as]);   	
    	}
    }
    
    writeln("Agent S1 Tstart : ")
    writeln(opl.Tstart[1]);
    
    writeln("Agent S2 Tstart : ")
    writeln(opl.Tstart[2]);
        
    //writeln("Agent S3 Tstart : ")
    //writeln(opl.Tstart[3]);
    
    writeln("Agent T1 Tstart : ");
    writeln(opl.Tstart[opl.M+1]);
    
    var TstartTxt = new Array();
    for(var a in opl.Atot){
    	TstartTxt[a] = new IloOplOutputFile("Tstart"+a+".txt");
    	for(var p in opl.Phases){
    	TstartTxt[a].write(opl.Tstart[a][p]);    	
    	TstartTxt[a].write(" ");  
    	}
        TstartTxt[a].write("\n");   
    }
    
    writeln("Tend: ");
    writeln(opl.Tend);
    var TendTxt = new Array();
    for(var a in opl.Atot){
    	TendTxt[a] = new IloOplOutputFile("Tend"+a+".txt");
    	for(var p in opl.Phases){
	    	TendTxt[a].write(opl.Tend[a][p]);  
	    	TendTxt[a].write(" ");  	
    	}
    	TendTxt[a].write("\n");
    }
    
        
    writeln("Fuel: ")
    writeln(opl.Fuel);
    var FuelTxt = new Array();
    for(var a in opl.Aservice){
    	FuelTxt[a] = new IloOplOutputFile("Fuel"+a+".txt");
    	for(var p in opl.Phases){
    		FuelTxt[a].write(opl.Fuel[a][p]);
            FuelTxt[a].write(" ");
    	}    
    	    FuelTxt[a].write("\n");
    }
    
    //writeln("Fuel: ")
    //writeln(opl.Fuel);
    writeln("D: ")
    writeln(opl.D);
    writeln("Iwait: ")
    writeln(opl.Iwait);
    
    var IwaitTxt = new Array();
    for(var a in opl.Atot){
    	IwaitTxt[a] = new IloOplOutputFile("Iwait"+a+".txt");
    	IwaitTxt[a].writeln(opl.Iwait[a]);    
    }
   
    var ObjTxt = new IloOplOutputFile("ObjVal.txt");
    ObjTxt.writeln(cplex1.getObjValue());
    
    opl.end();
	cplex1.end();
	
        
  }    