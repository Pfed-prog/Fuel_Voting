contract;

use std::{
    storage::{get, store},
    address::Address,
    assert::assert,
    chain::auth::{AuthError, Sender, msg_sender},
    context::{call_frames::{contract_id, msg_asset_id}, msg_amount, this_balance},
    contract_id::ContractId,
    result::*,
    revert::revert,
    token::transfer_to_output,
};


struct User {
    address: Address,
    admin: bool
}

struct Choice {
    //option: str[10],
    count: u64,
    //sum: u64
}

const STORAGE_KEY: b256 = 0x0000000000000000000000000000000000000000000000000000000000000000;


storage {
    asset: ContractId,
    creator: User,
    state: u64,
    voter: User,
    choice_1: Choice,
    choice_2: Choice,
    choice_3: Choice,
}


abi MyContract {
    fn constructor(creator: Address, asset: ContractId) -> bool;

    fn open_access(voter: Address) -> bool;
    fn vote(choice: u64) -> bool;
    
    fn is_admin() -> bool;
    fn n_voters() -> u64;
    fn ch_2()-> u64;
    fn get_state() -> u64;
    fn get_creator() -> Address;
}

impl MyContract for Contract {


    fn constructor(creator: Address, asset: ContractId) -> bool {
        assert(storage.state == 0);

        storage.creator = User {
            address: creator, admin: true
        };
        storage.state = 1;
        storage.asset = asset;

        true
    }



    fn open_access(voter: Address) -> bool {
        let sender: Result<Sender, AuthError> = msg_sender();

        if let Sender::Address(address) = sender.unwrap() {
            assert(storage.state ==1);

            if (address == storage.creator.address) {
                storage.voter = User {
                    address: voter, admin: false
                };
                return true
            };
        } else {
            revert(0);
        };

        false
    }

    fn vote(choice: u64) -> bool {
        let sender: Result<Sender, AuthError> = msg_sender();

        if let Sender::Address(address) = sender.unwrap() {
            assert(storage.state == 1);
            if (address == storage.voter.address) {
                let value = get::<u64>(STORAGE_KEY);
                store(STORAGE_KEY, value+1);
                if choice == 1 {
                    storage.choice_1.count  = storage.choice_1.count + 1
                    } else if choice == 2 {
                    storage.choice_2.count  = storage.choice_2.count  + 1
                } else {
                    storage.choice_3.count  = storage.choice_3.count  + 1
                }
                storage.voter = User {
                    address: storage.creator.address, admin: false
                };
                return true;
            };
        } else {
            revert(0);
        };
        false
    }


    fn is_admin() -> bool {
        
        let sender: Result<Sender, AuthError> = msg_sender();

        if let Sender::Address(address) = sender.unwrap() {
            assert(storage.state ==1);

            if (address == storage.creator.address) {
                
                return true;
            };
        } else {
            revert(0);
        };

        false
    }

    fn get_state() -> u64 {
        storage.state
    }
    
    fn get_creator() -> Address {
        storage.creator.address
    }
    
    //#[storage(read, write)]
    fn n_voters() -> u64 {
        let value = get::<u64>(STORAGE_KEY);
        value
    }

    fn ch_2() -> u64 {
        storage.choice_2.count 
    }

}
