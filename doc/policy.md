# Module interface policy

1. All combinatorial modules must have a dedicated reset input.
2. The reset input for asynchronous circuits must be the first parameter of
   the module. The next parameter should be the main clock input, if required.
3. For synchronous circuits, the first parameter of the module must be the
   clock input. If required, it must be followed by an input for the state
   initialization value on reset. The next should be the reset input itself.

# Synchronization

1. For synchronous circuits, the timeslot must start with the rising edge of
   the clock.

