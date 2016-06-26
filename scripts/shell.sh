time cat ../filenames | while read x; do echo "echo -ne \"$x\\t\"; ./midicsv ../allmid/$x | grep Note_ | sort -nk2 | sed 's/, /\t/g' | ./list2.py | tail -1"; done  | parallel -k > fullmusic.out


grep -vP "\t"nan fullmusic.out > fullmusic.clean.out

cut -f1 fullmusic.clean.out | while read x; do grep ^$x ../dic_ordered ; done | sed 's/ /_/g' > dic_ordered.clean

./pca.r


paste dic_ordered.clean pcout | cut -f3- | grep "Bach\|Mozart\|Haydn\|Beethoven" | sed 's/ /_/g' | sort | awk -v x=0 '{OFS="\t"; if ($1!=p) {p=$1; x+=1;} print x,$3,$4}' | ./plot.py pc2_pc3.pdf

cut -f3 dic_ordered.clean | sort | uniq -c | sort -rnk1 | head | awk '{print $2}' | while read x; do paste dic_ordered.clean pcout | cut -f3- | grep $x | sed 's/ /_/g' | sort | awk -v x=0 '{OFS="\t"; if ($1!=p) {p=$1; x+=1;} print x,$2,$3}' | cut -f2,3 | code_grand_plot.py -d --xlim -8 8 --ylim -8 8 -o out/$x.png; done


###################
grep -P  "\t"nan fullmusic.out | cut -f1 > unanalyzable
# remove these files
time cat ../filenames | while read x; do echo "echo -ne \"$x\\t\"; ./midicsv ../allmid/$x | grep Note_ | sort -nk2 | sed 's/, /\t/g' | ./list4.py | tail -1"; done  | parallel -k > fullmusic4.out

grep -vP "\t"nan fullmusic4.out | awk '{if (NF==306) print}'  > fullmusic4.clean.out

cut -f1 fullmusic4.clean.out | while read x; do grep ^$x ../dic_ordered ; done | sed 's/ /_/g' > dic_ordered4.clean

./pca4.r

cut -f3 dic_ordered4.clean | sort | uniq -c | sort -rnk1 | head | awk '{print $2}' | while read x; do paste dic_ordered4.clean pcout4 | cut -f3- | grep $x | sed 's/ /_/g' | sort | awk -v x=0 '{OFS="\t"; if ($1!=p) {p=$1; x+=1;} print x,$2,$3}' | cut -f2,3 | code_grand_plot.py -d --xlim -8 8 --ylim -8 8 -o out4/$x.png; done


#########################

cut -f3-14 fullmusic4.clean.out | ./pca.r  | tail -n+2 > tmp;  paste dic_ordered4.clean tmp | grep "Bach\|Mozart\|Haydn\|Beethoven" | cut -f4,5 | code_grand_plot.py -d
 
cut -f3-14,155-166 fullmusic4.clean.out |  ./pca.r  | tail -n+2 > pcout4






