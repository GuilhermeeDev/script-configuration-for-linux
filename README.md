# Linux AutoSetup 🐧

## O que é?
Migrar para uma distribuição Linux ou até mesmo mudar de distro pode ser um processo repetitivo e cheio de pequenos ajustes. Pensando nisso, nasceu o Linux AutoSetup, uma ferramenta que automatiza a configuração inicial do sistema, instala pacotes essenciais, adiciona repositórios oficiais/extra oficiais e cria um ambiente pronto para uso, podendo até te ajudar a personalizar a sua distro!

## Para que serve?
Este projeto foi criado para ajudar:
- quem está migrando do Windows para o Linux
- quem instalou uma distro nova e quer deixar tudo pronto rapidamente
- usuários que querem automação, praticidade e padronização

---
## 🔧 Ferramentas
Este projeto fornece ferramentas como:
- Adição de repositórios oficiais
- Instalação de pacotes básicos e de desenvolvimento
- Instalação de pacotes guiada
- (futuro) Configuração base de ambientes
- (futuro) Instalação e configuração de terminal personalizado
- (futuro) Configuração de automatizações do sistema.
- (futuro) Pacotão -lfs com app's .deb | .appImage |
---

## Suporte

```sh
    🐧 Distro       | 🟧 Debian-based | 🟦 Arch-based | 🟪 Fedora | 🟨 openSUSE | 🟩 Alpine |
---------------------------------------------------------------------------------------------
📦 Inst. de pacotes |       ✅        |       ✅      |      ✅   |      ✅     |     ❌    | 
🗃️ Ad. Repositorios |       ✅        |       ❌      |      ❌   |      ❌     |     ❌    |
🛠️ Inst. Terminal   |       ❌        |       ❌      |      ❌   |      ❌     |     ❌    |
🌟 Automatizações   |       ❌        |       ❌      |      ❌   |      ❌     |     ❌    | 
```

## Funcionalidades principais

### 1. **Instalação de Pacotes**
- O usuário pode instalar pacotes atraves de uma instalação guiada (Perguntas de Sim ou Não).
- O usuário pode editar arquivos de instalação de pacotes (necessario saber o nome da pacote).
- O usuário pode instalar pacotes pré-definidos para uso básico do linux.
- O usuário pode instalar pacotes para desenvolver/programar em linux.
- 
### 2. **Adição de Repositórios Oficiais e extra oficiais**
Cada distro possui repositórios dedicadas:
- Ubuntu/Debian/Mint/Pop!_OS → Universe, Multiverse, Restricted ++ extra oficiais.
- Arch/Manjaro → Multilib, Chaotic-AUR.
- openSUSE → Repositórios main/community.
- Fedora → RPM Fusion. 

### 3. **Instalação e configuração de terminal personalizado**
(futuro)
### 4. **Configuração de automatizações para a sua distro**
(futuro)
---

## Requisitos
- permissão de sudo
- conexão com a internet
- bash 4+
- git instalado

---

## Como rodar na minha máquina? 
Primeiro certifique-se de ter o `git` instalado no seu linux: `git --version`
saida esperada `git version 2.*.*`

Clone o repositório git.
```sh
git clone https://github.com/GuilhermeeDev/script-Linux-auto-setup.git
```

Acesse o diretorio raiz e execute o script `./main.sh`:
```sh
cd src
./main.sh
```

---

## O que devo ter em mente antes de abrir um Pull Request?
- Esse é um projeto opensource para a comunidade e contribuições são bem-vindas!
- Em caso de duvida, sugestões ou erros abra uma issue.
- Antes de contribuir com o projeto verifique [lista de ideias para contribuição](./docs/TODOLIST.md).
- Quer contribuir com o projeto? [passo a passo](./docs/CONTRIBUTING.md)
