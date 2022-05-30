contract;

use std::{
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

storage {
    creator: User,
    state: u64,
    voter: User,
    choice_1:u64,
    choice_2:u64,
    choice_3:u64,
    n_voters:u64
}


abi MyContract {
    fn constructor(creator: Address) -> bool;
    fn get_state() -> u64;
    fn get_creator() -> Address;
    fn open_access(voter: Address) -> bool;
    fn is_admin() -> bool;
    fn vote(choice: u64) -> bool;
    fn n_voters() -> u64;
    fn ch_2()-> u64;
}

impl MyContract for Contract {


    fn constructor(creator: Address) -> bool {
        assert(storage.state == 0);

        storage.creator = User {
            address: creator, admin: true
        };
        storage.state = 1;

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
            assert(storage.state ==1);
            if (address == storage.voter.address) {
                storage.n_voters = storage.n_voters + 1;
                if choice == 1 {
                    storage.choice_1 = storage.choice_1 + 1}
                else if choice == 2 {
                    storage.choice_2 = storage.choice_2 + 1
                }
                else {
                    storage.choice_3 = storage.choice_3 + 1
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

    fn n_voters() -> u64 {
        storage.n_voters
    }

    fn ch_2() -> u64 {
        storage.choice_2
    }

}
