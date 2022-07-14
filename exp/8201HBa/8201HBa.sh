tabulador="	"
exp_name=8201HBa
echo "experiment	timestamp	event"  >  log.txt 
fecha0=$(date +"%Y%m%d %H%M%S") 
echo "$exp_name""$tabulador""$fecha0""$tabulador""SH_START" >> log.txt 
Rscript --vanilla ~/labo/src/lib/exp_run_init.r  8201HBa
Rscript --vanilla ~/labo/src/completo/z971_HB_hibridacion.r  8201HBa  2>&1 | tee outfile 
cp  ~/log/*.txt  ./  
Rscript --vanilla ~/labo/src/lib/exp_run_end.r
fecha1=$(date +"%Y%m%d %H%M%S") 
echo "$exp_name""$tabulador""$fecha1""$tabulador""SH_END" >> log.txt 
find ./ ! -name "*.gz" ! -name . -exec cp -prt /media/expshared/astbaez/exp/8201HBa/  {} +  

