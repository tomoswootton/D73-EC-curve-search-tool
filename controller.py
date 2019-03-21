import GenECCCode


data = [3,11,179],[152,37],17,25,100
# genECCCodeScalarMult([0,7,71389],27181,26687,0,100)
# genECCCodeIsogency(data)
# findPolyRealations(data,"Isogeny")
# subprocess.call("wine ax64.exe 939111 1 2 2 2 1153 ECCcode.txt",shell=True)
# findPolyRelationScalarMult([0,7,71389],27181,26687,0,100)

# findPolyRealationsIsogency([3,11,179],[152,37],17,25,100)



for a in range (3,10):
    data = [a,11,179],[152,37],17,25,100
    findPolyRealations(data,"Isogeny")
