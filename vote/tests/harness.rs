use fuels::{prelude::*,
    tx::ContractId
    }
     ;
use fuels_abigen_macro::abigen;

// Load abi from json
abigen!(MyContract, "out/debug/vote-abi.json");
abigen!(Asset, "../asset/out/debug/asset-abi.json");

struct Metadata {
    instance: MyContract,
    wallet: LocalWallet,
}

async fn set_up() -> (Metadata, Metadata, Metadata, ContractId) {
    // Launch a local network and deploy the contract
    let num_wallets = 3;
    let coins_per_wallet = 1;
    let amount_per_coin = 1_000_000;

    let config = WalletsConfig::new(
        Some(num_wallets),
        Some(coins_per_wallet),
        Some(amount_per_coin),
    );

    let mut wallets = launch_provider_and_get_wallets(config).await;

    let deployer_wallet = wallets.pop().unwrap();
    let second_wallet = wallets.pop().unwrap();
    let third_wallet = wallets.pop().unwrap();


    let asset_id = Contract::deploy(
        "../asset/out/debug/asset.bin",
        &deployer_wallet,
        TxParameters::default(),
    )
    .await
    .unwrap();

    let contract_id = Contract::deploy("./out/debug/vote.bin", &deployer_wallet, TxParameters::default())
        .await
        .unwrap();

    let deployer = Metadata {
        instance: MyContract::new(contract_id.to_string(), deployer_wallet.clone()),
        wallet: deployer_wallet,
    };

    let second_user = Metadata {
        instance: MyContract::new(contract_id.to_string(), second_wallet.clone()),
        wallet: second_wallet,
    };

    let third_user = Metadata {
        instance: MyContract::new(contract_id.to_string(), third_wallet.clone()),
        wallet: third_wallet,
    };

    

    (deployer, second_user, third_user, asset_id)
}


#[tokio::test]
async fn construct() {
    let (_deployer, _ser_2, _ser_3, asset_id) = set_up().await;

     let response = _deployer
    .instance
    .constructor(_deployer.wallet.address(), asset_id)
    .call()
    .await
    .unwrap(); 

    assert_eq!(response.value, true);
    
     let response = _deployer
    .instance
    .get_state()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 1);

    let response = _deployer
    .instance
    .is_admin()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, true);

    let response = _ser_3
    .instance
    .is_admin()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, false); 

     let response = _ser_3
    .instance
    .get_state()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 1);


    let response = _ser_2
    .instance
    .get_creator()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, _deployer.wallet.address());

    

//open access 
    let response = _deployer
    .instance
    .open_access(_ser_2.wallet.address())
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, true);

    let response = _ser_2
    .instance
    .vote(2)
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, true);

    let response = _ser_2
    .instance
    .n_voters()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 1);

    let response = _ser_2
    .instance
    .ch_2()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 1);

    //open access 
    let response = _deployer
    .instance
    .open_access(_ser_3.wallet.address())
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, true);

    let response = _ser_3
    .instance
    .vote(1)
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, true);

    let response = _ser_3
    .instance
    .n_voters()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 2);

    let response = _ser_2
    .instance
    .ch_2()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 1); 


    // Now you have an instance of your contract you can use to test each function
}