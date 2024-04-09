---
title: Como personalizar o bash
date: 2023-04-22 20:10:00 -0300
categories: Guias
tags: como personalizar o bash
image:
  path: https://i.imgur.com/QsbX8ol.jpg
flarum_id: 13
---

O `bash` (Bourne Again SHell), é o interpretador de comandos mais comum nas distribuições Linux.

Ele é uma interface de linha de comando que permite aos usuários interagirem com o sistema operacional Linux por meio de comandos no terminal.

O `bash` suporta uma ampla gama de comandos, que podem ser usados para executar tarefas como manipulação de arquivos e diretórios, gerenciamento de processos, automação de tarefas, redirecionamento de entrada/saída, criação de scripts e muito mais.

Ele também suporta recursos avançados, como substituição de variáveis, expansão de curingas, controle de fluxo, histórico de comandos e a personalização do ambiente de shell.

Eu poderia escrever muita coisa sobre ele, visto que ele já é bastante antigo e existem muitas formas de explorar suas capacidades, porém, vou me ater as minhas personalizações e as explicações sobre a necessidade de cada uma delas, pra que você possa tirar suas próprias conclusões sobre o assunto.

## Arquivos de configuração do `bash`

Eu uso arquivos separados pra cada personalização e complemento que eu adiciono ao `bash`, dessa forma, fica mais fácil organizar, ativar e desativar recursos de acordo com a necessidade, tudo isso é feito usando a pasta `"$HOME"/.bashrc.d`, onde eu armazeno todos os scripts.

Pra criar essa pasta e fazer com que os scripts sejam carregados, basta executar os comandos abaixo:
```bash
mkdir -p "$HOME"/.bashrc.d
sed -i '/^# bashrc.d/{N;N;N;d;}' "$HOME"/.bashrc
cat <<EOF |tee -a "$HOME"/.bashrc>/dev/null
# bashrc.d
for script in "\$HOME"/.bashrc.d/*.bash;do
	source \$script
done
EOF
```

O que nós fizemos até aqui, além de criar a pasta necessária, foi adicionar algumas linhas ao final do arquivo `"$HOME"/.bashrc`, para que ele busque por scripts com a extensão `.bash` dentro da pasta `"$HOME"/.bashrc.d`, até esse ponto, nenhuma modificação no comportamento do `bash` foi implementada, mas já estamos preparados pra elas.

Ao longo de quase 2 décadas usando Linux, eu descobri uma série de melhorias que podem ser feitas no `bash` pra que ele se torne mais fácild e usar, afinal de contas, o terminal nunca é amistoso a primeira vista e quanto mais nós pudermos mitigar essa estranhesa, melhor, não?

## `atuin`
![atuin](https://github.com/ellie/atuin/raw/main/demo.gif)

O primiro dos complementos que eu gostaria de indicar é o [`atuin`](https://github.com/ellie/atuin/), que é um gerenciador de histórico de comandos.

A real necessidade para um complemento como esse, é que por padrão o `bash` não te dá um histórico completo dos comandos que você já executou anteriormente, sem um programa como o `atuin`, você tem que digitar um termo e ir pressionando `Ctrl+R` repetidamente pra navegar no histórico, o que é um pouco cansativo e até confuso na minha perspectiva, com o `atuin` você preciona `Ctrl+R` apenas uma vez e daí já pode começar a navegar no histórico usando as setas do teclado, ou se quiser pesquisar por algo, basta começar a escrever a parte do comando que você lembra, ele faz uma busca completa no histórico, é excelente e facilita muito o uso de comandos longos e que você só usa eventualmente, te dando a comodidade de não precisar decorar nada.

Para instalar o `atuin` no **Ubuntu**, basta executar os comandos abaixo:
```bash
wget -cq --show-progress "$(wget -qO- https://api.github.com/repos/ellie/atuin/releases|grep browser_download_url|grep .deb|head -n1|cut -d '"' -f4)"
sudo apt install ./atuin*.deb
rm atuin*.deb
wget -qO- "$HOME"/.bashrc.d/bash-preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
cat <<EOF |tee "$HOME"/.bashrc.d/atuin.bash>/dev/null
[[ -f ~/.bashrc.d/bash-preexec.sh ]] && source ~/.bashrc.d/bash-preexec.sh
eval "\$(atuin init bash --disable-up-arrow)"
EOF
```

Após a execução dos comandos, basta reiniciar o terminal e pressionar `Ctrl+R` pra exibir o histórico de comandos com o `atuin`.

## `bash` line editor (`ble.sh`)
O [`bash` line editor](https://github.com/akinomyoga/ble.sh), que vamos chamar de `ble.sh`, pra simplificar, é um complemento que abrange vários recursos diferentes, mas eu vou me ater apenas ao que eu faço uso, que é a _sugestão_ de comandos, ou seja, quando você começar a digitar algo no terminal, com base no seu histórico de comandos, o `ble.sh` já vai indicar o restante do comando, bastando você pressionar a seta direita do teclado pra autocompletar.

Se você faz um uso intenso do terminal, isso ajuda demais, pois poupa muito tempo na hora de digitar os comandos.

Para instalar o `ble.sh` no **Ubuntu**, basta executar os comandos abaixo:
```bash
sudo apt install build-essential git
git clone -q --recursive https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX="$HOME"/.local>/dev/null
cat <<EOF |tee "$HOME"/.bashrc.d/blesh.bash>/dev/null
source "\$HOME"/.local/share/blesh/ble.sh
EOF
cat <<EOF |tee "$HOME"/.blerc>/dev/null
ble-face -s auto_complete fg=238,bg=000
bleopt complete_auto_delay=300
EOF
rm -rf ble.sh*
```

Após a execução dos comandos, basta reiniciar o terminal pra começar a receber as sugestões dos comandos.

# `fzf` & `bat`
![fzf-dir](https://armno.in.th/images/fzf/cover.png)

O [`fzf`](https://github.com/junegunn/fzf) é um comando complementar para vários outros comandos indicados neste guia, mas pra descrever o que ele pode fazer, basicamente ele é um _buscador difuso_, ou seja, ele é capaz de fazer pesquisas interativas dentro de vários tipos de contexto, é bastante difícil descrever tudo que ele pode fazer, mas posso deixar aqui a descrição do próprio desenvolvedor:
> É um filtro Unix interativo para linha de comando que pode ser usado com qualquer lista; arquivos, histórico de comandos, processos, nomes de host, favoritos, git commits, etc.

Sei que pode parecer algo confuso de entender, eu mesmo demorei pra assimilar, mas na prática, vamos usar ele pra navegar em arquivos dentro de pastas, com uma _previsão_ do conteúdo para arquivos de texto, o que ajuda bastante na hora de conferir scripts ou anotações em texto puro que você tem guardados numa determinada pasta.

Além do `fzf`, nós vamos instalar também o [`bat`](https://github.com/sharkdp/bat), que é responsável pela exibição do conteúdo dos arquivos dentro deste contexto.

Pra instalar o `fzf` e o `bat`  no **Ubuntu**, basta executar os comandos abaixo:
```bash
wget -q --show-progress "$(wget -qO- https://api.github.com/repos/sharkdp/bat/releases|grep browser_download_url|grep amd64.deb|grep -v musl|head -n1|cut -d '"' -f4)"
sudo apt install ./bat*.deb fzf
rm bat*.deb
cat <<EOF |sudo tee /usr/local/bin/fzf-dir>/dev/null
#!/bin/bash
set -e
/usr/bin/fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
EOF
sudo chmod +x /usr/local/bin/fzf-dir
```

Após a execução dos comandos, você pode navegar até um diretório que contém arquivos de texto e rodar o comando `fzf-dir`, daí é só começar a navegar nos arquivos com as setas do teclado, todos os arquivos de texto terão uma previsão ao lado direito.

## `liquidprompt`
![liquidprompt](https://raw.githubusercontent.com/nojhan/liquidprompt/master/docs/theme/included/powerline-med.png)
O [`liquidprompt`](https://github.com/nojhan/liquidprompt) é um tema no estilo _powershell_/_agnoster_ para o `bash`.

Com ele, além da visualização melhorada do nome do host, usuário e pasta atual, você tem indicações de estado em pastas de repositório `git`, por exemplo, o que ajuda bastanta pra saber em que pé anda o desenvolvimento do seu projeto dentro dessa pasta.

Pra instalar o `liquidprompt` no **Ubuntu**, basta executar os comandos abaixo:
```bash
wget -q --show-progress http://ftp.us.debian.org/debian/pool/main/l/liquidprompt/$(wget -qO- http://ftp.us.debian.org/debian/pool/main/l/liquidprompt/|grep all.deb|tail -n1|cut -d '"' -f8)
sudo apt install ./liquidprompt*.deb
rm liquidprompt*.deb
cp /usr/share/liquidprompt/liquidpromptrc-dist .config/liquidpromptrc
sed -i 's/debian.theme/powerline.theme/g' "$HOME"/.config/liquidpromptrc
cat <<EOF |"$HOME"/.bashrc.d/liquidprompt.bash>/dev/null
echo \$- | grep -q i 2>/dev/null && . /usr/share/liquidprompt/liquidprompt
lp_theme powerline
EOF
```

Após a execução dos comandos, basta reiniciar o terminal para que o tema com os novos recursos seja exibido.

## `micro`
![micro](https://micro-editor.github.io/screenshots/micro-monokai.png)

O [`micro`](https://micro-editor.github.io) é um editor de texto para o terminal, que diferente do `nano`, por exemplo (que é o editor padrão na maioria das distribuições Linux), usa atalhos comuns como `Ctrl+S` pra salvar e `Ctrl+Q` pra sair, só pra citar alguns exemplos, além de não ser necessário usar o `sudo` pra editar arquivos com permissão de superusuário, a senha de aministrador só é solicitada na hora de salvar o arquivo.

Pra instalar o `micro` no **Ubuntu**, basta executar os comandos abaixo:
```bash
wget -q --show-progress "$(wget -qO- https://api.github.com/repos/zyedidia/micro/releases|grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"
sudo apt install ./micro*.deb
rm micro*.deb
mkdir -p "$HOME"/.config/micro
cat <<EOF |tee "$HOME"/.config/micro/settings.json>/dev/null
{
	"eofnewline": false,
}
EOF
```

Após a execução dos comandos, basta executar o comando `micro` para começar a editar seus arquivos.

## `ntfy`
![ntfy](https://raw.githubusercontent.com/dschep/ntfy/master/docs/demo.gif)

O [`ntfy`](https://github.com/dschep/ntfy) é um notificador para comandos demorados no terminal, ou seja, toda vez que você executar um comando que demora bastante tempo pra ser concluído, ao concluir a operação o terminal vai exibir uma notificação na sua área de trabalho ou no seu celular (opcional), pra te indicar que o processo terminou, o tempo mínimo pra notificações pode ser ajustado de acordo com suas necessidades, por padrão ele exibe notificações para comandos que demoram acima de 10s.

Para instalar o `ntfy` no **Ubuntu**, basta executar os comandos abaixo:
```bash
sudo apt install libnotify-bin pipx
pipx install --system-site-packages ntfy
cat <<EOF |tee "$HOME"/.bashrc.d/ntfy.bash>/dev/null
PATH="\$PATH":"\$HOME"/.local/bin
eval "\$(ntfy shell-integration)"
EOF
```

Após a execução dos comandos, basta reiniciar o terminal para que as notificações de comandos demorados comecem a ser exibidas.

Se você gostou do conteúdo desta postagem e quer receber mais conteúdos como esse, me siga no [**Twitter**](https://twitter.com/rauldipeas).