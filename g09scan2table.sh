awk '{
if (! match($1,"[a-zA-Z]")) {
        i1=$1
        i2=$2
        i3=$3
        i4=$4
        i5=$5
#       print("yes")
#       print(i1,i2,i3,i4) 
}
if (match($1,"Eigenvalues")) {
        energies=$3
        search="-"
        n=split(energies,enarray,search)
#       for (i=1;i<=n;i++) {
#               print(i,enarray[i])}
        energy[i1]=enarray[2]
        energy[i2]=enarray[3]
        energy[i3]=enarray[4]
        energy[i4]=enarray[5]
        energy[i5]=enarray[6]
#        print(i1,i2,i3,i4) 
#       print(energy[i1], " ", energy[i2], " ", energy[i3], " ", energy[i4], " ", energy[i5])
}
if (match($1,"D9")) {
#       print($1)
        d9[i1]=$2
        d9[i2]=$3
        d9[i3]=$4
        d9[i4]=$5
        d9[i5]=$6
#        print(i1,i2,i3,i4) 
#       print(d9[i1],d9[i2],d9[i3],d9[i4],d9[i5])
}
if (match($1,"D15")) {
#       print($1)
        d15[i1]=$2
        d15[i2]=$3
        d15[i3]=$4
        d15[i4]=$5
        d15[i5]=$6
#       print(i1,i2,i3,i4) 
#       print(d15[i1],d15[i2],d15[i3],d15[i4],d15[i5])
}
#print(energy[25])
}
END {
if (i5 == "") {
        if (i4 == "") {
                if (i3 == "") {
                        if (i2 == "") {
                                final_num=i1}
                                else {final_num=i2}}
                        else {final_num=i3}}
                else {final_num=i4}}
        else {final_num=i5}
#print("Final Number = ",final_num)
printf("%4s %12s %12s %s\n", "No", "D9", "D15", "Energy")
for (a=1; a <= final_num; a++) {
#       print(a)
#       print(a , d9[a] , d15[a] , energy[a])
        printf("%4s %12s %12s %s%s\n", a , d9[a] , d15[a] ,"-", energy[a]) 
}
}' 2h-flip-2scan2-data.txt
