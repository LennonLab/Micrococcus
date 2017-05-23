for i in $(ls -d *K*/); do
qsub -v var1=${i%%/} -N ${i%%/} kbs_genomes.sh;
done
