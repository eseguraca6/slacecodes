

Choose a suitable location to save and extract the archive ("Extract to
here"). A sub-directory called MZDDE will be created with all the files.

Add the directory MZDDE to your Matlab path.

Type "help MZDDE" at the Matlab prompt to get the function summaries.

Otherwise take a look in the Documents sub-directory for a little more
guidance. Some of the information is dated. The most important source of
information is the Zemax manual, the chapter on Zemax Extensions.

Almost all functions starting with small "z" access Zemax via DDE (as well
as functions denoted (Z) in the help file) and you MUST call zDDEInit before
you use any function that accesses Zemax. If you don't call zDDEInit first,
you will crash Matlab on your first call to such a function.
The Zemax DDE Toolbox for MATLAB

 You can save yourself some effort by downloading the Zemax DDE toolbox. This toolbox is open source under the GPL and implements a MATLAB function for each of the data items documented in the Zemax manual in the chapter on Zemax Extensions. The corresponding MATLAB function in the toolbox has the same name as the data item, but prefixed with "z". To get started, perform the following steps. 1.Download the toolbox archive (.zip file).
2.Unzip the archive to a sub-directory called MZDDE anywhere on your local disk.
3.Start Zemax and MATLAB.
4.Add the directory MZDDE to your MATLAB path to enable MATLAB to find the new functions (go to the File menu and select Set Path ...)
5.If you type help mzdde at the MATLAB prompt, you should get a list of all the functions in the toolbox and a short description of each function. If so, you are ready to use the toolbox.
6.Use the function zDDEInit to open the DDE link to Zemax. This step is important. If you don't do this before trying to execute other calls in the toolbox, MATLAB will issue a verbose error message suggesting that something terrible has happened and that you should contact the MathWorks technical support staff. If this happens, just ignore the error and make the call to zDDEInit.
7.Call other functions in the toolbox as required, making judicious use of zPushLens and zGetRefresh if you need to interact with the Zemax user interface. Of course, you can call the functions from the MATLAB command line, or incorporate them into your MATLAB functions and scripts.
8.Finish off by calling zDDEClose. This is not important in most cases, and you can just terminate MATLAB and Zemax without closing the DDE link.

Note that the toolbox function names are capitalized for readability. MATLAB function names are case insensitive under Windows?, so that zddeinit is equivalent to zDDEInit. This is convenient at the MATLAB command line, but the capitalization helps for readability in functions and scripts. The source code for all of the functions is available for modification and reuse, and you can examine the source to see how the basic MATLAB DDE calls are used.
