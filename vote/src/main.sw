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
    approved: bool,
    voted: bool
}

storage {
    creator: User,
    state: u64,
}


abi MyContract {
    fn constructor(creator: Address) -> bool;
    fn get_state() -> u64;
    fn make_admin() -> bool;
    fn is_admin() -> bool;
}

impl MyContract for Contract {


    fn constructor(creator: Address) -> bool {
        assert(storage.state == 0);

        storage.creator = User {
            address: creator, approved: true, voted: false
        };
        storage.state = 1;

        true
    }

    fn get_state() -> u64 {
        storage.state
    }


    fn make_admin() -> bool {
        false
    }


    fn is_admin() -> bool {

        let sender: Result<Sender, AuthError> = msg_sender();

        if let Sender::Address(address) = sender.unwrap() {
            assert(storage.state ==1);

            assert(address == storage.creator.address);

            true
        } else {
            false
        };
    }
}
