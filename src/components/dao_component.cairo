#[starknet::component]
mod DaoComponent {
    use starknet::{
        ContractAddress, ClassHash, get_caller_address, get_block_timestamp, get_contract_address
    };

    #[storage]
    struct Storage {
        votedFor: u128,
        votedAgainst: u128,
        hasVoted: LegacyMap<ContractAddress, bool>,
        proposal: felt252,
        admin: ContractAddress,
        votesOpen: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        NewVoter: NewVoter,
        Results : Results,
    }

    #[derive(Drop, starknet::Event)]
    struct NewVoter {
        #[key]
        voter: ContractAddress,
        vote: bool
    }

    #[derive(Drop, starknet::Event)]
    struct Results {
        #[key]
        number_voted_for: u128,
        number_voted_against: u128,
        result: felt252
    }

    mod Errors {
        const Address_Already_Voted: felt252 = 'Address Already Voted !';
        const Only_Admin: felt252 = 'Only admin !';
        const Voting_Time_Over: felt252 = 'Voting is closed !';
    }

    #[embeddable_as(DaoCompImpl)]
    impl Counter<
        TContractState, +HasComponent<TContractState>,
    > of dao::interfaces::dao::IDaoComp<
        ComponentState<TContractState>
    > {
        fn vote(ref self: ComponentState<TContractState>, vote: bool) {
            let voter = get_caller_address();
            assert(self.hasVoted.read(voter) == false, Errors::Address_Already_Voted);
            assert(self.votesOpen.read() == false, Errors::Voting_Time_Over);
            self.hasVoted.write(voter, true);
            if vote == true {
                self.votedFor.write(self.votedFor.read() + 1);
            }
            else {
                self.votedAgainst.write(self.votedAgainst.read() + 1);
            }
            self.emit(NewVoter { voter: voter, vote: vote });
        }

        fn getResults(ref self: ComponentState<TContractState>) -> felt252{
            assert(get_caller_address() == self.admin.read() , Errors::Only_Admin);
            self.votesOpen.write(false);
            let number_voted_for = self.votedFor.read();
            let number_voted_against = self.votedAgainst.read();
            if (number_voted_for >= number_voted_against) {
                self.emit(Results {number_voted_for : number_voted_for, number_voted_against : number_voted_against, result : 'Proposal got accepted !'});
                'Proposal got accepted'
            } else {
                self.emit(Results {number_voted_for : number_voted_for, number_voted_against : number_voted_against, result : 'Proposal got refused !'});
                'Proposal got refused'
            }
        }
    }

    #[generate_trait]
    impl DaoInternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of DaoInternalTrait<TContractState> {

        fn initializer(ref self: ComponentState<TContractState>, value: felt252) {
            self.proposal.write(value);
        }

        fn _get(ref self: ComponentState<TContractState>) -> felt252 {
            self.proposal.read()
        }
    }
}
