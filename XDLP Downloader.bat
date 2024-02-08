@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul & rem Formata o console para o padrão UTF-8.
title XDLP Downloader

rem Define e aplica o tamanho da janela do console para uso no script.
rem Ajuste inicial que mantém o tamanho da tela fixo, mesmo se o usuário interagir com o console antes do término de "checkDependencies".
set "DEFAULT_COLS=118" & set "DEFAULT_LINES=35"
mode con cols=!DEFAULT_COLS! lines=!DEFAULT_LINES!

rem Define e cor padrão para uso no script.
set "DEFAULT_COLOR=03" & rem Fundo preto e letras em cor aqua.

rem Mensagens de erro:
set "MISSING_ARGUMENTS_ERROR_MESSAGE=Digite corretamente os argumentos do comando. Tente novamente."
set "DOWNLOAD_ERROR_MESSAGE=Ocorreu um erro durante o download. Tente novamente."

rem Execução dos blocos de código principais:
call :checkDependencies
call :retrieveDownloadsPath
goto :selectPlatform

:displayTitle
mode con cols=!DEFAULT_COLS! lines=!DEFAULT_LINES! & rem Mantém o tamanho da tela fixo, mesmo se o usuário redimensionar a tela.
color !DEFAULT_COLOR! & rem Evita que o console perca a cor durante a aplicação.
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

:displayErrorMessage
call :displayTitle
echo %*
pause
exit /b

:checkDependencies
rem Dependências que precisam estar localizados no PATH do sistema.
set "DEPENDENCIES[0]=py yt-dlp spotdl ffmpeg ffprobe AtomicParsley"
set "PATH_ERROR_MESSAGE[0]=o PATH d"

set "COMMAND[0][0]=where"
set "COMMAND[0][1]="

rem Dependências que não precisam estar no PATH do sistema.
set "DEPENDENCIES[1]=mutagen"
set "PATH_ERROR_MESSAGE[1]="

set "COMMAND[1][0]=py -c"
set "COMMAND[1][1]=import"

rem Realiza uma verificação efetiva das dependências.
for /l %%i in (0, 1, 1) do (
     for %%j in (!DEPENDENCIES[%%i]!) do (
          !COMMAND[%%i][0]! "!COMMAND[%%i][1]! %%j" > nul 2>&1 || (
               call :displayErrorMessage O %%j não está instalado n!PATH_ERROR_MESSAGE[%%i]!o sistema. Instale-o antes de continuar.
               exit
          )
     )
)
exit /b

:retrieveDownloadsPath
rem Obtém o diretório de downloads padrão do registro do Windows.
set "REGISTRY_KEY_PATH=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
set "DOWNLOADS_FOLDER_ID={374DE290-123F-4565-9164-39C4925E467B}"
for /f "usebackq tokens=2,*" %%a in (`reg query "!REGISTRY_KEY_PATH!" /v "!DOWNLOADS_FOLDER_ID!"`) do (
    set "downloads_path=%%b"
)
exit /b

:handleYouTubeDownload
call :displayTitle
echo Escolha o formato digitando o número correspondente:
echo 1. Vídeo + Áudio
echo 2. Áudio
echo:

set "media_format_num="
set /p "media_format_num=> "

if "!media_format_num!"=="1" (
     set "media_type=o vídeo"
     set "media_format=--format bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best --format-sort vcodec:h264,res,acodec:m4a --remux-video mp4"
) else if "!media_format_num!"=="2" (
     set "media_type=a música"
     set "media_format=--extract-audio --audio-format mp3 --audio-quality 0"
) else (
     call :displayErrorMessage !MISSING_ARGUMENTS_ERROR_MESSAGE!
     goto :handleYouTubeDownload
)

call :displayTitle
echo Procurando pel!media_type! no !platform!: !query!
echo Por favor, aguarde enquanto o download é realizado...
echo:

rem Realiza o download efetivo do vídeo do YouTube.
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
       !media_format!                                  ^
       "!query!"
exit /b

:handleSpotifyDownload
call :displayTitle
echo Procurando pela música no !platform!: !query!
echo Por favor, aguarde enquanto o download é realizado...
echo:

rem Garante que o spotdl salve os arquivos na pasta de downloads do usuário.
cd /d !downloads_path!

rem Realiza o download efetivo da música do Spotify.
spotdl download "!query!"
exit /b

:selectPlatform
call :displayTitle
echo Escolha a plataforma digitando o número correspondente:
echo 1. YouTube
echo 2. Spotify
echo:

set "platform_num="
set /p "platform_num=> "

if "!platform_num!"=="1" (
     set "platform=Youtube"
) else if "!platform_num!"=="2" (
     set "platform=Spotify"
) else (
    call :displayErrorMessage !MISSING_ARGUMENTS_ERROR_MESSAGE!
    goto :selectPlatform
)

:handlePlatformSelection
call :displayTitle
set "query="
set /p "query=> Insira o nome ou o URL de algum conteúdo do !platform!: "
echo:

if "!platform_num!"=="1" (
     call :handleYouTubeDownload
) else if "!platform_num!"=="2" (
     call :handleSpotifyDownload
) else (
     call :displayErrorMessage !MISSING_ARGUMENTS_ERROR_MESSAGE!
     goto :selectPlatform
)

rem Verifica se ocorreu algum erro durante o download.
if not !errorlevel!==0 (
     call :displayErrorMessage !DOWNLOAD_ERROR_MESSAGE!
     goto :handlePlatformSelection
)

call :displayTitle
echo Download concluído com sucesso. O arquivo foi salvo em:
echo !downloads_path!
echo:

rem Verifica se a pasta Downloads está aberta ou não e a abre se não estiver.
for /f %%d in ("!downloads_path!") do set "downloads_folder_name=%%~nd"
tasklist /fi "WINDOWTITLE eq !downloads_folder_name!" | findstr /i explorer.exe > nul
if not !errorlevel!==0 (
    explorer "!downloads_path!"
)

:requestRestart
set "restart_choice="
set /p "restart_choice=> Gostaria de baixar outro vídeo? [S/N]: "

if /i "!restart_choice!"=="s" (
     goto :selectPlatform
) else if /i "!restart_choice!"=="n" (
     call :displayTitle
     echo Fechando o programa...
     timeout /t 1 /nobreak > nul
     endlocal
     exit
) else (
     call :displayErrorMessage !MISSING_ARGUMENTS_ERROR_MESSAGE!
     call :displayTitle
     goto :requestRestart
)
 
