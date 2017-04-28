#!/bin/bash
# ---------------------------------------------------
#sharpe ratio

#! /bin/bash
awk  -F\, '$1>=20160107 && $1<=20160118 {count++; sum+=($5-$6); ssq+=($5-$6)**2} END {sr=(sum/count)/sqrt((ssq/count)-((sum/count)**2)); print sr}' trade.csv

# ---------------------------------------------------

# write output to file
#ls -l > ls-l.txt

# ---------------------------------------------------

# write output to file (sepcify in cmd tool)
# Nikitas-Mac-Pro:Bash testing Nikita$ bash test_bash_awk.sh > output.txt

# ---------------------------------------------------

echo "hello world"
echo "test again"

# ---------------------------------------------------

# variables start with $(. so $(...)
echo $(date +%m_%d_%y-%H.%M.%S)

# ---------------------------------------------------

date_var=$(date +%m_%d_%y-%H.%M.%S)
echo "Current time: " $date_var

# backup file
file_name=test_file.txt
#tar -cZf $file_name.$date_var.tgz $file_name


# ---------------------------------------------------

# run exe
# python test.py

python test.py

# ---------------------------------------------------

# local variables
HELLO=Hello 
function hello {
    local HELLO=World
    echo $HELLO
}
echo $HELLO
hello
echo $HELLO

# ---------------------------------------------------
# if then
T1="foo"
T2="bar"
if [ "$T1" = "$T2" ]; then
    echo true
else
     echo false
fi	


# ---------------------------------------------------
# for loop 

for i in `seq 1 10`;
do
    echo $i
done    


# while loop. gt = greater than, lt = less than
COUNTER=0
while [  $COUNTER -lt 10 ]; do
    echo The counter is $COUNTER
    let COUNTER=COUNTER+1 
done


echo "Functions ---------------------------------------------------"

read_out_hello(){
    echo "Hello there" $1 " and " $2
}

read_out_hello "Nikita" "Lilian"


echo "Piping ---------------------------------------------------"
# Pipes let you use the output of a program as the input of another one

# something wrong fix later!!!!!!!
#echo "person1" "person2" |read_out_hello

echo "Math ---------------------------------------------------"

echo 1+1
echo $[3/4]
echo $((3+4))

echo "awk gawk ---------------------------------------------------"
# -F: means what field seperator to use. here it's :

# test file contains Hello:my:name:is:Alaa
#prints the fourth so "is" form tet file
awk -F\, '{print $4}' test_file.txt

#prints from test var
test_var="Hello:my:name:is:Alaa"
echo $test_var | awk -F: '{print $3}'

#print whole file
awk -F\, '{print;}' trade.csv

#awk '/search pattern1/ {Actions}
#     /search pattern2/ {Actions}' file

echo "awk $1 > 20160118 example --------------------"
#print all days greater than 20160118. first column.
awk -F\, '$1 > 20160118 {print;}' trade.csv

echo "awk 20160118 example --------------------"
awk -F\, '/20160118/ {print;}' trade.csv

echo "awk $NF last field example --------------------"
awk -F\, '{print $1 $6;}' trade.csv
awk -F\, '{print $1 $NF;}' trade.csv

echo "awk BEGIN and END example --------------------"

#Notes
#BEGIN { Actions}
#{ACTION} # Action for everyline in a file
#END { Actions }

awk -F\, 'BEGIN {print "Extract of table below\tCheck the table";}
/20160118/ {print;} 
/20160119/ {print;}
END {print "The check has completed\tCheck again\n------";}' trade.csv

echo "awk if column (double spaces) matches string example --------------------"
#check if column matches string
awk '$4 == "Technology" {print;}' employee.txt

echo "awk count number employees technology example --------------------"
#check if column matches string
awk '$4 == "Technology" {count++;} END {print count;}' employee.txt






