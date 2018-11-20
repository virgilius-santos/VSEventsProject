# Setup

#### Instale as dependências
`$ pod install`

## To do list:
- [x] Swift 3.0 ou superior
- [x] Autolayout
- [x] O app deve funcionar no iOS 9
- [x] Testes unitários
- [x] Preferencialmente utilizar: MVVM e RxSwift
- [x] Uso do git

## Uso de dependências
Nesse projeto utilizei as seguintes dependências: 
- RxSwift 
- Alamofire/AlamofireImage
- Quick/Nimble

## Observações
Neste projeto resolvi experimentar:
- pela primeira vez usei o RxSwift, pois entendi que este exercicio era uma ótima forma de ter contato com a programação reativa e, de tabela, atender a um requisito diferencial do exercicio. 
- o design pattern Clean Swift, pois na entrevista foi dito que vocês usam routers para navegacao e como o Clean Swift também faz uso dessa ferramenta, optei por utiliza-la, alinhando com o proximo ponto, 
- RxSwift + Clean Swift. na verdade eu ja estava atrás de outra oportunidade de programar usando Clean Swift.

Optei por não usar o MVVM pois é com ele que mais tenho trabalhado e, mesmo correndo o risco de errar bastante, optei por desenvolver alternativas usando este exercicio como ferramenta.

Os testes foram simples, mas priorizei as regras de negocio e repostas aos eventos da API.
Usei o Quick pois ele deixa os testes mais legiveis e gosto da maneira simples que ele permite implementar os testes