dir=$(echo $PWD)

sed -i -e "30 a dir=$dir" bash_emissao_esfera.sh

qsub bash_emissao_esfera.sh

sed -i -e '31d' bash_emissao_esfera.sh
