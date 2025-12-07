# Subtitles - Player de Mídia Multi-Idioma

Um aplicativo player de mídia baseado em Flutter que exibe legendas sincronizadas em vários idiomas, projetado para ajudar usuários a aprenderem idiomas enquanto curtem suas músicas e conteúdos de mídia favoritos.

## 🎯 Propósito

Subtitles é um aplicativo mobile e desktop que aprimora o consumo de mídia fornecendo legendas sincronizadas em tempo real em múltiplos idiomas. Perfeito para:

- **Aprendizado de Idiomas**: Compare letras no seu idioma nativo com o idioma que você está aprendendo
- **Apreciação Musical**: Entenda melhor as letras das músicas com traduções precisas
- **Acessibilidade**: Acompanhe o conteúdo de mídia através de exibição de texto
- **Suporte Multi-Idioma**: Alterne entre diferentes idiomas de legenda em tempo real

## ✨ Funcionalidades

- **Exibição de Legendas Multi-Idioma**: Visualize legendas em dois idiomas simultaneamente (Inglês + Português/Francês)
- **Sincronização em Tempo Real**: As legendas destacam e rolam automaticamente conforme a mídia toca
- **Gerenciamento de Biblioteca de Mídia**: Importe e organize suas músicas com arquivos de legenda correspondentes
- **Suporte a Arquivos SRT**: Compatibilidade com formato padrão de legendas SubRip (.srt)
- **Controles de Reprodução de Áudio**: Reproduza, pause e navegue pela sua mídia
- **Interface Linda**: Design baseado em gradientes com animações suaves
- **Rolagem Automática**: As legendas rolam automaticamente para manter a linha atual centralizada
- **Alternância de Idiomas**: Alterne entre diferentes idiomas de legenda (Português ↔ Francês)

## 📱 Screenshots

O aplicativo apresenta:
- Uma página de biblioteca de mídia para navegar pelas suas músicas importadas
- Uma página de player com exibição de legendas em dois idiomas
- Controles de mídia para gerenciamento de reprodução
- Destaque de legendas em tempo real

## 🚀 Começando

### Pré-requisitos

- Flutter SDK (>=3.4.0)
- Dart SDK (>=3.4.0)
- Para iOS: Xcode e CocoaPods
- Para Android: Android Studio

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/yourusername/subtitles.git
   cd subtitles
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Para iOS (se estiver rodando no macOS)**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Executando o App

#### Modo de Desenvolvimento

**No iOS:**
```bash
flutter run -d ios
```

**No Android:**
```bash
flutter run -d android
```

**No macOS:**
```bash
flutter run -d macos
```

**No Windows:**
```bash
flutter run -d windows
```

**No Linux:**
```bash
flutter run -d linux
```

#### Modo Release

```bash
flutter run --release
```

## 📂 Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada do app
├── models/
│   ├── media_item.dart               # Modelo de dados de arquivo de mídia
│   ├── subtitle_data.dart            # Modelo de dados de linha de legenda
│   └── subtitle_file.dart            # Metadados de arquivo de legenda
├── screens/
│   ├── home_page.dart                # Tela do player com legendas
│   └── media_list_page.dart          # Tela da biblioteca de mídia
├── services/
│   ├── media_library_service.dart    # Gerenciamento de arquivos de mídia
│   └── srt_parser.dart               # Parser de legendas SRT
└── widgets/
    ├── import_media_dialog.dart      # Diálogo de importação de mídia
    ├── media_controls.dart           # Controles de reprodução de áudio
    └── subtitle_line.dart            # Widget de exibição de legenda

assets/
├── media/                            # Arquivos de áudio (.mp3, .m4a, etc.)
└── subtitles/                        # Arquivos de legenda (.srt)
```

## 🎵 Adicionando Arquivos de Mídia

### Opção 1: Mídia Pré-empacotada (Desenvolvimento)

1. Coloque seus arquivos de áudio em `assets/media/`
2. Coloque os arquivos de legenda correspondentes em `assets/subtitles/`
3. Convenção de nomenclatura de legendas: `[Artista] - [Título da Música].[idioma].srt`
   - Exemplo: `Travis Scott - goosebumps.en.srt`
   - Exemplo: `Travis Scott - goosebumps.pt.srt`
   - Exemplo: `Travis Scott - goosebumps.fr.srt`

4. Atualize o [`pubspec.yaml`](pubspec.yaml):
   ```yaml
   flutter:
     assets:
       - assets/media/
       - assets/subtitles/
   ```

### Opção 2: Importar em Tempo de Execução

1. Toque no botão **+** na biblioteca de mídia
2. Selecione seu arquivo de áudio (.mp3, .m4a, .wav, etc.)
3. (Opcional) Selecione arquivos de legenda (.srt)
4. Preencha o título da música e o artista
5. Toque em **Importar**

## 📝 Formato de Legenda

O app usa o formato padrão de legendas SRT (SubRip):

```srt
1
00:00:15,800 --> 00:00:17,000
Primeira linha de texto

2
00:00:21,600 --> 00:00:24,000
Segunda linha de texto
```

## 🛠️ Dependências

Principais pacotes utilizados:
- [`just_audio`](https://pub.dev/packages/just_audio) (^0.9.38) - Reprodução de áudio
- [`file_picker`](https://pub.dev/packages/file_picker) (^8.0.0+1) - Seleção de arquivos
- [`path_provider`](https://pub.dev/packages/path_provider) (^2.1.1) - Caminhos de armazenamento local
- [`permission_handler`](https://pub.dev/packages/permission_handler) (^11.1.0) - Permissões de arquivos

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para enviar um Pull Request.

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

## 🙏 Agradecimentos

- Construído com Flutter
- Usa o formato de legendas SubRip (.srt)
- Inspirado em aplicativos de aprendizado de idiomas e apreciação musical

## 🐛 Problemas Conhecidos

- Crash no iOS no lançamento inicial com Dart VM (veja seção de solução de problemas)
- Escaneamento de assets pode não funcionar em todas as plataformas (use a funcionalidade de importação em vez disso)

## 💡 Melhorias Futuras

- [ ] Busca automática de conteúdo do Youtube
- [ ] Busca automática de conteúdo do Spotify
- [ ] Suporte para mais formatos de legenda (ASS, VTT)
- [ ] Sincronização automática de legendas
- [ ] Capacidades de edição de legendas
- [ ] Exportar playlists
- [ ] Integração com armazenamento em nuvem
- [ ] Suporte para mais idiomas
- [ ] Download offline de letras

---

Feito com ❤️ usando Flutter