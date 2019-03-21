import subprocess;

def appendResults(data,type):
    #TODO check results are new
    with open('IOrelations.txt') as fpr:
        #save each results
        res = []
        for line in fpr:
            res.append(line)


    #make title string
    print(data)
    if (type == "ScalarMult"):
        title = "\nResults for curve: a,b,p: "+str(data[0][0])+","+str(data[0][1]) \
         +","+str(data[0][2])+" u,v,w: "+str(data[1])+","+str(data[2])+","+str(data[3])+"\n"
    elif (type == "Isogeny"):
        title = "\nResults for curve: a,b,p: "+str(data[0][0])+","+str(data[0][1]) \
         +","+str(data[0][2])+" point X,Y: "+str(data[1][0])+","+str(data[1][1])+" u,v: "+str(data[2]) \
         +","+str(data[3])+"\n"

    with open('results.txt','a') as fpw:
        fpw.write(title)
        for line in res:
            fpw.write(line)

def findPolyRealations(data,type):
    print("ECCCode updated, calling ax64")
    # call ax64
    subprocess.call("wine ax64.exe 939111 1 2 2 2 1153 ECCcode.txt",shell=True)

    print("appending results")
    #append reuslts to results.txt
    appendResults(data,type)

def genECCCodeScalarMult(curve,u,v,w,numEntries):
    a,b,p = curve
    E = EllipticCurve(FiniteField(p),[a,b])
    # generate ECC code
    o = open('ECCcode.txt','w')
    for i in range(0,numEntries):
        G = E.random_element()
        o.write(str(G[0])+","+str((u*G)[0])+","+str((v*G)[0])+","+str((w*G)[0])+"\n")

def genECCCodeIsogency(curve,point,u,v,numEntries):
    a,b,p = curve
    E = EllipticCurve(GF(p),[a,b])
    phi = E.isogeny(E(point))
    #generate ECC code
    o = open('ECCcode.txt','w')
    for i in range(0,numEntries):
        G = E.random_element()
        o.write(str(G[0])+","+str((u*G)[0])+","+str((phi(G))[0])+","+str((v*phi(G))[0])+"\n")


data = [3,11,179],[152,37],17,25,100
# genECCCodeScalarMult([0,7,71389],27181,26687,0,100)
genECCCodeIsogency([3,11,179],[152,37],17,25,100)
findPolyRealations(data,"Isogeny")
# subprocess.call("wine ax64.exe 939111 1 2 2 2 1153 ECCcode.txt",shell=True)
# findPolyRelationScalarMult([0,7,71389],27181,26687,0,100)

# findPolyRealationsIsogency([3,11,179],[152,37],17,25,100)
