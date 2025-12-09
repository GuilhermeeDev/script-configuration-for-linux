# Linux AutoSetup 🐧  
Migrar para uma nova distribuição Linux — ou até mesmo reinstalar o sistema — pode ser um processo demorado, repetitivo e cheio de pequenos
ajustes. Pensando nisso, nasceu o Linux AutoSetup, uma ferramenta interativa que automatiza a configuração inicial do sistema, instala pacotes essenciais, detecta a distribuição em uso, adiciona repositórios oficiais e cria um ambiente pronto para uso em poucos minutos.

Este projeto foi criado para ajudar:
- quem está migrando do Windows para o Linux
- quem instalou uma distro nova e quer deixar tudo pronto rapidamente
- desenvolvedores que precisam montar o ambiente de trabalho sem perder tempo
- usuários que querem automação, praticidade e padronização
Com suporte às principais distribuições do ecossistema Linux!

---

Este projeto fornece ferramentas como:
- Instalação de dependências essenciais
- Instalação de pacotes básicos ou de desenvolvimento
- Adição de repositórios oficiais
- (futuro) configuração de ambientes
- (futuro) configuração de 
- (futuro) Beautiful Linux!
- (futuro) instalação e configuração de terminal personalizado.

---

## Suporte
|\---------------------------------------------------------------------------/|
|🐧 Distro                              | 📦 Gerenciador de Pacotes |  Status |
|🟧 Debian-based (Ubuntu, Mint, Pop!_OS)|   apt	                    |    ✅   |
|🟦 Arch-based   (Arch, Manjaro)	    |   pacman	                |    ✅   |
|🟪 Fedora	                            |   dnf	                    |    ✅   |
|🟩 openSUSE	                        |   zypper                  |    ✅   |
|/---------------------------------------------------------------------------\|

## Funcionalidades principais

### 1. **Instalação de Pacotes**
- O usuário pode instalar pacotes a partir de arquivos `.txt` predefinidos.
- O usuário pode editar arquivos `.txt` para adicionar pacotes.

### 2. **Adição de Repositórios Oficiais**
Cada distro possui repositórios dedicadas:
- Ubuntu/Debian/Mint/Pop!_OS → Universe, Multiverse, Restricted.
- Arch → Multilib, Chaotic-AUR.
- Fedora → RPM Fusion. 
- openSUSE → Repositórios main/community.

---

## Requisitos
- Bash 4+
- Permissão de sudo
- Conexão com a internet
---