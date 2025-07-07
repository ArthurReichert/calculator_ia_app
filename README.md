# Calculadora IA

Uma aplicação Flutter que utiliza inteligência artificial para resolver cálculos matemáticos a partir de imagens.

## 🚀 Funcionalidades

- **Análise de Imagens**: Capture ou selecione fotos de cálculos matemáticos
- **IA Integrada**: Utiliza o modelo GPT-4o da OpenAI para análise e resolução
- **Interface Moderna**: Design clean e intuitivo com Material Design
- **Chat Interface**: Histórico de conversas em formato de chat
- **Múltiplas Fontes**: Câmera ou galeria de fotos
- **Feedback Visual**: Indicadores de carregamento e estados
- **Configuração de API**: Interface para inserir e trocar chave da API OpenAI
- **Horário Local**: Timestamps das mensagens no horário do Brasil
- **Respostas em Português**: IA configurada para sempre responder em português brasileiro

## 🏗️ Arquitetura Clean Code

O projeto foi estruturado seguindo princípios de Clean Architecture e SOLID:

### Estrutura de Pastas

```
lib/
├── models/           # Modelos de dados
│   └── chat_message.dart
├── services/         # Serviços e APIs
│   └── openai_service.dart
├── widgets/          # Componentes reutilizáveis
│   ├── chat_message_widget.dart
│   ├── image_display_widget.dart
│   ├── loading_widget.dart
│   └── message_input_widget.dart
├── screen/           # Telas da aplicação
│   ├── chat_page.dart
│   ├── api_setup_page.dart
│   └── change_api_key_page.dart
├── utils/            # Utilitários e constantes
│   ├── app_constants.dart
│   ├── app_theme.dart
│   └── date_utils.dart
└── main.dart         # Ponto de entrada
```

### Princípios Aplicados

1. **Separação de Responsabilidades**: Cada classe tem uma responsabilidade específica
2. **Reutilização**: Widgets modulares e reutilizáveis
3. **Configuração Centralizada**: Constantes e temas em arquivos dedicados
4. **Injeção de Dependências**: Serviços isolados e testáveis
5. **Interface Limpa**: UI separada da lógica de negócio

## 🎨 Design System

### Cores
- **Primary**: Blue (#2196F3)
- **Secondary**: Teal (#03DAC6)
- **Background**: Light Gray (#F5F5F5)
- **Surface**: White
- **User Messages**: Light Blue (#E3F2FD)
- **AI Messages**: Light Purple (#F3E5F5)

### Componentes

#### ChatMessageWidget
- Exibe mensagens do usuário e da IA
- Suporte a imagens e texto
- Timestamp formatado
- Design responsivo

#### MessageInputWidget
- Campo de texto expansível
- Seleção de imagem (câmera/galeria)
- Preview da imagem selecionada
- Botão de envio inteligente

#### LoadingWidget
- Animação de carregamento
- Mensagem customizável
- Design consistente

## 🔧 Tecnologias

- **Flutter**: Framework de desenvolvimento
- **Dart**: Linguagem de programação
- **OpenAI GPT-4o**: Modelo de IA para análise
- **HTTP**: Cliente para requisições
- **Image Picker**: Seleção de imagens
- **Flutter SpinKit**: Animações de loading
- **Intl**: Formatação de datas

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  image_picker: ^1.1.2
  http: ^1.4.0
  flutter_spinkit: ^5.2.0
  intl: ^0.19.0
```

## 🚀 Como Usar

1. **Baixe o APK**
   - Baixe o arquivo APK mais recente
   - Instale em seu dispositivo Android

2. **Configure sua API Key**
   - Obtenha uma chave da API OpenAI em: https://platform.openai.com/api-keys
   - Abra o app e configure sua chave quando solicitado
   - Ou use o menu (⋮) → "Trocar API Key" para alterar posteriormente

3. **Use o App**
   - Tire uma foto ou escolha uma imagem da galeria
   - Adicione contexto se necessário
   - Envie para a IA analisar
   - Receba a solução detalhada

## 📱 Como Funciona

1. **Selecione uma Imagem**: Tire uma foto ou escolha da galeria
2. **Adicione Contexto**: Opcionalmente, adicione texto explicativo
3. **Envie para IA**: A IA analisa e resolve o cálculo
4. **Receba a Resposta**: Visualize a solução detalhada

## 🔒 Segurança

- **API Keys**: Cada usuário deve usar sua própria chave da API OpenAI
- **Armazenamento Local**: As chaves são armazenadas localmente no dispositivo
- **Privacidade**: As imagens são enviadas apenas para a API da OpenAI para análise

## 🛠️ Para Desenvolvedores

### Configuração do Ambiente

1. **Clone o repositório**
```bash
git clone <url-do-repo>
cd calculator_ia_app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o projeto**
```bash
flutter run
```

### Gerar APK

```bash
# APK de debug
flutter build apk --debug

# APK de release
flutter build apk --release

# APK otimizado por arquitetura
flutter build apk --split-per-abi
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

---

**Desenvolvido com ❤️ e Flutter**
