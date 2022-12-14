
/// MoveDAO governance module for MoveDAO on-chain

module movedao::Governance {
    use std::string::{Self, String};
    use std::debug;

    use aptos_std::event::EventHandle;
    use aptos_std::simple_map::SimpleMap;
    // use aptos_std::table::{Self, Table};

    struct Points has key, store { 
        amount: u64,
    }

    /// Configurations of the MoveDAOGovernance
    /// by this MoveDAOGovernance module.
    struct GovernanceConfig has key {
        min_voting_threshold: u128,
        required_proposer_stake: u64,
        voting_duration_secs: u64,
    }

    /// Events generated by interactions with the AptosGovernance module.
    struct GovernanceEvents has key {
        create_proposal_events: EventHandle<CreateProposalEvent>,
        update_config_events: EventHandle<UpdateConfigEvent>,
        vote_events: EventHandle<VoteEvent>,
    }

    /// Event emitted when a proposal is created.
    struct CreateProposalEvent has drop, store {
        proposer: address,
        stake_pool: address,
        proposal_id: u64,
        execution_hash: vector<u8>,
        proposal_metadata: SimpleMap<String, vector<u8>>,
    }

    /// Event emitted when there's a vote on a proposa;
    struct VoteEvent has drop, store {
        proposal_id: u64,
        voter: address,
        stake_pool: address,
        num_votes: u64,
        should_pass: bool,
    }

    /// Event emitted when the governance configs are updated.
    struct UpdateConfigEvent has drop, store {
        min_voting_threshold: u128,
        required_proposer_stake: u64,
        voting_duration_secs: u64,
    }

    struct ProjectProposalMetadata has store, drop {
        // proposal_id: u64,
        title: String,
        description: String,
        start_time: u64,
        end_time: u64,
        total_points: u64,
    }

    // public fun create_proposal(
    //     proposer: &signer,
    //     proposal_metadata: ProjectProposalMetadata
    // ) acquires GovernanceConfig, GovernanceEvents {
    //     let 
    // }

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }

    #[test]
    public fun test_speak() {
        let res = speak();

        debug::print(&res);

        let except = string::utf8(b"Hello World");
        assert!(res == except, 0);
    }
}
