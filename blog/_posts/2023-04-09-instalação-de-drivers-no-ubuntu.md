---
title: Instalação de drivers no Ubuntu
date: 2023-04-09 12:50:00 -0300
categories: Guias
tags: instalação de drivers no ubuntu
image:
  path: https://i.imgur.com/ATEyq8x.jpg
flarum_id: 7
---

Drivers são programas que determinam como seus dispositivos vão se comunicar com o restante do sistema, ou seja, são eles que determinam os melhores caminhos pra extrair o máximo possível de tudo que está na parte física do seu computador.

Ter os drivers corretos instalados no seu sistema é fundamental para o bom funcionamento do sistema, então, nesta postagem eu vou te mostrar como ter as últimas versões dos drivers de som e vídeo mais importantes que você vai precisar.

## ![mesa](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/GPU_Viewer.svg) MESA

O driver [**MESA**](https://launchpad.net/~kisak/+archive/ubuntu/kisak-mesa) é responsável por todos os dispositivos de vídeo da [**Intel**](http://intel.com), da [**AMD**](https://amd.com) e de várias outras desenvolvedoras, ou seja, sua abrangência cobre praticamente qualquer dispositivo de vídeo que possa estar utilizando.

Por padrão, ele já está incluso no núcleo do Linux, porém, no caso do Ubuntu, dependendo da versão que você estiver usando, pode ser que o driver **MESA** não esteja na última versão disponível, mas ele pode ser facilmente atualizado.

Basta executar os comandos abaixo:
```bash
sudo add-apt-repository ppa:kisak/kisak-mesa
pkcon update
```
Após a atualização, é necessário reiniciar o sistema para que os novos drivers entrem em funcionamento.

## ![nvidia](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/nvidia.svg) NVIDIA

Os dispositivos de vídeo da [**NVIDIA**](https://nvidia.com) funcionam usando o driver **MESA**, porém, com recursos limitados, infelizmente o código fonte dos drivers da **NVIDIA** não está disponível para ser incluído no **MESA** como as demais empresas fazem.

Dessa forma, pra que você tenha o driver mais atual instalado, você pode executar o comando abaixo:
```bash
if [[ -n $(lspci |grep NVIDIA|cut -d: -f3) ]]
then
    echo 'Sua GPU é NVIDIA'
    (lspci |grep NVIDIA|cut -d: -f3|cut -d ' ' -f4|head -n1)
    sudo add-apt-repository ppa:graphics-drivers/ppa
    pkcon install "$(apt search nvidia-driver 2>/dev/null|grep nvidia-driver|grep -v open|grep -v server|cut -d '/' -f1|tail -n1)"
    cat <<EOF |sudo tee /usr/local/bin/prime-run>/dev/null
#!/bin/sh
set -e
__NV_PRIME_RENDER_OFFLOAD=1 \
__VK_LAYER_NV_optimus=NVIDIA_only \
__GLX_VENDOR_LIBRARY_NAME=nvidia \
exec "\$@"
EOF
    sudo chmod +x /usr/local/bin/prime-run
else
	echo 'Sua GPU não é NVIDIA'
fi
```

Após a atualização, é necessário reiniciar o sistema para que os novos drivers entrem em funcionamento.

## ![alsa-firemware](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/mx-select-sound.svg) ALSA firmware

Assim como o **MESA** abrange uma enorme quantidade de dispositivos de vídeo, o [**ALSA**](http://ppa.launchpad.net/kxstudio-debian/libs/ubuntu/pool/main/a/alsa-firmware) também abrange uma quantidade enorme de dispositivos de áudio, desde dispositivos integrados em placas mãe, até dispositivos USB, entre outros.

Porém, da mesma forma que o **MESA**, no caso do Ubuntu, pode ser que ele não esteja disponível na última versão, mas ele pode ser facilmente atualizado com o comando abaixo:
```bash
wget -q --show-progress http://ppa.launchpad.net/kxstudio-debian/libs/ubuntu/pool/main/a/alsa-firmware/$(wget -qO- http://ppa.launchpad.net/kxstudio-debian/libs/ubuntu/pool/main/a/alsa-firmware/|grep amd64.deb|cut -d '"' -f8)
pkcon install-local ./alsa-firmware*.deb
```

Após a atualização, é necessário reiniciar o sistema para que os novos drivers entrem em funcionamento.

## ![jack](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/qjackctl.svg) JACK

O [**JACK**](https://launchpad.net/~ubuntustudio-ppa/+archive/ubuntu/backports) é um servidor de áudio que se faz necessário no caso de você precisar trabalhar com áudio em baixa latência, em aplições musicais ou de edição avançada de áudio.

Através dele, é possível alcançar latências baixíssimas e pra citar um exemplo, eu obtive algo em torno de 5 milissegundos nos programas de produção musical com os quais trabalho, o que é um valor significativamente baixo, visto que _em teoria_, qualquer valor abaixo de 8 milissegundos já é impercetível aos ouvidos humanos.

Por padrão, ele não vem instalado no Ubuntu e a maioria dos tutoriais que você vai encontrar, não abragem uma instalação dos complementos adequados.

Desse modo, execute os comandos abaixo pra uma instalação mais adequada:
```bash
sudo add-apt-repository -y ppa:ubuntustudio-ppa/backports
echo 'jackd2 jackd/tweak_rt_limits string true'|sudo debconf-set-selections>/dev/null
sudo apt install --no-install-recommends -y jackd2
```

Você pode conferir a postagem sobre [**Produção musical no Linux**](../produ%C3%A7%C3%A3o-musical-no-linux/) para mais detalhes de uso e complementos para o **JACK**.

## ![udev-rtirq](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/devices/audio-card.svg) `udev-rtirq`

O [`udev-rtirq`](https://github.com/jhernberg/udev-rtirq) é um script que configura o sistema para alta prioridade nos dispositivos de áudio, ou seja, o processamento do sistema vai primeiro para os dispositivos de áudio e depois pros demais processos em execução, o que gera uma maior estabilidade em aplicações profissionais de áudio.

Para instalar o `udev-rtirq` basta executar os comandos abaixo:
```bash
pkcon install build-essential git
git clone -q https://github.com/jhernberg/udev-rtirq
cd udev-rtirq
make install
cd ..
```
Após a atualização, é necessário reiniciar o sistema para que o novo gerenciamento entre em funcionamento.

> Lembrando que todas as sugestões contidas nesta postagem, podem ser percebidas de forma subjetiva, ou seja, alguns usuários vão conseguir identificar onde elas fizeram efeito, enquanto outros não conseguirão ter essa mesma percepção.
{: .prompt-warning}

Se você gostou do conteúdo desta postagem e quer receber mais conteúdos como esse, me siga no [**Twitter**](https://twitter.com/rauldipeas).

