

module openmove::Timer {
    use sui::clock::{Self, Clock};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::object::{Self, UID};

    struct Timer has key {
        id: UID,
        deadline: u64
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            Timer {
                id: object::new(ctx),
                deadline: 0,
            }
        );
    }

    public fun getDeadline(timer: &Timer): u64 {
        return timer.deadline
    }

    public fun setDeadline(timer: &mut Timer, timestamp: u64) {
        timer.deadline = timestamp;
    }

    public fun reset(timer: &mut Timer) {
        timer.deadline = 0;
    }

    public fun isUnset(timer: &Timer): bool {
        return timer.deadline == 0
    }

    public fun isStarted(timer: &Timer): bool {
        return timer.deadline > 0
    }

    public fun isPending(timer: &Timer, clock: &Clock): bool {
        return timer.deadline > (clock::timestamp_ms(clock) / 1000)
    }

    public fun isExpired(timer: &Timer, clock: &Clock): bool {
        return isStarted(timer) && timer.deadline <= (clock::timestamp_ms(clock) / 1000)
    }
}
