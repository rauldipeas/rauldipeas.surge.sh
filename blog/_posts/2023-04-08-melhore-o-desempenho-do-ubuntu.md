---
title: Melhore o desempenho do Ubuntu
date: 2023-04-08 16:25:00 -0300
categories: Guias
tags: melhore o desempenho do ubuntu
image:
  path: https://i.imgur.com/H2wF1U6.jpg
flarum_id: 8
---

## ![ubuntu](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/distributor-logo-ubuntu.svg) Ubuntu

O [**Ubuntu**](https://ubuntu.com) é uma distribuição excelente, pois nele é possível executar todos os tipos de tarefas relacionadas as nossas demandas atuais.

Você pode assistir um vídeo em alta resolução no [**YouTube**](https://youtube.com), pra passar o tempo, por exemplo, ou desenvolver um site, usando o [**VS Code**](https://code.visualstudio.com/) enquanto ouve uma música agradável no [**Spotify**](https://spotify.com), pra citar outras possibilidades.

Acho que podemos dizer que o Ubuntu está preparado pra todas as nossas necessidades de uso, atualmente, entretenimento, como jogos, filmes e música, trabalho, como programação, edição de vídeo e produção musical, entre outras infinitas possibilidades.

Mas algo que sempre deixa todo usuário com uma pulga atrás da orelha é se existe alguma forma de extrair mais do sistema, fazendo com que ele entregue uma maior performance, possibilitando rodar mais programas em simultâneo ou abrir os programas necessários com maior velocidade e é justamente aí que esse guia vai te mostrar as possibilidades e explicar como aplicar cada uma delas.

Por ser um sistema que busca entregar estabilidade, ele contém uma série de valores de configuração padrão, que abrangem esse conceito, ou seja, vão valor conservadores e que vão funcionar bem pra maioria dos usuários, porém, eles podem ser reconfigurados pra entregar uma performance superior, ainda de forma segura.

## ![mainline](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/mintsources-ppa.svg) Mainline

A primeira das modificações sugeridas, é utilizar uma versão mais nova do núcleo do sistema, já que ele é a base pra que todo o restante funcione corretamente.

A própria **Canonical**, empresa que desenvolve o Ubuntu, disponibiliza essa atualização pra ser instalada manualmente pelo usuário e pra facilitar esse processo e as atualizações futuras nós podemos usar a ferramenta [**mainline**](https://github.com/cappelikan/mainline).

O **mainline** pode ser instalado com os seguintes comandos:
```bash
sudo add-apt-repository ppa:cappelikan/ppa
pkcon install mainline
sudo mainline --install-latest
```

Após ter instalado a última versão do núcleo do sistema através do **mainline**, você deve reiniciar o sistema e se tudo correu como esperado, depois de um tempo você pode remover as versões antigas do núcleo do sistema e liberar algum espaço em disco.

Para isso, basta utilizar o comando:
```bash
sudo find /boot -name "*vmlinuz-*"|grep -v "$(uname -r)"|sed 's@/boot/vmlinuz@linux-*@g'|sed 's/-generic/\*/g'|xargs -o sudo apt autoremove --purge
```

## ![cfs-zen-tweaks](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/devices/cpu.svg) CFS Zen tweaks

A próxima otimzação que podemos fazer no **Ubuntu**, é no gerenciamento de processos, para trazer uma maior responsividade ao sistema e isso pode ser melhorado usando o [**CFS Zen tweaks**](https://github.com/igo95862/cfs-zen-tweaks), que melhora a gestão dos processos do sistema, focando exclusivamente na responsividade, ou seja, dando prioridade aos processos relacionados com a interação direta do usuário, reduzindo a prioridade de processos em segundo plano, que muitas vezes você nem sabe que estão sendo executados.

Para instalar o **CFS Zen tweaks**, basta executar os comandos abaixo:
```bash
wget -q --show-progress "$(wget -qO- https://api.github.com/repos/igo95862/cfs-zen-tweaks/releases|grep browser_download_url|grep .deb|head -n1|cut -d '"' -f4)"
pkcon install-local ./cfs-zen-tweaks*.deb
systemctl enable set-cfs-tweaks.service
systemctl start set-cfs-tweaks.service
```

Não é necessário reiniciar, os resultados já são imediatos.

## ![zswap](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/devices/media-memory.svg) ZSwap

Outra melhora que é possível fazer no Ubuntu sem grandes dificuldades, mas que confunde muitos usuários, é ajustar o gerenciamento da memória de troca, popularmente conhecida como **swap**.

Alguns usuários preferem usar ela em uma partição separada do disco, mas por padrão, o **Ubuntu** cria um arquivo na partição do sistema e escreve os dados diretamente nele.

Porém, o processo de escrita e leitura, tanto na partição quanto nesse arquivo, podem ser um pouco lentos, dependendo da capacidade de processamento, leitura e escrita do seu dispositivo de armazenamento e para melhorar essa gestão, é possível fazer uso de uma parte da memória RAM, que tem uma velocidade de escrita e leitura muito maior do que qualquer dispositivo de armazenamento que você possa estar usando.

Podemos fazer essa modificação no gerenciamento da memória de troca, utilizando o [**ZSwap**](https://en.wikipedia.org/wiki/Zswap), que já é nativo no sistema, sendo necessário apenas ativá-lo.

Você pode fazer isso com os comandos abaixo:
```bash
RAM=`cat /proc/meminfo|grep MemTotal|cut -d ' ' -f9`
sudo swapoff /swapfile
sudo fallocate -l $RAM /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=$RAM status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo sed -i 's/quiet splash/quiet splash zswap.enabled=1 zswap.compressor=lz4/g' /etc/default/grub
sudo update-grub
echo lz4|sudo tee -a /etc/initramfs-tools/modules>/dev/null
echo lz4_compress|sudo tee -a /etc/initramfs-tools/modules>/dev/null
sudo update-initramfs -u -k all
```

Após a execução dos comandos, é necessário reinciar para que o novo sistema de gerenciamento de memória seja ativado.

## ![nohang](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/rsibreak.svg) `nohang`

Por fim, a última modifiacação sugerida para melhorar a responsividade do sitema é o uso do programa `nohang`, que serve justamente pra fechar processos inativos durante um determinado período, liberando o processador pra processos relacionados a interação direta do usuário.

O `nohang` garante que um espaço mínimo da memória esteja sempre disponível, impedindo que o sistema trave por falta de memória, por exemplo.

Você pode instala-lo com o comando abaixo:
```bash
pkcon install nohang
```

Não é necessário reiniciar, os efeitos são imediatos.

> Lembrando que todas as sugestões contidas nesta postagem, podem ser percebidas de forma subjetiva, ou seja, alguns usuários vão conseguir identificar onde elas fizeram efeito, enquanto outros não conseguirão ter essa mesma percepção.
{: .prompt-warning}

Se você gostou do conteúdo desta postagem e quer receber mais conteúdos como esse, me siga no [**Twitter**](https://twitter.com/rauldipeas).