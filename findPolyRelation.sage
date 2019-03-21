import subprocess;

prevIOrelationFirstLine = ""
currentIOrelationFirstLine = ""
def appendResults(data,type):
    with open('IOrelations.txt') as fpr:
        #check if results are same as last round, i,e,. no poly relation found
        global prevIOrelationFirstLine
        currentIOrelationFirstLine = fpr.readline()
        print("prev: "+prevIOrelationFirstLine)
        print("curr: "+currentIOrelationFirstLine)
        if currentIOrelationFirstLine == prevIOrelationFirstLine:
            print("\nNo relation")
            return
        prevIOrelationFirstLine = currentIOrelationFirstLine
        fpr.seek(0) #set fpr pointer back to start of file

        print("\nResults new - appending to results\n")
        #save each results
        res = []
        for line in fpr:
            res.append(line)


    #make title string
    print(data)
    if type == "ScalarMult":
        title = "\nResults for Scalar multiplication on curve: a,b,p: "+str(data[0][0])+","+str(data[0][1]) \
         +","+str(data[0][2])+" u,v,w: "+str(data[1])+","+str(data[2])+","+str(data[3])+"\n"
    elif type == "Isogeny":
        title = "\nResults for Isogency on curve: a,b,p: "+str(data[0][0])+","+str(data[0][1]) \
         +","+str(data[0][2])+" point X,Y: "+str(data[1][0])+","+str(data[1][1])+" u,v: "+str(data[2]) \
         +","+str(data[3])+"\n"

    with open('results.txt','a') as fpw:
        fpw.write(title)
        for line in res:
            fpw.write(line)

def makeCurve(curve):
    a,b,p = curve
    #catch errors for inputs that dont form curves
    try:
        E = EllipticCurve(GF(p),[a,b])
    except (ArithmeticError, ValueError) as e:
        print("Invalid parameters:",e)
        return False
    return E

#data = {[a,b,p],u,v,w,numECCcodeEntries}
def genECCCodeScalarMult(data):
    a,b,p = data[0]
    u,v,w = data[1],data[2],data[3]
    #catch errors for inputs that dont form curves
    E = makeCurve(data[0])
    if not (E):
        return False
    # generate ECC code
    o = open('ECCcode.txt','w')
    for i in range(0,data[4]):
        G = E.random_element()
        o.write(str(G[0])+","+str((u*G)[0])+","+str((v*G)[0])+","+str((w*G)[0])+"\n")

    return True

#data = {[a,b,p],[x,y],u,v,numECCcodeEntries}
def genECCCodeIsogency(data):
    a,b,p = data[0]
    point = data[1]
    u,v = data[2], data[3]
    #catch errors for inputs that dont form curves
    E = makeCurve(data[0])
    if not (E):
        return False
    #catch errors for inputs that dont form isogencys
    try:
        phi = E.isogeny(E(point))
    except TypeError:
        print("Invalid parameters.")
        return False

    #generate ECC code
    o = open('ECCcode.txt','w')
    for i in range(0,data[4]):
        G = E.random_element()
        o.write(str(G[0])+","+str((u*G)[0])+","+str((phi(G))[0])+","+str((v*phi(G))[0])+"\n")

    return True

def findPolyRealations(data,type):
    if (type == 'ScalarMult'):
        #back out of funciton if genECCCodeScalarMult returns false
        if not genECCCodeScalarMult(data):
            return
    elif (type == 'Isogeny'):
        #back out of funciton if genECCCodeIso returns false
        if not genECCCodeIsogency(data):
            return
    else:
        print("ERROR: Invalid type.")
        return

    print("\nECCCode updated, calling ax64\n")
    # call ax64
    subprocess.call("wine ax64.exe 939111 1 2 2 2 1153 ECCcode.txt",shell=True)

    #append reuslts to results.txt
    appendResults(data,type)

#clear IOrelations.txt at the beginning
fp = open('IOrelations.txt','w')
fp.write("")
fp.close()

for a in range (8983,9000):
    data = [0,a,next_prime(299)],27181,26687,6672,100
    print("------------------------------------------------")
    print("START")
    print("\nNew data:")
    print(data)
    findPolyRealations(data,"ScalarMult")
    print("END")
    print("------------------------------------------------")