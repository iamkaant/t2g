shopt -s globstar #turn on search via **
FILES=`find */* -name "*.xyz" | grep -v tmp`
for file in $FILES
do
        echo -e "\n$file\n"
        lastcoord=`grep -n Energy $file | tail -n 1 | awk '{match($0,":"); print(substr($0,1,RSTART-1))}'` #finding position of last coord block in xyz
        awk '(match(FILENAME,".xyz")) && NR > '$lastcoord' {printf("%-5s %12s %12s %12s\n", $1, $2, $3, $4)}' $file #printing coords without other junk
done
