tabulador="	"
exp_name=8201ZZa
echo "experiment	timestamp	event"  >  log.txt 
fecha0=$(date +"%Y%m%d %H%M%S") 
echo "$exp_name""$tabulador""$fecha0""$tabulador""SH_START" >> log.txt 
Rscript --vanilla ~/labo/src/lib/exp_run_init.r  8201ZZa
Rscript --vanilla ~/labo/src/completo/z992_ZZ_lightgbm_semillerio.r  8201ZZa  2>&1 | tee outfile 
cp  ~/log/*.txt  ./  
Rscript --vanilla ~/labo/src/lib/exp_run_end.r
fecha1=$(date +"%Y%m%d %H%M%S") 
echo "$exp_name""$tabulador""$fecha1""$tabulador""SH_END" >> log.txt 
find ./ ! -name "*.gz" ! -name . -exec cp -prt /media/expshared/astbaez/exp/8201ZZa/  {} +  

#suicidio
export NAME=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google') 
export ZONE=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google') 
gcloud --quiet compute instances delete $NAME --zone=$ZONE 
