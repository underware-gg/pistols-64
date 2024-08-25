# 🔫 pistols-64

For the **Dojo Game Jam @ Dojo Sensei Residency NYC 2024**

## Team

* [Roger Mataleone](https://github.com/rsodre) / [@matalecode](https://x.com/matalecode)
* [Tim Storey](https://github.com/lbdl) / [@itrainspiders](https://x.com/itrainspiders)
* Calcutator

## Contents

### Dojo Contracts

* `/dojo/planetary`: world catalog
* `/dojo/planetary_interface`: interface for **planetary** (crate), imported by worlds to connet to each other
* `/dojo/pistols64`: mini-pistols game contracts

### Clients

* `/clients/sdk`: generated files from the `pistols64` contract (manifest, typescript, graphql)
* `/clients/terminal`: Python shell termimal client
* [TheOrugginTrail](https://github.com/ArchetypalTech/TheOrugginTrail-DoJo): text adventure client


## 🌎 The Planetary System 

**Planetary** is a Dojo world that connect other Dojo worlds.

> ⚠️ This is a proof of concept, not secure, not meant for production.

How does it work?

* Planetary is a Dojo world deployed on Katana/Slot/Starknet
* It provides the `planetary_interface` crate for world discovery.
* Worlds need to `register()` to Planetary to be discoverable, usually at `dojo_init()`.
* Any world can dicover other worlds from the interface.
* Discoverable worlds need their interface to be included in the Planetary interface.

Things to do and consider for future developments:

* Some protection around who can regiter and unregister worlds. Maybe adding the worlds class hashes to the interface and checking the caller class chash matches it.
* This is a simple system, but maybe over-complicated. Since discoverable worlds are white-listed, they could have their world address hard-coded.


## 🪐 Planetary integration

Import `planetary_interface ` in your Dojo project `Scarb.toml`:

```toml
[dependencies]
dojo = { git = "https://github.com/dojoengine/dojo", tag = "v1.0.0-alpha.7" }
planetary_interface = { git = "https://github.com/underware-gg/pistols-64", branch = "main" }
# planetary_interface = { path = "../planetary_interface" }
```


### To discover a world

There's a test planet called **Vulcan** included in the planitary system. When saluted with `live_long()`, it replies `and_prosper`.

Example accessing Vulcan from [pistols64](/dojo/pistols64/src/systems/action.cairo).

```rust
#[dojo::contract]
mod actions {
    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait,
        IVulcanSaluteDispatcher, IVulcanSaluteDispatcherTrait,
    };
    
    // ...

    // test with sozo:
    // sozo call pistols64-actions live_long
    fn live_long(world: @IWorldDispatcher) -> felt252 {
        let vulcan: IVulcanSaluteDispatcher = VulcanInterfaceTrait::new().dispatcher();
        (vulcan.live_long())
    }
}

```


### To make your world discoverable

The system interface has to be included in `planetary_interface`.
Example: [vulcan interface](/dojo/planetary_interface/src/interfaces/vulcan.cairo)

Then register it from the system you want to expose:
Example: [vulcan system](/dojo/planetary_interface/systems/vulcan.cairo)

```rust
use starknet::{ContractAddress};

#[dojo::interface]
trait IVulcan {
    fn live_long(world: @IWorldDispatcher) -> felt252;
}

#[dojo::contract(namespace: "vulcan", nomapping: true)]
mod salute {
    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
    };
    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait,
    };
    use planetary_interface::utils::misc::{WORLD};

    fn dojo_init(ref world: IWorldDispatcher) {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        planetary.dispatcher().register(VulcanInterfaceTrait::NAMESPACE, world.contract_address);
    }

    #[abi(embed_v0)]
    impl IVulcanImpl of IVulcan<ContractState> {
        fn live_long(world: @IWorldDispatcher) -> felt252 {
            WORLD(world);
            ('and_prosper')
        }
    }
}

```


## 🚀 Running locally

Install Dojo `1.0.0-alpha.7`, Scarb `2.7` and Cargo. See the [Dojo Book](https://book.dojoengine.org/getting-started/).

Stuff you might need...

```sh
brew install jq
brew install protobuf
cargo install toml-cli
```

Start up one [Katana](https://book.dojoengine.org/toolchain/katana) instance:

```sh
cd dojo/planetary
./run_katana
```

Migrate Planetary

```sh
cd dojo/planetary
./migrate
```

Migrate your game to the same Katana

```sh
cd dojo/pistols64
./migrate
```

Start up a [Torii](https://book.dojoengine.org/toolchain/torii) server **indexing your game world**. Planetary does not need to be indexed, as it's intended to be be interacted on-chain only.

```sh
cd dojo/pistols64
./run_torii
```


