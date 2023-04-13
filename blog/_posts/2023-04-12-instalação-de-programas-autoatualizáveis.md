---
title: Instalação de programas autoatualizáveis
date: 2023-04-11 15:15:00 -0300
categories: Guias
tags: instalação de programas autoatualizáveis
image:
  path: https://i.imgur.com/T0yVwGI.jpg
---

Na postagem sobre [Instalação de programas no Ubuntu](../instala%C3%A7%C3%A3o-de-programas-no-ubuntu), eu abordei vários métodos de instalação diferentes, porém, existe um método específico que não foi abordado, porque eu gostaria de fazer uma postagem específica sobre, com mais detalhes sobre o processo e suas possibilidades.

Existem diversos programas que são fornecidos diretamente pelos desenvolvedores, num formato __autoatualizável__, ou seja, o programa se atualiza sozinho, sem nenhuma necessidade de interação do usuário, toda vez que você abrir o programa, vai estar usando a última versão, inevitavelmente.

## ![firefox](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/firefox.svg) Firefox

O [**Firefox**](https://support.mozilla.org/pt-BR/kb/instale-o-firefox-no-linux) é um programa fornecido nesse formato, você baixa um arquivo compactado `.tar` direto do site da Mozilla, abre o programa e pronto, já garante que estará sempre na última versão do navegador.

Toda vez que você abre o navegador, ele faz uma checagem em segundo plano, pra identificar se existe alguma versão mais nova, caso haja, ele baixa e atualiza automaticamente, sem a necessidade de nenhum tipo de interação, apenas uma pequena janela é exibida, informando sobre o processo, que costuma ser bastante rápido.

Talvez, você possa não ter o conhecimento necessário pra fazer uma instalação adequada do Firefox nesse formato, então vou deixar aqui uma sequência de comandos que vocẽ pode usar pra fazer isso de forma simplificada:
```bash
wget -cO firefox-latest-linux64-pt-br.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=pt-BR"
tar fjx firefox-latest-linux64-pt-br.tar.bz2
sudo rm -r /opt/firefox
sudo mkdir -p /opt/firefox
sudo chmod 777 -R /opt/firefox
mv firefox/* /opt/firefox/
rm -r firefox firefox-latest-linux64-pt-br.tar.bz2
sudo mkdir -p /usr/local/bin /usr/local/share/applications /usr/local/share/pixmaps
sudo ln -fs /opt/firefox/firefox /usr/local/bin/firefox
sudo ln -fs /opt/firefox/browser/chrome/icons/default/default128.png /usr/local/share/pixmaps/firefox.png
cat <<EOF |sudo tee /usr/local/share/applications/firefox.desktop>/dev/null
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Navegue na internet
GenericName=Navegador de internet
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=firefox %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true

Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=Abrir uma nova janela
Exec=firefox -new-window

[Desktop Action new-private-window]
Name=Abrir uma nova janela no modo privado
Exec=firefox -private-window
EOF
```

Após a execução dos comandos, quando abrir o navegador pela primeira vez, se estiver usando o ambiente gráfico [GNOME](https://www.gnome.org) com o tema [Adwaita](https://gnome.pages.gitlab.gnome.org/libadwaita), pode notar que o visual dele não é totalmente integrado ao ambiente gráfico, por conta disso, pode querer instalar um tema para que o Firefox se integre melhor ao ambiente gráfico, eu recomendo o uso [deste tema](https://github.com/rafaelmardojai/firefox-gnome-theme).

Basta fechar o navegador e rodar o comando abaixo:
```bash
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh|bash
```

## ![thunderbird](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/thunderbird.svg) Thunderbird

O [**Thunderbird**](https://support.mozilla.org/pt-BR/kb/instalando-o-thunderbird-no-linux) é um cliente de email também desenvolvido pela Mozilla e assim como o **Firefox**, também é fornecido para instalação através de um arquivo compactado `.tar`, que basta ser extraído para que o programa seja executado sempre na última versão disponível.

Para instalar o **Thunderbird** da forma mais adequada, basta executar os comandos abaixo:
```bash
wget -cO thunderbird-latest-linux64-pt-br.tar.bz2 "https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=pt-BR"
tar fjx thunderbird-latest-linux64-pt-br.tar.bz2
sudo rm -r /opt/thunderbird
sudo mkdir -p /opt/thunderbird
sudo chmod 777 -R /opt/thunderbird
mv thunderbird/* /opt/thunderbird/
rm -r thunderbird thunderbird-latest-linux64-pt-br.tar.bz2
sudo mkdir -p /usr/local/bin /usr/local/share/applications /usr/local/share/pixmaps
sudo ln -fs /opt/thunderbird/thunderbird /usr/local/bin/thunderbird
sudo ln -fs /opt/thunderbird/chrome/icons/default/default128.png /usr/local/share/pixmaps/thunderbird.png
cat <<EOF |sudo tee /usr/local/share/applications/thunderbird.desktop>/dev/null
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird
Comment=Envie e receba e-mails com o Thunderbird
GenericName=Cliente de e-mail
Keywords=Email;E-mail;Newsgroup;Feed;RSS
Exec=thunderbird %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=x-scheme-handler/mailto;application/x-xpinstall;
StartupNotify=true
Actions=Compose;Contacts

[Desktop Action Compose]
Name=Compor uma nova mensagem
Exec=thunderbird -compose

[Desktop Action Contacts]
Name=Contatos
Exec=thunderbird -addressbook
EOF
```

## ![blender](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/blender.svg) Blender

O [**Blender**](http://blender.org) é um programa até um pouco difícil de descrever, tão vasta é a sua abrangência, ele realmente pode fazer muita coisa e brilha em várias áreas distintas, mas vamos nos ater as funções mais populares, que são _modelagem 3D_ e _edição de vídeo_.

A maioria dos tutoriais que você vai encontrar na internet sobre o **Blender**, vão abranger esses dois perfis de uso, ele realmente é muito poderoso nessas áreas e não fica devendo pra nenhum outro programa similar, você só precisa dedicar um tempo pra aprender, pois a curva de aprendizado pode ser extensa, dependendo do seu nível de conhecimento.

Agora voltando ao tema da postagem, o **Blender** seria uma pequena _trapaça_ da minha parte, já que ele não se atualiza sozinho, porém, ele tem um sistema de atualização muito parecido com o Firefox, ele procura por atualizações toda vez que você abre o programa, a única diferença é que ele não instala automaticamente, somente um pequeno aviso é exibido pra te informar, o que eu acho até mais seguro, visto que o **Blender** costuma trazer muitas melhorias e novos recursos a cada nova atualização.

Desse modo, pra instalar e também sempre que você quiser atualizar, basta executar os comandos abaixo:
```bash
BLENDER_VER=$(wget -qO- https://ftp.nluug.nl/pub/graphics/blender/release|grep Blender3.|tail -n1|cut -d \" -f6)
BLENDER_FILE=$(wget -qO- https://ftp.nluug.nl/pub/graphics/blender/release/"$BLENDER_VER"|grep .tar.xz|tail -n1|cut -d \" -f6)
wget -c https://ftp.nluug.nl/pub/graphics/blender/release/"$BLENDER_VER""$BLENDER_FILE"
tar -xf blender*.tar.xz
sudo mkdir -p /opt/blender
sudo chmod 777 /opt/blender
sudo mv blender*/* /opt/blender/
rm -r blender*/ blender*.tar.xz
sudo mkdir -p /usr/local/bin /usr/local/share/applications /usr/local/share/pixmaps
sudo ln -sf /opt/blender/blender /usr/local/bin/blender
sudo cp /opt/blender/blender.desktop /usr/local/share/applications/blender.desktop
sudo ln -sf /opt/blender/blender.svg /usr/local/share/pixmaps/blender.svg
```

Caso você esteja planejando usar o **Blender** para edição de vídeo, pode ser que você queira usar o [**Audacity**](https://www.audacityteam.org) como complemento para expandir as possibilidades, visto que o **Blender** não é tão abrangente no segmento de áudio.

Você pode instalar o **Audacity** e a [integração](https://github.com/tin2tin/audacity_tools_for_blender) com o **Blender** de forma simplificada, usando os comandos abaixo:
```bash
pkcon install audacity
mkdir -p "$HOME"/.audacity-data/Theme
wget -cO "$HOME"/.audacity-data/Theme/ImageCache.png https://github.com/visoart/audacity-themes/raw/master/themes/dark-blue/ImageCache.png
wget -c https://github.com/tin2tin/audacity_tools_for_blender/archive/main.zip
mkdir -p "$HOME"/.config/blender/"$(find /opt/blender/* -type d|head -n1|sed "s@/opt/blender/@@g")"/scripts/addons/
unzip audacity_tools_for_blender-main.zip -d "$HOME"/.config/blender/"$(find /opt/blender/* -type d|head -n1|sed "s@/opt/blender/@@g")"/scripts/addons/
rm audacity_tools_for_blender-main.zip
```

## ![libreoffice](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/libreoffice-main.svg) LibreOffice

O [**LibreOffice**](https://launchpad.net/~libreoffice/+archive/ubuntu/ppa), talvez seja a suíte _office_ de código aberto mais popular nos dias atuais, existem muitas empresas que fazem uso profissional dele, além de inúmeros tutoriais, internet afora, é uma suíte completa.

Assim como os demais programas apresentados nesta postagem, ele tem um método de instalação autoatualizável, porém, por conta do nível de complexidade, eu prefiro não recomendar ele aqui, visto que a chance de você instalar errado e ter problemas durante o uso, é grande.

Desse modo, vou _aproveitar a deixa_ pra indicar outra forma comum de instalar programas no **Ubuntu** e ter sempre a última versão disponível, que é usando _repositórios adicionais_ e no caso do **LibreOffice**, vamos usar um [**PPA**](https://launchpad.net/ubuntu/+ppas).

Caso tenha não tenha sido subentendido, vou tentar explicar de forma clara como funcionam os repositórios e quais as melhores práticas pra usar repositórios de terceiros.

_Repositórios_ são endereços na internet, onde os pacotes de instalação dos programas são hospedados e indexados de uma forma organizada, para que os gerenciadores de pacotes das distribuições possam encontrá-los de forma imediata.

Entendido esse fator, todas as distribuições tem seus repositórios próprios, onde ficam hospedados os programas que vem na instalação padrão e também pacotes de programas adicionais, que podem ser instalados posteriormente, com a curadoria de quem desenvolve a distribuição.

Quando você adiciona um repositório de terceiro, pode haver incompatibilidade de versão dos pacotes ou das dependências dos mesmos, por isso a Canonical lançou o [**Launchpad**](launchpad.net), pra garantir que os pacotes disponibilizados através dos repositórios hospedados nele, fossem compatíveis com as versões do **Ubuntu** para os quais os pacotes são disponibilizados.

Por conta disso, mesmo ainda sendo possível que aconteça essa incompatibilidade de versões de pacotes e dependências, essa margem de erro foi drasticamente reduzida, sendo possível afirmar que é seguro usar repositórios **PPA** hospedados no **Launchpad**.

Só vale ressaltar que é sempre bom conferir os pacotes disponíveis no repositório antes de adicionar ele ao seu sistema, por garantia.

Finalmente, sem mais delongas, você pode instalar o **LibreOffice** atualizado no **Ubuntu** com os comandos abaixo:
```bash
sudo add-apt-repository ppa:libreoffice/ppa
pkcon update
```

Se você gostou do conteúdo desta postagem e quer receber mais conteúdos como esse, me siga no [**Twitter**](https://twitter.com/rauldipeas).