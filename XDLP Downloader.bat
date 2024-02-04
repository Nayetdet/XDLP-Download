@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
mode con cols=118 lines=35
title XDLP Downloader

rem Define e aplica a cor padrão para uso no script.
set "default_color=03" & rem Fundo preto e letras em cor aqua.
color !default_color!

rem Verifica se os requerimentos estão instalados.
call :checkRequirements

rem Obtém o diretório do script em execução.
set "outputdir=%~dp0"

rem Define as plataformas e os formatos associados aos números de escolha do usuário.
set "platform[1]=YouTube"
set "platform[2]=Spotify"

set "format[1]=--format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --remux-video "mp4""
set "format[2]=--extract-audio --audio-format mp3 --format "(bestaudio[acodec^=opus]/bestaudio)/best""

rem Redireciona o usuário para a escolha da plataforma.
goto :choosePlatform

:printTitle
cls
for %%t in (
     "                              ▀████    ▐████▀ ████████▄   ▄█          ▄███████▄"
     "                                ███▌   ████▀  ███   ▀███ ███         ███    ███"
     "                                 ███  ▐███    ███    ███ ███         ███    ███"
     "                                 ▀███▄███▀    ███    ███ ███         ███    ███"
     "                                 ████▀██▄     ███    ███ ███       ▀█████████▀"
     "                                ▐███  ▀███    ███    ███ ███         ███"
     "                               ▄███     ███▄  ███   ▄███ ███▌    ▄   ███"
     "                              ████       ███▄ ████████▀  █████▄▄██  ▄████▀"
     "                                                         ▀"
     "████████▄   ▄██████▄   ▄█     █▄  ███▄▄▄▄    ▄█        ▄██████▄     ▄████████ ████████▄     ▄████████    ▄████████"
     "███   ▀███ ███    ███ ███     ███ ███▀▀▀██▄ ███       ███    ███   ███    ███ ███   ▀███   ███    ███   ███    ███"
     "███    ███ ███    ███ ███     ███ ███   ███ ███       ███    ███   ███    ███ ███    ███   ███    █▀    ███    ███"
     "███    ███ ███    ███ ███     ███ ███   ███ ███       ███    ███   ███    ███ ███    ███  ▄███▄▄▄      ▄███▄▄▄▄██▀"
     "███    ███ ███    ███ ███     ███ ███   ███ ███       ███    ███ ▀███████████ ███    ███ ▀▀███▀▀▀     ▀▀███▀▀▀▀▀"
     "███    ███ ███    ███ ███     ███ ███   ███ ███       ███    ███   ███    ███ ███    ███   ███    █▄  ▀███████████"
     "███   ▄███ ███    ███ ███ ▄█▄ ███ ███   ███ ███▌    ▄ ███    ███   ███    ███ ███   ▄███   ███    ███   ███    ███"
     "████████▀   ▀██████▀   ▀███▀███▀   ▀█   █▀  █████▄▄██  ▀██████▀    ███    █▀  ████████▀    ██████████   ███    ███"
     "                                            ▀                                                           ███    ███"
) do (
     echo %%~t
)
echo:
exit /b

:printErrorMessage
call :printTitle
echo %*
pause
exit /b

:checkRequirements
rem Requisitos que precisam estar localizados no PATH do sistema.
set "command[0]=where"
set "requirements[0]=py yt-dlp spotdl ffmpeg ffprobe AtomicParsley"
set "path_message[0]=o PATH d"

rem Requisitos que não precisam estar no PATH do sistema.
set "command[1]=py -c "import"
set "requirements[1]=mutagen"
set "path_message[1]="

for /l %%i in (0, 1, 1) do (
    for %%j in (!requirements[%%i]!) do (
        !command[%%i]! %%j > nul 2>&1 || (
          call :printErrorMessage O %%j não está instalado n!path_message[%%i]!o sistema. Instale-o antes de continuar.
          exit
        )
    )
)
exit /b

:handleYTDownload
call :printTitle
echo Escolha o formato digitando o número correspondente:
echo 1. Vídeo + Áudio
echo 2. Áudio
echo:

set "format_num="
set /p "format_num=> "

if not "!format_num!"=="1" if not "!format_num!"=="2" (
     call :printErrorMessage Digite corretamente os argumentos do comando. Tente novamente.
     goto :handleYTDownload
)

call :printTitle
echo Procurando pelo vídeo: !input!
echo Por favor, aguarde enquanto o download é realizado...
echo:

rem Baixa o vídeo do YouTube a partir do yt-dlp.
yt-dlp --output "%%(title)s-%%(id)s.%%(ext)s" ^
       --default-search "ytsearch"            ^
       --throttled-rate 100K                  ^
       --windows-filenames                    ^
       --force-ipv4                           ^
       --geo-bypass                           ^
       --quiet                                ^
       --progress                             ^
       --no-warnings                          ^
       --ignore-errors                        ^
       --no-overwrites                        ^
       --continue                             ^
       --add-metadata                         ^
       --embed-thumbnail                      ^
       !format[%format_num%]!                 ^
       "!input!"
exit /b

:choosePlatform
call :printTitle
echo Escolha a plataforma digitando o número correspondente:
echo 1. !platform[1]!
echo 2. !platform[2]!
echo:

set "platform_num="
set /p "platform_num=> "

if not "!platform_num!"=="1" if not "!platform_num!"=="2" (
     call :printErrorMessage Digite corretamente os argumentos do comando. Tente novamente.
     goto :choosePlatform
)

:handlePlatform
call :printTitle
set "input="
set /p "input=> Insira o nome ou o URL de um vídeo do !platform[%platform_num%]!: "
echo:

if "!platform_num!"=="1" (
     rem Baixa vídeos do YouTube via yt-dlp conforme o formato escolhido pelo usuário.
     call :handleYTDownload
) else (
     call :printTitle
     echo Procurando pela música: !input!
     echo Por favor, aguarde enquanto o download é realizado...
     echo:

     rem Baixa a música do Spotify a partir do spotdl.
     spotdl download "!input!"
)

rem É necessário capturar o valor de errorlevel imediatamente após a execução do yt-dlp ou do spotdl.
set "errorlevelvalue=!errorlevel!"

rem Iniciar o yt-dlp pode fazer com que o console perca a cor.
color !default_color!

rem Tratamento de erros genérico.
if not !errorlevelvalue!==0 (
     call :printErrorMessage Ocorreu um erro durante o download. Tente novamente.
     goto :handlePlatform
)

call :printTitle
echo Download concluído com sucesso. O arquivo foi salvo em:
echo !outputdir:~0,-1!
echo:

:chooseRestart
set "restart="
set /p "restart=> Gostaria de baixar outro vídeo? [S/N]: "

if /i "!restart!"=="s" goto :choosePlatform
if /i not "!restart!"=="n" (
     call :printErrorMessage Resposta inválida. Tente novamente.
     call :printTitle
     goto :chooseRestart
)

call :printTitle
echo Fechando o programa...
pause
endlocal
exit
