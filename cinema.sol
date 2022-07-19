// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;

contract Cinema{
    //owner of the cinema
    address payable public owner;

    uint8 public totalSeats;

    string public movieName;

    uint256 public seatPrice;

    uint256 public bookingclosingTime;

    uint256 public seatsAvailable;


    // Events to log data of transaction incase someone wants to subscribe to it
    event BookedSeats(address _buyer, uint _seats, uint _price);
    event movieChanged(string _movieName, uint _seats, uint _price);

    constructor(uint8 _seats, string memory _movieName, uint _price, uint _hoursTillBookingFinishes){
        // Saves the creator address as the owner when the smart contract is created 
        owner = payable(msg.sender);
        totalSeats = _seats;
        seatsAvailable = _seats;
        movieName = _movieName;
        seatPrice = _price;
        //In hours
        bookingclosingTime = _hoursTillBookingFinishes * 3600;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only the owner can access this function");
        _;
    }


    // Function to book a seat for the box office movie avengers the end game
    function bookSeat(uint _numberOfSeats) public payable {
        require(seatsAvailable > _numberOfSeats, "Seats not available");
        require(msg.value == _numberOfSeats * seatPrice, "Send correct amount");
        
        owner.transfer(msg.value);

        reduceSeatNumber(_numberOfSeats);

        emit BookedSeats(msg.sender, _numberOfSeats, seatPrice);
    }

    //Reset movie details to empty after the movie
    //This function can only be carried out by the owner of the smart contract

    function setForNextShow(string memory _movieName, uint _price, uint8 _seats, uint _hoursTillBookingFinishes ) public onlyOwner{
        require(msg.sender == owner, "Only the owner can access this function");
        require(block.timestamp > bookingclosingTime, "Movie booking not over");
        totalSeats = _seats;
        seatsAvailable = _seats;
        movieName = _movieName;
        seatPrice = _price;
        bookingclosingTime = _hoursTillBookingFinishes * 3600;

        emit movieChanged(_movieName, _seats, _price);
    }

    //Incase of an offline booking, the owner can block the seats
    function blockSeats(uint _seats) public onlyOwner{
        reduceSeatNumber(_seats);
    }

    // Reduce the total number of seat number internally once a seat is bought
    function reduceSeatNumber(uint _numberOfSeats) internal{
        seatsAvailable = seatsAvailable - _numberOfSeats;
    }

    
}
