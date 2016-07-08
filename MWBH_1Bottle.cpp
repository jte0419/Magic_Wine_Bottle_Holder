// --------------------- Magic Wine Bottle Holder : 1 Bottle -----------------------
// ------------------------- Written by: Josh Weisberger ---------------------------
// ---------------------------- Start date: 04/21/16 -------------------------------
// ---------------------------- Last update: 04/26/16 ------------------------------
//
// Notes:
//  04/21/16 - Transferring code from MATLAB: /Wine_Bottle_Holder/Wine_Bottle_Holder_1bottle.m
//  	     - Code works, just make sure to check against the MATLAB code for consistency
//           - Make sure clearance is correct...it seems low
//  04/26/16 - Everything works now and matches MATLAB output

#include <iostream> // For input/output
#include <iomanip>  // for setprecision()
#include <fstream>  
#include <string>   
#include <sstream>  // for std::stringstream
#include <math.h>   
#include <vector>   
#include <cstdlib>  // for exit()

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
int SET_WOOD_PARAMS(int i, char *argv[], double &wT, double &wW, double &wV, double &wM, double &wRho) {

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
	else if (wType_str == "Oak" || wType_str == "oak" || wType_str == "3") {
		wT = 0.75;					// Wood thickness [in]
		wW = 3;						// Wood width [in]
		wV = 0;						// Don't calculate density
		wM = 0;						// Don't calculate density
		wRho = 600;					// Wood density [kg/m^3]
	}
	else if (wType_str == "LowesMaple" || wType_str == "lowesmaple" || wType_str == "4") {
		wT = 0.5;					// Wood thickness [in]
		wW = 3.5;					// Wood width [in]
		wV = 42.6125;					// Wood volume [in^3]
		wM = 0.494;					// Wood density [kg]
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

// FUNCTION - Calculate the CG of the system
void CALC_CG(double wbL, double wtL, double del, double bbNeckToCG, double sepCG)
{
	double b = wbL*sin(del);

	double bbLPivot = bbNeckToCG-b;
	double btLPivot = bbLPivot-sepCG;

	double wL = wbL + wtL;

	double wLPivot = -0.5*wL*cos(90-del);
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
	     << "\t\tPallet     (pallet,     0)\n"
	     << "\t\tCherry     (cherry,     1)\n"
	     << "\t\tMaple      (maple,      2)\n"
	     << "\t\tOak        (oak,        3)\n"
	     << "\t\tLowesMaple (lowesmaple, 4)\n"
	     << "\n\t-b,--bottletype BOTTLE_TYPE\t\tSpecify bottle type\n"
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
	int bType   = 0;			// Bottle type [#]
	double wT   = 0.75;			// Wood thickness [in]
	double wW   = 3;			// Wood width [in]
	double wV   = 90;			// Wood volume [in^3]
	double wM   = 0.500;			// Wood mass [kg]
	double wRho = 0;			// Wood density [kg/m^3]
	
	double bHeight = 12;			// Bottle total height [in]
	double bLBody  = 7.5;			// Bottle body length (base to shoulder) [in]
	double bDNeck  = 1;			// Bottle neck diameter [in]
	double bLNeck  = 3.5;			// Bottle neck length [in]
	double bDBase  = 3;			// Bottle base diameter [in]
	double bLcg    = 4.5;			// Bottle base to CG length [in]
	double bRho    = 0.9755;		// Wine density [kg/L]
	double bV      = 0.750;			// Wine volume [L]
	
	int useMinAng   = 0;			// Flag for using minimum angle [#]
	double theta    = 45;			// Angle of wood w.r.t table [deg]
	double pctLAdd  = 20;			// Percentage of wood to add to length above hole [%]
	int iterMax     = 25;			// Maximum iterations to run [#]
	double errorTol = 1e-5;			// Error tolerance for solution convergence [#]
	
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
			// User specifies bottle type
			else if ((arg == "-b") || (arg == "--bottletype")) {
				int bFail = SET_BOTTLE_PARAMS(i,argv,bType,bHeight,bLBody,bDNeck,
		      				          bLNeck,bDBase,bLcg,bRho,bV);
		      		if (bFail == 1) {
		      			return 1;
		      		}
			}
			// User specifies wood type
			else if ((arg == "-w") || (arg == "--woodtype")) {
			
				// SET_WOOD_PARAMS, DO EVERYTHING THERE
				int wFail = SET_WOOD_PARAMS(i,argv,wT,wW,wV,wM,wRho);
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
	// - Check the blue output box after running to make sure desired settings were used
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
		string wType_str, bType_str;
		string wT_str, wW_str;
		string wV_str, wM_str;
		string bHeight_str, bLBody_str, bDNeck_str, bLNeck_str, bDBase_str;
		string bLcg_str, bRho_str, bV_str;
		string useMinAng_str, theta_str, pctLAdd_str;
		string iterMax_str, errorTol_str;
		int i, j;
		
		// Read the input file data
		for (i = 1; i <= 5; i++) {
			getline(inputFile,headerLine);	// Input first header lines
		}
		
		getline(inputFile,wType_str,'\t');	// Get wood type as a string
		getline(inputFile,bType_str,'\t');	// Get bottle type as a string
		
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
		
		getline(inputFile,bHeight_str,'\t');	// Get bottle height as a string
		getline(inputFile,bLBody_str,'\t');	// Get bottle body length as a string
		getline(inputFile,bDNeck_str,'\t');	// Get neck diameter as a string
		getline(inputFile,bLNeck_str,'\t');	// Get neck length as a string
		getline(inputFile,bDBase_str,'\t');	// Get bottle base diameter as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,bLcg_str,'\t');	// Get base to CG length as a string
		getline(inputFile,bRho_str,'\t');	// Get wine density as a string
		getline(inputFile,bV_str,'\t');		// Get wine volume as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,useMinAng_str,'\t');	// Get min angle flag as a string
		getline(inputFile,theta_str,'\t');	// Get wood angle w.r.t table as a string
		getline(inputFile,pctLAdd_str,'\t');	// Get wood add percentage as a string
		
		for (i = 1;i <= 1; i++) {
			getline(inputFile,headerLine);	// Input two header lines
		}
		
		getline(inputFile,iterMax_str,'\t');	// Get maximum iterations as a string
		getline(inputFile,errorTol_str,'\t');	// Get error tolerance as a string
		
		// Convert input strings to numbers
		wType = StrToInt(wType_str);
		bType = StrToInt(bType_str);
		
		if (wType == 4) {
			wT    = StrToDouble(wT_str);
			wW    = StrToDouble(wW_str);
			wV    = StrToDouble(wV_str);
			wM    = StrToDouble(wM_str);
		}
		
		if (bType == 2) {
			bHeight = StrToDouble(bHeight_str);
			bLBody  = StrToDouble(bLBody_str);
			bDNeck  = StrToDouble(bDNeck_str);
			bLNeck  = StrToDouble(bLNeck_str);
			bDBase  = StrToDouble(bDBase_str);
			bLcg    = StrToDouble(bLcg_str);
			bRho    = StrToDouble(bRho_str);
			bV      = StrToDouble(bV_str);
		}
		
		useMinAng = StrToInt(useMinAng_str);
		theta     = StrToDouble(theta_str);
		pctLAdd   = StrToDouble(pctLAdd_str);
		iterMax   = StrToInt(iterMax_str);
		errorTol  = StrToDouble(errorTol_str);
		
		// Close the input file
		inputFile.close();
		
	} // END load input file
	
	// Display values being used for the calculations
	cout << "\033[1;36m"
   	     << "\n |----------------------------------------------|"
	     << "\n |----------- Using These Variables ------------|"
	     << "\n |----------------------------------------------|\n"
	     << " | wType\tbType\t\t\t\t|\n"
	     << " | " << wType << "\t\t" << bType << "\t\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | wT\twW\t\t\t\t\t|\n"
	     << " | " << wT << "\t" << wW << "\t\t\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | wV\twM\t\t\t\t\t|\n"
	     << " | " << wV << "\t" << wM << "\t\t\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | bHeight\tbLBody\tbDNeck\tbLNeck\tbDBase\t|\n"
	     << " | " << bHeight << "\t" << bLBody << "\t" << bDNeck
	     << "\t" << bLNeck << "\t" << bDBase << "\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | bLcg\tbRho\tbV\t\t\t\t|\n"
	     << " | " << bLcg << "\t" << bRho << "\t" << bV << "\t\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | useMinAng\ttheta\tpctLAdd\t\t\t|\n"
	     << " | " << useMinAng << "\t\t" << theta << "\t" << pctLAdd << "\t\t\t|\n |\t\t\t\t\t\t| \n"
	     << " | iterMax\terrorTol\t\t\t|\n"
	     << " | " << iterMax << "\t" << errorTol << "\t\t\t\t\t|"
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
	
	// Convert wine bottle parameters to metric units [m]
	bHeight = bHeight*inchToM;
	bLBody  = bLBody*inchToM;
	bDNeck  = bDNeck*inchToM;
	bLNeck  = bLNeck*inchToM;
	bDBase  = bDBase*inchToM;
	bLcg    = bLcg*inchToM;
	
	// Calculated bottle parameters
	double bWShol    = (bDBase-bDNeck)/2;				// Width of shoulder [m]
	double bHShol    = bHeight-bLBody-bLNeck;			// Height of shoulder [m]
	double bNeckToCG = bHeight-bLcg-(0.5*bLNeck);			// Length from neck center to CG [m]
	
	// Initial value of pivot for iterations
	double bLPivot = 0;
	
	// Mass and weight of the wine bottle
	double bMass   = bRho*bV;					// Mass of bottle [kg]
	double bWeight = bMass*9.81;					// Weight of bottle [N] = [kg*m/s^2]
	
	// ----------------------------------------------------------------------------
	// ----------------------------- Wood Calculations ----------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
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
	// ----------------------------- Minimum Wood Angle ---------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 05/23/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Declare variables
	double num, den, minAngle, actualT;
	
	// First computation with smallest possible thickness
	num = 0.5*bDBase;					// Numerator
	den = ((0.5*bLNeck)-(wT/2)) + bHShol;			// Denominator
	minAngle = atan(num/den);				// Initial minimum angle [rad]
	
	// Recompute with updated thickness based on angle
	actualT  = (wT/2)/sin(minAngle);			// Adjusted thickness
	den      = ((0.5*bLNeck)-actualT) + bHShol;		// Denominator
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
	double bLPivotOld, wLHole, wL, wLPivot;
	double wWeight;
	
	for (int i = 1; i <= iterMax; i++) {
		
		// For error comparison later (initial value is zero)
		// - Initially zero so bottle CG is over base
		bLPivotOld = bLPivot;
		
		// Minimum length to have bottle CG over base of the wood
		wLHole = (bNeckToCG-bLPivot)/sin(del*degToRad);
		if (i == 1) {
			cout << "Minimum board length: " << wLHole*mToInch << " [in]\n\n";
		}
		
		// Length adjustments
		wL = wLHole + (0.5*bDNeck);				// Add half diameter of bottle neck to enclose neck in wood
		wL = wL + (pctLAdd/100)*wL;				// Add specificed percentage to length
		wL = wL + (wT/tan(theta*degToRad));			// Added length due to thickness change
		
		// Weight of the wood
		wWeight = WEIGHT_WOOD(wRho,wT,wW,wL);			// Wood weight changes with length change
		
		// Distance (magnitude) of wood CG to pivot
		wLPivot = (wL/2)*cos(theta*degToRad);
		
		// Calculate needed distance from bottle CG to pivot
		bLPivot = (wWeight*wLPivot)/bWeight;
		
		// Print results to the terminal
		if (i == 1) { 							   		// Print header for first iteration
			cout << "Wood Pivot [in]\tBottle Pivot [in]\n"
		             << "---------------------------------\n";
		}
		cout << "   " << wLPivot*mToInch << "\t   " << bLPivot*mToInch << endl;		// Update results every iteration
		
		// Check if new solution is within error tolerance
		if (fabs(bLPivotOld-bLPivot) <= errorTol) {
			cout << "\n" << "\033[1;32m   Solution has converged!\033[0m\n\n";
			break;
		}
		
	} // End iteration loop
	
	// ----------------------------------------------------------------------------
	// ------------------------------- Hole Drilling ------------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Declare variables
	double minHoleD, a, b, flatHoleD;
	
	// Absolute minimum hole diameter
	minHoleD = bDNeck;
	
	// Maximum hole diameter (corresponds to flat hole diameter)
	a = bDNeck/sin(theta*degToRad);					// Due solely to neck diameter and angle of wood
	b = wT/tan(del*degToRad);					// Due solely to thickness and angle of wood
	flatHoleD = a + b;						// Addition of both effects
	
	// ----------------------------------------------------------------------------
	// ------------------------------ Final Solutions -----------------------------
	// ----------------------------------------------------------------------------
	// --------------------------- Last Update: 04/22/16 --------------------------
	// ----------------------------------------------------------------------------
	
	// Check clearance of bottle first
	double clearance = wLHole*sin(theta*degToRad) - (0.5*bDBase);
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
	     << " | Length    : " << setprecision(4) <<  wL*mToInch << "\t[in]\t\t\t|\n"
	     << " | Thickness : " << setprecision(3) << wT*mToInch << "\t[in]\t\t\t|\n"
	     << " | Width     : " << wW*mToInch << "\t[in]\t\t\t|\n"
	     << " | Angle     : " << theta      << "\t[deg]\t\t\t|\n"
	     << " |----------------------------------------------|\n"
	     << " |                  H O L E                     |\n"
	     << " |----------------------------------------------|\n"
	     << " | L to Hole   : " << wLHole*mToInch << "\t[in]\t\t\t|\n"
	     << " | Min Hole D  : " << minHoleD*mToInch << "\t[in]\t\t\t|\n"
	     << " | Flat Hole D : " << flatHoleD*mToInch << "\t[in]\t\t\t|\n"
	     << " |----------------------------------------------|\033[0m\n\n";
	
	
	
	
	
	
	
	
} // End MAIN





