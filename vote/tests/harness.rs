use fuels::{prelude::*,
    // tx::ContractId
    }
     ;
use fuels_abigen_macro::abigen;

// Load abi from json
abigen!(MyContract, "out/debug/vote-abi.json");


struct Metadata {
    instance: MyContract,
    wallet: LocalWallet,
}

async fn set_up() -> Metadata {
    // Launch a local network and deploy the contract

    let wallet = launch_provider_and_get_single_wallet().await;


    let contract_id = Contract::deploy("./out/debug/vote.bin", &wallet, TxParameters::default())
        .await
        .unwrap();

    let deployer = Metadata {
        instance: MyContract::new(contract_id.to_string(), wallet.clone()),
        wallet: wallet,
    };

    deployer
}


#[tokio::test]
async fn construct() {
    let _deployer = set_up().await;

    let response = _deployer
    .instance
    .constructor(_deployer.wallet.address())
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

    // Now you have an instance of your contract you can use to test each function
}

/* #[tokio::test]
async fn state() {
    let _deployer = set_up().await;

    let response = _deployer
    .instance
    .get_state()
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, 0);
    

    // Now you have an instance of your contract you can use to test each function
} */


#[tokio::test]
async fn is_admin() {
    let _deployer = set_up().await;


    

    // Now you have an instance of your contract you can use to test each function
}

#[tokio::test]
async fn make_admin() {
    let _deployer = set_up().await;

    let response = _deployer
    .instance
    .make_admin()     
    .call()
    .await
    .unwrap();

    assert_eq!(response.value, false);
    

    // Now you have an instance of your contract you can use to test each function
}