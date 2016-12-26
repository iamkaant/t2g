FILES=`find */* -name "*.xyz" | grep -v c | grep -v si`
echo $FILES
for file in $FILES
do
        filepath=/raid/home/roz/AK/P9/Dimer/$file #stating full path to the file
        path=`awk 'NR == 1 {n=split($0,folder,"/"); for (i=2; i < n; i++) {printf("/%s",folder[i])}}' <<< $filepath` #finding directory structure without file name
        filexyz=`awk 'NR == 1 {n=split($0,folder,"/"); printf("%s",folder[n])}' <<< $filepath` #finding file name
        echo $filexyz
        filename=`awk 'NR == 1 {if (match($0,".xyz")) {print(substr($0,1,RSTART-1))}}' <<< $filexyz`  #finding file name without .xyz
        echo $filename
        #echo $path
        cd $path
        x2t *.xyz > coord
        if grep -e "al" -e "b" <<< $file
        then
                charge=-2
        else
                if grep -e "n" -e "p" <<< $file
                then
                        charge=2
                fi
        fi
        echo $charge
        echo -e "\n\na coord\nired\n*\nb all cc-pVTZ\n*\neht\n\n"$charge"\n\n\ncc\nfreeze\n*\ncbas\n*\nmemory 20000\ndenconv 0.1E-7\nricc2\nmp2\nscs\ngeoopt mp2\n*\n*\nscf\nconv\n8\niter\n130\n\n*\n" | define
        cp /raid/home/roz/AK/tmp.sh "$filename".sh
        cp /raid/home/roz/AK/run.sh .
        qsub "$filename".sh
        sleep 5
done
