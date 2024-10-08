
# Pistols64 terminal client

Experimental shell terminal client for Pistols64.

```
                ,)
                (,
                ,)
     __________| |____
    /                 \
   /   The             \
  /   Fool & Flintlock  \
  |            Tavern   |
  |     ____     ___    |
  |    |    |   |___|   |
__|____|____|___________|__
```

## Playing with sozo

Read models from the contract:

Use [sozo model](https://book.dojoengine.org/toolchain/sozo/world-commands/model) to read model data:

```sh
cd dojo/pistols64
sozo model pistols64-actions live_long
```

Use [sozo call](https://docs.dojoengine.org/guides/sozo-call) to run view functions:

```sh
cd dojo/pistols64
sozo model get pistols64-Challenge 0x1234
sozo model get pistols64-Round 0x1234,0x1
```

Use [sozo execute](https://docs.dojoengine.org/guides/sozo-execute) to run view functions:

```sh
cd dojo/pistols64
export NAME_A=0x$(echo "Ringo"|xxd -p)
export NAME_B=0x$(echo "George"|xxd -p)
export MESSAGE=0x$(echo "Hallelujah my a**\!"|xxd -p)
sozo execute pistols64-actions create_challenge --calldata $NAME_A,$NAME_B,$MESSAGE --wait --receipt
  > Transaction hash: 0x0798927e62fd6812825b8911fe520d78b8a2c714031debbe2c6c5d9e7dc9dfcd
  > Receipt: {...}
```




## Shell Terminal Client

From here on you're gonna need **Python**...

### macOS / Linux

If you don't have Python, the easiest way to install and maintain it is using `pyenv`.

```sh
brew install pyenv
pyenv install 3.12
```

Needs to be activated before use, by running the following command.
Or better, paste at the end of your shell config file (`.zshrc` on your home).
Python will be activated automatically every time you open a new terminal.

```sh
eval "$(pyenv init -)"
python --version
```

### Windows

```
¯\_(ツ)_/¯
```

### Run a duel from terminal client

Configure sozo for localhost Katana, or another chain:

```sh
export STARKNET_RPC_URL=http://localhost:5050
export DOJO_ACCOUNT_ADDRESS=0xb3ff441a68610b30fd5e2abbf3a1548eb6ba6f3559f2862bf2dc757e5828ca
export DOJO_PRIVATE_KEY=0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a
export DOJO_MANIFEST_PATH=../../../dojo/pistols64/Scarb.toml
```

Start a duel from the **pistols64** contract (needs planetary and pistols64 [deployed](/README.md))

```sh
cd clients/terminal/src
python ./duel.py
```

![Shoggoth's Deli](../../images/terminal_duel.png)


To just render random duels...

```sh
cd clients/terminal/src
python duel_renderer.py Ringo George 'Hallelujah my a**!' 9 10 10 1 Ringo
```

Play some test animations...

```sh
cd clients/terminal/src
python ./anim/tavern.py
python ./anim/walk.py
python ./anim/flip.py
python ./anim/dance.py
python ./anim/death.py
```

## Shoggoth's Deli

![Shoggoth's Deli](../../images/deli.png)

The Planetary full circle...

1. Send commands from `sozo` to the `pistols64` contract
2. `pistols64` finds `TheOrugginTrail` interface from `Planetary`
3. `pistols64` sends the comand to `TheOrugginTrail`, **triggering a new duel**
4. `TheOrugginTrail` finds `pistols64` interface from `Planetary`
5. `TheOrugginTrail` creates a new challenge calling the `pistols64` contract
6. Transaction completes, we get the Duel ID from events in the the receipt.
7. Call `pistols64` (or Torii) to get the duel results.
8. Play final animation

This needs planetary, pistols64 and TheOrugginTrail [deployed](/README.md).

```sh
cd clients/terminal/src
python ./deli.py
```

![Shoggoth's Deli](../../images/terminal_deli.png)

