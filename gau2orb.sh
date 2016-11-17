FILES=`ls | grep log`
awk 'BEGIN {printf("%-20s %12s %12s\n", "Filename", "HOMO", "LUMO")}'
for file in $FILES
do
        OCCENER=`grep "Alpha  occ. eigenvalues --"  $file | tail -n 1 | awk '{print($NF)}'` #string from log with occupied orbital energy to energy value
        VIRTENER=`grep "Alpha virt. eigenvalues --"  $file | head -n 1 | awk '{print($5)}'` #string from log with virt orbital energy to energy value
        awk 'BEGIN {printf("%-20s %12s %12s\n", "'$file'", "'$OCCENER'", "'$VIRTENER'")}'
done

