This tool is for automatically generating EECCode, inputting it into ax64 and storing the results. The intention is for us to be able to automatically process a large number of curves, parameter, isogeny point combinations (Perhaps on the UCL's servers).

Currenlty scalar multiplaction and isogeny ECCCode generators are implemented.

Output polynomial relations are saved to results.txt only if a relation is found. The next question is how to process the data to automatically identify nice relations, ideas welcome.

GitHub: https://github.com/tomoswootton/D73-EC-curve-search-tool

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
DEPENDENCIES:

This program requires Pyton ^2.7, Sage and Wine (Linux)
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
USAGE:

run and edit file main.sage

findPolyRealations(data,type)
	Takes two arguments for the different operations:
	for
		type = 'ScalarMult', data = [a,b,p],u,v,w,num
		type = 'Isogeny', data = [a,b,p],[X,Y],u,v,num
	where num is the number of rows desired in ECCCode.txt


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
EXAMPLES:

The following code will run ax64 curves with 30 different u values 0-30. Results can be viewed in results.txt.

Example code:

for u in range(0,30):
    data = [3,11,179],[152,37],u,25,100
    print("------------------------------------------------")
    print("START")
    print("\nNew data:")
    print(data)
    findPolyRealations(data,"Isogeny")
    print("END")
    print("------------------------------------------------")

An example for "ScalarMult" which finds another one of the relations in the spreadsheet.


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
DOCUMENTATION:

This section is a brief explanation of what each function does for anyone interested in improving/fixing the tool.

findPolyRealations(data,type)
	Is the main function for each round. It directs the program to the ECC Code generator functions, calls ax64 and calls the append results function.

genECCCodeScalarMult(data), genECCCodeIsogency(data)
	Generate the ECCCode.txt files each round. They generate random G values and write a list of tuples to the file, while making sure to catch type errors for invalid parameters

makeCurve(data)
	Is its own function just to simplify error catching while generating curves

appendResults(data,type)
	checks for relation data in IOrelation.txt and returns if file is empty. Else it appends the relation data into results.txt along with some information about the curve and parameters that the relation belongs to.
