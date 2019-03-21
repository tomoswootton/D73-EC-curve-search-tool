import GenECCCode
import subprocess;




line = ""
def checkNewResults():
    #check if IOrelations.txt has changed since prev round
    fp = open('IOrelations.txt', 'r')
    line = fp.nextLine()
# generate ECCcode file
# genECCCodeScalarMult([0,7,71389],27181,26687,0,100)
#works
# genECCCodeScalarMult(0,7,71389,27181,26687,100)


for a in range (3,4):
    print(a)
    GenECCCode.genECCCodeIsogency([a,11,179],[152,37],17,25,100)
    subprocess.call("wine ax64.exe 939111 1 2 2 2 1153 ECCcode.txt",shell=True)
    appendResults()
    # CheckNewResults()
