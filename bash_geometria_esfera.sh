'

        o bash a seguir roda tudo que é necessário para a geometria da esfera de raios cósmico.
        Para executá-lo em outra pasta,:
        
        1-Copie o arquivo bash_ang0.sh para o diretório desejado.
        2-execute esse bash.

        Ps.:Para a utilização do programa geometria esfera, usamos o pandas e colocamos o header como 
        a primeira linha do arquivo. 
        
            Desse modo, antes de rodar esse bash lembre-se sempre de retirar a linhas comentadas 
        no início do output do CRPropa (deixando somente a primeira linha sem #) 

        ps2.: Lembre-se que esse bash não precisa ser submetido como um job ( usando qsub), ele só funcio-
        nará rodando bash basg_qsub.sh 

'
dir=$(echo $PWD)

cd $dir
awk -v l=100000 '(NR==1){header=$0;next}
                (NR%l==2) {
                   close(file);
                   file=sprintf("%s.%0.5d.txt",FILENAME,++c)
                   sub(/txt[.]/,"",file)
                   print header > file
                }
                {print > file}' dados.txt


mkdir -p resultados/colorbar_cluster

declare -a angs

for((i=10; i<100; i=i+10)) do
        angs=(${angs[*]} "$i")
done

for ang in "${angs[@]}"
do
        cp bash_ang0.sh bash_ang${ang}.sh
        sed -i -e "s/ang0/ang${ang}/g" bash_ang${ang}.sh
        sed -i -e "44s/{item} 0/{item} ${ang}/g" bash_ang${ang}.sh
done



sed -i "30 a dir=$dir" bash_ang*.sh

qsub bash_ang0.sh
for ang in "${angs[@]}"
do
        qsub bash_ang${ang}.sh
done

sed -i '31d' bash_ang*.sh
                             
