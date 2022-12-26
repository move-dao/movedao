

/// This module provides the foundation for points.
module movedao1::points {

    use aptos_framework::managed_coin;
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::account;

    use aptos_std::table::{Self, Table};

    // use std::error;
    use std::signer;
    use std::vector;

    const MODULE_OWNER: address = @movedao1;

    // Define MoveDAO Points
    struct MoveDAOPoint has key, store { }  

    // Define Airdrop relationship
    struct AirdropClaimVec has key {
        airdrop_claims: Table<address, AirdropClaimPair>,      // <airdrop_address, AirdropClaimPair>
    }

    struct AirdropClaimPair has store, copy {
        airdrop_addr: address,
        claim_addr: address,
        is_claimed: bool,
    }

    // Define AirdropEvent, contains resource account address
    struct AirdropPointEvent has key, store {
        airdrop_point: Coin<MoveDAOPoint>,
        airdrop_signer_cap: account::SignerCapability,
    } 

    struct AirdropPointBox has key {
        airdrops: Table<address, AirdropPointEvent>,    // <admin_address, AirdropPointEvent>
    }

    const ENO_CAPABILITIES: u64 = 1;

    const ENO_MOVEDAO_POINT_BALANE: u64 = 2;

    const ENO_AIRDROP_ADDRESS: u64 = 3;

    const ENO_USER_AIRDROP: u64 = 4;

    const EAIRDROP_ADDRESS_ALREADY_EXISTS: u64 = 5;

    // Init 
    fun init_module(owner: &signer) {
        managed_coin::initialize<MoveDAOPoint>(
            owner,
            b"MoveDAO Point",
            b"MDPT",
            3,
            false
        );
    }

    public entry fun mint(account: &signer, recipient: address, amount: u64)  {
        managed_coin::mint<MoveDAOPoint>(account, recipient, amount);
    }

    public entry fun register(account: &signer) {
        managed_coin::register<MoveDAOPoint>(account);
    }

    public entry fun transfer(from: &signer, to: address, amount: u64) {
        coin::transfer<MoveDAOPoint>(from, to, amount);
    }

    public entry fun burn(account: &signer, amount: u64) {
        managed_coin::burn<MoveDAOPoint>(account, amount);
    }

    // public fun withdraw(account: &signer, amount: u64): MoveDAOPoint acquires 

    // TODO Treasury
    // public entry fun create_treasury(account: &signer, account: )

    public fun find_airdrop_claims(owner_addr: address, user_addr: address): vector<AirdropClaimPair> acquires AirdropClaimVec {

        let matched_airdrop_claim = vector::empty<AirdropClaimPair>();

        let airdrop_claim_vec = borrow_global<AirdropClaimVec>(owner_addr);

        let i = 0;
        let len = vector::length<AirdropClaimPair>(&airdrop_claim_vec.airdrop_claims);

        while (i < len) {
            let airdrop_claim_pair = vector::borrow<AirdropClaimPair>(&airdrop_claim_vec.airdrop_claims, i);

            if ((airdrop_claim_pair.claim_addr == user_addr) && (!airdrop_claim_pair.is_claimed)) { 
                vector::push_back(&mut matched_airdrop_claim, *airdrop_claim_pair);
            };

            i = i + 1;
        };

        matched_airdrop_claim

    }

    public fun airdrop_exist(owner_addr: address, user_addr: address): bool acquires AirdropClaimVec {
        vector::length<AirdropClaimPair>(&find_airdrop_claims(owner_addr, user_addr)) > 0
    }

    // do airdrop
    public entry fun airdrop(admin: &signer, seed: vector<u8>, to: address, amount: u64) acquires AirdropPointBox, AirdropClaimVec {
        let admin_addr = signer::address_of(admin);

        // create resource account with account
        let (airdrop_signer, airdrop_signer_cap) = account::create_resource_account(admin, seed);
        let airdrop_addr = signer::address_of(&airdrop_signer);

        // Determine if the airdrop address exists
        if (!exists<AirdropClaimVec>(admin_addr)) {
            let airdrop_claims = vector::empty<AirdropClaimPair>();
            move_to(admin, AirdropClaimVec { airdrop_claims })
        };

        let airdrop_claim_vec = borrow_global_mut<AirdropClaimVec>(admin_addr);

        
        assert!(!vector::contains(airdrop_addresses, &airdrop_addr), EAIRDROP_ADDRESS_ALREADY_EXISTS);

        register(&airdrop_signer);
        
        if (coin::balance<MoveDAOPoint>(admin_addr) <= amount + 10000) {
            mint(admin, admin_addr, 1000000000);
        };

        // mint(admin, airdrop_addr, amount);

        assert!(coin::balance<MoveDAOPoint>(admin_addr) > amount, ENO_MOVEDAO_POINT_BALANE);

        let airdrop_point = coin::withdraw<MoveDAOPoint>(admin, amount);

        let event = AirdropPointEvent {
            airdrop_point,
            airdrop_signer_cap
        };

        // transfer(admin, airdrop_addr, amount);

        // if airdrop not exist, create it 
        if (!exists<AirdropPointBox>(airdrop_addr)) {
            let airdrops = table::new<address, AirdropPointEvent>();
            let box = AirdropPointBox { airdrops };
            move_to(admin, box);
        };

        let airdrops = &mut borrow_global_mut<AirdropPointBox>(airdrop_addr).airdrops;
        table::add<address, AirdropPointEvent>(airdrops, to, event);

        vector::push_back(airdrop_addresses, airdrop_addr);

    }

    // Claim
    public entry fun claim(user: &signer, owner_addr: address) acquires AirdropPointBox, AirdropClaimVec {
        let user_addr = signer::address_of(user);
        
        if (!coin::is_account_registered<MoveDAOPoint>(user_addr)) {
            register(user);
        };

        // Maybe a user has many airdrop to claim
        let airdrop_claims = find_airdrop_claims(owner_addr, user_addr);

        let idx = 0;
        let claims_len = vector::length<AirdropClaimPair>(airdrop_claims);

        while (idx < claims_len) {
            let airdrop_claim_pair = vector::borrow<AirdropClaimPair>(airdrop_claims, idx);

            let airdrop_addr = airdrop_claim_pair.airdrop_addr;
            assert!(exists<AirdropPointBox>(airdrop_addr), ENO_AIRDROP_ADDRESS);

            let airdrops = &mut borrow_global_mut<AirdropPointBox>(airdrop_addr).airdrops;

            assert!(table::contains(airdrops, user_addr), ENO_USER_AIRDROP);

            let event = table::remove(airdrops, user_addr);
            
            let AirdropPointEvent { airdrop_point, airdrop_signer_cap: _ } = event;

            // let airdrop_signer = account::create_signer_with_capability(&airdrop_signer_cap);

            coin::deposit(user_addr, airdrop_point);
        }
        
    }

    // Test

    #[test(owner = @0x007, user = @0x008)]
    public entry fun test_airdrop_clain_e2e(owner: signer, user: signer) acquires AirdropPointBox, AirdropClaimVec {
        let owner_addr = signer::address_of(&owner);
        let user_addr = signer::address_of(&user);

        let airdrop_amount = 1000;

        // airdrop
        airdrop(&owner, b"01", user_addr, airdrop_amount);

        // Determine AirdropClaimVec is empty
        assert!(exists<AirdropClaimVec>(owner_addr), 0);

        // Determine AirdropClaimVec for user by owner is exist
        assert!(airdrop_exist(owner_addr, user_addr), 0);

        // claim
        register(&user);

        let before_balance = coin::balance<MoveDAOPoint>(user_addr);

        claim(&user, owner_addr);

        let after_balance = coin::balance<MoveDAOPoint>(user_addr);

        assert!(before_balance + airdrop_amount == after_balance, 0);
    }
    
    #[test(owner = @0x007)]
    public entry fun test_init_moudule_ok(owner: signer) {

        let owner_addr = signer::address_of(&owner);
        account::create_account_for_test(owner_addr);

        init_module(&owner);

        assert!(coin::is_coin_initialized<MoveDAOPoint>(), 0);
    }

    #[test(from = @0x007, to = @0x008)]
    public entry fun test_transfer_ok(from: signer, to: signer) {
        let from_addr = signer::address_of(&from);
        let to_addr = signer::address_of(&to);

        account::create_account_for_test(from_addr);
        account::create_account_for_test(to_addr);

        init_module(&from);

        assert!(coin::is_coin_initialized<MoveDAOPoint>(), 0);

        register(&from);
        register(&to);

        let amount = 10000;
        mint(&from, to_addr, amount);

        let half_balance = amount / 2;

        transfer(&to, from_addr,  half_balance);

        assert!(coin::balance<MoveDAOPoint>(from_addr) == half_balance, 0);
        assert!(coin::balance<MoveDAOPoint>(to_addr) == half_balance, 0);
    }

    #[test(owner = @0x007)] 
    public entry fun test_burn_ok(owner: signer) {
        let owner_addr = signer::address_of(&owner);
        account::create_account_for_test(owner_addr);

        init_module(&owner);

        register(&owner);

        let amount = 200000;
        mint(&owner, owner_addr, amount);
        assert!(coin::balance<MoveDAOPoint>(owner_addr) == amount, 0);

        burn(&owner, amount / 2);
        assert!(coin::balance<MoveDAOPoint>(owner_addr) == amount / 2, 0);
    }
}
    