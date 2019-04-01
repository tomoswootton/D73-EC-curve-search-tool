This tool provides various tools for D73 project. The intention is for us to be able to automatically process a large number of curves, parameter, isogeny point combinations (Perhaps on the UCL's servers). Output polynomial relations are saved to results.txt only if a relation is found and it passes all filters. 

Currenlty scalar multiplaction and isogeny ECCCode generators are implemented. As well as a filter for results, automatic special scalar finding and a tool to help find interesting isogeny points.



GitHub: https://github.com/tomoswootton/D73-EC-curve-search-tool

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
DEPENDENCIES:

This program requires Pyton ^2.7, Sage and Wine (Linux)
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
USAGE:

run: sage D73Tool.sage

Set filter variables to remove undesired relations
	maxDegree
	maxNumTerms


findPolyRealations(data,type)
	Takes two arguments for the different operations:
	for
		type = 'ScalarMult', data = [a,b,p],u,v,w,num
		type = 'Isogeny', data = [a,b,p],[X,Y],u,v,num
	where num is the number of rows desired in ECCCode.txt


printIsogenyECCcodeSamples(curve,u,v,numEntries)
	prints numEntries ECCcode lines for each isogeny point on the given curve for given u,v. Use to 	find interesting ECCcode generators. (Many isogeny points, u,v combos result in xi3=xi4, or 		xi3,xi4 in (0,1)).


rootToScalar(a,b,p)
	Finds special scalars for given curve 
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
	Finds poly relations for Scalar multiples or Isogenys. It directs the program to the ECC Code generator functions, calls ax64 and calls the append results function.


genECCCodeScalarMult(data), genECCCodeIsogency(data)
	Generate the ECCCode.txt files each round. They generate random G values and write a list of tuples to the file, while making sure to catch type errors for invalid parameters


printIsogenyECCcodeSamples(curve,u,v,numEntries)
	prints numEntries ECCcode lines for each isogeny point on the given curve for given u,v. Use to find interesting ECCcode generators. (Many isogeny points, u,v combos result in xi3=xi4, or xi3,xi4 in (0,1)).

rootToScalar(a,b,p)
	Finds special scalars for given curve 


makeCurve(data)
	Is its own function just to simplify error catching while generating curves


appendResults(data,type)
	checks for relation data in IOrelation.txt and returns if file is empty. Else it appends the relation data into results.txt along with some information about the curve and parameters that the relation belongs to. Also applies filters to results based on variables maxDegree and maxNumTerms. 

