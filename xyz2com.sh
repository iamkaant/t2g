FILES=`ls | grep xyz`
#Setting env. in script for G09
echo -e  "g09root=/opt/g09\nUSER=\`whoami\`\nGAUSS_SCRDIR=/scr/\$USER\n. $g09root/g09/bsd/g09.profile\nexport PATH=$g09root:\$GAUSS_SCRDIR:\$PATH\nexport CURRDIR=\`pwd\`\n" > gauss-batch.sh
echo -e "JOBS=\"\c" >> gauss-batch.sh
COUNT=1 #Variable for proper line numbers in JOBS variable in G09 script
for file in $FILES
do
        if [ "$COUNT" != 1 ] #if it's not the first entry in G09 script, adding new line
        then echo -e -n "\n"  >> gauss-batch.sh
        fi
        filename=`awk 'NR == 1 {if (match(FILENAME,".xyz")) {print(substr(FILENAME,1,RSTART-1))}}' $file` #deleting extension .xyz
        echo -e "%NProc=16\n%mem=18000MB" > $filename.com #pasting header
        echo "%chk=" $filename >> $filename.com #pasting checkpoint name
        echo -e "#P HF/def2SVP GFInput SCF=Tight Pop=Full\n" >> $filename.com #pasting route section
        echo -e $filename  "\n\n-3 1" >> $filename.com #pasting archive entry name
        lastcoord=`grep -n Energy $file | tail -n 1 | awk '{match($0,":"); print(substr($0,1,RSTART-1))}'` #finding position of last coord block in xyz
        awk '(match(FILENAME,".xyz")) && NR > '$lastcoord' {printf("%-5s %12s %12s %12s\n", $1, $2, $3, $4)}' $file >> $filename.com #pasting coords without other junk
        echo -e "\n" >> $filename.com #must have empty line in .com file
        echo -n $filename  >> gauss-batch.sh #add entry to G09 script without new line
        COUNT=$COUNT+1
done
#Adding necessary commands to G09 batch script
echo -e "\"\nfor JOBID in \$JOBS\ndo\n  mkdir /scr/\$USER/\$JOBID\n     cp \$JOBID.com /scr/\$USER/\$JOBID\n    cd /scr/\$USER/\$JOBID\n        g09 \$JOBID > \$JOBID.log\n     cp \$JOBID.* \$CURRDIR\n        cd \$CURRDIR\n  rm -rf /scr/\$USER/\$JOBID\ndone\n" >> gauss-batch.sh
