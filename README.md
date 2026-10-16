# ot_oficial_assets

Assets personalizados do cliente OT Tiozao (sprites, aparencias e sons da versao 1525).
O codigo do cliente fica em [ot_oficial_client-](https://github.com/leoalvesjf/ot_oficial_client-);
este repositorio guarda so os arquivos de `data/things/1525` e `data/sounds/1525`,
no mesmo caminho que o cliente usa.

## Como os jogadores recebem

Os jogadores **nao** baixam daqui. O `publish-update.ps1` do launcher copia a pasta `data/`
do cliente de quem publica e gera o `manifest.json` com o sha256 de cada arquivo;
o launcher baixa so os arquivos que mudaram. Entao, antes de publicar, a pasta do cliente
precisa estar sincronizada com este repositorio (passo 1 abaixo).

O auto-instalador do OTClient (`modules/client_assets`) nao serve para atualizar:
ele so baixa quando a versao esta ausente ou incompleta, e hoje aponta para os assets
oficiais (`dudantas/tibia-client`), sem as personalizacoes.

## Dia a dia

1. **Pegar os assets mais novos** (antes de testar ou publicar):
   ```powershell
   git checkout development
   git pull
   .\sync-assets.ps1 -Cliente C:\caminho\do\cliente -Para cliente
   ```
2. **Editar sprites/efeitos** no cliente, com a ferramenta de sempre, e testar no jogo.
3. **Subir a mudanca** na branch `development` (o Leo leva para a `main`):
   ```powershell
   .\sync-assets.ps1 -Cliente C:\caminho\do\cliente -Para repo
   git add -A
   git commit -m "Efeito X: nova sprite"
   git push origin development
   ```
   O script se recusa a copiar se o `catalog-content.json` citar um arquivo que nao existe,
   e avisa se sobrar `appearances-*.dat` sem uso. Apague as sobras antes do commit:
   cada `appearances` tem 4,6 MB e iria para todos os jogadores.

No repositorio do cliente, `data/things/*/` e `data/sounds/*/` continuam no `.gitignore`.
Nao use `git add -f` nessas pastas la; mudancas de assets entram so aqui.

## Pendente

- Esta primeira versao veio do commit `b3d6b62` (PR #1 do cliente). Ficaram de fora 6
  `appearances-*.dat` que o `catalog-content.json` nao usa (`180719da`, `23f3d51f`,
  `5e3ea77b`, `7790d802`, `c02f0b52`, `f5247604`). Confirmar com o valcio se sao versoes
  antigas; se algum for necessario, ele continua no historico daquele PR.

## Download do mapa com marcadores

O pacote completo com marcadores fica em `data/things/1525/map-download/`:
`world.otmm`, `markers.json` e `manifest.json` com SHA256 e tamanhos.
O caminho final no cliente e o mesmo. A rotina `game_minimap.MinimapDownload`
no repositorio de codigo prepara o primeiro uso sem substituir mapa pessoal existente.
O launcher tambem pode distribuir esta subpasta no fluxo normal de assets.

Enquanto o repositorio for privado, o teste usa um auxiliar local autenticado pelo Git;
nenhum token deve entrar no pacote ou no cliente distribuido. Arquivos ainda nao
commitados so podem ser testados pelo clone local, nao baixados do GitHub.
Instrucoes do auxiliar: `docs/minimap-download.md` no repositorio do cliente.
