# XDLP Downloader
Script feito em batch desenvolvido com o intuito de simplificar o processo de download de vídeos do Youtube e de músicas do Spotify, o que só foi possível graças às ferramentas yt-dlp e spotdl. Em essência, este código consiste em uma camada superficial sobre essas ferramentas, tornando o processo mais acessível e intuitivo.

## Pré-Requisitos
Antes de usar este script, certifique-se de ter as seguintes ferramentas instaladas:
- **Python:** É necessário ter o Python instalado no seu sistema. Você pode baixá-lo [aqui](https://www.python.org/). Durante a instalação, marque a opção "Adicionar Python ao PATH" para facilitar o acesso às ferramentas via terminal.
- **yt-dlp:** Ferramenta para baixar vídeos do YouTube. Pode ser instalado via `pip install yt-dlp` ou diretamente do [repositório oficial do yt-dlp](https://github.com/yt-dlp/yt-dlp#installation).
- **spotdl:** Ferramenta para baixar músicas do Spotify. Instale via `pip install spotdl`.
- **ffmpeg:** Ferramenta para manipulação de áudio e vídeo. Faça o download no [site oficial do FFmpeg](https://ffmpeg.org/download.html) e certifique-se de adicionar o diretório dele ao PATH do sistema.
- **AtomicParsley:** Ferramenta para manipulação de metadados de vídeo. Faça o download no [repositório oficial do AtomicParsley](https://github.com/wez/atomicparsley/releases).
- **mutagen:** Biblioteca para manipulação de metadados de áudio. Instale via `pip install mutagen`.
> Certifique-se de que todas as ferramentas e dependências estejam corretamente configuradas em seu Windows. Verifique se yt-dlp, spotdl, ffmpeg e AtomicParsley estão acessíveis via terminal e adicionados ao PATH do sistema.

## Utilização
1. Faça o download ou clone este repositório para o seu sistema.
2. Abra um terminal ou prompt de comando.
3. Navegue até o diretório onde o script está localizado.
4. Execute o script "XDLP Downloader.bat".
5. Escolha a plataforma desejada (YouTube ou Spotify).
6. Insira o nome ou URL do vídeo/música que deseja baixar.
7. Siga as instruções no terminal para completar o processo de download.
8. O arquivo será salvo no diretório de downloads padrão do seu sistema.

## Notas
- Além de permitir o download de vídeos do YouTube, o script oferece a flexibilidade de explorar outros sites suportados pelo yt-dlp. Ao utilizar o script, você tem a opção de pesquisar e baixar conteúdo de uma ampla variedade de plataformas suportadas. Consulte a [documentação completa do yt-dlp](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md) para obter a lista abrangente de sites suportados e as diversas opções de pesquisa disponíveis.
