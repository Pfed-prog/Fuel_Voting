# Fuel_Voting

In this repository we have implemented Governance Voting Process on Fuel Blockchain.

The deployer of the contract has an authority to assign acess to vote.

The voters choose one of the three options and can signal their preference with providing native assets.

In the contract we have implemented methods, located in ```vote``` folder:

to access the address of the creator - ```get_creator()```

call the contract to determine whether you have admin privilleges - ```is_admin()```

the creator to open access to voter - ```open_access()```

methods ```get_option_...()``` provide the options

methods ```get_count_...()``` provide the number of voters in favour of the option

methods ```get_balance_...()``` provide the number of pledged native assets

methods ```get_average_donation_...()``` provide the average donation per option

method ```get_n_voters()```  provides the total number of voters

method ```get_state()``` provides the state of the application

## Furher Work

- Implement Quadratic Funding
- Add Funding with non native Assets
