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
public class ElmNames {
	
	public String elmName;
	
	public static String[] indNames;
	
	public ElmNames(String elmName, String[] indNames){
		this.elmName = elmName;
		this.indNames = indNames;
	}
	
	
	public static void main(String[] args){
		System.out.println(indNames[0]);
		System.out.println(indNames[1]);
	}
}
