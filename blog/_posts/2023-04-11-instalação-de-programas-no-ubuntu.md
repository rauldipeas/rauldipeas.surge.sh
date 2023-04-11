---
title: Instalação de programas no Ubuntu
date: 2023-04-11 15:15:00 -0300
categories: Guias
tags: instalação de programas no ubuntu
image:
  path: https://i.imgur.com/YoliuSJ.jpg
---

O Ubuntu, assim como todas as demais distribuições Linux, suporta uma grande variedade de formas pra instalar novos programas, dentre as mais simples como dar alguns cliques na central de programas, até a compilação de um programa diretamente do código fonte, passando por diversas outras.

Dentre as formas mais populares, existem os _pacotes_, que são arquivos compactados, com o conteúdo dos programas dentro, possibilitando a instalação com poucos cliques.

Esses pacotes podem ser disponibilizados através dos repositórios do Ubuntu ou de repositórios de terceiros, permitindo assim que você acompanhe as atualizações assim que novas versões estiverem disponíveis, mas, também podem ser disponibilizados diretamente através de páginas na internet, sem a possibilidade de receber atualizações automaticamente.

Seguindo esse conceito, vou listar alguns métodos mais populares de instalação de programas para o Ubuntu, descrevendo suas possibilidades e dando minhas recomendações sobre o potêncial uso de cada um deles.

## ![synaptic](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/synaptic.svg) Synaptic

O [**Synaptic**](https://savannah.nongnu.org/projects/synaptic) é um gerenciador de pacotes no formato `.deb` e através dele é possível instalar programas disponíveis nos _repositórios_ que estão configurados na sua instalação do Ubuntu, sejam eles os repositórios padrão do Ubuntu, PPAs do Launchpad ou repositórios de terceiros.

Ele é um _frontend_ para o `apt` e disponibiliza praticamente todas as suas funções através de uma interface gráfica.

![synaptic](https://i.imgur.com/17Vtwfb.png)

Na minha opinião, a real vantagem do **Synaptic** sobre outras centrais de instalação de programas disponíveis para o Ubuntu, é que ele lista absolutamente todos os pacotes disponíveis nos repositórios da sua instalação, enquanto a maioria das demais centrais de programas, listam apenas programas que contém lançadores com ícones, ou seja, programas que você usa na linha de comando, bibliotecas de compatibilidade, entre outros, não são listados por elas, o que torna o **Synaptic** muito mais abrangente.

## ![deb-get](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/distributor-logo-debian.svg) `deb-get`

Conforme eu citei, existem programas que não são disponibilizados através de um repositório, desse modo, você não tem como acompanhar as atualizações desse programa de forma automática, assim que novas versões forem disponibilizadas pelo desenvolvedor, é justamente nesse caso que o [`deb-get`](https://github.com/wimpysworld/deb-get) pode ser uma boa opção, visto que ele disponibiliza a instalação e atualização desses programas diretamente das páginas onde eles são disponibilizadas, te poupando esse tempo de verificar manualmente.

O `deb-get` é um programa feito para linha de comando, porém, ele possui uma interface gráfica desenvolvida por terceiros que facilita o seu uso, se chama [**Deborah**](https://github.com/ymauray/deborah/).

![deborah](https://i.imgur.com/BGzR1DV.png)

O `deb-get` é uma boa opção pra instalar programas sem a necessidade de adicionar repositórios ao sistema, visto que ele mesmo faz esse processo quando necessário, vale a pena dar uma conferida na [página do programa](https://github.com/wimpysworld/deb-get/tree/main/01-main) pra saber todos os programas que ele disponibiliza, são diversos.

## ![pacstall](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/mimetypes/text-x-pkgbuild.svg) Pacstall

O [**Pacstall**](https://pacstall.dev/) faz a instalação dos programas através de receitas, que compila diretamente do código fonte a maioria dos programas disponíveis na sua lista.

Disponível apenas para o uso através da linha de comando, ele não possui nenhuma interface gráfica até o momento.

Ele é fortemente inspirado no [**AUR**](aur.archlinux.org) do [**Arch Linux**](https://archlinux.org).

[Nesta página](https://pacstall.dev/packages) você pode conferir todos os programas que ele disponibiliza.

## ![appimage](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/mimetypes/application-x-iso9660-appimage.svg) AppImage

O formato [**AppImage**](https://appimage.org) é bastante conveniente, porque você não precisa necessariamente instalar, basta baixar o pacote, dar permissão de execução e abrir o programa, ele já vem com todas as dependências necessárias pra execução do programa embutidas no pacote.

![appimage](https://i.imgur.com/7ObNA5R.png)

Confesso que tenho um pouco de resistência a usar programas assim, porque eles tem menos integração com o sistema do que programas instaláveis através de pacotes `.deb`, mas eventualmente eles acabam sendo a única opção viável.

## ![flatpak](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/mimetypes/application-vnd.flatpak.svg) Flatpak e ![snap](https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/22x22/apps/com.github.bartzaalberg.snaptastic.svg) Snap

Eu resolvi englobar esses dois pacotes na mesma descrição, porque apesar de eles terem diferenças significativas, o resultado final é muito próximo.

Assim com o **AppImage**, o [**Flatpak**](https://flatpak.org) e o [**Snap**](https://snapcraft.io) são formatos que vizam carregar todas as depenências necessárias pros programas empacotados nesses formatos, tornando a instalação desses programas _universal_, ou seja, tecnicamente são suportados em qualquer distribuição.

Eu não sou adepto, porque ambos tem uma série de problemas que no meu ponto de vista não justifica o seu uso, até o presente momento.

**Snaps** costumam ser lentos, ter problemas de compatibilidade de temas, além de serem pacotes com tamanho consideravelmente maior do que os `.deb` tradicionais.

**Flatpaks** instalam uma série de dependências adicionais, que são usadas de forma compartilhada entre os programas, o que é até um ponto positivo, porém, dependendo dos programas que você precisar, pode ser que você tenha mais de uma versão dessas dependências, que no meu ponto de vista, é uma redundância, mas os desenvolvedores justificam isso como uma certificação de que o programa vai rodar em qualquer distro.

A leitura que eu faço desses empacotamentos mais _modernos_, é que eles foram criados pra aumentar o _hype_ de empresas maiores, com a premissa de que são _universais_ e no caso dos **snaps**, podem até carregar código proprietário.

Até a data desta postagem, eles não são relevantes ou necessários pra mim, prefiro compilar programas direto do código fonte, mas esse pode não ser o seu caso.

Se você gostou do conteúdo desta postagem e quer receber mais conteúdos como esse, me siga no [**Twitter**](https://twitter.com/rauldipeas).