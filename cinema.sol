// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.11;

contract Cinema{
    //owner of the cinema
    address payable public owner;

    uint8 public totalSeat = 3;

    // The theatre could have seats that are free or they could all be used
    // so we will create an Enum for the condition of seats availability in the theatre
    // it will contain two variables 
    // 1. free
    // 2. finished

    enum SeatAvailability{Free, Finished}
    SeatAvailability public seatAvailability;

    // Events to log data of transaction incase someone wants to subscribe to it
    event BookedSeats(address _buyer, uint _amountPaid);

    constructor(){
        // Saves the creator address as the owner when the smart contract is created 
        owner = payable(msg.sender);
        // Initially sets the seats to free when the contract is created
        seatAvailability = SeatAvailability.Free;
    }

    // Reduce the total number of seat number internally once a seat is bought
    function reduceSeatNumber()internal{
        totalSeat = totalSeat - 1;
    }

    // set the availability of seat according to the amount of seats remaining
    function setAvailability() internal {
        if(totalSeat > 0){
            seatAvailability = SeatAvailability.Free;
        }
        else{
            seatAvailability = SeatAvailability.Finished;
        }
    }

    //modifier function to allow purchase only when the availability condition is set to Free
    modifier allowPurchaseWhenFree {
        require(seatAvailability == SeatAvailability.Free, "There are no seats available for this movie please check back tomorrow");
        _;
    }

    modifier ensureUserHasEnoughMoney (uint _amount) {
        require(msg.value > _amount, "You need 6 ether to book  the seat, 5 ethers for the seat with little change for gas fee, so approximately 6 ether for the booking");
        _;
    }



    // Function to book a seat for the box office movie avengers the end game
    function bookSeatForAvengersEndgame() public payable allowPurchaseWhenFree ensureUserHasEnoughMoney( 5 ether) {
        
        owner.transfer(msg.value);

        reduceSeatNumber();

        setAvailability();

        emit BookedSeats(msg.sender, msg.value);
    }

    //Owner modifier function to require that only creator of the smart contract can reset the cinema seat to the original value
    modifier ownersCheck {
        require( payable(msg.sender) == payable(owner), "You cannot reset the seat, you do not have access priviledge to perform this action");
        _;
    }


    //Reset all the seats to empty after the movie
    //This function can only be carried out by the owner of the smart contract

    function resetTotalSeatsAvailable() public ownersCheck returns(uint8){
        totalSeat = 3;
        return totalSeat;
    }


    
}
