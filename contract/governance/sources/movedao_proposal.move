
/// define MoveDAO proposals

module movedao::proposal {

    use std::string::String;

    struct ProjectProposal has store, drop {
        // proposal_id: u64,
        title: String,
        description: String,
        start_time: u64,
        end_time: u64,
        total_points: u64,
    }
}