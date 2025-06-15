# VSEventsProject

Este projeto é um aplicativo iOS para visualização de eventos, desenvolvido como um exercício para demonstrar habilidades em Swift e arquitetura de aplicativos iOS.

## Setup

#### Instale as dependências
```bash
$ pod install
```

## Arquitetura e Padrões

O projeto utiliza exclusivamente a arquitetura **MVVM (Model-View-ViewModel)** combinada com **RxSwift** para programação reativa. A navegação entre telas é realizada por meio de **routers** dedicados, que centralizam a lógica de transição e apresentação de telas.

O uso de **interactors** foi descontinuado e eles permanecem no projeto apenas para demonstrar habilidades em testes unitários.

### Injeção de Dependências

A injeção de dependências é feita principalmente via inicializadores. O arquivo `DependenciesContainer.swift` pode ser utilizado para centralizar a criação de serviços e dependências compartilhadas, que são injetadas nos ViewModels e routers conforme necessário.

### Camada de API

A comunicação com a API é abstraída pela `APIProtocol.swift` e implementada em `API.swift`. Esta camada utiliza **Alamofire** para as requisições de rede e **RxSwift** para lidar com as respostas de forma assíncrona e reativa.

### Navegação

A navegação entre as telas é realizada exclusivamente por **routers** dedicados, que centralizam a lógica de transição e apresentação de telas. Os routers são integrados ao padrão MVVM, recebendo comandos dos ViewModels para realizar navegações, como push, modal ou apresentação de fluxos específicos. Isso garante uma separação clara entre lógica de navegação e regras de negócio/interface.

## Tecnologias e Dependências

- **Swift:** 5.0
- **iOS Deployment Target:** 12.1

### CocoaPods Utilizados:

- **RxSwift**: Para programação reativa.
- **RxCocoa**: Bindings de RxSwift para Cocoa e CocoaTouch.
- **Alamofire**: Para requisições de rede HTTP.
- **AlamofireImage**: Para download e cache de imagens.
- **Quick**: Framework de testes BDD para Swift.
- **Nimble**: Matcher framework para Quick.
- **RxAlamofire**: Wrappers RxSwift para Alamofire.
- **RxDataSources**: Para lidar com DataSources de TableViews e CollectionViews de forma reativa.
- **RxSwiftExt**: Coleção de operadores úteis para RxSwift.
- **RxMapKit**: Utilizado a partir de um fork proprietário (https://github.com/virgilius-santos/RxMapKit.git) para atualizar o suporte ao RxSwift, já que o repositório original deixou de ser mantido.
- Outras dependências de suporte do RxSwift (RxRelay, RxBlocking, RxTest) e Differentiator.

## Lista de Tarefas (Original do Desafio)

- [x] Swift 5.0 ou superior
- [ ] Migrar para ViewCode
- [x] O app deve funcionar no iOS 9 (Atualizado para iOS 12.1 como target mínimo)
- [x] Testes unitários
- [x] Preferencialmente utilizar: MVVM e RxSwift (Optado por Clean Swift + RxSwift)
- [x] Uso do git

## Observações Adicionais

Os testes unitários foram focados nas regras de negócio e nas respostas da API, utilizando Quick e Nimble para maior legibilidade.
