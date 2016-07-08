// --------------------- Magic Wine Bottle Holder : 2 Bottle -----------------------
// ------------------------- Written by: Josh Weisberger ---------------------------
// ---------------------------- Start date: 04/21/16 -------------------------------
// ---------------------------- Last update: 04/27/16 ------------------------------
//
// Notes:
//  04/21/16 - Transferring code from MATLAB: /Wine_Bottle_Holder/Wine_Bottle_Holder_1bottle.m
//  	     - Code works, just make sure to check against the MATLAB code for consistency
//           - Make sure clearance is correct...it seems low
//  04/26/16 - Everything works now and matches MATLAB output
//           - Copied code from MWBH_1Bottle.cpp to update for 2 bottles

#include <iostream>
#include <iomanip> // for setprecision()
#include <fstream>
#include <string>
#include <sstream> // for std::stringstream
#include <math.h>
#include <vector>
#include <cstdlib> // for exit()

using namespace std;

// FUNCTION - Convert a string to double
double StrToDouble(string sVal)
{
	double dVal;
	stringstream stream;
	stream.str("");
	stream.clear();
	stream << sVal;
	stream >> dVal;		
	
	return dVal;
}

// FUNCTION - Convert a string to int
int StrToInt(string sVal)
{
	int iVal;
	stringstream stream;
	stream.str("");
	stream.clear();
	stream << sVal;
	stream >> iVal;
	
	return iVal;
}

// FUNCTION - Set wood parameters based on type
int SET_WOOD_PARAMS(int i, char *argv[], double &wT, double &wW, double &wV, double &wM) {

	string wType_str = argv[i+1];
	if (wType_str == "Pallet" || wType_str == "pallet" || wType_str == "0") {
		wT = 0.75;					// Wood thickness [in]
		wW = 3;						// Wood width [in]
		wV = 90;					// Wood volume [in^3]
		wM = 0.500;					// Wood mass [kg]
		return 0;
	}
	else if (wType_str == "Cherry" || wType_str == "cherry" || wType_str == "1") {
		wT = 0.75;					// Wood thickness [in]
		wW = 3;						// Wood width [in]
		wV = 90;					// Wood volume [in^3]
		wM = 0.870;					// Wood mass [kg]
		return 0;
	}
	else if (wType_str == "Maple" || wType_str == "maple" || wType_str == "2") {
		wT = 0.75;					// Wood thickness [in]
		wW = 3;						// Wood width [in]
		wV = 90;					// Wood volume [in^3]
		wM = 1.070;					// Wood mass [kg]
		return 0;
	}
	else {
		cout << "\033[1;31mNo such wood exists, seek --help\033[0m\n";
		return 1;
	}
}

// FUNCTION - Set bottle parameters based on type
int SET_BOTTLE_PARAMS(int i, char *argv[], int bType, double &bHeight, double &bLBody, double &bDNeck,
		       double &bLNeck, double &bDBase, double &bLcg, double &bRho, double &bV) {
		       
	string bType_str = argv[i+1];
	if (bType_str == "Bordeaux" || bType_str == "bordeaux" || bType_str == "0") {
		bHeight = 12;					// Bottle total height [in]
		bLBody  = 7.5;					// Bottle body length (base to shoulder) [in]
		bDNeck  = 1;					// Bottle neck diameter [in]
		bLNeck  = 3.5;					// Bottle neck length [in]
		bDBase  = 3;					// Bottle base diameter [in]
		bLcg    = 4.5;					// Bottle base to CG length [in]
		bRho    = 0.9755;				// Wine density [kg/L]
		bV      = 0.750;				// Wine volume [L]
		return 0;
	}
	else if (bType_str == "Burgundy" || bType_str == "burgundy" || bType_str == "1") {
		bHeight = 11.75;				// Bottle total height [in]
		bLBody  = 5.5;					// Bottle body length (base to shoulder) [in]
		bDNeck  = 1.25;					// Bottle neck diameter [in]
		bLNeck  = 2.5;					// Bottle neck length [in]
		bDBase  = 3;					// Bottle base diameter [in]
		bLcg    = 4.25;					// Bottle base to CG length [in]
		bRho    = 0.9755;				// Wine density [kg/L]
		bV      = 0.750;				// Wine volume [L]
		return 0;
	}
	else {
		cout << "\033[1;31mNo such bottle exists, seek --help\033[0m\n";
		return 1;
	}    
}

// FUNCTION - Calculate the weight of the wood
double WEIGHT_WOOD(double wRho, double wT, double wW, double wL)
{
	// Wood volume
	double wVolume = wT*wW*wL;

	// Calculate the mass and weight of the wood board
	double wMass   = wRho*wVolume;
	double wWeight = wMass*9.81;
	
	return wWeight;
}

// FUNCTION - Show usage
static void SHOW_USAGE(string name)
{
	cerr << "\nUsage: " << name << " option SOURCES\n\n"
	     << "Options:\n"
	     << "\t-h,--help\t\t\t\tShow this help messaage\n"
	     << "\n\t-i,--inputfile INPUT_FILE\t\tUse an input file [.inp]\n"
	     << "\n\t-d,--default\t\t\t\tUse all default settings\n"
	     << "\n\t-w,--woodtype WOOD_TYPE\t\t\tSpecify wood type\n"
	     << "\t\tSupported Wood Types:\n"
	     << "\t\tPallet (pallet, 0)\n"
	     << "\t\tCherry (cherry, 1)\n"
	     << "\t\tMaple  (maple,  2)\n"
	     << "\n\t-bb,--bottletypebottom BOTTLE_TYPE\tSpecify bottle type\n"
	     << "\t\tSupported Bottle Types:\n"
	     << "\t\tBordeaux (bordeaux, 0)\n"
	     << "\t\tBurgundy (burgundy, 1)\n"
	     << "\n\t-bt,--bottletypetop BOTTLE_TYPE\t\tSpecify bottle type\n"
	     << "\t\tSupported Bottle Types:\n"
	     << "\t\tBordeaux (bordeaux, 0)\n"
	     << "\t\tBurgundy (burgundy, 1)\n"
	     << "\n\t-a,--angle ANGLE\t\t\tAngle with respect to table [degrees]\n"
	     << "\n\t-ma,--minangle\t\t\t\tUse minimum angle for calculations\n"
	     << endl;
}

// ------------------------------------------------------------------------------------------------------
// ---------------------------------------_______________------------------------------------------------
// --------------------------------------|               |-----------------------------------------------
// --------------------------------------| MAIN FUNCTION |-----------------------------------------------
// --------------------------------------|_______________|-----------------------------------------------
// ------------------------------------------------------------------------------------------------------
int main(int argc, char *argv[])
{
	// ----------------------------------------------------------------------------
	// -------------------------- Command Line Arguments --------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Define variables
	string inpFlnm;
	string arg;
	string bType_str;
	string wType_str;
	int useInp;
	
	// Define the default values
	// - Wood type:   Pallet (0)
	// - Bottle type: Bordeaux (0)
	int wType   = 0;			// Wood type [#]
	int bTypeB  = 0;			// Bottom bottle type [#]
	int bTypeT  = 0;			// Top bottle type [#]
	double wT   = 0.75;			// Wood thickness [in]
	double wW   = 3;			// Wood width [in]
	double wV   = 90;			// Wood volume [in^3]
	double wM   = 0.500;			// Wood mass [kg]
	double wRho = 0;			// Wood density [kg/m^3]
	
	// - Bottom bottle
	double b1Height = 12;			// Bottle total height [in]
	double b1LBody  = 7.5;			// Bottle body length (base to shoulder) [in]
	double b1DNeck  = 1;			// Bottle neck diameter [in]
	double b1LNeck  = 3.5;			// Bottle neck length [in]
	double b1DBase  = 3;			// Bottle base diameter [in]
	double b1Lcg    = 4.5;			// Bottle base to CG length [in]
	double b1Rho    = 0.9755;		// Wine density [kg/L]
	double b1V      = 0.750;		// Wine volume [L]
	
	// - Top bottle
	double b2Height = 12;			// Bottle total height [in]
	double b2LBody  = 7.5;			// Bottle body length (base to shoulder) [in]
	double b2DNeck  = 1;			// Bottle neck diameter [in]
	double b2LNeck  = 3.5;			// Bottle neck length [in]
	double b2DBase  = 3;			// Bottle base diameter [in]
	double b2Lcg    = 4.5;			// Bottle base to CG length [in]
	double b2Rho    = 0.9755;		// Wine density [kg/L]
	double b2V      = 0.750;		// Wine volume [L]
	
	int useMinAng   = 0;			// Flag for using minimum angle [#]
	double theta    = 45;			// Angle of wood w.r.t table [deg]
	double pctLAdd  = 10;			// Percentage of wood to add to length above hole [%]
	double sepPct   = 50;			// Bottle vertical separation percentage of base diameters [%]
	int iterMax     = 100;			// Maximum iterations to run [#]
	double errorTol = 1e-4;			// Error tolerance for solution convergence [#]
	double adjustM  = 0.01;			// Moment shift adjustment [#]
	
	// Show usage if user didn't enter any arguments
	if (argc == 1) {
		SHOW_USAGE(argv[0]);
		cout << "\033[1;31mEnter at least one argument!\033[0m\n";
		return 1;
	}
	
	// Parse user input information
	for (int i = 1; i < argc; i++) {					// Loop through all arguments (except file name)
		
		arg = argv[i];							// Current argument
		
		// User wants to display help
		// - Will not run the rest of the code
		if ((arg == "-h") || (arg == "--help")) {			// Compare to short and long arguments
			SHOW_USAGE(argv[0]);					// Call function to show help dialog
			return 1; 						// Exit out of the program
		}
		
		// User wants to use all default values
		// - Does not change any variables from default values
		if ((arg == "-d") || (arg == "--default")) {			// Compare to short and long arguments
			cout << "\033[1;31mUsing all default values\033[0m\n";	// Indicate that we are using default values
		}
		
		// User wants to use minimum angle calculation
		// - Does not change any variables, except uses minimum angle
		// - If user also specifies angle, will still use minimum angle
		if ((arg == "-ma") || (arg == "--minangle")) {
			useMinAng = 1;
		}
		
		// Command line arguments with options
		if (i + 1 != argc) {
			
			// User specifies input file (see separate if statement below)
			if ((arg == "-i") || (arg == "--inputfile")) {
				useInp = 1;
				inpFlnm = argv[i+1];
			}
			// User specifies bottom bottle type
			else if ((arg == "-bb") || (arg == "--bottletypebottom")) {
				int bFail = SET_BOTTLE_PARAMS(i,argv,bTypeB,b1Height,b1LBody,b1DNeck,
		      				          b1LNeck,b1DBase,b1Lcg,b1Rho,b1V);
		      		if (bFail == 1) {
		      			return 1;
		      		}
			}
			// User specifies top bottle type
			else if ((arg == "-bt") || (arg == "--bottletypetop")) {
				int bFail = SET_BOTTLE_PARAMS(i,argv,bTypeT,b2Height,b2LBody,b2DNeck,
		      				          b2LNeck,b2DBase,b2Lcg,b2Rho,b2V);
		      		if (bFail == 1) {
		      			return 1;
		      		}
			}
			// User specifies wood type
			else if ((arg == "-w") || (arg == "--woodtype")) {
			
				// SET_WOOD_PARAMS, DO EVERYTHING THERE
				int wFail = SET_WOOD_PARAMS(i,argv,wT,wW,wV,wM);
				if (wFail == 1) {
					return 1;
				}
			}
			// User specifies angle between wood and table
			else if ((arg == "-a") || (arg == "--angle")) {
				theta = StrToDouble(argv[i+1]);
			}
			
		} // END command line arguments with options
		
	} // END parsing command line arguments
	
	// User input "-i/--inputfile" on the command line
	if (useInp == 1) {
		// Make sure the file has the .inp format
		// - If it does not, append .inp to end of filename
		int num = inpFlnm.find(".inp",0);
		if (num == -1) {
			inpFlnm.append(".inp");			
		}
		cout << "Using input file: " << inpFlnm.c_str() << endl;
		
		// If user wants to use an input file, over-write any other variables from command line		
		ifstream inputFile;								// Initialize a file stream
		inputFile.open (inpFlnm.c_str());						// Open the file for reading
		
		// Check that the input file exists in the current directory
		// - If not, exit the program
		// - If it does, continue with data loading below
		if (!inputFile) {
			cout << "File doesn't exist!\n" << endl;				// Indicate that file doesn't exist
			return 1;								// Exit the program
		}
		
		// Define strings used to read in data from the input file
		string headerLine;
		string wType_str, bTypeB_str, bTypeT_str;
		string wT_str, wW_str;
		string wV_str, wM_str;
		string b1Height_str, b1LBody_str, b1DNeck_str, b1LNeck_str, b1DBase_str;
		string b1Lcg_str, b1Rho_str, b1V_str;
		string b2Height_str, b2LBody_str, b2DNeck_str, b2LNeck_str, b2DBase_str;
		string b2Lcg_str, b2Rho_str, b2V_str;
		string useMinAng_str, theta_str, pctLAdd_str, sepPct_str;
		string iterMax_str, errorTol_str, adjustM_str;
		int i, j;
		
		// Read the input file data
		for (i = 1; i <= 5; i++) {
			getline(inputFile,headerLine);	// Input first header lines
		}
		
		getline(inputFile,wType_str,'\t');	// Get wood type as a string
		getline(inputFile,bTypeB_str,'\t');	// Get bottom bottle type as a string
		getline(inputFile,bTypeT_str,'\t');	// Get top bottle type as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,wT_str,'\t');		// Get wood thickness as a string
		getline(inputFile,wW_str,'\t');		// Get wood width as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,wV_str,'\t');		// Get wood volume as a string
		getline(inputFile,wM_str,'\t');		// Get wood mass as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,b1Height_str,'\t');	// Get bottle height as a string
		getline(inputFile,b1LBody_str,'\t');	// Get bottle body length as a string
		getline(inputFile,b1DNeck_str,'\t');	// Get neck diameter as a string
		getline(inputFile,b1LNeck_str,'\t');	// Get neck length as a string
		getline(inputFile,b1DBase_str,'\t');	// Get bottle base diameter as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,b2Height_str,'\t');	// Get bottle height as a string
		getline(inputFile,b2LBody_str,'\t');	// Get bottle body length as a string
		getline(inputFile,b2DNeck_str,'\t');	// Get neck diameter as a string
		getline(inputFile,b2LNeck_str,'\t');	// Get neck length as a string
		getline(inputFile,b2DBase_str,'\t');	// Get bottle base diameter as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,b1Lcg_str,'\t');	// Get base to CG length as a string
		getline(inputFile,b1Rho_str,'\t');	// Get wine density as a string
		getline(inputFile,b1V_str,'\t');	// Get wine volume as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,b2Lcg_str,'\t');	// Get base to CG length as a string
		getline(inputFile,b2Rho_str,'\t');	// Get wine density as a string
		getline(inputFile,b2V_str,'\t');	// Get wine volume as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,useMinAng_str,'\t');	// Get min angle flag as a string
		getline(inputFile,theta_str,'\t');	// Get wood angle w.r.t table as a string
		getline(inputFile,pctLAdd_str,'\t');	// Get wood add percentage as a string
		getline(inputFile,sepPct_str,'\t');	// Get bottle separation percentage as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,iterMax_str,'\t');	// Get maximum iterations as a string
		getline(inputFile,errorTol_str,'\t');	// Get error tolerance as a string
		getline(inputFile,adjustM_str,'\t');	// Get moment adjustment factor as a string
		
		// Convert input strings to numbers
		wType  = StrToInt(wType_str);
		bTypeB = StrToInt(bTypeB_str);
		bTypeT = StrToInt(bTypeT_str);
		wT     = StrToDouble(wT_str);
		wW     = StrToDouble(wW_str);
		wV     = StrToDouble(wV_str);
		wM     = StrToDouble(wM_str);
	 	
		b1Height = StrToDouble(b1Height_str);
		b1LBody  = StrToDouble(b1LBody_str);
		b1DNeck  = StrToDouble(b1DNeck_str);
		b1LNeck  = StrToDouble(b1LNeck_str);
		b1DBase  = StrToDouble(b1DBase_str);
		b1Lcg    = StrToDouble(b1Lcg_str);
		b1Rho    = StrToDouble(b1Rho_str);
		b1V      = StrToDouble(b1V_str);
		
		b2Height = StrToDouble(b2Height_str);
		b2LBody  = StrToDouble(b2LBody_str);
		b2DNeck  = StrToDouble(b2DNeck_str);
		b2LNeck  = StrToDouble(b2LNeck_str);
		b2DBase  = StrToDouble(b2DBase_str);
		b2Lcg    = StrToDouble(b2Lcg_str);
		b2Rho    = StrToDouble(b2Rho_str);
		b2V      = StrToDouble(b2V_str);
		
		useMinAng = StrToInt(useMinAng_str);
		theta     = StrToDouble(theta_str);
		pctLAdd   = StrToDouble(pctLAdd_str);
		sepPct    = StrToDouble(sepPct_str);
		iterMax   = StrToInt(iterMax_str);
		errorTol  = StrToDouble(errorTol_str);
		adjustM   = StrToDouble(adjustM_str);
		
		// Close the input file
		inputFile.close();
		
	} // End load input file
	
	// Display values being used for the calculations
	cout << "\033[1;36m"
   	     << "\n |----------------------------------------------|"
	     << "\n |----------- Using These Variables ------------|"
	     << "\n |----------------------------------------------|\n"
	     << " | wType\tbTypeB\tbTypeT\t\t\t|\n"
	     << " | " << wType << "\t\t" << bTypeB << "\t" << bTypeT << "\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | wT\twW\t\t\t\t\t|\n"
	     << " | " << wT << "\t" << wW << "\t\t\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | wV\twM\t\t\t\t\t|\n"
	     << " | " << wV << "\t" << wM << "\t\t\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | b1Height\tb1LBody\tb1DNeck\tb1LNeck\tb1DBase\t|\n"
	     << " | " << b1Height << "\t\t" << b1LBody << "\t" << b1DNeck
	     << "\t" << b1LNeck << "\t" << b1DBase << "\t|\n |\t\t\t\t\t\t| \n"
	     << " | b2Height\tb2LBody\tb2DNeck\tb2LNeck\tb2DBase\t|\n"
	     << " | " << b2Height << "\t\t" << b2LBody << "\t" << b2DNeck
	     << "\t" << b2LNeck << "\t" << b2DBase << "\t|\n |\t\t\t\t\t\t| \n"
	     << " | b1Lcg\tb1Rho\tb1V\t\t\t|\n"
	     << " | " << b1Lcg << "\t\t" << b1Rho << "\t" << b1V << "\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | b2Lcg\tb2Rho\tb2V\t\t\t|\n"
	     << " | " << b2Lcg << "\t\t" << b2Rho << "\t" << b2V << "\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | useMinAng\ttheta\tpctLAdd\tsepPct\t\t|\n"
	     << " | " << useMinAng << "\t\t" << theta << "\t" << pctLAdd << "\t" << sepPct << "\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | iterMax\terrorTol\tadjustM\t\t|\n"
	     << " | " << iterMax << "\t\t" << errorTol << "\t\t" << adjustM << "\t\t|"
	     << "\n ------------------------------------------------\033[0m\n\n";
	
	// ----------------------------------------------------------------------------
	// ------------------------- Wine Bottle Calculations -------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Define some conversions
	double inchToM  = 0.0254;					// Convert inches to meters
	double mToInch  = 1/0.0254;					// Convert meters to inches
	double radToDeg = 180/M_PI;					// Convert radians to degrees
	double degToRad = M_PI/180;					// Convert degrees to radians
	
	// Convert wine bottle parameters to metric units
	b1Height = b1Height*inchToM;					// Bottom bottle
	b1LBody  = b1LBody*inchToM;
	b1DNeck  = b1DNeck*inchToM;
	b1LNeck  = b1LNeck*inchToM;
	b1DBase  = b1DBase*inchToM;
	b1Lcg    = b1Lcg*inchToM;
	
	b2Height = b2Height*inchToM;					// Top bottle
	b2LBody  = b2LBody*inchToM;
	b2DNeck  = b2DNeck*inchToM;
	b2LNeck  = b2LNeck*inchToM;
	b2DBase  = b2DBase*inchToM;
	b2Lcg    = b2Lcg*inchToM;
	
	// Calculated bottle parameters
	double b1WShol    = (b1DBase-b1DNeck)/2;			// Width of shoulder [m]
	double b1HShol    = b1Height-b1LBody-b1LNeck;			// Height of shoulder [m]
	double b1NeckToCG = b1Height-b1Lcg-(0.5*b1LNeck);		// Length from neck center to CG [m]
	
	double b2WShol    = (b2DBase-b2DNeck)/2;			// Width of shoulder [m]
	double b2HShol    = b2Height-b2LBody-b2LNeck;			// Height of shoulder [m]
	double b2NeckToCG = b2Height-b2Lcg-(0.5*b2LNeck);		// Length from neck center to CG [m]
	
	// Weight of bottles
	double b1Mass   = b1Rho*b1V;					// Bottom bottle mass
	double b2Mass   = b2Rho*b2V;					// Top bottle mass
	double b1Weight = b1Mass*9.81;					// Bottom bottle weight
	double b2Weight = b2Mass*9.81;					// Top bottle weight
	
	// ----------------------------------------------------------------------------
	// ----------------------------- Wood Calculations ----------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/27/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Angle between wood and vertical
	double del = 90-theta;						// Angle used frequently in computations [deg]
	
	// Convert wood parameters to metric units
	wT = wT*inchToM;						// Thickness of wood [m]
	wW = wW*inchToM;						// Width of wood [m]
	
	// Compute wood density
	if (wM != 0 && wV != 0) {
		wV = wV*pow(inchToM,3);					// Convert wood volume to [m^3]
		wRho = wM/wV;						// Wood density [kg/m^3]
	}
	
	// ----------------------------------------------------------------------------
	// ------------------------- Bottle Vertical Separation -----------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/27/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Convert percentage to a decimal
	sepPct = sepPct/100;
	
	// Minimum vertical separation distance [m]
	double minSep;
	minSep = (sepPct*b1DBase) + (sepPct*b2DBase);
	minSep = minSep + (sepPct*minSep);	
	
	// ----------------------------------------------------------------------------
	// ----------------------------- Minimum Wood Angle ---------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 05/23/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Declare variables
	double num, den, minAngle, actualT;

	// First computation with smallest possible thickness
	num      = 0.5*b1DBase;					// Numerator
	den      = ((0.5*b1LNeck)-(wT/2)) + b1HShol;		// Denominator
	minAngle = atan(num/den);				// Initial minimum angle [rad]
	
	// Recompute with updated thickness based on angle
	actualT  = (wT/2)/sin(minAngle);			// Adjusted thickness
	den      = ((0.5*b1LNeck)-actualT) + b1HShol;		// Denominator
	minAngle = atan(num/den);				// Actual minimum angle [rad]
	
	// Convert minAngle from rad to deg
	minAngle = minAngle*radToDeg;
	
	// If the user wants to use the minimum angle
	if (useMinAng == 1) {
		// Set minimum angle
		theta = minAngle;					// New angle to use [deg]
		
		// Update angle used in computations
		del = 90-theta;						// Angle w.r.t vertical [deg]
		
		// Print the minimum angle to terminal
		cout << "Min angle: " << theta << " [deg]\n\n";
	}
	else {
		if (theta < minAngle) {
			cout << "\033[1;31mAngle requested is too small (not possible)!\033[0m\n\n";	// Display that the angle is not possible
			return 1;									// Exit the program
		}
	}
	
	// ----------------------------------------------------------------------------
	// -------------------------- Computation Iterations --------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Declare new variables
	double b1LPivot, b2LPivot, b1LPivotOld, b2LPivotOld;
	double wL1Hole, wL2Hole, wLHole, wLTot;
	double wWeight;
	double oldM, sumM;
	double xSepCG, wL, wLPivot;
	
	// Pre-iterative loop computations
	xSepCG = minSep/tan(theta*degToRad);					// X-distance separation of two bottle CGs
	
	b1LPivot = 0;								// Initial pivot point of bottom bottle
	b2LPivot = b1LPivot-xSepCG;						// Initial pivot point of top bottle
	
	oldM = 1;								// Arbitrary old moment
	
	// Terminal printing headers
	cout << "Wood Pivot\tBB Pivot\tBT Pivot\tMoment\n";
	
	for (int i = 1; i <= iterMax; i++) {
		
		// Hole lengths
		wL1Hole = (b1NeckToCG-b1LPivot)/sin(del*degToRad);		// Base to bottom hole
		wL2Hole = minSep/sin(theta*degToRad);				// Bottom hole to top hole
		wLHole  = wL1Hole + wL2Hole;					// Base to top hole
		
		// Total length of board
		wLTot = wLHole + (0.5*b2DNeck);					// Add half diameter of bottle neck to enclose in wood
		wLTot = wLTot + (pctLAdd/100)*wLTot;				// Add specified percentage to length
		wLTot = wLTot + (wT/tan(theta*degToRad));			// Added length due to thickness and angle
		
		// Weight of wood
		wWeight  = WEIGHT_WOOD(wRho,wT,wW,wLTot);			// Wood weight (changes with length)
		
		// Distance (magnitude) of wood CG to pivot
		wLPivot = -(wLTot/2)*cos(theta*degToRad);			// New pivot length [m]
		
		// Calculate moment
		// - Negative moment = system tips to wood side
		// - Positive moment = system tips to bottle side
		sumM = (wWeight*wLPivot)+(b2Weight*b2LPivot)+(b1Weight*b1LPivot);
		
		// Print the iteration information to terminal
		cout << setprecision(4) << wLPivot << "\t\t" << b1LPivot 
		     << "\t\t"  << b2LPivot << "\t\t" << sumM << endl;
		
		// Change moment adjustment
		// - If we crossed over from negative moment to positive moment, or vice versa
		if (oldM*sumM < 0) {
			adjustM = 0.1*adjustM;
		} 
		
		// Reset old moment to the moment just calculated
		oldM = sumM;
		
		// Add or subtract distance based on moment
		if (sumM > -errorTol && sumM < errorTol) {
			cout << "\n\033[1;32mSolution Converged in " << i << " iterations!\033[0m\n\n";
			break;
		}
		else if (sumM < 0) {
			b1LPivot = b1LPivot + adjustM;				// Move bottles to the right
		}
		else if (sumM > 0) {
			b1LPivot = b1LPivot - adjustM;				// Move bottles to the left
		}
		
		// Calculate new top bottle pivot point
		b2LPivot = b1LPivot-xSepCG;
		
	} // End iteration loop
	
	// Minimum vertical height of bottom bottle
	
	// ----------------------------------------------------------------------------
	// ------------------------------- Hole Drilling ------------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Declare variables
	double minHoleD, a, b, flatHoleD;
	
	// Absolute minimum hole diameter
	minHoleD = b1DNeck;
	
	// Hole diameter for lie-flat bottle
	a = b1DNeck/sin(theta*degToRad);				// Due solely to neck diameter and angle of wood
	b = wT/tan(del*degToRad);					// Due solely to thickness and angle of wood
	flatHoleD = a + b;						// Addition of both effects
	
	// ----------------------------------------------------------------------------
	// ------------------------------ Final Solutions -----------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Check clearance of bottle first
	double clearance = wLHole*sin(theta*degToRad) - (0.5*b2DBase);
	if (clearance <= 0) {
		cout << "\033[1;31m   Bottle will touch the ground!\033[0m\n\n";
	}
	else {
		cout << "\033[1;33m   Ground clearance: " << setprecision(3)
		     << clearance*mToInch << " [in]\033[0m\n\n";
	}
	
	cout << "\033[1;32m"
   	     << "\n |----------------------------------------------|"
	     << "\n |-------- F I N A L  S O L U T I O N ----------|"
	     << "\n |----------------------------------------------|\n"
	     << " |                  W O O D                     |\n"
	     << " |----------------------------------------------|\n"
	     << " | Length    : " << setprecision(4) <<  wLTot*mToInch << "\t[in]\t\t\t|\n"
	     << " | Thickness : " << setprecision(3) << wT*mToInch << "\t[in]\t\t\t|\n"
	     << " | Width     : " << wW*mToInch << "\t[in]\t\t\t|\n"
	     << " | Angle     : " << theta      << "\t[deg]\t\t\t|\n"
	     << " |----------------------------------------------|\n"
	     << " |            B O T T O M  H O L E              |\n"
	     << " |----------------------------------------------|\n"
	     << " | L to Hole   : " << wL1Hole*mToInch << "\t[in]\t\t\t|\n"
	     << " | Min Hole D  : " << minHoleD*mToInch << "\t[in]\t\t\t|\n"
	     << " | Flat Hole D : " << flatHoleD*mToInch << "\t[in]\t\t\t|\n"
	     << " |----------------------------------------------|\n"
	     << " |               T O P  H O L E                 |\n"
	     << " |----------------------------------------------|\n"
	     << " | L to Hole   : " << wLHole*mToInch << "\t[in]\t\t\t|\n"
	     << " | Min Hole D  : " << minHoleD*mToInch << "\t[in]\t\t\t|\n"
	     << " | Flat Hole D : " << flatHoleD*mToInch << "\t[in]\t\t\t|\n"
	     << " |----------------------------------------------|\033[0m\n\n";
	
	
	
	
	
	
	
	
} // End MAIN





