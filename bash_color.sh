#!/bin/sh
#PBS -M rma@ifi.unicamp.br
#PBS -m abe
#PBS -N plot_1M
#PBS -e esfera.err
#PBS -o esfera.out
#PBS -q auger
#PBS -l nodes=1:ppn=1




. /etc/profile.d/modules.sh

module load compiler/gcc-4.8.2
source /home/sw/intel/bin/compilervars.sh intel64
source /home/sw/intel/composer_xe_2015/mkl/bin/mklvars.sh intel64
. /home/sw/intel/impi/5.1.2.150/bin64/mpivars.sh
export INTEL_LICENSE_FILE=/opt/intel/composerxe-2011.0.084/licenses:/opt/intel/l
icenses:/home/cc/fandri/intel/licenses:/opt/intel/composer_xe_2011_sp1.6.233/lic
enses:/opt/intel/licenses:/home/cc/fandri/intel/licenses
export I_MPI_HYDRA_BOOTSTRAP=rsh
export I_MPI_DEVICE=rdssm



#Inicio do script

dir=/home/drc01/kemp/rma/CARLOS/jatos/plots_finais/10nG/Lc_1Mpc/resultados

cd $dir
for(( i=0; i<=90; i= i+10 )) do

        cd colorbar_cluster/
         >chegaram_${i}.txt
         >sairam_${i}.txt

        cd ../

        cd resultados_ang${i}

        cat resultados_ang${i} | awk '{print $14}' >../colorbar_cluster/chegaram_${i}.txt
        cat resultados_cone_ang${i} | awk '{print $14}' >../colorbar_cluster/sairam_${i}.txt

        cd ../

done

cd colorbar_cluster


sed -i -e '1d' sairam*
sed -i -e '1d' chegaram*

source /home/drc01/kemp/rma/root_carlos/setVar.sh

cd  /home/drc01/kemp/rma/CARLOS/jatos/100k_eventos/test_1024/colorbar_cluster/

g++ MakePlot2D-Carlos.cc -o MakePlot2D-Carlos.exe `root-config --cflags --glibs`
./MakePlot2D-Carlos.exe
