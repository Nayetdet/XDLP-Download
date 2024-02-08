@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul & rem Formata o console para o padrão UTF-8.
title XDLP Downloader

rem Define e aplica o tamanho da janela do console para uso no script.
rem Ajuste inicial que mantém o tamanho da tela fixo, mesmo se o usuário interagir com o console antes do término de "checkRequirements".
set "cols=118" & set "lines=35"
mode con cols=!cols! lines=!lines!

rem Define e cor padrão para uso no script.
set "default_color=03" & rem Fundo preto e letras em cor aqua.

rem Mensagens de erro.
set "missing_arguments_error_message=Digite corretamente os argumentos do comando. Tente novamente."
set "download_error_message=Ocorreu um erro durante o download. Tente novamente."

rem Chamada geral de blocos de código:
call :checkRequirements & rem Verifica se os requerimentos mínimos estão instalados.
call :getDownloadsFolderPath & rem Obtém o diretório de downloads padrão do registro do Windows.
goto :choosePlatform & rem Redireciona o usuário para a escolha da plataforma (YouTube ou Spotify).

:printTitle
mode con cols=!cols! lines=!lines! & rem Mantém o tamanho da tela fixo, mesmo se o usuário redimensionar a tela.
color !default_color! & rem Evita que o console perca a cor durante a aplicação.
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
set "requirements[0]=py yt-dlp spotdl ffmpeg ffprobe AtomicParsley"
set "path_error_message[0]=o PATH d"

set "command[0][0]=where"
set "command[0][1]="

rem Requisitos que não precisam estar no PATH do sistema.
set "requirements[1]=mutagen"
set "path_error_message[1]="

set "command[1][0]=py -c"
set "command[1][1]=import"

rem Verificação efetiva dos requerimentos.
for /l %%i in (0, 1, 1) do (
     for %%j in (!requirements[%%i]!) do (
          !command[%%i][0]! "!command[%%i][1]! %%j" > nul 2>&1 || (
               call :printErrorMessage O %%j não está instalado n!path_error_message[%%i]!o sistema. Instale-o antes de continuar.
               exit
          )
     )
)
exit /b

:getDownloadsFolderPath
set "registry_key_path=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
set "downloads_folder_id={374DE290-123F-4565-9164-39C4925E467B}"
for /f "usebackq tokens=2,*" %%a in (`reg query "!registry_key_path!" /v "!downloads_folder_id!"`) do (
    set "downloads_path=%%b"
)
exit /b

:handleYouTubeDownload
call :printTitle
echo Escolha o formato digitando o número correspondente:
echo 1. Vídeo + Áudio
echo 2. Áudio
echo:

set "format_num="
set /p "format_num=> "

if "!format_num!"=="1" (
     set "format=--format bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best --remux-video mp4"
) else if "!format_num!"=="2" (
     set "format=--extract-audio --audio-format mp3 --format (bestaudio[acodec^=opus]/bestaudio)/best"
) else (
     call :printErrorMessage !missing_arguments_error_message!
     goto :handleYouTubeDownload
)

call :printTitle
echo Procurando pelo vídeo: !input!
echo Por favor, aguarde enquanto o download é realizado...
echo:

yt-dlp --output "!downloads_path!\%%(title)s.%%(ext)s" ^
       --default-search "ytsearch"                     ^
       --throttled-rate 100K                           ^
       --windows-filenames                             ^
       --force-ipv4                                    ^
       --geo-bypass                                    ^
       --quiet                                         ^
       --progress                                      ^
       --no-warnings                                   ^
       --ignore-errors                                 ^
       --no-overwrites                                 ^
       --continue                                      ^
       --add-metadata                                  ^
       --embed-thumbnail                               ^
       !format!                                        ^
       "!input!"
exit /b

:handleSpotifyDownload
call :printTitle
echo Procurando pela música: !input!
echo Por favor, aguarde enquanto o download é realizado...
echo:

cd /d !downloads_path! & rem Garante que o spotdl salve os arquivos na pasta de downloads do usuário.
spotdl download "!input!"
exit /b

:choosePlatform
call :printTitle
echo Escolha a plataforma digitando o número correspondente:
echo 1. YouTube
echo 2. Spotify
echo:

set "platform_num="
set /p "platform_num=> "

if "%platform_num%"=="1" (set "platform=YouTube") else if "%platform_num%"=="2" (set "platform=Spotify") else (
    call :printErrorMessage !missing_arguments_error_message!
    goto :choosePlatform
)

:handlePlatform
call :printTitle
set "input="
set /p "input=> Insira o nome ou o URL de um vídeo do !platform!: "
echo:

if "!platform_num!"=="1" (
     rem Baixa o vídeo do YouTube.
     call :handleYouTubeDownload
) else (
     rem Baixa o vídeo do Spotify.
     call :handleSpotifyDownload
)

rem Tratamento de erros genérico.
if not !errorlevel!==0 (
     call :printErrorMessage !download_error_message!
     goto :handlePlatform
)

call :printTitle
echo Download concluído com sucesso. O arquivo foi salvo em:
echo !downloads_path!
echo:

rem Verifica se a pasta Downloads está aberta ou não e a abre se não estiver.
for /f %%d in ("!downloads_path!") do set "downloads_folder_name=%%~nd"
tasklist /fi "WINDOWTITLE eq !downloads_folder_name!" | findstr /i explorer.exe > nul
if not !errorlevel!==0 (
    explorer "!downloads_path!"
)

:chooseRestart
set "restart="
set /p "restart=> Gostaria de baixar outro vídeo? [S/N]: "

if /i "!restart!"=="s" (
     goto :choosePlatform
) else if /i "!restart!"=="n" (
     call :printTitle
     echo Fechando o programa...
     timeout /t 3 /nobreak > nul
     endlocal
     exit
) else (
     call :printErrorMessage !missing_arguments_error_message!
     call :printTitle
     goto :chooseRestart
)
