use traits::Into;
use debug::PrintTrait;

#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
enum ChallengeState {
    Null,       // 0
    InProgress, // 1
    Resolved,   // 2
    Draw,       // 3
    Canceled,   // 4
}

mod CHALLENGE_STATE {
    const NULL: u8          = 0;
    const IN_PROGRESS: u8   = 1;
    const RESOLVED: u8      = 2;
    const DRAW: u8          = 3;
    const CANCELED: u8      = 4;
}

trait ChallengeStateTrait {
    fn exists(self: ChallengeState) -> bool;
    fn is_canceled(self: ChallengeState) -> bool;
    fn is_live(self: ChallengeState) -> bool;
    fn is_finished(self: ChallengeState) -> bool;
}

impl ChallengeStateImpl of ChallengeStateTrait {
    fn exists(self: ChallengeState) -> bool {
        match self {
            ChallengeState::Null        => false,
            ChallengeState::InProgress  => true,
            ChallengeState::Resolved    => true,
            ChallengeState::Draw        => true,
            ChallengeState::Canceled    => true,
        }
    }
    fn is_canceled(self: ChallengeState) -> bool {
        match self {
            ChallengeState::Null        => false,
            ChallengeState::InProgress  => false,
            ChallengeState::Resolved    => false,
            ChallengeState::Draw        => false,
            ChallengeState::Canceled    => true,
        }
    }
    fn is_live(self: ChallengeState) -> bool {
        match self {
            ChallengeState::Null        => false,
            ChallengeState::InProgress  => true,
            ChallengeState::Resolved    => false,
            ChallengeState::Draw        => false,
            ChallengeState::Canceled    => false,
        }
    }
    fn is_finished(self: ChallengeState) -> bool {
        match self {
            ChallengeState::Null        => false,
            ChallengeState::InProgress  => false,
            ChallengeState::Resolved    => true,
            ChallengeState::Draw        => true,
            ChallengeState::Canceled    => true,
        }
    }
}

impl ChallengeStateIntoU8 of Into<ChallengeState, u8> {
    fn into(self: ChallengeState) -> u8 {
        match self {
            ChallengeState::Null =>       CHALLENGE_STATE::NULL,
            ChallengeState::InProgress => CHALLENGE_STATE::IN_PROGRESS,
            ChallengeState::Resolved =>   CHALLENGE_STATE::RESOLVED,
            ChallengeState::Draw =>       CHALLENGE_STATE::DRAW,
            ChallengeState::Canceled =>   CHALLENGE_STATE::CANCELED,
        }
    }
}

impl TryU8IntoChallengeState of TryInto<u8, ChallengeState> {
    fn try_into(self: u8) -> Option<ChallengeState> {
        if self == CHALLENGE_STATE::NULL             { Option::Some(ChallengeState::Null) }
        else if self == CHALLENGE_STATE::IN_PROGRESS { Option::Some(ChallengeState::InProgress) }
        else if self == CHALLENGE_STATE::RESOLVED    { Option::Some(ChallengeState::Resolved) }
        else if self == CHALLENGE_STATE::DRAW        { Option::Some(ChallengeState::Draw) }
        else if self == CHALLENGE_STATE::CANCELED    { Option::Some(ChallengeState::Canceled) }
        else { Option::None }
    }
}

impl ChallengeStateIntoFelt252 of Into<ChallengeState, felt252> {
    fn into(self: ChallengeState) -> felt252 {
        match self {
            ChallengeState::Null =>       0,
            ChallengeState::InProgress => 'InProgress',
            ChallengeState::Resolved =>   'Resolved',
            ChallengeState::Draw =>       'Draw',
            ChallengeState::Canceled =>   'Canceled',
        }
    }
}

impl TryFelt252IntoChallengeState of TryInto<felt252, ChallengeState> {
    fn try_into(self: felt252) -> Option<ChallengeState> {
        if self == 0                 { Option::Some(ChallengeState::Null) }
        else if self == 'InProgress' { Option::Some(ChallengeState::InProgress) }
        else if self == 'Resolved'   { Option::Some(ChallengeState::Resolved) }
        else if self == 'Draw'       { Option::Some(ChallengeState::Draw) }
        else if self == 'Canceled'   { Option::Some(ChallengeState::Canceled) }
        else { Option::None }
    }
}

impl PrintChallengeState of PrintTrait<ChallengeState> {
    fn print(self: ChallengeState) {
        let num: felt252 = self.into();
        num.print();
        // let num: u8 = self.into();
        // num.print();
    }
}


