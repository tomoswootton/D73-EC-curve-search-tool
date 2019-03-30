import subprocess

def appendResults(data,type):
    with open('IOrelations.txt') as fpr:
        #check if no poly relation found, dont store in results.txt
        if fpr.readline() == "":
            print("\nNo relation")
            return
        fpr.seek(0) #set fpr pointer back to start of file

        print("\nAppending to results\n")
        #save each results
        res = []
        for line in fpr:
            res.append(line)

    #make title
    if type == "ScalarMult":
        title = "\nResults for Scalar multiplication on curve: a,b,p: "+str(data[0][0])+","+str(data[0][1]) \
        +","+str(data[0][2])+" u,v,w: "+str(data[1])+","+str(data[2])+","+str(data[3])+" relations found after filter:\n"
    elif type == "Isogeny":
        title = "\nResults for Isogency on curve: a,b,p: "+str(data[0][0])+","+str(data[0][1]) \
         +","+str(data[0][2])+" point X,Y: "+str(data[1][0])+","+str(data[1][1])+" u,v: "+str(data[2]) \
         +","+str(data[3])+" relations found after filter:\n"

    with open('results.txt','a') as fpw:
        for line in res:
            if filterResult(line):
                fpw.write(title)
                fpw.write(line)
    fpw.close()

def filterResult(line):
    if (line[-3] != "0"):
        print("BUG: line read error")
        return False
    # remove single term = 0 entries
    if (line.count("+")+line.count("-") == 1):
        return False
    if (line.count("+")+line.count("-") > maxNumTerms):
        return False
    for i in range(1,len(line)):
        if line[i] == "{":
            if int(line[i+1]) > maxDegree:
                return False;
    return True

def makeCurve(curve):
    a,b,p = curve
    #catch errors for inputs that dont form curves
    try:
        E = EllipticCurve(GF(p),[a,b])
    except (ArithmeticError, ValueError) as e:
        print("Invalid curve parameters:",e)
        return False
    return E

#data = {[a,b,p],u,v,w,numECCcodeEntries}
def genECCCodeScalarMult(data):
    try:
        a,b,p = data[0]
        u,v,w = data[1],data[2],data[3]
        #catch errors for inputs that dont form curves
        E = makeCurve(data[0])
        if not (E):
            return False
        # generate ECC code
        o = open('ECCcode.txt','w')
        for i in range(0,data[4]):
            #dont let G=0
            G = E.random_element()
            while(G[0] == 0):
                G = E.random_element()

            o.write(str(G[0])+","+str((u*G)[0])+","+str((v*G)[0])+","+str((w*G)[0])+"\n")
    except (TypeError) as e:
        print("Invalid parameters:",e)
        return False

    return True

def makeIsogeny(data):
    try:
        point = data[1]
        #catch errors for inputs that dont form curves
        E = makeCurve(data[0])
        if not (E):
            return False, False

        #gen isogeny
        phi = E.isogeny(E(point))
        # check 2nd curve isnt the same as 1st
        if (phi.domain() == phi.codomain()):
            print("Isogeny 2nd curve same as 1st")
            return False, False

    except (TypeError) as e:
        print("Invalid parameters:",e)
        return False, False

    return E,phi

#data = {[a,b,p],[x,y],u,v,numECCcodeEntries}
def genECCCodeIsogency(data):
    a,b,p = data[0]
    point = data[1]
    u,v = data[2], data[3]
    E,phi = makeIsogeny(data)
    if not E:
        return False

    #generate ECC code
    o = open('ECCcode.txt','w')
    for i in range(0,data[4]):
        #dont let G=0
        G = E.random_element()
        while(G[0] == 0):
            G = E.random_element()
        o.write(str(G[0])+","+str((u*G)[0])+","+str((phi(G))[0])+","+str((v*(phi(G)[0])))+"\n")

    return True

# creates ECCCode, finds relation, filters and appends results
def findPolyRealationsAX64(data,type):
    if (type == 'ScalarMult'):
        #back out of funciton if genECCCodeScalarMult returns false
        if not genECCCodeScalarMult(data):
            return

    elif (type == 'Isogeny'):
        #back out of function if genECCCodeIso returns false
        if not genECCCodeIsogency(data):
            return

    else:
        print("ERROR: Invalid type.")
        return

    print("\nECCCode updated, calling ax64\n")

    # call ax64
    cmd = "wine ax64.exe 939111 1 2 2 2 " + str(data[0][2]) + " ECCcode.txt"
    subprocess.call(cmd,shell=True)

    #append reuslts to results.txt
    appendResults(data,type)

    #clear IOrelation.txt
    with open('IOrelations.txt','w') as fpw:
        fpw.write("")
    fpw.close()

# code by Arjun and Jay
def findIsogenies(E):
    return [G for phi, G in {(E.isogeny(G), G) for G in E} if phi.domain() != phi.codomain()];

# function prints numEntries ECCcode lines for each isogeny point
# use to find interesting ECCcode generators
def printECCcodeSamples(curve,u,v,numEntries):
    E = makeCurve(curve)
    isos = findIsogenies(E)
    for iso in isos:
        print("point ")
        print(iso)
        genECCCodeIsogency([curve,[iso[0],iso[1]],u,v,numEntries])
        with open('ECCcode.txt','r') as fpw:
            for line in fpw:
                print(line)
        fpw.close()

import random

maxDegree = 3
maxNumTerms = 3

#
# for i in range(1,20):
#     data = [0,7,
#     103], \
#     [33,\
#     93],\
#     random.randint(1,103),\
#     random.randint(1,103),\
#     100
#     print(data)
#     findPolyRealationsAX64(data,"Isogeny")

# for i in range(1,20):
#     data = [0,7,
#     107], \
#     [98,\
#     54],\
#     random.randint(1,103),\
#     random.randint(1,103),\
#     100
#     print(data)
#     findPolyRealationsAX64(data,"Isogeny")


printECCcodeSamples([0,7,103],2,2,5)
