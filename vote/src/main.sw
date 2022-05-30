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
    hash::sha256,
    token::transfer_to_output,
};


struct User {
    address: Address,
    admin: bool
}

struct Choice {
    option: str[10],
    count: u64,
    sum: u64
}

storage {
    creator: User,
    state: u64,
    voter: User,
    choice_1: Choice,
    choice_2: Choice,
    choice_3: Choice,
}

abi MyContract {                    //, asset: ContractId
    fn constructor(creator: Address) -> bool;

    fn vote(choice: u64) -> bool;

    fn open_access(voter: Address) -> bool;
    
    fn get_option_1() -> str[1];
    fn get_option_2() -> str[1];
    fn get_option_3() -> str[1];

    fn is_admin() -> bool;
    fn get_n_voters() -> u64;

    fn get_balance_1() -> u64;
    fn get_balance_2() -> u64;
    fn get_balance_3() -> u64;

    fn get_count_1()-> u64;
    fn get_count_2()-> u64;
    fn get_count_3()-> u64;
    
    fn get_state() -> u64;
    fn get_creator() -> Address;
}


impl MyContract for Contract {

    fn constructor(creator: Address) -> bool {
        assert(storage.state == 0);

        storage.creator = User {
            address: creator, admin: true
        };
        storage.state = 1;
        //storage.asset = asset;

        true
    }


    fn open_access(voter: Address) -> bool {
        let sender: Result<Sender, AuthError> = msg_sender();

        if let Sender::Address(address) = sender.unwrap() {
            
            assert(storage.state == 1);

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


    fn vote(choice:u64) -> bool {
        
        let sender: Result<Sender, AuthError> = msg_sender();
        
        if let Sender::Address(address) = sender.unwrap() {

            assert(storage.state == 1);
            
            if (address == storage.voter.address) {
                if choice == 1 {
                        storage.choice_1.count  = storage.choice_1.count + 1;
                        storage.choice_1.sum = storage.choice_1.sum + msg_amount();
                        return true;
                };
                if choice == 2 {
                        storage.choice_2.count  = storage.choice_2.count + 1;
                        storage.choice_2.sum = storage.choice_2.sum + msg_amount();
                        return true;
                };
                if choice == 3 {
                        storage.choice_3.count  = storage.choice_3.count  + 1;
                        storage.choice_3.sum = storage.choice_3.sum + msg_amount();
                        return true;
                };

                //close the access to vote again
                storage.voter = User {
                        address: storage.creator.address, admin: false
                }; 
            return false;
            };
            return false;
        } else {
            revert(0);
        };
        return false;
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
    
    fn get_n_voters() -> u64 {
        storage.choice_1.count+storage.choice_2.count+storage.choice_3.count
    }

    fn get_count_1() -> u64 {
        storage.choice_1.count
    }
    
    fn get_count_2() -> u64 {
        storage.choice_2.count 
    }

    fn get_count_3() -> u64 {
        storage.choice_3.count 
    }

    fn get_balance_1() -> u64 {
        storage.choice_1.sum
    }

    fn get_balance_2() -> u64 {
        storage.choice_2.sum
    }

    fn get_balance_3() -> u64 {
        storage.choice_3.sum
    }

    fn get_option_1() -> str[1]{
        return "a"
    }

    fn get_option_2() -> str[1]{
        return "b"
    }

    fn get_option_3() -> str[1]{
        return "c"
    }

}
