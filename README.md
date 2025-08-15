# Jogo em desenvolvimento do PET
 - O projeto do Jogo da Feira, o qual se fazia um jogo todo ano, foi ampliado para Jogo do PET. A partir de 2025 o PET Computação UFPR se dedicará a um jogo não apenas para a Feira de Cursos e Profissões, mas também para aperfeiçoar ideias e conhecimentos tanto dos integrantes do programa quanto da comunidade externa.

##  O jogo terá relação com a matéria Circuitos Digitais (CI1068)
 - Linguagem lua é obrigatória.
 
 - Precisa ter relação com área da computação.

## Estrutura dos arquivos
```
jogoPET2025/
│
├── main.lua
├── conf.lua
│
├── core/
│   ├── game_state.lua         # Gerencia transições e lógica dos estados do jogo
│   ├── player.lua             # Dados, movimentação e animação do jogador
│   ├── npc.lua                # Dados, animação e interação dos NPCs
│   ├── schoolbus.lua          # Animação e lógica do ônibus escolar
│   ├── interaction.lua        # Lógica de interação (portas, cadeiras, etc.)
│   ├── map_manager.lua        # Carregamento, troca e colisão dos mapas
│   ├── audio.lua              # Carregamento e reprodução de sons/músicas
│   ├── buttons.lua            # Criação e manipulação de botões
│   └── utils.lua              # Funções utilitárias (ex: imprimir posição)
│
├── assets/
│   ├── sprites/               # Sprites do jogo
│   ├── sounds/                # Sons do jogo
│   ├── fonts/                 # Fontes utilizadas
│   └── images/                # Outras imagens
│
├── libraries/
│   └── (bibliotecas externas: windfield, camera, anim8, sti, etc.)
│
├── maps/
│   ├── menu.lua               # Mapa do menu principal
│   ├── level1.lua             # Mapa do nível 1
│   ├── level2.lua             # Mapa do nível 2
│   └── testMap.lua            # Mapa de testes
```