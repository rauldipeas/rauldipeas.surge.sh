---
title: Produção musical no Linux
date: 2023-04-07 14:45:00 -0300
categories: Guias
tags: produção musical no linux
pin: true
image:
  path: https://i.imgur.com/rr91QmQ.png
flarum_id: 3
---
![ubuntu](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/distributor-logo-ubuntu.svg "Ubuntu"){: w="150" .normal}
![tuxguitar](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/tuxguitar.svg "TuxGuitar"){: w="150" .normal}
![helvum](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/org.pipewire.Helvum.svg "Helvum"){: w="150" .normal}
![música](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/org.gnome.Music.svg "Música"){: w="150" .normal}

O [**Linux**](https://linux.org) é um sistema operacional bastante abrangente (assim como o [**Windows**](https://www.microsoft.com/pt-br/windows) e o [**MacOS**](https://www.apple.com/br/macos)) e uma de suas infinitas possibilidade é a produção musical.

Através deste guia eu vou compartilhar alguns conhecimentos que obtive ao longo da última década(ou um pouco mais de tempo).

O ponto de partida, sem dúvidas, é escolher uma distribuição que seja suficientemente completa e tenha o suporte necessário de tudo que vamos precisar pra trabalhar com música.

A minha escolha da vez é o [**Ubuntu**](https://ubuntu.com).

Se você gosta deste tema e quer conversar com outros músicos que também usam Linux, acesse o nosso grupo no [**Telegram**](https://t.me/producaomusicalnolinux).

## ![ubuntu](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/distributor-logo-ubuntu.svg "Ubuntu") [**Ubuntu**](https://ubuntu.com)

O [**Ubuntu**](https://ubuntu.com) é uma distribuição baseada no [**Debian**](https://debian.org), que por ser uma das distribuições mais comentadas na internet, atrai a atenção de muitos usuários.

Isso se dá pelo fato de que o [**Debian**](https://debian.org) é uma das distribuições mais antigas ainda em atividade e por isso, é possível encontrar muito conteúdo sobre ele na internet.

Neste guia eu vou utilizar o [**Kubuntu**](https://kubuntu.org), mas todos os comandos indicados são compatíveis com qualquer um dos [_sabores_](https://ubuntu.com/desktop/flavours) do [**Ubuntu**](https://ubuntu.com).

![kubuntu-desktop](https://i.imgur.com/szZmW59.png "Área de trabalho do Kubuntu")

## ![rtcqs](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/emblems/emblem-default.svg "rtcqs") [rtcqs](https://codeberg.org/rtcqs/rtcqs)

O `rtcqs` é um checador de configurações do sistema, necessário pra checar se todas as configurações de desempenho já estão setadas corretamente, garantindo que o sistema tenha o máximo de desempenho possível com os programas de áudio.

![rtcqs](https://i.imgur.com/mNw09cO.png "rtcqs")

As checagens indicadas se baseiam nas recomendações da [**Wiki do LinuxAudio**](https://wiki.linuxaudio.org/wiki/system_configuration).

📦 Instalação
```bash
sudo apt install pipx python3-tk
pipx install rtcqs
mkdir -p "$HOME"/.local/share/{applications,icons}
wget -qO "$HOME"/.local/share/applications/rtcqs.desktop https://github.com/autostatic/rtcqs/raw/main/rtcqs.desktop
sed -i "s@Exec=rtcqs_gui@Exec=$HOME/.local/bin/rtcqs_gui@g" "$HOME"/.local/share/applications/rtcqs.desktop
wget -qO "$HOME"/.local/share/icons/rtcqs.svg https://github.com/autostatic/rtcqs/raw/main/rtcqs_logo.svg
```

🔧 Configuração
```bash
sudo usermod -aG audio "$USER"
cat <<EOF |sudo tee /etc/sysctl.d/swappiness.conf >/dev/null
vm.swappiness = 10
EOF
cat <<EOF |sudo tee /etc/default/grub.d/cmdline-linux-default.cfg >/dev/null
GRUB_CMDLINE_LINUX_DEFAULT="cpufreq.default_governor=performance mitigations=off preempt=full quiet splash threadirqs"
EOF
sudo update-grub
sudo wget -qO /etc/udev/rules.d/99-cpu-dma-latency.rules https://raw.githubusercontent.com/Ardour/ardour/master/tools/udev/99-cpu-dma-latency.rules
systemctl --user disable xdg-desktop-portal
systemctl --user mask xdg-desktop-portal
sudo systemctl mask xdg-desktop-portal
```
    
## ![udev-rtirq](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/devices/audio-card.svg "udev-rtirq") [udev-rtirq](https://github.com/jhernberg/udev-rtirq)

O `udev-rtirq` é um script que adiciona regras de gerenciamento de hardware ao sistema, que garantem alta prioridade no gerenciamento da interface de áudio.

📦 Instalação
```bash
sudo apt install build-essential git
git clone -q https://github.com/jhernberg/udev-rtirq
cd udev-rtirq
sudo make install
cd ..
rm -r udev-rtirq
```

## ![xanmod](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/devices/cpu.svg "XanMod") [XanMod](https://xanmod.org)

O **XanMod** é o núcleo de sistema recomendado para este contexto, por conter uma série de patches e otimizações que contribuem para o melhor desempenho de programas que são executados através do [**WINE**](https://www.winehq.org/), além de contribuir de forma decisiva para uma baixíssma incidência de [`xruns`](https://unix.stackexchange.com/questions/199498/what-are-xruns)(que ocasionam artefatos sonoros, como clicks e pops no áudio) ao utilizar programas de áudio de baixa latência.

📦 Instalação
```bash
wget -cq https://dl.xanmod.org/check_x86-64_psabi.sh
chmod +x check_x86-64_psabi.sh
wget -cq --show-progress https://dl.xanmod.org/xanmod-repository.deb
sudo apt install --no-install-recommends ./xanmod-repository.deb
sudo apt update
sudo apt install linux-firmware linux-xanmod-x64$(./check_x86-64_psabi.sh|cut -d"-" -f3)
rm check_x86-64_psabi.sh xanmod-repository.deb
```

## ![cadence](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/cadence.svg "Cadence") [Cadence](https://kx.studio/Applications:Cadence)

O **Cadence** é o programa responsável por gerenciar todas configurações de som do sistema, utilizando como base os programas [**JACK**](https://jackaudio.org) e [**PulseAudio**](https://www.freedesktop.org/wiki/Software/PulseAudio).

Através das configurações indicadas aqui, seu sistema estará preparado pra executar o áudio com baixa latência e bom desempenho.

📦 Instalação
```bash
wget -cq --show-progress http://ppa.launchpad.net/kxstudio-debian/kxstudio/ubuntu/pool/main/k/kxstudio-repos/"$(wget -qO- http://ppa.launchpad.net/kxstudio-debian/kxstudio/ubuntu/pool/main/k/kxstudio-repos/|grep all.deb|tail -n1|cut -d '"' -f8)"
sudo apt install ./kxstudio-repos*.deb
sudo add-apt-repository -ny multiverse
sudo add-apt-repository -y universe
echo 'jackd2 jackd/tweak_rt_limits string true'|sudo debconf-set-selections
sudo apt install alsa-firmware cadence pulseaudio
sudo apt autoremove --purge qjackctl meterbridge
systemctl --user mask pipewire.service pipewire.socket
systemctl --user --now stop pipewire.service pipewire.socket
systemctl --user --now disable pipewire.service pipewire.socket
systemctl --user --now enable pulseaudio.service pulseaudio.socket
systemctl --user --now start pulseaudio.service pulseaudio.socket
pactl info|grep "Nome do servidor"
rm kxstudio-repos*.deb
```
    
🔧 Configuração
> As configurações recomendadas para o **Cadence** podem variar um pouco de acordo com o seu hardware, vou deixar aqui configurações que funcionam bem na maioria dos hardwares atuais.
{: .prompt-info}

![cadence-driver](https://i.imgur.com/qxnUY8Z.png "Cadence Driver")

![cadence-engine](https://i.imgur.com/Msr9y1N.png "Cadence Engine")

> Caso você tenha baixo desempenho ou artefatos sonoros, procure alterar o valor _Periods/Buffer_ na aba _Driver_, pela minha experiência, esse valor não tem um padrão claro, cada hardware precisa de um valor específico.
{: .prompt-warning}

## ![wine](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/wine.svg "WINE") [WINE TkG](https://github.com/Frogging-Family/wine-tkg-git)

O **WINE** é o programa responsável por disponibilizar uma camada de compatibilidade para a execução de programas do Windows no Linux, a versão **TkG** é compilada utilizando patches específicos para um maior desempenho, em especial o patch [**FSYNC**](https://www.phoronix.com/news/Linux-Kernel-Wine-Sync-API-2021).

![q4wine](https://i.imgur.com/2qv0xPt.png "Q4WINE")

📦 Instalação
```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install q4wine wine wine32:i386 winetricks
wget -q --show-progress "$(wget -qO- https://api.github.com/repos/Kron4ek/Wine-Builds/releases|grep browser_download_url|grep staging-tkg-amd64.tar.xz|head -n1|cut -d '"' -f4)"
tar fx wine*staging-tkg-amd64.tar.xz
rm wine*staging-tkg-amd64.tar.xz
sudo mv wine*staging-tkg-amd64 /opt/wine-tkg
wget -q --show-progress "$(wget -qO- https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases|grep browser_download_url|grep wine-lutris-ge|grep .tar.xz|head -n1|cut -d '"' -f4)"
tar fx wine-lutris-ge*.tar.xz
sudo cp lutris*/lib/wine/i386-windows/winemenubuilder.exe /opt/wine-tkg/lib/wine/i386-windows/winemenubuilder.exe
sudo cp lutris*/lib64/wine/x86_64-windows/winemenubuilder.exe /opt/wine-tkg/lib/wine/x86_64-windows/winemenubuilder.exe
find . -name "*lutris-ge*" -print0|xargs -0 rm -r
WINE_GECKO_VER="$(wget -qO- https://dl.winehq.org/wine/wine-gecko/|grep folder|cut -d '"' -f6|sort -d|grep -v wine|tail -n1)"
wget -qO- https://dl.winehq.org/wine/wine-gecko/"$WINE_GECKO_VER"|grep x86|grep tar|grep -wv pdb|grep -wv rc|cut -d '"' -f6>wine-gecko.links
sed -i 's@wine-gecko@https://dl.winehq.org/wine/wine-gecko/wine-gecko@g' wine-gecko.links
sed -i 's@wine/wine-gecko/@'wine/wine-gecko/"$WINE_GECKO_VER"'@g' wine-gecko.links
wget -q --show-progress "$(cat<wine-gecko.links|head -n1)"
wget -q --show-progress "$(cat<wine-gecko.links|tail -n1)"
rm wine-gecko.links
WINE_MONO_VER="$(wget -qO- https://dl.winehq.org/wine/wine-mono/|grep folder|cut -d '"' -f6|sort -g|tail -n1)"
wget -qO- https://dl.winehq.org/wine/wine-mono/"$WINE_MONO_VER"|grep x86|grep tar|cut -d '"' -f6>wine-mono.links
sed -i 's@wine-mono@https://dl.winehq.org/wine/wine-mono/wine-mono@g' wine-mono.links
sed -i 's@wine/wine-mono/@'wine/wine-mono/"$WINE_MONO_VER"'@g' wine-mono.links
wget -q --show-progress "$(cat<wine-mono.links|head -n1)"
rm wine-mono.links
sudo mkdir -p /opt/wine-tkg/share/wine/{gecko,mono}
sudo tar fx wine-gecko-*-x86.tar.xz -C /opt/wine-tkg/share/wine/gecko/
sudo tar fx wine-gecko-*-x86_64.tar.xz -C /opt/wine-tkg/share/wine/gecko/
sudo tar fx wine-mono-*-x86.tar.xz -C /opt/wine-tkg/share/wine/mono/
rm -r wine-gecko-*-x86.tar.xz
rm -r wine-gecko-*-x86_64.tar.xz
rm -r wine-mono-*-x86.tar.xz
cat <<EOF |sudo tee /etc/environment.d/99wine.conf>/dev/null
if [ -d "/opt/wine-tkg/bin" ] ; then
    PATH="/opt/wine-tkg/bin:\$PATH"
fi
export WINE_ENABLE_PIPE_SYNC_FOR_APP=1
export WINEESYNC=1
export WINEFSYNC=1
EOF
```

🔧 Configuração
```bash
winetricks -f -q dxvk
```

## ![yabridge](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/org.gnome.Extensions.svg "yabridge") [`yabrige`](https://github.com/robbert-vdh/yabridge)

O `yabridge` é o programa responsável por criar links simbólicos dos plugins VST do Windows, que podem ser lidos pelos programas de áudio nativos do Linux, como **REAPER**, **Waveform**, **Bitwig**, entre outros.

Ele é compatível com plugins **VST2** e **VST3** de **32** e **64** bits.

📦 Instalação
```bash
wget -q --show-progress "$(wget -qO- https://api.github.com/repos/robbert-vdh/yabridge/releases|grep browser_download_url|head -n2|tail -n1|cut -d '"' -f4)"
tar fxz yabridge*.tar.gz
rm -r yabridge*.tar.gz
sudo mv yabridge/yabridgectl /usr/bin/yabridgectl
sudo mv yabridge/libyabridge* /usr/lib/
sudo mv yabridge/yabridge* /usr/bin/
rm -r yabridge
```

🔧 Configuração
```bash
mkdir -pv "$HOME"/.wine/drive_c/Program\ Files/Common\ Files/VST3
mkdir -pv "$HOME"/.wine/drive_c/Program\ Files/VSTPlugins
yabridgectl add "$HOME"/.wine/drive_c/Program\ Files/Common\ Files/VST3
yabridgectl add "$HOME"/.wine/drive_c/Program\ Files/VSTPlugins
yabridgectl sync --prune --verbose
```

## ![reaper](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/cockos-reaper.svg "REAPER") [REAPER](https://reaper.fm)

O **REAPER** é uma estação de trabalho de áudio digital, com o qual você pode produzir música, editar áudio, editar vídeo (de maneira básica) e fazer apresentações musicais ao vivo.

![reaper](https://i.imgur.com/rr91QmQ.png "REAPER")

Os comandos indicados aqui incluem a instalação do [**ReaPack**](https://reapack.com) e da extensão [**SWS**](https://www.sws-extension.org), além da tradução para o português brasileiro.

📦 Instalação
```bash
REAPER_VER="$(wget -qO- http://reaper.fm| grep VERSION|cut -d '>' -f2|cut -d ':' -f1|sed 's/VERSION //g')"
cd /tmp
rm -rf /tmp/*reaper* /tmp/*libSwell*
wget -q --show-progress http://reaper.fm/"$(wget -qO- http://reaper.fm/download.php|grep _linux_x86_64.tar.xz|cut -d '"' -f2)"
tar fx reaper*_linux_x86_64.tar.xz -C /tmp
sed -i 's/rmdir --/rm -rf --/g' /tmp/reaper*/install-reaper.sh
sudo /tmp/reaper*/install-reaper.sh --install /opt --integrate-desktop --quiet --integrate-sys-desktop
wget -qO libSwell.colortheme https://stash.reaper.fm/41334/libSwell.colortheme
sudo mv libSwell.colortheme /opt/REAPER/libSwell.colortheme
cat <<EOF |sudo tee -a /usr/share/applications/cockos-reaper.desktop 
#\n
Actions=NewProject;ShowAudioConfig;ReaMote;WhatsNew;License;
[Desktop Action NewProject]
Name=REAPER (create new project)
Name[pt_BR]=REAPER (criar novo projeto)
Exec=/opt/REAPER/reaper -new
Icon=cockos-reaper
[Desktop Action ShowAudioConfig]
Name=REAPER (show audio configuration on startup)
Name[pt_BR]=REAPER (mostrar configurações de áudio ao iniciar)
Exec=/opt/REAPER/reaper -audiocfg
Icon=cockos-reaper
[Desktop Action ReaMote]
Name=ReaMote
Exec=/opt/REAPER/reamote-server
Icon=folder-remote
[Desktop Action WhatsNew]
Name=What's new
Name[pt_BR]=O que há de novo?
Exec=xdg-open /opt/REAPER/whatsnew.txt
Icon=text-x-plain
[Desktop Action License]
Name=License and User Agreement
Name[pt_BR]=Licença e contrato de usuário
Exec=xdg-open /opt/REAPER/EULA.txt
Icon=text-x-plain
EOF
```

🔧 Configuração
```bash
mkdir -pv "$HOME"/.config/REAPER/{LangPack,UserPlugins}
wget -O "$HOME"/.config/REAPER/LangPack/pt-BR.ReaperLangPack https://stash.reaper.fm"$(wget -qO- https://stash.reaper.fm/tag/Language-Packs|grep pt-BR|head -n1|cut -d '"' -f2|sed 's/\/v//g')"
wget https://sws-extension.org/download/pre-release/"$(wget -qO- http://sws-extension.org/download/pre-release/|grep Linux-x86_64|head -n1|cut -d '"' -f4)"
tar fvx sws-*-Linux-x86_64-*.tar.xz -C "$HOME"/.config/REAPER
rm -rfv sws-*-Linux-x86_64-*.tar.xz
wget -O "$HOME"/.config/REAPER/UserPlugins/reaper_reapack-x86_64.so "$(wget -qO- https://api.github.com/repos/cfillion/reapack/releases|grep browser_download_url|grep download/v|grep x86_64.so|head -n1|cut -d '"' -f4)"
```

## ![xruns](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/48x48/status/notification-audio-volume-muted.svg "xruns"){: w="22"} Boas práticas para evitar `xruns`
### ![wireless](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/devices/network-wireless.svg "Wireless") Desative conexões sem fio(wifi e bluetooth)
Conexões sem fio, sabidamente causam `xruns` esporádicos.

Alguns notebooks tem um botão físico para desativar a conexão sem fio, se esse não for o seu caso, você pode desativar através do gerenciador de rede na área de notificação do seu ambiente gráfico.

![wifi](https://i.imgur.com/R443kiR.png "Conexão sem fio")

### ![mediainfo](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/mkvinfo.svg "MediaInfo") Evite a conversão de arquivos de áudio em tempo real

Muitos programas de gravação de áudio, como é o caso do **REAPER**, por exemplo, permitem que você importe arquivos em formatos diferentes pra dentro do projeto, fazendo a conversão desses formatos em tempo real, durante a reprodução do projeto, isso gera uma sobrecarga de processamento e sabidamente pode causar `xruns`.

Quando você estiver usando um programa de gravação de áudio, é recomendado evitar a _conversão de arquivos de áudio em tempo real_, ou seja, faça a conversão prévia de quaisquer arquivos que precisa usar no seu projeto, evitando sobrecarga no processamento durante a execução desses arquivos dentro do seu programa de gravação.

Para checar os formatos dos arquivos, você pode usar o programa [**MediaInfo**](https://mediaarea.net/en/MediaInfo), que pode ser facilmente instalado através do comando indicado abaixo.

📦 Instalação
```bash
sudo apt install mediainfo-gui
```

![mediainfo](https://i.imgur.com/hizh47U.png "MediaInfo")

Para converter os arquivos de áudio, vídeo e imagem em outros formatos, você pode usar o programa [**Videomass**](https://jeanslack.github.io/Videomass), que pode ser facilmente instalado através dos comandos indicados abaixo.

📦 Instalação
```bash
sudo apt-add-repository ppa:jeanslack/videomass
sudo apt install --no-install-recommends yt-dlp
sudo apt install python3-videomass
```

![videomass](https://i.imgur.com/Mm7XAQg.png "Videomass")

Se você gostou do conteúdo desta postagem e quer receber mais conteúdos como esse, me siga no [**Twitter**](https://twitter.com/rauldipeas).