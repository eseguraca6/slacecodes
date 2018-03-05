// zArrayTrace.cpp Derived from.
// Zclient: ZEMAX client template program
// Originally written by Kenneth Moore June 1997
// Copyright 1997-2001 Kenneth Moore
//
// Modified by D Griffith, November 2003
// Converted to DLL, calleable as Matlab mex.
// Implements mass ray-tracing as documented in the Zemax Manual
// $Revision: 133 $

// Revision 1.1 fixed the following problem - this was prior to moving to Subversion.
// There is an error in the function zArrayTrace included in the MZDDE Toolbox. 
// When calling the function with polarisation switched on, setting Ezr = 1 results in Exr = 1 but Ezr = 0. 
// Setting Exr to any non-zero value always results in Exr being set to the value chosen for Ezr, while Ezr is always zero. 
// I've tracked down the error in the source file zArrayTrace.cpp - 
//  from line 325 onwards in the CASE statements, all the case 13's should refer to Ezr, but in fact refer to Exr. 
// Exr is already covered by the case 9's and so the value gets overwritten, while Ezr is never set. 
 
// Revision control shifted to Subversion - Revision numbers change.

// The zclient program is responsible for establishing communication
// with the ZEMAX server. All data from ZEMAX can be obtained by calling
// PostRequestMessage or PostArrayTraceMessage with the item name and a buffer to hold the data.
//
// Zclient will call UserFunction when the DDE communication link is established and ready.
// Zclient will automatically terminate the connection when UserFunction returns.
//
// Version 1.1 modified to support Array ray tracing September, 1997
// Version 1.2 modified for faster execution October, 1997
// Version 1.3 modified for faster execution November, 1997
// Version 1.4 modified to fix memory leak January, 1998
// Version 1.5 modified to add support for long path names and quotes November, 1998
// Version 1.6 modified to fix missing support for long path names and quotes in MakeEmptyWindow March, 1999
// Version 1.7 modified to fix memory leak in WM_DDE_ACK, March 1999
// Version 1.8 modified to add E-field data to DDERAYDATA for ZEMAX 10.0, December 2000
// Version 1.9 modified PostRequestMessage and PostArrayTraceMessage to return -1 if data failed (usually because of a timeout) or 0 otherwise, April 2001

// The following updates to zclient.c since this mex function was written have been implemented.
// zclient.c is now kept under revision control in the same directory as zArrayTrace.

// Version 2.0 modified WM_USER_INITIATE to distingush between 2 possibly simultaneous copies of ZEMAX running when responding to UDOP calls, September 1, 2006
// Version 2.1 modified to support Visual Studio 2005. Added the #pragma to disable the warning about deprecated functions
// Version 2.2 modified to move GotData=0 to more robust position. If ZEMAX returns data very quickly a deadlock can occur. November 30, 2007


#include <windows.h>
#include <dde.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include <math.h>
#include "mex.h"

#define WM_USER_INITIATE (WM_USER + 1)
#define DDE_TIMEOUT 50000

// Get rid of strcpy deprecated warning
#pragma warning ( disable : 4996 ) // functions like strcpy are now deprecated for security reasons; this disables the warning

typedef struct
	{
    double x, y, z, l, m, n, opd, intensity;
	double Exr, Exi, Eyr, Eyi, Ezr, Ezi;
	int wave, error, vigcode, want_opd;
	}DDERAYDATA;
/* Here are the field names for the DDERAYDATA struct */
#define NUMFIELDS 18
const char *FieldNames[NUMFIELDS] = {"x", "y", "z", "l", "m", "n", "opd", "intensity", 
									 "Exr","Exi","Eyr","Eyi", "Ezr", "Ezi",
									 "wave", "error", "vigcode", "want_opd"};


LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM);
void WaitForData(HWND hwnd);
char *GetString(char *szBuffer, int n, char *szSubString);
void remove_quotes(char *s);
int  PostRequestMessage(char *szItem, char *szBuffer);
int  PostArrayTraceMessage(char *szBuffer, DDERAYDATA *RD);
void CenterWindow(HWND hwnd);
void UserFunction(void);
void MakeEmptyWindow(int text, char *szAppName, char *szOptions);
void Get_2_5_10(double cmax, double *cscale);
int myGetInt(mxArray *ScalarNumeric);


/* global variables used by the client code */
char szAppName[] = "ZemaxClient";
int GotData, ngNumRays, ZEMAX_INSTANCE = 0;
char szGlobalBuffer[5000], szCommandLine[260];
HINSTANCE globalhInstance;
HWND hwndServer, hwndClient;
DDERAYDATA *rdpGRD = NULL;
mxArray *gplhs;
mxArray *dval; /* Temporary variable */
const mxArray *gprhs;
int nfields, nelems, mode, numrays;
DDERAYDATA *MyRayData;
unsigned int DDE_Timeout;


/* BEEP related stuff - mainly for debugging*/
void BEEP(int freq, int duration);
bool isNTxyz();
void DoEvents();

void BEEP(int freq, int duration)
    {
        	if(isNTxyz() == false){
        	int tmp;
        	long frq = 1190000L / (long)freq;
        _outp(67, 0xb6);
        _outp(66, frq & 0xff);
        _outp(66, (frq >> 8) & 0xff);
        	tmp = _inp(97);
        _outp(97, tmp | 0x03);
        	long firstTick;
        	firstTick = GetTickCount();
        	do{DoEvents();}
        	while((GetTickCount() - firstTick) <= (unsigned long)duration);
        	tmp = _inp(97);
        _outp(97, tmp & 0xfc);}
        	else{Beep(freq, duration);}
    }

bool isNTxyz()
    {
        	OSVERSIONINFO osVerInfo;
        	memset(&osVerInfo, 0, sizeof(OSVERSIONINFO));
        	osVerInfo.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
        	GetVersionEx(&osVerInfo);
        	if(osVerInfo.dwPlatformId == VER_PLATFORM_WIN32_NT)
        	{return true;}
        	else{return false;}
        	return false;
    }

void DoEvents()
    {
        MSG msg;
        while(PeekMessage(&msg,NULL,NULL,NULL,PM_REMOVE)){DispatchMessage(&msg);}
    }
/* End of BEEP-related stuff */





int CALLBACK LibMain(HANDLE hInstance, WORD wDataSeg, WORD wHeapSize, LPSTR lpszCmdLine)
{
	//if (wHeapSize > 0)
        //   UnlockDate (0);    //Unlocks the data segment of the library.
		globalhInstance = (HINSTANCE)hInstance;
//BEEP(500,500); //debug
        return 1;
}




//int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])

{
HWND       hwnd;
MSG        msg;
WNDCLASSEX wndclass;
int nfields, field_num, elem_num, FieldIndex;
char FieldName[10];
mxClassID ClassID;

wndclass.cbSize        = sizeof (wndclass);
wndclass.style         = CS_HREDRAW | CS_VREDRAW;
wndclass.lpfnWndProc   = WndProc;
wndclass.cbClsExtra    = 0;
wndclass.cbWndExtra    = 0;
wndclass.hInstance     = globalhInstance;
wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION);
wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW);
wndclass.hbrBackground = (HBRUSH) GetStockObject (WHITE_BRUSH);
wndclass.lpszMenuName  = NULL;
wndclass.lpszClassName = szAppName;
wndclass.hIconSm       = LoadIcon (NULL, IDI_APPLICATION);
RegisterClassEx (&wndclass);

hwnd = CreateWindow (szAppName, "ZEMAX Client", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, globalhInstance, NULL);
UpdateWindow (hwnd);

// Check the number of arguments. There must be one lhs and one or two rhs.
if (nrhs < 1)
	mexErrMsgTxt("One input DDERaydata struct is required.");

if (nrhs > 2)
	mexErrMsgTxt("Too many input arguments. Type help zArrayTrace");

if (nlhs > 1)
	mexErrMsgTxt("Too many output arguments.");

if (nrhs == 2) // There is a timeout argument as well ?
	{
	if (mxIsNumeric(prhs[1]))
		switch (mxGetClassID(prhs[1])) // We cater for all numeric classes you know
			{
			case mxDOUBLE_CLASS : DDE_Timeout = (unsigned int)*mxGetPr(prhs[1]); break;
			case mxSINGLE_CLASS : DDE_Timeout = (unsigned int)*(float *)mxGetData(prhs[1]); break;
			case mxINT8_CLASS   : DDE_Timeout = (unsigned int)*(char *)mxGetData(prhs[1]); break;
			case mxUINT8_CLASS  : DDE_Timeout = (unsigned int)*(unsigned char *)mxGetData(prhs[1]); break;
			case mxINT16_CLASS  : DDE_Timeout = (unsigned int)*(short *)mxGetData(prhs[1]); break;
			case mxUINT16_CLASS : DDE_Timeout = (unsigned int)*(unsigned short *)mxGetData(prhs[1]); break;
			case mxINT32_CLASS  : DDE_Timeout = (unsigned int)*(int *)mxGetData(prhs[1]); break;
			case mxUINT32_CLASS : DDE_Timeout = *(unsigned int *)mxGetData(prhs[1]); break;
			}
	else
		{
		mexPrintf("Second argument must be numeric timeout in milliseconds - default assumed.");
		DDE_Timeout = DDE_TIMEOUT;
		}
	}
else 
	DDE_Timeout = DDE_TIMEOUT; // Use the default defined above


// Set a global pointer to the rhs that we can pick up later if need be
gprhs = prhs[0];

gplhs = plhs[0];



// Set a global pointer to the lhs that we can pick up later.
gplhs = plhs[0];

if (!mxIsStruct(gprhs))
    mexErrMsgTxt("Input must be a structure.");

// Get the number of fields in the struct
nfields = mxGetNumberOfFields(gprhs); 
// mexPrintf("Fields : %i\n", nfields); //debug

nelems  = mxGetNumberOfElements(gprhs); 
// mexPrintf("Elements : %i\n", nelems); //debug

// It turns out to be wise to check that the user has correctly specified the 


// Here we insert the Matlab struct data into the global raydata struct array MyRayData

// Firstly we must establish how much memory is required and allocate the memory for the ray data.
// Mode 5 requires a whole lot of memory for a single ray, this is the most difficult case.
// So find out if the user want mode 5.

dval = mxGetField(gprhs, 0, "opd"); /* Get the opd field from the first element */
if (dval == NULL) mode = 0;
else mode = myGetInt(dval);
if (mode > 5) // This is mode 5
	{
	// nelems = mode - 4; // Not sure this is correct
	numrays = mode - 5;
	mode = 5;
	mexPrintf("Mode 5 ... \n"); //debug
	}
else
	{
	dval = mxGetField(gprhs, 0 , "error"); //This is supposedly the number of rays - has the user screwed up or not
	if (dval != NULL)
		{
		numrays = myGetInt(dval);
	    if ((nelems-1) != numrays)
			{
			mexPrintf("Field \"error\" set to %i does not correspond with array size of %i.\n", numrays, nelems);
			mexErrMsgTxt("Aborted.");
			}
		}
	else // The user did not even set the error field.
		{
		mexPrintf("The \"error\" field was not set. Should be set to the number of rays.\n");
		mexErrMsgTxt("Aborted.");
		}	
	}


// Allocate the memory using the Matlab routine.
MyRayData = (DDERAYDATA *)mxCalloc(numrays+1, sizeof(DDERAYDATA));

if (MyRayData == NULL) mexErrMsgTxt("Unable to allocate memory for the DDERAYDATA structure.");

// mexPrintf("Got to after mxCalloc\n"); //debug

// Now copy the Matlab struct array into the MyRayData struct array.
// mxCalloc zeroes out the memory, so it should be OK to just insert the fields that do have values
for (field_num=0; field_num<nfields; field_num++) // Run through the fields in the struct and prepare to put into MyRayData
	{
	strcpy(FieldName, mxGetFieldNameByNumber(gprhs, field_num));
	// mexPrintf("%s\n", FieldName); //debug
	FieldIndex = 0;
	if      (strcmp("x",			FieldName)==0) FieldIndex = 1;
	else if (strcmp("y",			FieldName)==0) FieldIndex = 2;
	else if (strcmp("z",			FieldName)==0) FieldIndex = 3;
	else if (strcmp("l",			FieldName)==0) FieldIndex = 4;
	else if (strcmp("m",			FieldName)==0) FieldIndex = 5;
	else if (strcmp("n",			FieldName)==0) FieldIndex = 6;
	else if (strcmp("opd",			FieldName)==0) FieldIndex = 7;
	else if (strcmp("intensity",	FieldName)==0) FieldIndex = 8;
	else if (strcmp("Exr",			FieldName)==0) FieldIndex = 9;
	else if (strcmp("Exi",			FieldName)==0) FieldIndex = 10;
	else if (strcmp("Eyr",			FieldName)==0) FieldIndex = 11;
	else if (strcmp("Eyi",			FieldName)==0) FieldIndex = 12;
	else if (strcmp("Ezr",			FieldName)==0) FieldIndex = 13;
	else if (strcmp("Ezi",			FieldName)==0) FieldIndex = 14;
	else if (strcmp("wave",			FieldName)==0) FieldIndex = 15;
	else if (strcmp("error",		FieldName)==0) FieldIndex = 16;
	else if (strcmp("vigcode",		FieldName)==0) FieldIndex = 17;
	else if (strcmp("want_opd",		FieldName)==0) FieldIndex = 18;
	else mexPrintf("Warning : Unknown field \"%s\"\n", FieldName);

	for (elem_num=0; elem_num<nelems; elem_num++) // Run through the elements which have values and pop them into MyRayData
		{
		dval = mxGetField(gprhs, elem_num, FieldName);
		if (dval != NULL) // No value here, move on
			{
		    if (mxIsNumeric(dval)) // We will cater for all numeric classes just to be thorough
				{
				ClassID = mxGetClassID(dval);
				switch (ClassID)
				{
				case mxDOUBLE_CLASS : // The data is a double
		            // mexPrintf("%f\n", *mxGetPr(dval)); // debug
				    // sharp end - will have to put in a switch statement for every numeric type - ouch.
					switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*mxGetPr(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*mxGetPr(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*mxGetPr(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*mxGetPr(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*mxGetPr(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*mxGetPr(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*mxGetPr(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*mxGetPr(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*mxGetPr(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*mxGetPr(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*mxGetPr(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*mxGetPr(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*mxGetPr(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*mxGetPr(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*mxGetPr(dval); break;
						} break;
				case mxSINGLE_CLASS : // The data is a single precision float
					 // mexPrintf("%f\n", *(float *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(float *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(float *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(float *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(float *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(float *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(float *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(float *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(float *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(float *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(float *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(float *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(float *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(float *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(float *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*(float *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*(float *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*(float *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*(float *)mxGetPr(dval); break;
						} break;
				case mxINT8_CLASS : // The data is a char
					 // mexPrintf("%i\n", *(char *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(char *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(char *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(char *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(char *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(char *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(char *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(char *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(char *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(char *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(char *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(char *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(char *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(char *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(char *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*(char *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*(char *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*(char *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*(char *)mxGetPr(dval); break;
						} break;
				case mxUINT8_CLASS : // The data is an unsigned char
					 // mexPrintf("%i\n", *(unsigned char *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(unsigned char *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(unsigned char *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(unsigned char *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(unsigned char *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(unsigned char *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(unsigned char *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(unsigned char *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(unsigned char *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(unsigned char *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(unsigned char *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(unsigned char *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(unsigned char *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(unsigned char *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(unsigned char *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*(unsigned char *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*(unsigned char *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*(unsigned char *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*(unsigned char *)mxGetPr(dval); break;
						} break;
				case mxINT16_CLASS : // The data is a short
					 // mexPrintf("%i\n", *(short *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(short *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(short *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(short *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(short *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(short *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(short *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(short *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(short *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(short *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(short *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(short *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(short *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(short *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(short *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*(short *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*(short *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*(short *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*(short *)mxGetPr(dval); break;
						} break;
				case mxUINT16_CLASS : // The data is an unsigned short
					 // mexPrintf("%i\n", *(unsigned short *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(unsigned short *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(unsigned short *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(unsigned short *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(unsigned short *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(unsigned short *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(unsigned short *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(unsigned short *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(unsigned short *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(unsigned short *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(unsigned short *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(unsigned short *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(unsigned short *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(unsigned short *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(unsigned short *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*(unsigned short *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*(unsigned short *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*(unsigned short *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*(unsigned short *)mxGetPr(dval); break;
						} break;
				case mxINT32_CLASS : // The data is a regular int
					 // mexPrintf("%i\n", *(int *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(int *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(int *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(int *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(int *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(int *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(int *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(int *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(int *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(int *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(int *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(int *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(int *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(int *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(int *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= *(int *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= *(int *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= *(int *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= *(int *)mxGetPr(dval); break;
						} break;
				case mxUINT32_CLASS : // The data is an unsigned int
					 // mexPrintf("%i\n", *(unsigned int *)mxGetData(dval)); //debug
					 switch (FieldIndex)
						{
					    case  1: MyRayData[elem_num].x			= (double)*(unsigned int *)mxGetData(dval); break;
						case  2: MyRayData[elem_num].y			= (double)*(unsigned int *)mxGetData(dval); break;
					    case  3: MyRayData[elem_num].z			= (double)*(unsigned int *)mxGetData(dval); break;
						case  4: MyRayData[elem_num].l			= (double)*(unsigned int *)mxGetData(dval); break;					    
						case  5: MyRayData[elem_num].m			= (double)*(unsigned int *)mxGetData(dval); break;
						case  6: MyRayData[elem_num].n			= (double)*(unsigned int *)mxGetData(dval); break;					    
						case  7: MyRayData[elem_num].opd		= (double)*(unsigned int *)mxGetData(dval); break;
						case  8: MyRayData[elem_num].intensity	= (double)*(unsigned int *)mxGetData(dval); break;					    
						case  9: MyRayData[elem_num].Exr		= (double)*(unsigned int *)mxGetData(dval); break;
						case 10: MyRayData[elem_num].Exi		= (double)*(unsigned int *)mxGetData(dval); break;
					    case 11: MyRayData[elem_num].Eyr		= (double)*(unsigned int *)mxGetData(dval); break;
						case 12: MyRayData[elem_num].Eyi		= (double)*(unsigned int *)mxGetData(dval); break;
					    case 13: MyRayData[elem_num].Ezr		= (double)*(unsigned int *)mxGetData(dval); break;
						case 14: MyRayData[elem_num].Ezi		= (double)*(unsigned int *)mxGetData(dval); break;
					    case 15: MyRayData[elem_num].wave		= (int)*(unsigned int *)mxGetPr(dval); break;
						case 16: MyRayData[elem_num].error		= (int)*(unsigned int *)mxGetPr(dval); break;
					    case 17: MyRayData[elem_num].vigcode	= (int)*(unsigned int *)mxGetPr(dval); break;
						case 18: MyRayData[elem_num].want_opd	= (int)*(unsigned int *)mxGetPr(dval); break;
						} break;
				}
				}
		    else if (FieldIndex != 0) // We found a non-numeric value in one of the recognised fields - not kosher
				{
				mexPrintf("Fields named \"%s\" must be numeric.", FieldName);
                mexErrMsgTxt("Aborted");
				}
			}
		}
	}
// OK ready to initiate DDE and stuff, we have the DDERAYDATA ready for business.

// But first, we have to take care of mode 5 subtleties....
if (mode==5) nelems = numrays + 1;
// mexPrintf("Input structure populated.\n"); //debug

SendMessage (hwnd, WM_USER_INITIATE, 0, 0L);

while (GetMessage (&msg, NULL, 0, 0))
	{
    TranslateMessage (&msg);
    DispatchMessage (&msg);
	}
// return msg.wParam; // Presumably this is of no use in a DLL.

// mexPrintf("Creating output array..\n"); //debug
// Create the output array
plhs[0] = mxCreateStructMatrix(1, nelems, NUMFIELDS, FieldNames);
if (plhs[0] == NULL) mexPrintf("Pointer is NULL.\n"); //debug


nlhs = 1; // One output argument

// mexPrintf("About to start populating ouput structure\n"); //debug
// Stuff the results back into a Matlab struct array
for (field_num=0; field_num<NUMFIELDS; field_num++) // Run through the fields in the struct and set the data from the retured array
	{
	strcpy(FieldName, mxGetFieldNameByNumber(plhs[0], field_num)); //debug
	// mexPrintf("Field name %i is \"%s\"\n", field_num, FieldName); //debug
	for (elem_num=0; elem_num<nelems; elem_num++) // Run through the elements
		{
		// dval = mxGetField(gprhs, elem_num, FieldName);
        // if (dval == NULL) mexPrintf("Nothing, sorry\n"); //debug
		switch (field_num)
			{
			case 0 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].x)); break;
			case 1 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].y)); break;
			case 2 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].z)); break;
			case 3 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].l)); break;
			case 4 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].m)); break;
			case 5 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].n)); break;
			case 6 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].opd)); break;
			case 7 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].intensity)); break;
			case 8 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].Exr)); break;
			case 9 : mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].Exi)); break;
			case 10: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].Eyr)); break;
			case 11: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].Eyi)); break;
			case 12: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].Ezr)); break;
			case 13: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar(MyRayData[elem_num].Ezi)); break;
			// The following is a compromise - would have preferred to return int32 values, but could not get that working
			case 14: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar((double)MyRayData[elem_num].wave)); break;
			case 15: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar((double)MyRayData[elem_num].error)); break;
			case 16: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar((double)MyRayData[elem_num].vigcode)); break;
			case 17: mxSetField(plhs[0], elem_num, FieldName, mxCreateDoubleScalar((double)MyRayData[elem_num].want_opd)); break;
			}

		}
	}
// Return the original MyRayData memory to free
// mexPrintf("Returning Memory..\n"); //debug
mxFree(MyRayData);
// BEEP(200,500); //debug

}

LRESULT CALLBACK WndProc (HWND hwnd, UINT iMsg, WPARAM wParam, LPARAM lParam)
{
ATOM          aApp, aTop, aItem;
DDEACK        DdeAck;
DDEDATA      *pDdeData;
GLOBALHANDLE  hDdeData;
WORD          wStatus;
UINT          uiLow, uiHi;

switch (iMsg)
	{
   case WM_CREATE :
		hwndServer = 0;
      return 0;

	case WM_USER_INITIATE :
   	/* find ZEMAX */
	
	// code added September 1, 2006 to identify which ZEMAX is calling us, in case more than 1 copy of ZEMAX is running
	// this currently is only supported by user defined operands.
    // aApp = GlobalAddAtom ("ZEMAX");
		if (1)
			{
			char szSub[500];
			GetString(szCommandLine, 5, szSub);
			if (strcmp(szSub,"ZEMAX1") == 0 || strcmp(szSub,"ZEMAX2") == 0)
				{
				if (strcmp(szSub,"ZEMAX1") == 0)
					{
					aApp = GlobalAddAtom ("ZEMAX1");
					ZEMAX_INSTANCE = 1;
					}
				if (strcmp(szSub,"ZEMAX2") == 0)
					{
					aApp = GlobalAddAtom ("ZEMAX2");
					ZEMAX_INSTANCE = 2;
					}
				}
			else
				{
		      aApp = GlobalAddAtom ("ZEMAX");
				ZEMAX_INSTANCE = 0;
				}
			}
      aTop = GlobalAddAtom ("RayData");
		SendMessage (HWND_BROADCAST, WM_DDE_INITIATE, (WPARAM) hwnd, MAKELONG (aApp, aTop));

		/* delete the atoms */
      GlobalDeleteAtom (aApp);
      GlobalDeleteAtom (aTop);

      /* If no response, terminate */
      if (hwndServer == NULL)
      	{
		 // MessageBox (hwnd, "Cannot Communicate with ZEMAX.", "ZEMAX Inactive", MB_ICONEXCLAMATION | MB_OK);
         DestroyWindow(hwnd);
		 mexErrMsgTxt("Unable to contact ZEMAX. Please ensure ZEMAX is executing.");

         return 0;
         }

		hwndClient = hwnd;

      UserFunction(); /* Here go off and do the DDE calls */

      /* terminate the DDE connection */
   	PostMessage(hwndServer, WM_DDE_TERMINATE, (WPARAM) hwnd, 0L);
      hwndServer = NULL;

      /* now TERMINATE! */
      DestroyWindow(hwnd);
      return 0;

   case WM_DDE_DATA :
   	/* here comes the data! */
      // wParam -- sending window handle
      // lParam -- DDEDATA memory handle & item atom
      UnpackDDElParam(WM_DDE_DATA, lParam, &uiLow, &uiHi);
      FreeDDElParam(WM_DDE_DATA, lParam);
	  hDdeData  = (GLOBALHANDLE) uiLow;
      pDdeData = (DDEDATA *) GlobalLock (hDdeData);
      aItem     = (ATOM) uiHi;

      // Initialize DdeAck structure
      DdeAck.bAppReturnCode = 0;
      DdeAck.reserved       = 0;
      DdeAck.fBusy          = FALSE;
      DdeAck.fAck           = FALSE;

      // Check for matching format, put the data in the buffer
      if (pDdeData->cfFormat == CF_TEXT)
      	{       
         /* get the data back into RD */
			if (rdpGRD) memcpy(rdpGRD, (DDERAYDATA *) pDdeData->Value, (ngNumRays+1)*sizeof(DDERAYDATA));
			else strcpy(szGlobalBuffer, (char *) pDdeData->Value);
         }

      GotData = 1;
		GlobalDeleteAtom (aItem);

      // Acknowledge if necessary
      if (pDdeData->fAckReq == TRUE)
      	{
         wStatus = *((WORD *) &DdeAck);
         if (!PostMessage ((HWND) wParam, WM_DDE_ACK, (WPARAM) hwnd, PackDDElParam (WM_DDE_ACK, wStatus, aItem)))
         	{
				if (hDdeData)
					{
					GlobalUnlock (hDdeData);
					GlobalFree (hDdeData);
					}
            return 0;
            }
         }

      // Clean up
		GlobalUnlock (hDdeData);
      if (pDdeData->fRelease == TRUE || DdeAck.fAck == FALSE) GlobalFree (hDdeData);
      return 0;

   case WM_DDE_ACK:
   	/* we are receiving an acknowledgement */
      /* the only one we care about is in response to the WM_DDE_INITIATE; otherwise free just the memory */
      if (hwndServer == NULL)
      	{
			uiLow = (UINT) NULL;
			uiHi = (UINT) NULL;
         UnpackDDElParam(WM_DDE_ACK, lParam, &uiLow, &uiHi);
         FreeDDElParam(WM_DDE_ACK, lParam);
         hwndServer = (HWND) wParam;
         if (uiLow) GlobalDeleteAtom((ATOM) uiLow);
         if (uiHi) GlobalDeleteAtom((ATOM) uiHi);
         }
		else
			{
			HWND dummy;
			uiLow = (UINT) NULL;
			uiHi = (UINT) NULL;
         UnpackDDElParam(WM_DDE_ACK, lParam, &uiLow, &uiHi);
         FreeDDElParam(WM_DDE_ACK, lParam);
         dummy = (HWND) wParam;
         if (uiLow) GlobalDeleteAtom((ATOM) uiLow);
         if (uiHi) GlobalDeleteAtom((ATOM) uiHi);
			}
   	return 0;

   case WM_DDE_TERMINATE :
   	PostMessage(hwndServer, WM_DDE_TERMINATE, (WPARAM) hwnd, 0L);
      hwndServer = NULL;
      return 0;

   case WM_PAINT :
   	{
      PAINTSTRUCT ps;
   	BeginPaint(hwnd, &ps);
      EndPaint(hwnd, &ps);
      }
      return 0;

   case WM_CLOSE :
   	PostMessage(hwndServer, WM_DDE_TERMINATE, (WPARAM) hwnd, 0L);
   	break;             // for default processing

   case WM_DESTROY :
   	PostQuitMessage(0);
      return 0;
   }
   return DefWindowProc(hwnd, iMsg, wParam, lParam);
}

void WaitForData(HWND hwnd)
{
int sleep_count;
MSG msg;
DWORD dwTime;
dwTime = GetCurrentTime();
// don't do this here, wait until just prior to PostMessage
//GotData = 0;
sleep_count = 0;
#if(0)
while ( (GetCurrentTime() - dwTime < DDE_Timeout) && !GotData)
	{
   while (PeekMessage (&msg, hwnd, WM_DDE_FIRST, WM_DDE_LAST, PM_REMOVE))
   	{
      DispatchMessage (&msg);
      }
   /* Give the server a chance to respond */
   Sleep(0);
   }
#else

while (!GotData)
	{
   while (PeekMessage (&msg, hwnd, WM_DDE_FIRST, WM_DDE_LAST, PM_REMOVE))
   	{
      DispatchMessage (&msg);
      }
   /* Give the server a chance to respond */
   Sleep(0);
   sleep_count++;
   if (sleep_count > 10000)
   	{
      if (GetCurrentTime() - dwTime > DDE_Timeout) 
		{
		// The command has timed out
		mexErrMsgTxt("Command has timed out.\n");
		}
      sleep_count = 0;
      }
   }

#endif
}

char * GetString(char *szBuffer, int n, char *szSubString)
{
int i, j, k;
char szTest[5000];

szSubString[0] = '\0';
i = 0;
j = 0;
k = 0;
while (szBuffer[i] && (k <= n) )
	{
   szTest[j] = szBuffer[i];

   if (szBuffer[i] == '"')
   	{

      i++;
      j++;
      szTest[j] = szBuffer[i];

      /* we have a double quote; keep reading until EOF or another double quote */
      while(szBuffer[i] != '"' && szBuffer[i])
      	{
	      i++;
   	   j++;
		   szTest[j] = szBuffer[i];
         }
      }

   if (szTest[j] == ' ' || szTest[j] == '\n' || szTest[j] == '\r' || szTest[j] == '\0' || szTest[j] == ',')
   	{
      szTest[j] = '\0';
      if (k == n)
      	{
         strcpy(szSubString, szTest);
			return szSubString;
         }
      k++;
      j = -1;
      }
   i++;
   j++;
   }

szTest[j] = '\0';
if (k == n) strcpy(szSubString, szTest);

return szSubString;
}

int PostRequestMessage(char *szItem, char *szBuffer)
{
ATOM aItem;

aItem = GlobalAddAtom(szItem);

/* clear the buffers */
szGlobalBuffer[0] = '\0';
szBuffer[0] = '\0';

GotData = 0; // Inserted for zclient Version 2.2

if (!PostMessage(hwndServer, WM_DDE_REQUEST, (WPARAM) hwndClient, PackDDElParam(WM_DDE_REQUEST, CF_TEXT, aItem)))
	{
   // MessageBox (hwndClient, "Cannot communicate with ZEMAX", "ZEMAX Inactive", MB_ICONEXCLAMATION | MB_OK);
   
   GlobalDeleteAtom(aItem);
   mexErrMsgTxt("Cannot communicate with ZEMAX. Please ensure ZEMAX is running.\n");
   }

WaitForData(hwndClient);
strcpy(szBuffer, szGlobalBuffer);

if (GotData) return 0;
else return -1;
}

int PostArrayTraceMessage(char *szBuffer, DDERAYDATA *RD)
{
ATOM aItem;
HGLOBAL hPokeData;
DDEPOKE * lpPokeData;
long numbytes;
int numrays;


if (RD[0].opd > 4)
	{
	/* NSC Rays */
	numrays = (int)RD[0].opd - 5;
	}
else
	{
	/* sequential rays */
	numrays = RD[0].error;
	}

/* point to where the data is */
rdpGRD = RD;
ngNumRays = numrays;

// mexPrintf("numbytes = (1+numrays)*sizeof(DDERAYDATA);\n"); //debug
numbytes = (1+numrays)*sizeof(DDERAYDATA);

// mexPrintf("hPokeData = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, (LONG) sizeof(DDEPOKE) + numbytes);\n"); //debug
hPokeData = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, (LONG) sizeof(DDEPOKE) + numbytes);

if (hPokeData == NULL) mexErrMsgTxt("Unable to allocate Global Memory for DDE.");

// mexPrintf("lpPokeData = (DDEPOKE *) GlobalLock(hPokeData);\n"); //debug
lpPokeData = (DDEPOKE *) GlobalLock(hPokeData);

lpPokeData->fRelease = TRUE;

lpPokeData->cfFormat = CF_TEXT;

memcpy(lpPokeData->Value, RD, numbytes);

/* clear the buffers */
szGlobalBuffer[0] = '\0';
szBuffer[0] = '\0';

aItem = GlobalAddAtom("RayArrayData");
GlobalUnlock(hPokeData);

GotData = 0; // Added in zclient Version 2.2

// mexPrintf("Just Before the big DDE poke post.\n"); //debug

if (!PostMessage(hwndServer, WM_DDE_POKE, (WPARAM) hwndClient, PackDDElParam(WM_DDE_POKE, (UINT) hPokeData, aItem)))
	{
    // MessageBox (hwndClient, "Cannot communicate with ZEMAX!", "Hello?", MB_ICONEXCLAMATION | MB_OK);
    GlobalDeleteAtom(aItem);
    GlobalFree(hPokeData);
    mexErrMsgTxt("Cannot communicate with ZEMAX. Please ensure ZEMAX is running.\n");
	}
GlobalDeleteAtom(aItem);

// mexPrintf("Just after the big poke.\n"); //debug

WaitForData(hwndClient);
strcpy(szBuffer, szGlobalBuffer);

/* clear the pointer */
rdpGRD = NULL;

if (GotData) return 0;
else return -1;
}

void MakeEmptyWindow(int text, char *szAppName, char *szOptions)
{
char szOutputFile[260], szModuleName[260], szBuffer[5000];
FILE *output;

/* get the output file name */
GetString(szCommandLine, 2, szOutputFile);

/* get the module name */
GetModuleFileName(globalhInstance, szModuleName, 255);

if ((output = fopen(szOutputFile, "wt")) == NULL)
	{
   /* can't open the file!! */
   return;
   }

if (text)
	{
   fputs("System is invalid, cannot compute data.\n",output);
   fclose(output);
	/* create a text window. Note we pass back the filename, module name, and activesurf as a single setting parameter. */
   sprintf(szBuffer,"MakeTextWindow,\"%s\",\"%s\",\"%s\",%s", szOutputFile, szModuleName, szAppName, szOptions);
   PostRequestMessage(szBuffer, szBuffer);
   }
else
	{
   fputs("NOFRAME\n",output);
   fputs("TEXT \"System is invalid, cannot compute data.\" .1 .5\n",output);
   fclose(output);
   sprintf(szBuffer,"MakeGraphicWindow,\"%s\",\"%s\",\"%s\",1,%s", szOutputFile, szModuleName, szAppName, szOptions);
   PostRequestMessage(szBuffer, szBuffer);
   }
}

void CenterWindow(HWND hwnd)
{
RECT rect;
int newx, newy;
GetWindowRect(hwnd, &rect);
newx = (GetSystemMetrics(SM_CXSCREEN) - (rect.right  - rect.left))/2;
newy = (GetSystemMetrics(SM_CYSCREEN) - (rect.bottom -  rect.top))/2;
SetWindowPos(hwnd, HWND_TOP, newx, newy, 0, 0, SWP_NOSIZE);
}

void Get_2_5_10(double cmax, double *cscale)
{
int i;
double temp;
if (cmax <= 0)
	{
	*cscale = .00001;
	return;
	}
*cscale = log10(cmax);
i = 0;
for (; *cscale < 0; i--) *cscale = *cscale + 1;
for (; *cscale > 1; i++) *cscale = *cscale - 1;
temp = 10;
if (*cscale < log10(5.0)) temp = 5;
if (*cscale < log10(2.0)) temp = 2;
*cscale = temp * pow(10, (double) i );
}

void remove_quotes(char *s)
{
int i=0;
/* remove the first quote if it exists */
if (s[0] == '"')
	{
	while (s[i])
		{
		s[i] = s[i+1];
		i++;
		}
	}
/* remove the last quote if it exists */
if (strlen(s) > 0)
	{
	if (s[strlen(s)-1] == '"') s[strlen(s)-1] = '\0';
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Here comes the UserFunction                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void UserFunction(void)
{

static char szBuffer[5000], szSub[256], szAppName[] = "Bulk Raytrace";

/* Now go and do the bulk raytracing */
// mexPrintf("About to post ray data.\n"); //debug
PostArrayTraceMessage(szBuffer, MyRayData);

// mexPrintf("Ray Data posted.\n"); //debug

}


// Returns an int from a Matlab mxArray numeric scalar
int myGetInt(mxArray *ScalarNumeric)
{
	int i;
	switch (mxGetClassID(ScalarNumeric))
		{
		case mxDOUBLE_CLASS : i = (int)*mxGetPr(ScalarNumeric);						return(i); break;
		case mxSINGLE_CLASS : i = (int)*(float *)mxGetData(ScalarNumeric);			return(i); break;
		case mxINT8_CLASS   : i = (int)*(char *)mxGetData(ScalarNumeric);			return(i); break;
		case mxUINT8_CLASS  : i = (int)*(unsigned char *)mxGetData(ScalarNumeric);	return(i); break;
		case mxINT16_CLASS  : i = (int)*(short *)mxGetData(ScalarNumeric);			return(i); break;
		case mxUINT16_CLASS : i = (int)*(unsigned short *)mxGetData(ScalarNumeric);	return(i); break;
		case mxINT32_CLASS  : i = *(int *)mxGetData(ScalarNumeric);					return(i); break;
		case mxUINT32_CLASS : i = (int)*(unsigned int *)mxGetData(ScalarNumeric);	return(i); break;
		}
	return(0);
}
