# Snake Math

## Sobre o projeto

Snake Math é um jogo sério educacional que combina a movimentação clássica do Snake com resolução de operações matemáticas. A cada rodada, duas respostas aparecem no campo e o jogador deve conduzir a cobra até a alternativa correta.

## Equipe

- Felipe Kock Mendonça
- Guilherme Peiter
- Matheus Tonolli Cordeiro

## Requisitos

- Godot Engine 4.2 ou superior (Godot 4.x)
- Não requer plugins, addons ou assets externos

## Como executar

1. Abra o Godot Engine.
2. Importe o arquivo `project.godot` desta pasta.
3. Abra o projeto.
4. Execute com F5. Também é possível abrir uma cena e executar com F6.

## Controles

- WASD ou Setas: movimentar a cobra
- ESC: pausar ou continuar

## Mecânicas

- A cobra anda automaticamente em uma grade, cresce ao acertar e não pode inverter a direção imediatamente.
- Cada operação possui exatamente duas respostas no campo: uma correta e uma alternativa plausível.
- Acertos concedem 10 pontos; erros matemáticos removem uma das três vidas.
- Colisões com parede ou com o próprio corpo encerram a partida.
- A cada cinco acertos o nível sobe, novas operações são liberadas e a velocidade aumenta com limite seguro.
- Divisões são sempre exatas e subtrações não geram resultado negativo.

## Estrutura

- `scenes/`: menu, tutorial, partida e Game Over.
- `scripts/snake.gd`: movimento, crescimento, desenho e colisões da cobra.
- `scripts/math_manager.gd`: geração e validação das operações e alternativas.
- `scripts/game.gd`: integração, HUD, respostas, pontuação, vidas, níveis e pausa.
- `scripts/main_menu.gd`, `tutorial.gd` e `game_over.gd`: fluxo das interfaces.
- `scripts/ui_factory.gd`: identidade visual compartilhada.
- `scripts/game_state.gd`: transferência segura do resultado para a tela final.

