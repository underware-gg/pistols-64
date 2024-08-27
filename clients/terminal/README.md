
# Pistols64 terminal client

Experimental shell terminal client for Pistols64.


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
sozo call pistols64-actions create_challenge --calldata $NAME_A,$NAME_B,$MESSAGE --wait --receipt
  > Transaction hash: 0x0798927e62fd6812825b8911fe520d78b8a2c714031debbe2c6c5d9e7dc9dfcd
  > Receipt: {...}
```


## Shell Terminal Client

From here on you're gonna need Python...

### macOS / Linux

**If you  don't have Python**, the easiest way to install and maintain it is using `pyenv`.

```sh
brew install pyenv
pyenv install 3.12
```

Needs to be activated before use.
Run this, or to add this to your shell config file (`.zshrc` on your home).

```sh
eval "$(pyenv init -)"
python --version
```

### Windows

```
¯\_(ツ)_/¯
```

